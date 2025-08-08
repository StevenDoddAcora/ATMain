page 50203 "ACO_JournalDimCombinationList"
{

    //#region "Documentation"
    //ABS001 - PMC - 31/07/2019 - This page is the List page for "Journal Dimension Combination Management"
    //2.3.3.2018 LBR 26/11/2019 - CHG003377 (Purchase Invoice Default Dimensions) - page name changed as it support now Documents as well;
    //#endregion "Documentation"


    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    SourceTable = ACO_JournalDimCombHeader;
    CardPageId = ACO_JournalDimCombination;
    //>>2.3.3.2018
    //Caption = 'Journal Dimension Combinations';
    Caption = 'Journal/Document Dimension Combinations';
    //<<2.3.3.2018

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ACO_JournalType; Rec.ACO_JournalType)
                {
                    ApplicationArea = All;
                    //>>2.3.3.2018
                    //ToolTip = 'It identifies the Journal Type related to the Journal Dimension Combination';
                    ToolTip = 'It identifies the Type related to the Journal/Document Dimension Combination';
                    //<<2.3.3.2018
                }
                field(ACO_PrimaryShortcutDimensionCode; Rec.ACO_PrimaryShortcutDimensionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'It determines which shortcut Dimesion should trigger the combination functionality';
                }
                field(ACO_PrimaryDimensionCode; Rec.ACO_PrimaryDimensionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'It identifies the Primary Dimension Code';
                }

            }
        }
        area(Factboxes)
        {
        }
    }

    actions
    {
    }
}