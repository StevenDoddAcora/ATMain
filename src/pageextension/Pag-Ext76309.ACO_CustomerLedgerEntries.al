pageextension 50309 "ACO_CustomerLedgerEntries" extends "Customer Ledger Entries" // It extends page 25 - "Customer Ledger Entries"
{

    //#region "Documentation"
    //ABS001 - PMC - 01/08/2019 - This page extension extends table 25 - "Customer Ledger Entries"
    //      - To meet intial specification requirement  03.09.03 the following changes have been introduced:
    //          - Field "ACO_DisputeCode" [50000] added to the table to specify the dispute code related to the Cust. Ledger Entry
    //2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    layout
    {
        addafter("Customer No.")
        {
            //>>2.3.0.2018
            field(ACO_CustomerName; Rec.ACO_CustomerName)
            {
                Visible = true;
                Editable = false;
            }
            //<<2.3.0.2018
        }

        addbefore("On Hold")
        {
            field(ACO_DisputeCode; Rec.ACO_DisputeCode)
            {
                ApplicationArea = All;
                ToolTip = 'It identifies the Dispute Code related to the Customer Ledger Entry';
                Visible = true;
            }
            //>>2.3.0.2018
            field(ACO_DisputeName; Rec.ACO_DisputeName)
            {
                Visible = true;
                Editable = false;
            }
            //<<2.3.0.2018
        }

        ///<summary>It modifies "On Hold"</summary>
        Rec.modify("On Hold")
        {
            ///<summary>The field is now disabled since it can only be changed via changing "Dispute Code"</summary>
            Enabled = false;
        }
    }

    actions
    {
    }
}


