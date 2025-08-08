tableextension 50115 "ACO_VendorBankAccount" extends "Vendor Bank Account"
{
    //#region "Documentation"
    // 2.3.4.2018 LBR 05/11/2019 - CHG003386 (Payment Journals) - new "Manual Export" logic added
    //#endregion "Documentation"

    fields
    {
        field(50010; "ACO_ManualPaymentExp"; Boolean)
        {
            Caption = 'Manual Payment Export';
            DataClassification = ToBeClassified;
        }

    }

}