pageextension 50322 "ACO_PostedPurchCrMemo" extends "Posted Purchase Credit Memo"
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