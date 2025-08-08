pageextension 50317 "ACO_PurchInvSubform" extends "Purch. Invoice Subform"
{
    //#region "Documentation"
    //  2.3.3.2018 LBR 26/11/2019 - CHG003377 (Purchase Invoice Default Dimensions) - same logic as for combined dimension bespoke but for purch inv;
    //#endregion "Documentation"

    layout
    {
        addlast(Control1)
        {
            //>> Add new controls based on new Shortcut dimension array
            field(ExtendedShortcutDimCode3; ExtendedShortcutDimCode[3])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,3';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3), "Dimension Value Type" = const(Standard), "Blocked" = const(false));
                Visible = ExtendedShortcutDimVisible3;
                trigger OnValidate()
                begin
                    //>> It replicates the stardard validation
                    ValidateShortcutDimCode(3, ExtendedShortcutDimCode[3]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(3, ExtendedShortcutDimCode[3])
                end;
            }
            field(ExtendedShortcutDimCode4; ExtendedShortcutDimCode[4])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), "Dimension Value Type" = const(Standard), "Blocked" = const(false));
                Visible = ExtendedShortcutDimVisible4;
                trigger OnValidate()
                begin
                    //>> It replicates the stardard validation
                    ValidateShortcutDimCode(4, ExtendedShortcutDimCode[4]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(4, ExtendedShortcutDimCode[4])
                end;
            }
            field(ExtendedShortcutDimCode5; ExtendedShortcutDimCode[5])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,5';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5), "Dimension Value Type" = const(Standard), "Blocked" = const(false));
                Visible = ExtendedShortcutDimVisible5;
                trigger OnValidate()
                begin
                    //>> It replicates the stardard validation
                    ValidateShortcutDimCode(5, ExtendedShortcutDimCode[5]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(5, ExtendedShortcutDimCode[5])
                end;
            }
            field(ExtendedShortcutDimCode6; ExtendedShortcutDimCode[6])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,6';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6), "Dimension Value Type" = const(Standard), "Blocked" = const(false));
                Visible = ExtendedShortcutDimVisible6;
                trigger OnValidate()
                begin
                    //>> It replicates the stardard validation
                    ValidateShortcutDimCode(6, ExtendedShortcutDimCode[6]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(6, ExtendedShortcutDimCode[6])
                end;
            }
            field(ExtendedShortcutDimCode7; ExtendedShortcutDimCode[7])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,7';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7), "Dimension Value Type" = const(Standard), "Blocked" = const(false));
                Visible = ExtendedShortcutDimVisible7;
                trigger OnValidate()
                begin
                    //>> It replicates the stardard validation
                    ValidateShortcutDimCode(7, ExtendedShortcutDimCode[7]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(7, ExtendedShortcutDimCode[7])
                end;
            }
            field(ExtendedShortcutDimCode8; ExtendedShortcutDimCode[8])
            {
                ApplicationArea = All;
                CaptionClass = '1,2,8';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8), "Dimension Value Type" = const(Standard), "Blocked" = const(false));
                Visible = ExtendedShortcutDimVisible8;
                trigger OnValidate()
                begin
                    //>> It replicates the stardard validation
                    ValidateShortcutDimCode(8, ExtendedShortcutDimCode[8]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(8, ExtendedShortcutDimCode[8])
                end;
            }





        }
        //>> It modify standard page fields (only shortcut dimension 1 and 2 are fully accessible in extension)
        //>> so the other controls should be disable and replaced
        Rec.modify("Shortcut Dimension 1 Code")
        {
            Visible = ExtendedShortcutDimVisible1;
            trigger OnAfterValidate()
            begin
                ApplyJnlDimCombination(1, "Shortcut Dimension 1 Code");
            end;
        }

        Rec.modify("Shortcut Dimension 2 Code")
        {
            Visible = ExtendedShortcutDimVisible2;
            trigger OnAfterValidate()
            begin
                ApplyJnlDimCombination(2, "Shortcut Dimension 2 Code");
            end;
        }
        Rec.modify("ShortcutDimCode[3]")
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;

        }
        Rec.modify("ShortcutDimCode[4]")
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        Rec.modify("ShortcutDimCode[5]")
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        Rec.modify("ShortcutDimCode[6]")
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        Rec.modify("ShortcutDimCode[7]")
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        Rec.modify("ShortcutDimCode[8]")
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
    }

    actions
    {
    }

    //#region "Page Functions"

    //>> It sets the Type according to Dimension Combination Type
    local procedure SetDimCombType();
    var
        DimCombHdr: Record ACO_JournalDimCombHeader;
    begin
        DimCombinationType := DimCombHdr.ACO_JournalType::"Purchase Invoice";
    end;


    ///<summary>It sets the visibility of the controls related to extended shortcut dimensions</summary>
    local procedure SetShortcutDimVisibility()
    var
        GenLedgerSetup: Record "General Ledger Setup";
    begin

        if GenLedgerSetup.Get then begin
            ExtendedShortcutDimVisible1 := (StrLen(GenLedgerSetup."Shortcut Dimension 1 Code") > 0);
            ExtendedShortcutDimVisible2 := (StrLen(GenLedgerSetup."Shortcut Dimension 2 Code") > 0);
            ExtendedShortcutDimVisible3 := (StrLen(GenLedgerSetup."Shortcut Dimension 3 Code") > 0);
            ExtendedShortcutDimVisible4 := (StrLen(GenLedgerSetup."Shortcut Dimension 4 Code") > 0);
            ExtendedShortcutDimVisible5 := (StrLen(GenLedgerSetup."Shortcut Dimension 5 Code") > 0);
            ExtendedShortcutDimVisible6 := (StrLen(GenLedgerSetup."Shortcut Dimension 6 Code") > 0);
            ExtendedShortcutDimVisible7 := (StrLen(GenLedgerSetup."Shortcut Dimension 7 Code") > 0);
            ExtendedShortcutDimVisible8 := (StrLen(GenLedgerSetup."Shortcut Dimension 8 Code") > 0);
        end else begin
            ExtendedShortcutDimVisible1 := false;
            ExtendedShortcutDimVisible2 := false;
            ExtendedShortcutDimVisible3 := false;
            ExtendedShortcutDimVisible4 := false;
            ExtendedShortcutDimVisible5 := false;
            ExtendedShortcutDimVisible6 := false;
            ExtendedShortcutDimVisible7 := false;
            ExtendedShortcutDimVisible8 := false;
        end;

    end;

    ///<summary>It applies the Journal Dimension Combination for the general Journal</summary>
    local procedure ApplyJnlDimCombination(FieldNumber: Integer; ShortcutDimensionCode: Code[20])
    var
        DimCombHrd: Record ACO_JournalDimCombHeader;
        DimCombLine: Record ACO_JournalDimCombLine;
        //>> ---------------------------------------
        nDimension: Integer;
    begin
        //>> It looks for the Dimesion combination for the Shortcut Dimension required ...
        DimCombHrd.Reset;
        DimCombHrd.Rec.SetRange(ACO_JournalType, DimCombinationType);
        //>> (FieldNumber - 1) is required since the field is an option field
        DimCombHrd.Rec.SetRange(ACO_PrimaryShortcutDimensionCode, (FieldNumber - 1));
        if DimCombHrd.FindFirst() then begin
            for nDimension := 1 to 8 do begin
                DimCombLine.Reset;
                DimCombLine.Rec.SetRange(ACO_EntryNo, DimCombHrd.ACO_EntryNo);
                DimCombLine.Rec.SetRange(ACO_PrimaryDimensionValue, ShortcutDimensionCode);
                DimCombLine.Rec.SetRange(ACO_ShortcutDimensionNo, nDimension);
                if DimCombLine.FindFirst() then begin
                    case nDimension of
                        1:  //>> Shorcut Dimension 1
                            begin
                                "Shortcut Dimension 1 Code" := DimCombLine.ACO_DimensionValue;
                                Rec.Validate("Shortcut Dimension 1 Code");
                            end;
                        2:  //>> Shortcut Dimension 2
                            begin
                                "Shortcut Dimension 2 Code" := DimCombLine.ACO_DimensionValue;
                                Rec.Validate("Shortcut Dimension 2 Code");
                            end;
                        else    //>> All the remaining shortcut (non global dimensions)
                        begin
                            ExtendedShortcutDimCode[nDimension] := DimCombLine.ACO_DimensionValue;
                            ValidateShortcutDimCode(nDimension, ExtendedShortcutDimCode[nDimension]);
                        end;
                    end;    //>> End Case
                end;
            end;
        end;
    end;

    //#endregion "Page Functions"

    //#region "Page Triggers"

    trigger OnOpenPage()
    begin

        //>> It sets the Journal Type according to dimension combination
        SetDimCombType;

        //>> It sets visibility of the controls related to extended Shortcut Dimensions
        SetShortcutDimVisibility;

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //>> It clears the new array as standard clears the standard array
        clear(ExtendedShortcutDimCode)
    end;

    trigger OnAfterGetRecord()
    begin
        //>> It replicates standard code on the new Shortcut Dimension array
        ShowShortcutDimCode(ExtendedShortcutDimCode);
    end;

    //#endregion "Page Triggers"

    var

        ///<summary>It is used to replace standard shortcut dimensions array</summary>
        ExtendedShortcutDimCode: array[10] of Code[20];

        ///<summary>It is used to set the type number according to Dimension Combination Type</summary>
        DimCombinationType: Integer;

        //>> Visibility Variables
        [InDataSet]
        ExtendedShortcutDimVisible1: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible2: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible3: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible4: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible5: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible6: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible7: Boolean;

        [InDataSet]
        ExtendedShortcutDimVisible8: Boolean;
}