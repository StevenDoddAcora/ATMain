table 50103 "ACO_DisputeCode"
{
    //#region "Documentation"
    //ABS001 - PMC - 01/08/2019 - This table contains the definition of "Dispute Codes" required to meet initial specification requirement 03.09.03
    //#endregion "Documentation"


    DataClassification = CustomerContent;
    Caption = 'Dispute Code';
    LookupPageId = ACO_DisputeCodes;
    DrillDownPageId = ACO_DisputeCodes;

    fields
    {
        field(1; ACO_Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            Description = '[Primary Key] - It identifies the code of the dispute';

        }
        ///<summary>According to the specification the field should be 100 characters but the field value should be copied to the comment table and the comment table allows 80 characters</summary>
        ///<summary>It </summary>
        field(2; ACO_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Description = 'It identifies the description of the Dispute Code';
            Editable = true;
            trigger OnValidate()
            begin
                ValidateField(FieldNo(ACO_Description), true);
            end;
        }
        field(3; ACO_HoldText; Code[3])
        {
            Caption = 'Hold Text';
            DataClassification = CustomerContent;
            Description = 'It identifies the Hold Text related to the Dispute Code';
            Editable = true;
            trigger OnValidate()
            begin
                ValidateField(FieldNo(ACO_HoldText), true);
            end;
        }



    }

    keys
    {
        key(PK; ACO_Code)
        {
            Clustered = true;
        }
        key(AK; ACO_Description)
        {

        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; ACO_Code, ACO_Description) { }
    }

    //#region "Table Triggers"

    trigger OnInsert()
    begin
        //>> It validates all fields
        ValidateAllFields(true);
    end;

    trigger OnModify()
    begin
        //>> It validates all fields
        ValidateAllFields(true);
    end;

    //#endregion "Table Triggers"

    //#region "Table Functions"

    ///<summary>It validates the fields checking that mandatory fields are specified</summary>
    local procedure ValidateField(FieldNumber: Integer; Mandatory: Boolean)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        //>> --------------
        FieldValue: Text;
        //>> --------------
        MustBeSpecifiedErrorMessage: Label '%1 must be specified.', MaxLength = 999, Comment = '', Locked = false;
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
    end;

    ///<summary>It validates all relevant fields</summary>
    local procedure ValidateAllFields(Mandatory: Boolean)
    begin
        ValidateField(FieldNo(ACO_Description), Mandatory);
        ValidateField(FieldNo(ACO_HoldText), Mandatory);
    end;

    //#endregion "Table Functions"

}