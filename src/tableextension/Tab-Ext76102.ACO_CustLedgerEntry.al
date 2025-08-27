namespace Acora.AvTrade.MainApp;

using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using System.Text;

tableextension 50102 "ACO_CustLedgerEntry" extends "Cust. Ledger Entry" // It extends table 21 - "Cust. Ledger Entry"
{

    //#region "Documentation"
    //ABS001 - PMC - 01/08/2019 - This table extension extends table 21 - "Cust. Ledger Entry"
    //      - To meet intial specification requirement  03.09.03 the following changes have been introduced:
    //          - Field "ACO_DisputeCode" [50000] added to the table to specify the dispute code related to the Cust. Ledger Entry
    //2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"


    fields
    {
        field(50000; ACO_DisputeCode; Code[10])
        {
            Caption = 'Dispute Code';
            TableRelation = ACO_DisputeCode;
            DataClassification = CustomerContent;
            Description = 'It identifies the Dispute Code related to the Customer Ledger Entry';
            Editable = true;
            trigger OnValidate()
            begin
                ValidateDisputeCode;
            end;
        }

        //>>2.3.0.2018
        field(50010; ACO_CustomerName; text[50])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
        }
        field(50020; ACO_DisputeName; text[50])
        {
            Caption = 'Dispute Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(ACO_DisputeCode.ACO_Description WHERE(ACO_Code = FIELD(ACO_DisputeCode)));
        }
        //<<2.3.0.2018
    }

    //#region "Table Functions"

    ///<summary>It validates the Dispute Code on assigns the "Hold Text"</summary>
    local procedure ValidateDisputeCode()
    var
        DisputeCode: Record ACO_DisputeCode;
        Management: Codeunit ACO_DisputeManagement;
    begin
        if strlen(ACO_DisputeCode) = 0 then begin
            "On Hold" := '';    //>> On Hold is cleared
        end else begin
            DisputeCode.Reset;
            DisputeCode.SetRange(ACO_Code, ACO_DisputeCode);
            if DisputeCode.FindFirst() then begin
                Validate("On Hold", DisputeCode.ACO_HoldText);
                //>> It creates the comment for the related Document
                Management.InsertDisputeComment(Database::"Cust. Ledger Entry", Rec."Entry No.", DisputeCode);
            end else begin
                "On Hold" := '';
            end;
        end;
    end;

    //#endregion "Table Functions"

}