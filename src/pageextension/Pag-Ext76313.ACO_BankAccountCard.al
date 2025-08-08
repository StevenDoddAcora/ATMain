pageextension 50313 "ACO_BankAccountCard" extends "Bank Account Card"
{
    //#region "Documentation"
    // 2.2.3.2018 LBR 13/09/2019 - Sangging to use correct bank account on the statement;    
    // 2.2.5.2018 LBR 15/10/2019 - CHG003334 (BAC's Export file selection). New fields added;
    //#endregion "Documentation"

    layout
    {
        addafter("Payment Match Tolerance")
        {
            field(ACO_Default; Rec.ACO_Default)
            {
                ApplicationArea = All;
            }
        }
        //>>2.2.5.2018
        addafter("Payment Export Format")
        {
            field(ACO_BankPaymentType; Rec.ACO_BankPaymentType)
            {
                ApplicationArea = All;
            }
            field(ACO_PaymentMethodCode; Rec.ACO_PaymentMethodCode)
            {
                ApplicationArea = All;
            }
        }
        //<<2.2.5.2018
    }

    actions
    {
    }
}

