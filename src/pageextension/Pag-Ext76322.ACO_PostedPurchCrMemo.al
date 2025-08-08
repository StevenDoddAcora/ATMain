pageextension 50322 "ACO_PostedPurchCrMemo" extends "Posted Purchase Credit Memo"
{
    //#region "Documentation"
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New fields added;
    //#endregion "Documentation"

    layout
    {
        addlast(General)
        {
            field(ACO_DisputeCode; Rec.ACO_DisputeCode)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ACO_DisputeName; Rec.ACO_DisputeName)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
    }
}

