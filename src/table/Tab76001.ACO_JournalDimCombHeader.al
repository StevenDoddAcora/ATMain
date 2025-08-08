table 50101 "ACO_JournalDimCombHeader"
{

    //#region "Documentation"
    //>>ABS001 - PMC - 30/07/2019 - This table contains Header details for "Journal Dimension Combination"
    //                                  - The table is required to meet requirement 03.09.05.01 of the initial specification
    //2.3.3.2018 LBR 26/11/2019 - CHG003377 (Purchase Invoice Default Dimensions) - new type added to the Type for Purchase Invoices;
    //#endregion "Documentation"


    DataClassification = CustomerContent;
    Caption = 'Journal Dimension Combination Header';
    DataCaptionFields = ACO_JournalType;
    LookupPageId = ACO_JournalDimCombinationList;
    DrillDownPageId = ACO_JournalDimCombinationList;

    fields
    {

        field(1; ACO_EntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            Description = 'Primary Key - It is just used as Primary Key';
        }

        field(2; ACO_JournalType; Option)
        {
            //>>2.3.3.2018
            //Caption = 'Journal Type';
            //DataClassification = CustomerContent;
            //OptionMembers = "General Journal","Sales Journal","Purchase Journal","Cash Receipt Journal","Payment Journal";
            //OptionCaption = 'General Journal,Sales Journal,Purchase Journal,Cash Receipt Journal,Payment Journal';
            //Description = 'It identifies the Journal Type related to the Journal Dimension Combination';
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = "General Journal","Sales Journal","Purchase Journal","Cash Receipt Journal","Payment Journal","Purchase Quote","Purchase Order","Purchase Invoice","Purchase Credit Memo";
            OptionCaption = 'General Journal,Sales Journal,Purchase Journal,Cash Receipt Journal,Payment Journal,,,Purchase Invoice,';
            Description = 'It identifies the Type related to the Journal/Document Dimension Combination';
            //<<2.3.3.2018
        }
        field(3; ACO_PrimaryShortcutDimensionCode; Option)
        {
            Caption = 'Primary Shortcut Dimension Code';
            DataClassification = CustomerContent;
            OptionMembers = "Shortcut Dimension 1","Shortcut Dimension 2","Shortcut Dimension 3","Shortcut Dimension 4","Shortcut Dimension 5","Shortcut Dimension 6","Shortcut Dimension 7","Shortcut Dimension 8";
            OptionCaption = 'Shortcut Dimension 1,Shortcut Dimension 2,Shortcut Dimension 3,Shortcut Dimension 4,Shortcut Dimension 5,Shortcut Dimension 6,Shortcut Dimension 7,Shortcut Dimension 8';
            Description = 'It determines which shortcut Dimesion should trigger the combination functionality';
            trigger OnValidate()
            begin
                //>> It validates the field and the "Primary Shortcut Dimension Code"
                ValidateShortCutDimensionCode(true);
            end;
        }
        field(4; ACO_PrimaryDimensionCode; Code[20])
        {
            Caption = 'Primary Dimension Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
            Description = 'It identifies the Primary Dimension Code';
            Editable = false;
            trigger OnValidate()
            begin
                //>> It validates the "Primary Dimension Code" ensuring it is specified
                ValidatePrimaryDimensionCode(true);
            end;
        }

    }

    keys
    {
        key(PK; ACO_EntryNo)
        {
            Clustered = true;
        }
    }

    //#region "Table Triggers"


    trigger OnInsert()
    begin
        //>> It sets the Entry No. on Insert
        SetEntryNo;
        //>> ---------------
        ValidateJournalType;
    end;

    trigger OnModify()
    begin
        //>> It sets the Entry No. on Insert
        SetEntryNo;
        //>> ---------------
        ValidateJournalType;
    end;

    ///<summary>It deletes related lines</summary>
    trigger OnDelete()
    begin
        //>> it deletes the related lines
        DeleteLines;
    end;


    //#endregion "Table Triggers"

    //#region "Table Functions"

    ///<summary>It sets the Entry No.</summary>
    local procedure SetEntryNo();
    var
        Table: Record ACO_JournalDimCombHeader;
    begin
        if (ACO_EntryNo = 0) then begin
            Table.Reset;
            if Table.FindLast() then begin
                ACO_EntryNo := (Table.ACO_EntryNo + 1);
            end else begin
                ACO_EntryNo := 1;
            end;
        end;
    end;

    ///<summary>It ensure the Journal Type is unique</summary>
    local procedure ValidateJournalType()
    var
        Table: Record ACO_JournalDimCombHeader;
        //>> -----------------------------------
        DimCombinationExistsErrMessage: Label 'A Journal Dimension Combination already exists for %1 %2.', MaxLength = 999, Comment = '', Locked = false;
    begin
        Table.Reset;
        Table.SetRange(ACO_JournalType, Rec.ACO_JournalType);
        Table.SetFilter(ACO_EntryNo, '<>%1', Rec.ACO_EntryNo);
        if not Table.IsEmpty then begin
            Error(DimCombinationExistsErrMessage,
                  FieldCaption(ACO_JournalType),         //>> %1
                  ACO_JournalType);                      //>> %2
        end;
    end;


    ///<summary>It validates the shortcut dimension code</summary>
    ///<summary>It assigns the required "Primary Dimension Code"</summary>
    procedure ValidateShortCutDimensionCode(Mandatory: Boolean)
    var
        GenLedgerSetup: Record "General Ledger Setup";
    begin
        if GenLedgerSetup.Get then begin
            case ACO_PrimaryShortcutDimensionCode of
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 1":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 1 Code";
                    end;    //>> End Shortcut Dimension 1
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 2":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 2 Code";
                    end;    //>> End Shortcut Dimension 2
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 3":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 3 Code";
                    end;    //>> End Shortcut Dimension 3
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 4":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 4 Code";
                    end;    //>> End Shortcut Dimension 4
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 5":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 5 Code";
                    end;    //>> End Shortcut Dimension 5
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 6":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 6 Code";
                    end;    //>> End Shortcut Dimension 6
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 7":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 7 Code";
                    end;    //>> End Shortcut Dimension 7
                ACO_PrimaryShortcutDimensionCode::"Shortcut Dimension 8":
                    begin
                        ACO_PrimaryDimensionCode := GenLedgerSetup."Shortcut Dimension 8 Code";
                    end;    //>> End Shortcut Dimension 8
            end;    //>> End Case
        end else begin
            ACO_PrimaryDimensionCode := '';
        end;    //>> End If Get

        //>> It validates the primary dimension code
        ValidatePrimaryDimensionCode(Mandatory);

    end;

    ///<summary>It validates Primary Dimension Code</summary>
    local procedure ValidatePrimaryDimensionCode(Mandatory: Boolean)
    var
        MustSpecifyErrorMessage: Label '%1 is not set to any Dimension Code therefore %2 is not specified. %2 must be specified', MaxLength = 999, Comment = '', Locked = false;
        PrimaryDimensionCodeChangeConfirm: Label '%1 has been change (from %2 to %3). %4 for %5 %6 should be re-configured, all lines will be deleted. Do you want to proceed?', MaxLength = 999, Comment = 'CommentText', Locked = false;
        //>> ------------------------------
        Line: Record ACO_JournalDimCombLine;
    begin

        if StrLen(ACO_PrimaryDimensionCode) = 0 then begin
            if Mandatory then begin
                Error(MustSpecifyErrorMessage,
                      ACO_PrimaryShortcutDimensionCode,         //>> %1
                      FieldCaption(ACO_PrimaryDimensionCode));  //>> %2
            end;
        end else begin
            if Rec.ACO_PrimaryDimensionCode <> xRec.ACO_PrimaryDimensionCode then begin
                if LineExist then begin
                    if Confirm(PrimaryDimensionCodeChangeConfirm, true,
                               FieldCaption(ACO_PrimaryDimensionCode),          //>> %1
                               xRec.ACO_PrimaryDimensionCode,                   //>> %2
                               Rec.ACO_PrimaryDimensionCode,                    //>> %3
                               Line.TableCaption,                               //>> %4
                               Rec.TableCaption,                                //>> %5
                               ACO_JournalType) then begin                      //>> %6 
                        //>> it deletes the Lines ...       
                        DeleteLines;
                    end else begin   //>> value should be reverted to xRec value
                        ACO_PrimaryShortcutDimensionCode := xRec.ACO_PrimaryShortcutDimensionCode;
                        ACO_PrimaryDimensionCode := xRec.ACO_PrimaryDimensionCode;
                    end;
                end;
            end;
        end;

    end;

    ///<summary>It determines whether lines exist for the Journal Dimension Setup</summary>
    local procedure LineExist(): Boolean
    var
        Line: Record ACO_JournalDimCombLine;
    begin
        Line.Reset;
        Line.SetRange(ACO_EntryNo, Rec.ACO_EntryNo);
        exit(not Line.IsEmpty);
    end;

    ///<summary>It Deletes the Lines related to the Header table</summary>
    local procedure DeleteLines();
    var
        Line: Record ACO_JournalDimCombLine;
    begin
        Line.Reset;
        Line.SetRange(ACO_EntryNo, Rec.ACO_EntryNo);
        Line.DeleteAll(true);
    end;


    //#endregion "Table Functions"

}