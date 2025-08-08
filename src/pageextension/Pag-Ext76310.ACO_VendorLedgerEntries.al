pageextension 50310 "ACO_VendorLedgerEntries" extends "Vendor Ledger Entries" // It extends page 29 - "Vendor Ledger Entries"
{

    //#region "Documentation"
    //ABS001 - PMC - 01/08/2019 - This page extension extends table 29 - "Vendor Ledger Entries"
    //      - To meet intial specification requirement  03.09.03 the following changes have been introduced:
    //          - Field "ACO_DisputeCode" [50000] added to the table to specify the dispute code related to the Cust. Ledger Entry
    //2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"


    layout
    {

        addafter("Vendor No.")
        {
            //>>2.3.0.2018
            field(ACO_VendorName; ACO_VendorName)
            {
                Visible = true;
                Editable = false;
            }
            //<<2.3.0.2018
        }

        addbefore("On Hold")
        {
            field(ACO_DisputeCode; ACO_DisputeCode)
            {
                ApplicationArea = All;
                ToolTip = 'It identifies the Dispute Code related to the Vendor Ledger Entry';
                Visible = true;
            }
            //>>2.3.0.2018
            field(ACO_DisputeName; ACO_DisputeName)
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
        addlast(Processing)
        {
            action(DisputeAuditTrail)
            {
                ApplicationArea = All;
                Caption = 'Dispute Audit Trail Entries';
                Image = EntriesList;

                trigger OnAction()
                var
                    VendDisputeEntry: Record ACO_VendorDisputeEntry;
                begin
                    VendDisputeEntry.Rec.SetRange(ACO_VendorLedgerEntryNo, rec."Entry No.");
                    Page.Run(0, VendDisputeEntry);
                end;
            }
        }
    }
}