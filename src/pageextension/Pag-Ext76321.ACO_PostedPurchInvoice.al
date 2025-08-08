pageextension 50321 "ACO_PostedPurchInvoice" extends "Posted Purchase Invoice"
{
    //#region "Documentation"
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New fields added;
    //#endregion "Documentation"

    layout
    {
        addlast(General)
        {
            field(ACO_DisputeCode; ACO_DisputeCode)
            {
                ApplicationArea = all;
                Editable = false;
                trigger OnValidate();
                begin
                    CalcFields(ACO_DisputeName);
                end;
            }
            field(ACO_DisputeName; ACO_DisputeName)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
    }
}