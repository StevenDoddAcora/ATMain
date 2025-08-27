namespace Acora.AvTrade.MainApp;

using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Setup;

tableextension 50111 "ACO_BankAccount_Ext" extends "Bank Account"
{
    //#region "Documentation"
    // 2.2.3.2018 LBR 13/09/2019 - Sangging to use correct bank account on the statement;  
    // 2.2.5.2018 LBR 15/10/2019 - CHG003334 (BAC's Export file selection). New field added;  
    // 2.2.6.2018 LBR 16/10/2019 - Snagging 
    //#endregion "Documentation"

    fields
    {
        field(50000; ACO_Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = ToBeClassified;
            trigger OnValidate();
            var
                BankAccount: Record "Bank Account";
                ErrorText: Label 'For Currency Code = %1 there is already another Bank Account set as %2';
                GenLedSetup: Record "General Ledger Setup";
            begin
                GenLedSetup.get();

                if ACO_Default then begin
                    BankAccount.SetFilter("No.", '<>%1', "No.");
                    BankAccount.SetRange("Currency Code", "Currency Code");
                    //>>2.2.6.2018
                    BankAccount.SetRange(ACO_Default, true);
                    //<<2.2.6.2018
                    if BankAccount.FindFirst() then begin
                        if "Currency Code" = '' then
                            Error(ErrorText, GenLedSetup."LCY Code", FieldCaption(ACO_Default))
                        else
                            Error(ErrorText, "Currency Code", FieldCaption(ACO_Default));
                    end;
                end;
            end;
        }
        //>>2.2.5.2018
        field(50010; ACO_PaymentMethodCode; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(50020; ACO_BankPaymentType; Enum "Bank Payment Type")
        {
            Caption = 'Bank Payment Type';
            DataClassification = ToBeClassified;
        }
        //<<2.2.5.2018              
    }
}
