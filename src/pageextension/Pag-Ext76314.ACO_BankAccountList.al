pageextension 50314 "ACO_BankAccountList" extends "Bank Account List"
{
    //#region "Documentation"
    //2.2.3.2018 LBR 13/09/2019 - Sangging to use correct bank account on the statement;    
    //#endregion "Documentation"

    layout
    {
        addlast(Control1)
        {
            field(ACO_Default; Rec.ACO_Default)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

