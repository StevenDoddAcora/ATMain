pageextension 50318 "ACO_VendorBankAccCard" extends "Vendor Bank Account Card"
{
    //#region "Documentation"
    // 2.3.4.2018 LBR 05/12/2019 - CHG003386 (Payment Journals) - new "Manual Export" logic added
    //#endregion "Documentation"

    layout
    {
        addlast(General)
        {
            field(ACO_ManualPaymentExp; ACO_ManualPaymentExp)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}