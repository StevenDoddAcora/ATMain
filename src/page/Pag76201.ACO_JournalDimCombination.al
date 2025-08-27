namespace Acora.AvTrade.MainApp;

using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Document;

page 50201 "ACO_JournalDimCombination"
{

    //#region "Documentation"
    //ABS001 - PMC - 31/07/2019 - This page is the Main page for "Journal Dimension Combination Management"
    //2.3.3.2018 LBR 26/11/2019 - CHG003377 (Purchase Invoice Default Dimensions) - page name changed as it support now Documents as well;
    //#endregion "Documentation"


    PageType = Document;
    SourceTable = ACO_JournalDimCombHeader;
    //>>2.3.3.2018
    //Caption = 'Journal Dimension Combinations';
    Caption = 'Journal/Document Dimension Combinations';
    //<<2.3.3.2018

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Visible = true;

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
                    trigger OnValidate()
                    begin
                        CurrPage.Lines.Page.SetParentDimCode(Rec.ACO_PrimaryDimensionCode);
                    end;
                }
                field(ACO_PrimaryDimensionCode; Rec.ACO_PrimaryDimensionCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'It identifies the Primary Dimension Code';
                }
            }
            part(Lines; ACO_JournalDimCombSubform)
            {
                SubPageLink = ACO_EntryNo = field(ACO_EntryNo);
                UpdatePropagation = Both;

            }
        }
    }

    actions
    {
    }

    //#region "Page Triggers"

    ///<summary>It triggers code on new record to ensure the related fields are update as required</summary>
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //>> It calls the validation of the selected Shortcut dimension to ensure the related fields are correctly validated
        Rec.ValidateShortCutDimensionCode(false);
        //>> It sets the Parent Dimension Code on the sub-form
        CurrPage.Lines.Page.SetParentDimCode(Rec.ACO_PrimaryDimensionCode);
    end;

    //#endregion "Page Triggers"

}