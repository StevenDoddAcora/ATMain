page 50205 "ACO_VendorDisputeEntries"
{
    //#region "Documentation"
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New object created
    //#endregion "Documentation"

    Caption = 'Dispute Audit Trail Entries';
    PageType = List;
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = ACO_VendorDisputeEntry;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ACO_EntryNo; Rec.ACO_EntryNo)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ACO_VendorNo; Rec.ACO_VendorNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_VendorName; Rec.ACO_VendorName)
                {
                    ApplicationArea = All;
                }
                field(ACO_DocumentType; Rec.ACO_DocumentType)
                {
                    ApplicationArea = All;
                }
                field(ACO_DocumentNo; Rec.ACO_DocumentNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_DocumentDate; Rec.ACO_DocumentDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_PostingDate; Rec.ACO_PostingDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_Amount; Rec.ACO_Amount)
                {
                    ApplicationArea = All;
                }
                field(ACO_CurrencyCode; Rec.ACO_CurrencyCode)
                {
                    ApplicationArea = All;
                }
                field(ACO_ExteranlDocNo; Rec.ACO_ExteranlDocNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_VendorLedgerEntryNo; Rec.ACO_VendorLedgerEntryNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_UserID; Rec.ACO_UserID)
                {
                    ApplicationArea = All;
                }
                field(ACO_UserName; Rec.ACO_UserName)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ACO_CreationDate; Rec.ACO_CreationDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_CreationTime; Rec.ACO_CreationTime)
                {
                    ApplicationArea = All;
                }
                field(ACO_OldDisputeCode; Rec.ACO_OldDisputeCode)
                {
                    ApplicationArea = All;
                }
                field(ACO_OldDisputeName; Rec.ACO_OldDisputeName)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ACO_NewDisputeCode; Rec.ACO_NewDisputeCode)
                {
                    ApplicationArea = All;
                }
                field(ACO_NewDisputeName; Rec.ACO_NewDisputeName)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
        // area(Factboxes)
        // {

        // }
    }

    actions
    {
        // area(Processing)
        // {
        //     action(ActionName)
        //     {
        //         ApplicationArea = All;

        //         trigger OnAction();
        //         begin

        //         end;
        //     }
        // }
    }
}