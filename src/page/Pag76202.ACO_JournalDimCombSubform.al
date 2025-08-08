page 50202 "ACO_JournalDimCombSubform"
{

    //#region "Documentation"
    //ABS001 - PMC - 31/07/2019 - This page is the Sub-page for "Journal Dimension Combination Management"
    //2.3.3.2018 LBR 26/11/2019 - CHG003377 (Purchase Invoice Default Dimensions) - page name changed as it support now Documents as well;
    //#endregion "Documentation"


    PageType = ListPart;
    SourceTable = ACO_JournalDimCombLine;
    MultipleNewLines = true;
    LinksAllowed = false;
    DelayedInsert = true;
    AutoSplitKey = false;
    Caption = 'Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ACO_PrimaryDimensionValue; Rec.ACO_PrimaryDimensionValue)
                {
                    ApplicationArea = All;
                    ToolTip = 'It identifies the Dimension Value for the related Primary Dimension Code';
                }
                field(ACO_DimensionCode; Rec.ACO_DimensionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'It identifies the Dimension Value for the related Primary Dimension Code';
                }
                field(ACO_DimensionValue; Rec.ACO_DimensionValue)
                {
                    ApplicationArea = All;
                    ToolTip = 'It identifies the Dimension Value for the related Dimension Code';
                }
            }
        }
    }

    actions
    {
    }

    //#region "Page Triggers"

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //>> It sets the new record with data from the Parent ...
        Rec.SetNewRecord(ParentDimCode);
    end;

    //#endregion "Page Triggers"

    //#region "Page Functions"

    procedure SetParentDimCode(ParentDimCode2: Code[20]);
    var
    begin
        ParentDimCode := ParentDimCode2;
    end;

    //#endregion "Page Functions"

    var
        ParentDimCode: Code[20];

}