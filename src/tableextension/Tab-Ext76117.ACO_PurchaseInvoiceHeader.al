tableextension 50118 "ACO_PurchaseInvoiceHeader" extends "Purch. Inv. Header"
{
    //#region "Documentation"
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New fields added
    //#endregion "Documentation"

    fields
    {
        field(50000; ACO_DisputeCode; Code[10])
        {
            Caption = 'Dispute Code';
            TableRelation = ACO_DisputeCode;
            DataClassification = CustomerContent;
            Description = 'It identifies the Dispute Code related to the Vendor Ledger Entry';
        }
        field(50020; ACO_DisputeName; text[50]){
            Caption = 'Dispute Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(ACO_DisputeCode.ACO_Description WHERE (ACO_Code=FIELD(ACO_DisputeCode)));
        }
    } 
}