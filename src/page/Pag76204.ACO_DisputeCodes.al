page 50204 "ACO_DisputeCodes"
{

    //#region "Documentation"
    //ABS001 - PMC - 01/08/2019 - This page manages the definition of "Dispute Codes" required to meet initial specification requirement 03.09.03
    //#endregion "Documentation"


    PageType = List;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = ACO_DisputeCode;
    Caption = 'Dispute Codes';
    Editable = true;
    LinksAllowed = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ACO_Code; Rec.ACO_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the code of the dispute';
                }
                field(ACO_Description; Rec.ACO_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the description of the Dispute Code';
                }
                field(ACO_HoldText; Rec.ACO_HoldText)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the Hold Text related to the Dispute Code [the text is used to populate On Hold field in Customer Ledger Entries and Vendor Ledger Entries]';
                }
            }
        }
        area(Factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}