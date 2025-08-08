table 50102 "ACO_JournalDimCombLine"

//#region "Documentation"
//>>ABS001 - PMC - 30/07/2019 - This table contains line details for "Journal Dimension Combination"
//                                  - The table is required to meet requirement 03.09.05.01 of the initial specification
//#endregion "Documentation"

{
    DataClassification = CustomerContent;
    Caption = 'Journal Dimension Combination Line';

    fields
    {
        field(1; ACO_EntryNo; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            Description = 'It replicates the Primary Key of the header table';
        }

        ///<summary>The field is not editable since is copied from the Header table [50001]</summary>
        field(2; ACO_PrimaryDimensionCode; Code[20])
        {
            Caption = 'Primary Dimension Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
            Description = 'It identifies the Primary Dimension Code';
            Editable = false;
            trigger OnValidate()
            begin
                ValidateField(FieldNo(ACO_PrimaryDimensionCode), true, false);
            end;
        }
        field(3; ACO_PrimaryDimensionValue; Code[20])
        {
            Caption = 'Primary Dimension Value';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field(ACO_PrimaryDimensionCode));
            Description = 'It identifies the Dimension Value for the related Primary Dimension Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateField(FieldNo(ACO_PrimaryDimensionValue), true, false);
            end;
        }
        field(4; ACO_DimensionCode; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
            Description = 'It identifies the Dimension Code';
            trigger OnValidate()
            begin
                ValidateField(FieldNo(ACO_DimensionCode), true, false);
            end;

        }
        field(5; ACO_DimensionValue; Code[20])
        {
            Caption = 'Dimension Value';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field(ACO_DimensionCode));
            Description = 'It identifies the Dimension Value for the related Dimension Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateField(FieldNo(ACO_DimensionValue), true, false);
            end;

        }
        field(6; ACO_ShortcutDimensionNo; Integer)
        {
            Caption = 'Shortcut Dimension No.';
            Description = '[Uneditable] - It is only used to simplify to the way to code determines whether the dimension should be updated';
            Editable = false;
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; ACO_EntryNo, ACO_PrimaryDimensionCode, ACO_PrimaryDimensionValue, ACO_DimensionCode)
        {
            Clustered = true;
        }
    }

    //#region "Table Triggers"


    trigger OnInsert()
    begin
        //>> It validates all relevant fields
        ValidateAllFields(true, true);
    end;


    //#endregion "Trigger Triggers"

    //#region "Table Functions"

    ///<summary>It validates the Field ensuring it is specified</summary>
    local procedure ValidateField(FieldNumber: Integer; Mandatory: Boolean; OnInsert: Boolean)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        //>> --------------
        Header: Record ACO_JournalDimCombHeader;
        //>> --------------
        FieldValue: Text;
        //>> --------------
        DimensionNumber: Integer;
        //>> --------------
        MustBeSpecifiedErrorMessage: Label '%1 must be specified.', MaxLength = 999, Comment = '', Locked = false;
        DifferentPrimaryDimensionCodeErrorMessage: Label '%1 must be set to the same value of field %2 on the related %3 (%4).', MaxLength = 999, Comment = '', Locked = false;
        NoShortcutDimErrorMessage: Label 'The specified %1 (%2) is not set as a Shortcut Dimension therefore it cannot be used as part of a Journal Dimension Combination', MaxLength = 999, Comment = '', Locked = false;
    begin
        //>> it gets the field and the field value
        RecRef.GetTable(Rec);
        FldRef := RecRef.Field(FieldNumber);
        FieldValue := Format(FldRef.Value);

        if StrLen(FieldValue) = 0 then begin
            if Mandatory then begin
                Error(MustBeSpecifiedErrorMessage, FldRef.Caption);
            end else begin
                exit;   //>> If there is no value specified there is no need for further validation
            end;
        end;

        //>> It implements field specific validation
        case FieldNumber of
            FieldNo(ACO_PrimaryDimensionCode):
                begin
                    if not OnInsert then begin
                        if FieldValue <> GetParentPrimaryDimensionCode(true) then begin
                            //>> %1 must be set to the same value of field %2 on the related %3 (%4).
                            Error(DifferentPrimaryDimensionCodeErrorMessage,
                                    FieldCaption(ACO_PrimaryDimensionCode),               //>> %1
                                    Header.FieldCaption(ACO_PrimaryDimensionCode),        //>> %2
                                    Header.TableCaption,                                  //>> %3
                                    GetParentPrimaryDimensionCode(false));                //>> %4
                        end;
                    end;
                end;    //>> End Primary Dimension Code
            FieldNo(ACO_DimensionCode):
                begin
                    if not IsShortcutDimension(ACO_DimensionCode, DimensionNumber) then begin
                        Error(NoShortcutDimErrorMessage,
                              FieldCaption(ACO_DimensionCode),      //>> %1
                              ACO_DimensionCode);                   //>> %2
                    end else begin
                        ACO_ShortcutDimensionNo := DimensionNumber;
                        //>> -------------------------------------------------------
                        if Rec.ACO_DimensionCode <> xRec.ACO_DimensionCode then begin
                            if not OnInsert then begin
                                ACO_DimensionValue := '';   //>> It clears the related dimension value
                            end;
                        end;
                    end;
                end;    //>> End Dimension Code
        end;    //>> End Case 
    end;

    ///<summary>It validates all relevant fields</summary>
    local procedure ValidateAllFields(Mandatory: Boolean; OnInsert: Boolean)
    begin
        //>> Primary Dimension Code
        ValidateField(FieldNo(ACO_PrimaryDimensionCode), Mandatory, OnInsert);
        //>> Primary Dimension Value
        ValidateField(FieldNo(ACO_PrimaryDimensionValue), Mandatory, OnInsert);
        //>> Dimension Code
        ValidateField(FieldNo(ACO_DimensionCode), Mandatory, OnInsert);
        //>> Dimension Value
        ValidateField(FieldNo(ACO_DimensionValue), Mandatory, OnInsert);
    end;

    ///<summary>It determines whether the spaecified Dimension Code is set as a Shortcut Dimension</summary>
    local procedure IsShortcutDimension(DimensionCode: Code[20]; var DimensionNumber: Integer): Boolean
    var
        GenLedgSetup: Record "General Ledger Setup";
    begin
        if StrLen(DimensionCode) = 0 then begin
            DimensionNumber := 0;
            exit(false);
        end else begin
            if not GenLedgSetup.Get then begin
                DimensionNumber := 0;
                exit(false)
            end else begin
                if GenLedgSetup."Shortcut Dimension 1 Code" = DimensionCode then begin
                    DimensionNumber := 1;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 2 Code" = DimensionCode then begin
                    DimensionNumber := 2;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 3 Code" = DimensionCode then begin
                    DimensionNumber := 3;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 4 Code" = DimensionCode then begin
                    DimensionNumber := 4;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 5 Code" = DimensionCode then begin
                    DimensionNumber := 5;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 6 Code" = DimensionCode then begin
                    DimensionNumber := 6;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 7 Code" = DimensionCode then begin
                    DimensionNumber := 7;
                    exit(true);
                end;
                if GenLedgSetup."Shortcut Dimension 8 Code" = DimensionCode then begin
                    DimensionNumber := 8;
                    exit(true);
                end;
            end;
        end;
    end;

    ///<summary>It gets the Parent Primary Dimension Code</summary>
    local procedure GetParentPrimaryDimensionCode(Mandatory: Boolean): Code[20]
    var
        Header: Record ACO_JournalDimCombHeader;
        //>> -----------------------------------------
        MustBeSpecifiedErrorMessage: Label '%1 has not been specified for the related %2. %1 must be specified.', MaxLength = 999, Comment = '', Locked = false;
    begin
        Header.Reset;
        Header.SetRange(ACO_EntryNo, Rec.ACO_EntryNo);
        if Header.FindFirst() then begin
            if StrLen(Header.ACO_PrimaryDimensionCode) = 0 then begin
                if Mandatory then begin
                    Error(MustBeSpecifiedErrorMessage,
                          Header.FieldCaption(ACO_PrimaryDimensionCode),        //>> %1
                          Header.TableCaption);                                 //>> %2
                end;
            end;
            //>> It gets the "Primary Dimension Code" from the related header
            exit(Header.ACO_PrimaryDimensionCode);
        end;
    end;

    ///<summary>It sets a new record for the table</summary>
    procedure SetNewRecord(ParentDimCode: Code[20])
    var
        DimensionCode: Code[20];
    begin
        if Strlen(ParentDimCode) = 0 then begin
            DimensionCode := GetParentPrimaryDimensionCode(false);
        end else begin
            DimensionCode := ParentDimCode;
        end;
        //>> ------------------------------------------------
        //>> It does not call validation since it would cause an error message to be triggered when inserting a new "Journal Dimension Combination"
        ACO_PrimaryDimensionCode := DimensionCode;
    end;

    //#endregion "Table Functions"

}