namespace Acora.AvTrade.MainApp;

using Microsoft.Bank.BankAccount;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;
using System.DateTime;
using System.Text;
using Microsoft.Foundation.NoSeries;

tableextension 50112 "ACO_GenJnlLine_Ext" extends "Gen. Journal Line"
{
    //#region "Documentation"
    // 2.2.5.2018 LBR 15/10/2019 - CHG003334 (BAC's Export file selection). New logic added to pre-populate some field for payments;
    // 2.2.6.2018 LBR 16/10/2019 - CHG003323 (Posting Groups for Journals). New logic added to pre-populate posting groups
    // 2.3.4.2018 LBR 05/11/2019 - CHG003386 (Payment Journals) - new "Manual Export" logic added
    // 3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New fields added
    //#endregion "Documentation"

    fields
    {
        modify("Account No.")
        {
            trigger OnAfterValidate();
            begin
                TryUpdateVendorRecipentBankAccount();
                //>>2.2.6.2018
                TryUpdateBusPostingGroups()
                //<<2.2.6.2018
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate();
            begin
                TryUpdateVendorRecipentBankAccount();
            end;
        }
        modify("Bal. Account No.")
        {
            trigger OnAfterValidate();
            begin
                TryUpdatePaymentMethodCode();
                //>>2.2.6.2018
                TryUpdateBusPostingGroups()
                //<<2.2.6.2018
            end;
        }
        //>>2.3.4.2018
        modify("Recipient Bank Account")
        {
            trigger OnAfterValidate();
            var
                VendBankAcc: record "Vendor Bank Account";
                VendorNo: code[20];
            begin
                ACO_ManualPaymentExp := FALSE;

                if ("Account Type" = "Account Type"::Vendor) then
                    VendorNo := "Account No."
                else if ("Bal. Account Type" = "Bal. Account Type"::Vendor) then
                    VendorNo := "Bal. Account No.";

                if VendBankAcc.get(VendorNo, "Recipient Bank Account") then
                    ACO_ManualPaymentExp := VendBankAcc.ACO_ManualPaymentExp;
            end;
        }

        field(50010; "ACO_ManualPaymentExp"; Boolean)
        {
            Caption = 'Manual Payment Export';
            DataClassification = ToBeClassified;
        }
        //<<2.3.4.2018

        //>>3.1.0.2018
        field(50000; ACO_DisputeCode; Code[10])
        {
            Caption = 'Dispute Code';
            TableRelation = ACO_DisputeCode;
            DataClassification = CustomerContent;
            Description = 'It identifies the Dispute Code related to the Vendor Ledger Entry';
            trigger OnValidate()
            var
                DisputeCode: Record ACO_DisputeCode;
            begin
                if strlen(ACO_DisputeCode) = 0 then begin
                    "On Hold" := '';
                end else begin
                    if DisputeCode.Get(ACO_DisputeCode) then
                        Validate("On Hold", DisputeCode.ACO_HoldText)
                    else
                        "On Hold" := '';
                end;
            end;
        }
        field(50020; ACO_DisputeName; text[50])
        {
            Caption = 'Dispute Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(ACO_DisputeCode.ACO_Description WHERE(ACO_Code = FIELD(ACO_DisputeCode)));
        }
        //<<3.1.0.2018
    }

    trigger OnBeforeInsert();
    begin
        TryUpdatePaymentReference();
    end;

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        AddSetup: Record ACO_AdditionalSetup;

    //>>2.2.6.2018
    local procedure TryUpdateBusPostingGroups();
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        if not GenJnlTemplate.GET("Journal Template Name") then
            GenJnlTemplate.Init();

        if NOT (GenJnlTemplate.Type IN [GenJnlTemplate.Type::Purchases, GenJnlTemplate.Type::Sales]) then
            exit;

        // Account Type = GL
        if ("Account Type" = "Account Type"::"G/L Account") then begin
            if ("Bal. Account Type" = "Bal. Account Type"::Vendor) then begin
                if Vendor.GET("Bal. Account No.") then begin
                    Validate("Gen. Bus. Posting Group", Vendor."Gen. Bus. Posting Group");
                    Validate("VAT Bus. Posting Group", Vendor."VAT Bus. Posting Group");
                end;
            end;

            if ("Bal. Account Type" = "Bal. Account Type"::Customer) then begin
                if Customer.GET("Bal. Account No.") then begin
                    Validate("Gen. Bus. Posting Group", Customer."Gen. Bus. Posting Group");
                    Validate("VAT Bus. Posting Group", Customer."VAT Bus. Posting Group");
                end;
            end;

            exit;
        end;

        // Bal Account = GL
        if ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") then begin
            if ("Account Type" = "Account Type"::Vendor) then begin
                if Vendor.GET("Account No.") then begin
                    Validate("Bal. Gen. Bus. Posting Group", Vendor."Gen. Bus. Posting Group");
                    Validate("Bal. VAT Bus. Posting Group", Vendor."VAT Bus. Posting Group");
                end;
            end;

            if ("Account Type" = "Account Type"::Customer) then begin
                if Customer.GET("Account No.") then begin
                    Validate("Bal. Gen. Bus. Posting Group", Customer."Gen. Bus. Posting Group");
                    Validate("Bal. VAT Bus. Posting Group", Customer."VAT Bus. Posting Group");
                end;
            end;
        end;

    end;
    //<<2.2.6.2018

    //>>2.2.5.2018
    procedure TryUpdatePaymentMethodCode();
    var
        BankAccount: Record "Bank Account";
    begin
        if "BAl. Account Type" <> "Bal. Account Type"::"Bank Account" then
            exit;

        if "Bal. Account No." = '' then
            exit;

        if not GenJnlTemplate.GET("Journal Template Name") then
            GenJnlTemplate.Init();

        if GenJnlTemplate.Type <> GenJnlTemplate.Type::Payments then
            exit;

        if not BankAccount.get("Bal. Account No.") then
            BankAccount.init();

        VALIDATE("Payment Method Code", BankAccount.ACO_PaymentMethodCode);
    end;

    procedure TryUpdatePaymentReference();
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if "Payment Reference" <> '' then
            exit;

        if not AddSetup.get() then
            AddSetup.init();

        if not GenJnlTemplate.GET("Journal Template Name") then
            GenJnlTemplate.Init();

        AddSetup.TESTFIELD(ACO_PaymentRefSeriesNo);

        if GenJnlTemplate.Type <> GenJnlTemplate.Type::Payments then
            exit;

        // There can be gaps (this has been confirmed with customer)
        Validate("Payment Reference", NoSeriesMgt.GetNextNo(AddSetup.ACO_PaymentRefSeriesNo, TODAY, TRUE));
    end;

    procedure TryUpdateVendorRecipentBankAccount();
    begin
        if "Account Type" <> "Account Type"::Vendor then
            exit;

        if "Account No." = '' then
            exit;

        if not GenJnlTemplate.GET("Journal Template Name") then
            GenJnlTemplate.Init();

        if GenJnlTemplate.Type <> GenJnlTemplate.Type::Payments then
            exit;

        "Recipient Bank Account" := GetVendorBankAccount("Account No.", "Currency Code");

        //>>2.3.4.2018
        //if "Recipient Bank Account" <> '' then
        //<<2.3.4.2018
        Validate("Recipient Bank Account");
    end;

    procedure GetVendorBankAccount(VendorNo: code[20]; CurrCode: code[20]): Code[20];
    var
        VendorBankAcc: Record "Vendor Bank Account";
    begin
        VendorBankAcc.SetRange("Vendor No.", VendorNo);
        VendorBankAcc.SetRange("Currency Code", CurrCode);
        if VendorBankAcc.Count() > 1 then
            exit('');

        if not VendorBankAcc.FindFirst() then
            exit('');

        exit(VendorBankAcc.Code);
    end;
    //<<2.2.5.2018
}