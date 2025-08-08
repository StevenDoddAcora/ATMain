pageextension 50304 "ACO_PaymentJournal" extends "Payment Journal" //Extends page 256 - "Payment Journal"
{

    //#region "Documentation"
    // 2.1.0.2018 LBR 13/06/2019 - Aged Creditors Analysis (point 5.4) New action added to print the report;
    // ABS001 - PMC - 31/07/2019 - This page extension extends page 256 - "Payment Journal"
    //                                  - The page extension is required to meet requirement 03.09.05.01 of the initial specification
    // 2.2.5.2018 LBR 15/10/2019 - CHG003334 (BAC's Export file selection). AVT Suggest Vendor payments report has been added and standard has been made not visible;
    // 2.3.4.2018 LBR 05/11/2019 - CHG003386 (Payment Journals) - new "Manual Export" logic added
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
                    Rec.ValidateShortcutDimCode(3, ExtendedShortcutDimCode[3]);
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
                    Rec.ValidateShortcutDimCode(4, ExtendedShortcutDimCode[4]);
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
                    Rec.ValidateShortcutDimCode(5, ExtendedShortcutDimCode[5]);
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
                    Rec.ValidateShortcutDimCode(6, ExtendedShortcutDimCode[6]);
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
                    Rec.ValidateShortcutDimCode(7, ExtendedShortcutDimCode[7]);
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
                    Rec.ValidateShortcutDimCode(8, ExtendedShortcutDimCode[8]);
                    //>> It applies the Journal Dimension Combination
                    ApplyJnlDimCombination(8, ExtendedShortcutDimCode[8])
                end;
            }
            //>>2.3.4.2018
            field(ACO_ManualPaymentExp; Rec.ACO_ManualPaymentExp)
            {
                ApplicationArea = All;
            }
            //<<2.3.4.2018
        }
        //>> It modify standard page fields (only shortcut dimension 1 and 2 are fully accessible in extension)
        //>> so the other controls should be disable and replaced
        modify("Shortcut Dimension 1 Code")
        {
            Visible = ExtendedShortcutDimVisible1;
            trigger OnAfterValidate()
            begin
                ApplyJnlDimCombination(1, Rec."Shortcut Dimension 1 Code");
            end;
        }

        modify("Shortcut Dimension 2 Code")
        {
            Visible = ExtendedShortcutDimVisible2;
            trigger OnAfterValidate()
            begin
                ApplyJnlDimCombination(2, Rec."Shortcut Dimension 2 Code");
            end;
        }
        modify(ShortcutDimCode3)
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;

        }
        modify(ShortcutDimCode4)
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        modify(ShortcutDimCode5)
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        modify(ShortcutDimCode6)
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        modify(ShortcutDimCode7)
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }
        modify(ShortcutDimCode8)
        {
            //>> hidden and disabled
            Visible = false;
            Enabled = false;
        }

    }

    actions
    {
        addlast(Processing)
        {
            //>>1.1.0.2018
            action(ACO_AgedCreditorsAnalysis)
            {
                ApplicationArea = All;
                Caption = 'Suggested Vendor Payment Analysis';
                Image = PrintChecklistReport;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    AgedCreditorsAnalysis: Report "ACO_SuggVendPaymentAnalysis";
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");

                    Report.Run(Report::"ACO_SuggVendPaymentAnalysis", true, false, GenJnlLine);
                end;
            }
            //<<1.1.0.2018
            //>>2.2.5.2018
            action(ACO_SuggestVendorPayments)
            {
                ApplicationArea = All;
                Caption = 'Avtrade Suggest Vendor Payments';
                Image = PrintChecklistReport;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    SuggestVendorPayments: Report ACO_SuggestVendorPayments;
                begin
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RUNMODAL;
                end;
            }
            //<<2.2.5.2018
        }

        //>>2.2.5.2018
        modify(SuggestVendorPayments)
        {
            Visible = false;
            Promoted = false;
            Enabled = false;
        }
        //<<2.2.5.2018
    }
    //#region "Page Functions"

    //>> It sets the Journal Type according to Journal Dimension Combination 
    local procedure SetJournalType();
    var
        DimCombHdr: Record ACO_JournalDimCombHeader;
    begin
        DimCombinationJounalType := DimCombHdr.ACO_JournalType::"Payment Journal";
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
        DimCombHrd.SetRange(ACO_JournalType, DimCombinationJounalType);
        //>> (FieldNumber - 1) is required since the field is an option field
        DimCombHrd.SetRange(ACO_PrimaryShortcutDimensionCode, (FieldNumber - 1));
        if DimCombHrd.FindFirst() then begin
            for nDimension := 1 to 8 do begin
                DimCombLine.Reset;
                DimCombLine.SetRange(ACO_EntryNo, DimCombHrd.ACO_EntryNo);
                DimCombLine.SetRange(ACO_PrimaryDimensionValue, ShortcutDimensionCode);
                DimCombLine.SetRange(ACO_ShortcutDimensionNo, nDimension);
                if DimCombLine.FindFirst() then begin
                    case nDimension of
                        1:  //>> Shorcut Dimension 1
                            begin
                                Rec."Shortcut Dimension 1 Code" := DimCombLine.ACO_DimensionValue;
                                Rec.Validate("Shortcut Dimension 1 Code");
                            end;
                        2:  //>> Shortcut Dimension 2
                            begin
                                Rec."Shortcut Dimension 2 Code" := DimCombLine.ACO_DimensionValue;
                                Rec.Validate("Shortcut Dimension 2 Code");
                            end;
                        else    //>> All the remaining shortcut (non global dimensions)
                        begin
                            ExtendedShortcutDimCode[nDimension] := DimCombLine.ACO_DimensionValue;
                            Rec.ValidateShortcutDimCode(nDimension, ExtendedShortcutDimCode[nDimension]);
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
        SetJournalType;

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
        Rec.ShowShortcutDimCode(ExtendedShortcutDimCode);
    end;

    //#endregion "Page Triggers"

    var

        ///<summary>It is used to replace standard shortcut dimensions array</summary>
        ExtendedShortcutDimCode: array[10] of Code[20];

        ///<summary>It is used to set the Journal type number according to Journal Dimension Combination</summary>
        DimCombinationJounalType: Integer;

        //>> Visibility Variables

        ExtendedShortcutDimVisible1: Boolean;


        ExtendedShortcutDimVisible2: Boolean;


        ExtendedShortcutDimVisible3: Boolean;


        ExtendedShortcutDimVisible4: Boolean;


        ExtendedShortcutDimVisible5: Boolean;


        ExtendedShortcutDimVisible6: Boolean;


        ExtendedShortcutDimVisible7: Boolean;


        ExtendedShortcutDimVisible8: Boolean;













}
