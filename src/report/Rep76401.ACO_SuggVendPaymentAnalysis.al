report 50401 "ACO_SuggVendPaymentAnalysis"
{
    //#region "Documentation"
    // 2.1.0.2018 LBR 13/06/2019 - Aged Creditors Analysis (point 5.4) New report created for the Journal Payment purpose. It based on the Aged Account Payable report;
    // 2.2.3.2018 LBR 18/09/2019 - report named changed to Suggested Vendor Payment Analysis + report layout changes
    //                           - Change date to show Document Date instead of Posting date, Removed Document No column
    //            LBR 09/10/2019 - Corrected Sum for totals by GL Accounts
    // 2.2.8.2018 LBR 29/10/2019 - Snagging (Suggest vendor payment GL summary by currency)
    // 2.3.1.2018 LBR 26/11/2019 - CHG003391 (Suggest Vendor Payments Analysis - new priority logic) - entries sorting changed to based on the date, 
    // 3.0.7.2018 LBR 30/01/2020 - Adjusting the version, corrected issue with the payment analysis division by 0;
    //#endregion "Documentation"

    DefaultLayout = RDLC;
    RDLCLayout = 'src/report/layouts/Rep50401.ACO_SuggVendPaymentAnalysis.rdlc';
    Caption = 'Suggested Vendor Payment Analysis';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Account No.";

            trigger OnAfterGetRecord(); //<Gen. Journal Line>
            var
                VendorRec: Record Vendor;
            begin
                //>>
                // Add vendor to the temp table so we can analyse entries later
                if "Account Type" = "Account Type"::Vendor then begin
                    if VendorRec.GET("Account No.") then begin
                        if not VendorTMP.GET(VendorRec."No.") then begin
                            VendorTMP.INIT();
                            VendorTMP.TRANSFERFIELDS(VendorRec);
                            VendorTMP.INSERT();
                        end;
                        // Add Vendor Ledger Entry to the temp table
                        UpdateVendorLedgerEntryTMP("Gen. Journal Line");
                    end;
                end;
                //<<
            end;
        }
        dataitem(VendorInteger; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            PrintOnlyIfDetail = true;
            column(JnlTemplateName; "Gen. Journal Line"."Journal Template Name")
            {
            }
            column(JnlBatchName; "Gen. Journal Line"."Journal Batch Name")
            {
            }
            column(CurrencyCode; JnlCurrencyCode)
            {
            }
            column(TodayFormatted; TodayFormatted)
            {
            }
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(NewPagePerVendor; NewPagePerVendor)
            {
            }
            column(AgesAsOfEndingDate; STRSUBSTNO(Text006, FORMAT(EndingDate, 0, 4)))
            {
            }
            //>>2.3.1.2018
            column(AgesAsOfEndingDateForPriority; STRSUBSTNO(AgesAsOfForPriorityLbl, FORMAT(EndingDatePriority, 0, 4)))
            {
            }
            column(AgesAsOfEndingDateForNoPriority; STRSUBSTNO(AgesAsOfForNoPriorityLbl, FORMAT(EndingDateNoPriority, 0, 4)))
            {
            }
            //<<2.3.1.2018
            column(SelectAgeByDuePostngDocDt; STRSUBSTNO(Text007, SELECTSTR(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(CaptionVendorFilter; TABLECAPTION + ': ' + VendorFilter)
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }
            column(AgingBy; AgingBy)
            {
            }
            column(SelctAgeByDuePostngDocDt1; STRSUBSTNO(Text004, SELECTSTR(AgingBy + 1, Text009)))
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(GrandTotalVLE5RemAmtLCY; GrandTotalVLERemaingAmtLCY[5])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE4RemAmtLCY; GrandTotalVLERemaingAmtLCY[4])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE3RemAmtLCY; GrandTotalVLERemaingAmtLCY[3])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE2RemAmtLCY; GrandTotalVLERemaingAmtLCY[2])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1RemAmtLCY; GrandTotalVLERemaingAmtLCY[1])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1AmtLCY; GrandTotalVLEAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(No_Vendor; Vendor."No.")
            {
            }
            column(AgedAcctPayableCaption; AgedAcctPayableCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllAmtsinLCYCaption; AllAmtsinLCYCaptionLbl)
            {
            }
            column(AgedOverdueAmsCaption; AgedOverdueAmsCaptionLbl)
            {
            }
            column(GrandTotalVLE5RemAmtLCYCaption; GrandTotalVLE5RemAmtLCYCaptionLbl)
            {
            }
            column(AmountLCYCaption; AmountLCYCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeCaptionLbl)
            {
            }
            column(VendorNoCaption; Vendor.FIELDCAPTION("No."))
            {
            }
            column(VendorNameCaption; Vendor.FIELDCAPTION(Name))
            {
            }
            column(CurrencyCaption; CurrencyCaptionLbl)
            {
            }
            column(TotalLCYCaption; TotalLCYCaptionLbl)
            {
            }
            column(PrintDate; FORMAT(TODAY))
            {
            }
            column(PrintTime; FORMAT(TIME))
            {
            }
            column(Contact_Vendor; Vendor."Contact")
            {
            }
            column(LastPaidDateTxt; GetLastPaidDateTxt(Vendor."No."))
            {
            }
            column(Turnover_Vendor; '')
            {
            }
            column(CreditLimit_Vendor; Vendor."Creditor No.")
            {
            }
            column(PayOnTime_Vendor; '')
            {
            }
            column(PaymentTerms_Vendor; '')
            {
            }
            column(DisputedItemsAmount1; '')
            {
            }
            //>>2.2.8.2018
            column(gGLTotalCurrencyCode; gGLTotalCurrencyCode)
            {
            }
            //<<2.2.8.2018
            //>>2.3.1.2018
            column(PriorityText; GetPriorityText(Vendor."No."))
            {
            }
            //<<2.3.1.2018
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord(); //<Vendor Ledger Entry>
                var
                    VendorLedgEntry: Record "Vendor Ledger Entry";
                begin
                    VendorLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                    VendorLedgEntry.SETRANGE("Closed by Entry No.", "Entry No.");
                    VendorLedgEntry.SETRANGE("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    if VendorLedgEntry.FindSet() then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.NEXT = 0;

                    if "Closed by Entry No." <> 0 then begin
                        VendorLedgEntry.SETRANGE("Closed by Entry No.", "Closed by Entry No.");
                        if VendorLedgEntry.FindSet() then
                            repeat
                                InsertTemp(VendorLedgEntry);
                            until VendorLedgEntry.NEXT = 0;
                    end;

                    VendorLedgEntry.RESET;
                    VendorLedgEntry.SETRANGE("Entry No.", "Closed by Entry No.");
                    VendorLedgEntry.SETRANGE("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromVendor(VendorLedgEntry);
                    if VendorLedgEntry.FindSet() then
                        repeat
                            InsertTemp(VendorLedgEntry);
                        until VendorLedgEntry.NEXT = 0;
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem(); //<Vendor Ledger Entry>
                begin
                    //>>
                    // This filter was in DataItem however the vendor is based on the temp therfore it needs to be here
                    SETRANGE("Vendor No.", Vendor."No.");
                    //<<
                    SETRANGE("Posting Date", EndingDate + 1, DMY2DATE(31, 12, 9999));
                    CopyDimFiltersFromVendor("Vendor Ledger Entry");
                end;
            }
            dataitem(OpenVendorLedgEntry; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord(); //OpenVendorLedgEntry
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        CALCFIELDS("Remaining Amt. (LCY)");
                        if "Remaining Amt. (LCY)" = 0 then
                            CurrReport.SKIP;
                    end;
                    InsertTemp(OpenVendorLedgEntry);
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem(); //OpenVendorLedgEntry
                begin
                    //>>
                    // This filter was in DataItem however the vendor is based on the temp therfore it needs to be here
                    SETRANGE("Vendor No.", Vendor."No.");
                    //<<

                    if AgingBy = AgingBy::"Posting Date" then begin
                        SETRANGE("Posting Date", 0D, EndingDate);
                        SETRANGE("Date Filter", 0D, EndingDate);
                    end;
                    CopyDimFiltersFromVendor(OpenVendorLedgEntry);
                end;
            }
            dataitem(CurrencyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                PrintOnlyIfDetail = true;
                dataitem(TempVendortLedgEntryLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(VendorName; Vendor.Name)
                    {
                    }
                    column(VendorNo; Vendor."No.")
                    {
                    }
                    column(VLEEndingDateRemAmtLCY; VendorLedgEntryEndingDate."Remaining Amt. (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVLE1RemAmtLCY; AgedVendorLedgEntry[1]."Remaining Amt. (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmtLCY; AgedVendorLedgEntry[2]."Remaining Amt. (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmtLCY; AgedVendorLedgEntry[3]."Remaining Amt. (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmtLCY; AgedVendorLedgEntry[4]."Remaining Amt. (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmtLCY; AgedVendorLedgEntry[5]."Remaining Amt. (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtAmtLCY; VendorLedgEntryEndingDate."Amount (LCY)" * -1)
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtDueDate; FORMAT(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocNo; VendorLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(VendLedgEntyEndgDtDocType; FORMAT(VendorLedgEntryEndingDate."Document Type"))
                    {
                    }
                    //>>2.2.3.2018
                    column(VendLedgEntryEndDtPostgDt; VendorLedgEntryEndingDate."Document Date") // Date format changed 
                    {
                    }
                    //<<2.2.3.2018
                    column(AgedVendLedgEnt5RemAmt; AgedVendorLedgEntry[5]."Remaining Amount" * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmt; AgedVendorLedgEntry[4]."Remaining Amount" * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmt; AgedVendorLedgEntry[3]."Remaining Amount" * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmt; AgedVendorLedgEntry[2]."Remaining Amount" * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt1RemAmt; AgedVendorLedgEntry[1]."Remaining Amount" * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VLEEndingDateRemAmt; VendorLedgEntryEndingDate."Remaining Amount" * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndingDtAmt; VendorLedgEntryEndingDate.Amount * -1)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalVendorName; STRSUBSTNO(Text005, Vendor.Name))
                    {
                    }
                    column(CurrCode_TempVenLedgEntryLoop; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(DocumentDate_VendLedgEntryEndDt; FORMAT(VendorLedgEntryEndingDate."Document Date"))
                    {
                    }
                    column(ExtDocNo_VendLedgEntryEndDt; VendorLedgEntryEndingDate."External Document No.")
                    {
                    }
                    column(Description_VendLedgEntryEndDt; VendorLedgEntryEndingDate.Description)
                    {
                    }
                    column(DueDate_VendLedgEntryEndDt; FORMAT(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(DisputedItemsAmount; FORMAT(VendorLedgEntryEndingDate."On Hold"))
                    {
                    }

                    trigger OnAfterGetRecord(); //TempVendortLedgEntryLoop
                    var
                        PeriodIndex: Integer;
                        percValue: Decimal;
                        lGenJnlLine: Record "Gen. Journal Line";
                    begin
                        if Number = 1 then begin
                            if not TempVendorLedgEntry.FindSet() then
                                CurrReport.BREAK;
                        end else if TempVendorLedgEntry.NEXT = 0 then
                                CurrReport.BREAK;

                        VendorLedgEntryEndingDate := TempVendorLedgEntry;
                        DetailedVendorLedgerEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgEntryEndingDate."Entry No.");
                        if DetailedVendorLedgerEntry.FindSet() then
                            repeat
                                if (DetailedVendorLedgerEntry."Entry Type" =
                                    DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") and
                                   (VendorLedgEntryEndingDate."Posting Date" > EndingDate) and
                                   (AgingBy <> AgingBy::"Posting Date")
                                then begin
                                    if VendorLedgEntryEndingDate."Document Date" <= EndingDate then
                                        DetailedVendorLedgerEntry."Posting Date" :=
                                          VendorLedgEntryEndingDate."Document Date"
                                    else if (VendorLedgEntryEndingDate."Due Date" <= EndingDate) and
                                          (AgingBy = AgingBy::"Due Date")
                                       then
                                        DetailedVendorLedgerEntry."Posting Date" :=
                                        VendorLedgEntryEndingDate."Due Date"
                                end;

                                if (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) or
                                   (TempVendorLedgEntry.Open and
                                    (AgingBy = AgingBy::"Due Date") and
                                    (VendorLedgEntryEndingDate."Due Date" > EndingDate) and
                                    (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                                then begin
                                    if DetailedVendorLedgerEntry."Entry Type" in
                                       [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                    then begin
                                        VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Amount (LCY)" :=
                                        VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                    if DetailedVendorLedgerEntry."Posting Date" <= EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" :=
                                        VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    end;
                                end;
                            until DetailedVendorLedgerEntry.NEXT = 0;

                        if VendorLedgEntryEndingDate."Remaining Amount" = 0 then
                            CurrReport.SKIP;

                        case AgingBy of
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                begin
                                    if VendorLedgEntryEndingDate."Document Date" > EndingDate then begin
                                        VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                        VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                                    end;
                                    PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                                end;
                        end;
                        CLEAR(AgedVendorLedgEntry);
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";

                        //>>2.2.3.2018
                        // Update GL Buffer for nominals total calculation
                        if VendorLedgEntryEndingDate."Amount to Apply" = 0 then begin
                            // Apply to one document only
                            // Find related line on journal to find amount
                            lGenJnlLine.setrange("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                            lGenJnlLine.setrange("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                            lGenJnlLine.setrange("Applies-to Doc. No.", VendorLedgEntryEndingDate."Document No.");
                            if lGenJnlLine.FindFirst() then begin
                                //>>3.0.7.2018
                                //percValue := lGenJnlLine.Amount / VendorLedgEntryEndingDate."Remaining Amount";
                                // percValue is need for partial payments as then GL amount is not fully applied
                                percValue := 1;
                                if (VendorLedgEntryEndingDate."Remaining Amount" <> 0) then
                                    percValue := ABS(lGenJnlLine.Amount / VendorLedgEntryEndingDate."Remaining Amount");
                                //<<3.0.7.2018
                                if (percValue > 1) then
                                    percValue := 1;
                                UpdateGLEntryBuffer(VendorLedgEntryEndingDate."Posting Date", VendorLedgEntryEndingDate."Document No.", percValue);
                            end;
                        end else begin
                            // Apply to multiple documents
                            //
                            //>>3.0.7.2018
                            //percValue := VendorLedgEntryEndingDate."Amount to Apply" / VendorLedgEntryEndingDate."Remaining Amount";
                            percValue := 1;
                            if (VendorLedgEntryEndingDate."Remaining Amount" <> 0) then
                                percValue := ABS(VendorLedgEntryEndingDate."Amount to Apply" / VendorLedgEntryEndingDate."Remaining Amount");

                            if (percValue > 1) then
                                percValue := 1;
                            //<<3.0.7.2018
                            UpdateGLEntryBuffer(VendorLedgEntryEndingDate."Posting Date", VendorLedgEntryEndingDate."Document No.", percValue);
                        end;
                        //<<2.2.3.2018
                    end;

                    trigger OnPostDataItem(); //TempVendortLedgEntryLoop
                    begin
                        if not PrintAmountInLCY then
                            UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem(); //TempVendortLedgEntryLoop
                    begin
                        if not PrintAmountInLCY then
                            TempVendorLedgEntry.SETRANGE("Currency Code", TempCurrency.Code);
                    end;
                }

                trigger OnAfterGetRecord(); //CurrencyLoop
                begin
                    CLEAR(TotalVendorLedgEntry);

                    if Number = 1 then begin
                        if not TempCurrency.FindSet() then
                            CurrReport.BREAK;
                    end else if TempCurrency.NEXT = 0 then
                            CurrReport.BREAK;

                    if TempCurrency.Code <> '' then
                        CurrencyCode := TempCurrency.Code
                    else
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPostDataItem(); //CurrencyLoop
                begin
                    if NewPagePerVendor and (NumberOfCurrencies > 0) then
                        CurrReport.SKIP; // Replaced deprecated NEWPAGE
                end;

                trigger OnPreDataItem(); //CurrencyLoop
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord(); //VendorInteger
            begin
                //>>
                if Number = 1 then begin
                    if not VendorTMP.FindSet() then
                        CurrReport.BREAK;
                end else if VendorTMP.NEXT = 0 then
                        CurrReport.BREAK;

                Vendor.GET(VendorTMP."No.");
                //<<

                //>>2.3.1.2018
                EndingDate := GetEndingDate(Vendor."No.");

                CalcDates;
                CreateHeadings;
                //<<2.3.1.2018

                if NewPagePerVendor then
                    PageGroupNo := PageGroupNo + 1;

                TempCurrency.RESET;
                TempCurrency.DELETEALL;
                TempVendorLedgEntry.RESET;
                TempVendorLedgEntry.DELETEALL;
                CLEAR(GrandTotalVLERemaingAmtLCY);
                GrandTotalVLEAmtLCY := 0;
            end;

            trigger OnPreDataItem(); //VendorInteger
            begin
                PageGroupNo := 1;

                //>>
                VendorTMP.RESET();
                //>>2.3.1.2018
                VendorTMP.SetCurrentKey(Priority);
                VendorTMP.Ascending(false);
                //<<2.3.1.2018
                if VendorTMP.COUNT() = 0 then
                    CurrReport.BREAK();

                GeneralLedgerSetup.GET();

                JnlCurrencyCode := "Gen. Journal Line"."Currency Code";
                if JnlCurrencyCode = '' then
                    JnlCurrencyCode := GeneralLedgerSetup."LCY Code";
                //<<                                              
            end;
        }
        dataitem(CurrencyTotals; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(Number_CurrencyTotals; Number)
            {
            }
            column(NewPagePerVend_CurrTotal; NewPagePerVendor)
            {
            }
            column(TempCurrency2Code; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt6RemAmtLCY5; AgedVendorLedgEntry[6]."Remaining Amount" * -1)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt1RemAmtLCY1; AgedVendorLedgEntry[1]."Remaining Amount" * -1)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt2RemAmtLCY2; AgedVendorLedgEntry[2]."Remaining Amount" * -1)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt3RemAmtLCY3; AgedVendorLedgEntry[3]."Remaining Amount" * -1)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt4RemAmtLCY4; AgedVendorLedgEntry[4]."Remaining Amount" * -1)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt5RemAmtLCY5; AgedVendorLedgEntry[5]."Remaining Amount" * -1)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrencySpecificationCaption; CurrencySpecificationCaptionLbl)
            {
            }
            //>>2.2.3.2018
            column(GLAccountFilterCaption1; GLAccountFilterCaption[1])
            {
            }
            column(GLAccountFilterCaption2; GLAccountFilterCaption[2])
            {
            }
            column(GLAccountFilterCaption3; GLAccountFilterCaption[3])
            {
            }
            column(GLAccountFilterCaption4; GLAccountFilterCaption[4])
            {
            }
            column(GLAccountFilterCaption5; GLAccountFilterCaption[5])
            {
            }
            column(CalculateGLAccountBalanceAtDateValue1; CalculateGLAccountBalanceAtDateValue(1))
            {
            }
            column(CalculateGLAccountBalanceAtDateValue2; CalculateGLAccountBalanceAtDateValue(2))
            {
            }
            column(CalculateGLAccountBalanceAtDateValue3; CalculateGLAccountBalanceAtDateValue(3))
            {
            }
            column(CalculateGLAccountBalanceAtDateValue4; CalculateGLAccountBalanceAtDateValue(4))
            {
            }
            column(CalculateGLAccountBalanceAtDateValue5; CalculateGLAccountBalanceAtDateValue(5))
            {
            }
            //<<2.2.3.2018

            trigger OnAfterGetRecord(); //CurrencyTotals
            begin
                if Number = 1 then begin
                    if not TempCurrency2.FindSet() then
                        CurrReport.BREAK;
                end else if TempCurrency2.NEXT = 0 then
                        CurrReport.BREAK;

                CLEAR(AgedVendorLedgEntry);
                TempCurrencyAmount.SETRANGE("Currency Code", TempCurrency2.Code);
                if TempCurrencyAmount.FindSet() then
                    repeat
                        if TempCurrencyAmount.Date <> DMY2DATE(31, 12, 9999) then
                            AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                                TempCurrencyAmount.Amount
                        else
                            AgedVendorLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                    until TempCurrencyAmount.NEXT = 0;
            end;

            trigger OnPreDataItem(); //CurrencyTotals
            begin
                PageGroupNo := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    //>>2.3.1.2018
                    //field(AgedAsOf; EndingDate)
                    //{
                    //    ApplicationArea = Basic, Suite;
                    //    Caption = 'Aged As Of';
                    //    ToolTip = 'Specifies the date that you want the ageing calculated for.';
                    //}

                    field(AgedAsOfPriority; EndingDatePriority)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of (Priority)';
                        ToolTip = 'Specifies the date that you want the ageing calculated for priority Vendors.';
                    }

                    field(AgedAsOfNoPriority; EndingDateNoPriority)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of (No Priority)';
                        ToolTip = 'Specifies the date that you want the ageing calculated for no priority Vendors.';
                    }
                    //<<2.3.1.2018
                    field(AgingBy; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ageing by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the ageing will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies if you want the report to specify the ageing per vendor ledger entry.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        //>>2.2.3.2018
                        Visible = false;
                        //<<2.2.3.2018
                        Caption = 'Print Details';
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each vendor.';
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(NewPagePerVendor; NewPagePerVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        //>>2.2.3.2018
                        Visible = false;
                        //<<2.2.3.2018
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                    }
                }
                //>>2.2.3.2018
                group(SummaryByNominals)
                {
                    Caption = 'Summary by Nominal Ranges';

                    //>>1.3.9.2018
                    field(gGLTotalCurrencyCode; gGLTotalCurrencyCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Total Currency Code';
                        Visible = true;
                        TableRelation = Currency.Code;
                        ToolTip = 'Specifies if you want see report totals by different currency than LCY';
                    }
                    //<<1.3.9.2018

                    grid(GLFilter)
                    {
                        Caption = 'Filter(s)';
                        ShowCaption = false;
                        group(Group1)
                        {
                            ShowCaption = false;
                            field(GLAccountFilterCaption1; GLAccountFilterCaption[1])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                            }
                            field(GLAccountFilterCaption2; GLAccountFilterCaption[2])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                            }
                            field(GLAccountFilterCaption3; GLAccountFilterCaption[3])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                            }
                            field(GLAccountFilterCaption4; GLAccountFilterCaption[4])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                            }
                            field(GLAccountFilterCaption5; GLAccountFilterCaption[5])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                            }
                        }
                        group(Group2)
                        {
                            ShowCaption = false;
                            field(GLAccountFilter1; GLAccountFilter[1])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
                            }
                            field(GLAccountFilter2; GLAccountFilter[2])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
                            }
                            field(GLAccountFilter3; GLAccountFilter[3])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
                            }
                            field(GLAccountFilter4; GLAccountFilter[4])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
                            }
                            field(GLAccountFilter5; GLAccountFilter[5])
                            {
                                ShowCaption = false;
                                ApplicationArea = all;
                                TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
                            }
                        }
                    }
                }
                //<<2.2.3.2018
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        var
            lGenJnlLine: Record "Gen. Journal Line";
        begin
            //>>2.3.1.2018
            //if EndingDate = 0D then
            //    EndingDate := WORKDATE;

            if EndingDate = 0D then begin
                EndingDate := WORKDATE;
                EndingDatePriority := EndingDate;
                EndingDateNoPriority := EndingDate;
            end;
            //<<2.3.1.2018

            if FORMAT(PeriodLength) = '' then
                EVALUATE(PeriodLength, '<1M>');

            //>>
            AgingBy := AgingBy::"Document Date";
            PrintDetails := true;
            PrintAmountInLCY := false;
            //<<

            //>>2.2.3.2018
            NewPagePerVendor := false;
            if GLAccountFilterCaption[1] = '' then
                GLAccountFilterCaption[1] := 'Purchases';
            if GLAccountFilterCaption[2] = '' then
                GLAccountFilterCaption[2] := 'Repairs';
            if GLAccountFilterCaption[3] = '' then
                GLAccountFilterCaption[3] := 'Logistics';
            //<<2.2.3.2018

            //>>2.2.8.2018
            lGenJnlLine.CopyFilters("Gen. Journal Line");
            if lGenJnlLine.FindFirst() then
                gGLTotalCurrencyCode := lGenJnlLine."Currency Code";
            //<<2.2.8.2018
        end;
    }

    labels
    {
        TitleLbl = 'Aged Creditors Analysis'; BatchNameLbl = 'Batch Name:'; Date1Lbl = 'Date'; Time1Lbl = 'Time'; PageLbl = 'Page'; DateFromLbl = 'Date From'; DateToLbl = 'Date To'; SupplierFromLbl = 'Supplier From'; SupplierToLbl = 'Supplier To'; InclFutureTransLbl = 'Include future transactions'; ExcludeLaterPaymLbl = 'Exlude later payments'; ACLbl = 'A/C'; NameLbl = 'Name'; ContactLbl = 'Contact:'; LastPaidLbl = 'Last Paid:'; NoLbl = 'No'; TypeLbl = 'Type'; DateLbl = 'Date'; RefLbl = 'Ref.'; DetailsLbl = 'Details'; PayByLbl = 'Pay By'; BalanceLbl = 'Balance'; CurrentLbl = 'Current'; Period1Lbl = 'Period 1'; Period2Lbl = 'Period 2'; Period3Lbl = 'Period 3'; OlderLbl = 'Older'; DisputedItemLbl = 'On Hold'; AccountTotalsLbl = 'Account Totals '; TurnoverLbl = 'Turnover:'; CreditLimitLbl = 'Credit Limit:'; CustomerAccountLbl = 'Customer Account'; PayOnTimeLbl = 'Pay on time'; Note1Lbl = '** NOTE: All report values are shown in Base Currency, unless otherwise indicated **';
    }

    trigger OnPreReport();
    var
    // CaptionManagement: Codeunit CaptionManagement; // Commented out - missing dependency
    begin
        VendorFilter := Vendor.GetFilters();

        GLSetup.GET;

        //>>2.3.1.2018
        //CalcDates;
        //CreateHeadings;
        //<<2.3.1.2018

        TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f');
        CompanyDisplayName := COMPANYPROPERTY.DISPLAYNAME;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempVendorLedgEntry: Record "Vendor Ledger Entry" temporary;
        VendorLedgEntryEndingDate: Record "Vendor Ledger Entry";
        TotalVendorLedgEntry: array[5] of Record "Vendor Ledger Entry";
        AgedVendorLedgEntry: array[6] of Record "Vendor Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        TypeHelper: Codeunit "Type Helper";
        GrandTotalVLERemaingAmtLCY: array[5] of Decimal;
        GrandTotalVLEAmtLCY: Decimal;
        VendorFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        EndingDatePriority: Date;
        EndingDateNoPriority: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePerVendor: Boolean;
        PeriodStartDate: array[5] of Date;
        PeriodEndDate: array[5] of Date;
        HeaderText: array[5] of Text[30];
        Text000: Label 'Not Due';
        Text001: Label 'Before';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text003: Label 'More than';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        AgesAsOfForPriorityLbl: Label 'Aged as of %1 for PRIORITY vendors';
        AgesAsOfForNoPriorityLbl: Label 'Aged as of %1 for NO PRIORITY vendors';
        Text007: Label 'Aged by %1';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        Text027: Label '-%1';
        AgedAcctPayableCaptionLbl: Label 'Aged Creditors Analysis';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllAmtsinLCYCaptionLbl: Label 'All Amounts in LCY';
        AgedOverdueAmsCaptionLbl: Label 'Aged Overdue Amounts';
        GrandTotalVLE5RemAmtLCYCaptionLbl: Label 'Balance';
        AmountLCYCaptionLbl: Label 'Original Amount';
        DueDateCaptionLbl: Label 'Due Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentTypeCaptionLbl: Label 'Document Type';
        CurrencyCaptionLbl: Label 'Currency Code';
        TotalLCYCaptionLbl: Label 'Total (LCY)';
        CurrencySpecificationCaptionLbl: Label 'Currency Specification';
        TodayFormatted: Text;
        CompanyDisplayName: Text;
        VendorTMP: Record Vendor temporary;
        VendorLedgerEntryTMP: Record "Vendor Ledger Entry" temporary;
        Vendor: Record Vendor;
        JnlCurrencyCode: Code[20];
        GeneralLedgerSetup: Record "General Ledger Setup";
        GLAccountFilterCaption: array[5] of Text;
        GLAccountFilter: array[5] of Text;
        GLEntryTMP: Record "G/L Entry" temporary;
        gGLTotalCurrencyCode: Code[20];

    //>>2.3.1.2018
    local procedure GetEndingDate(VendorNo: Code[20]): Date;
    var
        lVendor: Record Vendor;
    begin
        // The aging date is based on the priority setup
        if lVendor.get(VendorNo) then begin
            if lVendor.Priority > 0 then
                exit(EndingDatePriority)
            else
                exit(EndingDateNoPriority);
        end;

        exit(EndingDate);
    end;

    local procedure GetPriorityText(VendorNo: Code[20]): Text;
    var
        lVendor: Record Vendor;
        lPriorityLbl: Label 'PRIORITY';
    begin
        // The aging date is based on the priority setup
        if lVendor.get(VendorNo) then begin
            if lVendor.Priority > 0 then
                exit(lPriorityLbl)
            else
                exit('');
        end;

        exit('');
    end;
    //<<2.3.1.2018

    //>>2.2.3.2018
    local procedure UpdateGLEntryBuffer(PostingDate: Date; DocNo: Code[20]; percValue: Decimal);
    var
        GLEntry: Record "G/L Entry";
    begin
        percValue := ABS(percValue);
        GLEntry.SetCurrentKey("Document No.", "Posting Date");
        GLEntry.SetRange("Posting Date", PostingDate);
        GLEntry.SetRange("Document No.", DocNo);
        if GLEntry.FindSet(false) then begin
            repeat
            begin
                GLEntryTMP.TransferFields(GLEntry);
                GLEntryTMP.Amount *= percValue;
                GLEntryTMP.insert(false);
            end;
            until GLEntry.Next() = 0;
        end;

    end;

    local procedure CalculateGLAccountBalanceAtDateValue(Index: Integer) ReturnValue: Decimal
    var
        TotalValue: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if GLAccountFilter[Index] = '' then
            exit(0);

        GLEntryTMP.SetCurrentKey("G/L Account No.", "Posting Date");
        //GLEntryTMP.SetRange("Posting Date", 0D, EndingDate);
        GLEntryTMP.SetFilter("G/L Account No.", GLAccountFilter[Index]);

        //>>1.3.9.2018
        //GLEntryTMP.CalcSums(Amount);
        //exit(GLEntryTMP.Amount);

        // if GLEntryTMP.FindSet()(false) then begin
        //     repeat
        //     begin
        //         TotalValue += GLEntryTMP.Amount;
        //     end;
        //     until GLEntryTMP.next() = 0;
        // end;

        //Total in Currency Calcualtion
        IF (gGLTotalCurrencyCode <> '') AND (gGLTotalCurrencyCode <> 'GBP') THEN BEGIN
            if GLEntryTMP.FindSet(false) then begin
                repeat
                begin
                    TotalValue += CurrExchRate.ExchangeAmtLCYToFCY(
                                            GLEntryTMP."Posting Date",
                                            gGLTotalCurrencyCode,
                                            GLEntryTMP."Amount",
                                            CurrExchRate.GetCurrentCurrencyFactor(gGLTotalCurrencyCode));
                end;
                until GLEntryTMP.next() = 0;
            end;
            exit(TotalValue);
        END ELSE BEGIN
            GLEntryTMP.CalcSums(Amount);
            exit(GLEntryTMP.Amount);
        END;
        //<<1.3.9.2018
    end;
    //<<2.2.3.2018

    local procedure CalcDates();
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if not EVALUATE(PeriodLength2, STRSUBSTNO(Text027, PeriodLength)) then
            ERROR(EnterDateFormulaErr);
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := DMY2DATE(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
        end else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CALCDATE(PeriodLength2, EndingDate + 1);
        end;
        for i := 2 to ARRAYLEN(PeriodEndDate) do begin
            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CALCDATE(PeriodLength2, PeriodEndDate[i] + 1);
        end;

        i := ARRAYLEN(PeriodEndDate);

        PeriodStartDate[i] := 0D;

        for i := 1 to ARRAYLEN(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                ERROR(Text010, PeriodLength);
    end;

    local procedure CreateHeadings();
    var
        i: Integer;
    begin
        if AgingBy = AgingBy::"Due Date" then begin
            HeaderText[1] := Text000;
            i := 2;
        end else
            i := 1;
        while i < ARRAYLEN(PeriodEndDate) do begin
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := STRSUBSTNO('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i] :=
              STRSUBSTNO('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i := i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then
            HeaderText[i] := STRSUBSTNO('%1\%2', Text001, PeriodStartDate[i - 1])
        else
            HeaderText[i] := STRSUBSTNO('%1\%2 %3', Text003, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;

    local procedure InsertTemp(var VendorLedgEntry: Record "Vendor Ledger Entry");
    var
        Currency: Record Currency;
    begin
        with TempVendorLedgEntry do begin
            if GET(VendorLedgEntry."Entry No.") then
                exit;
            //>>
            // Investiage only ledgers which are in the journal nothing else
            if not VendorLedgerEntryTMP.GET(VendorLedgEntry."Entry No.") then
                exit;
            //<<
            TempVendorLedgEntry := VendorLedgEntry;
            INSERT;
            if PrintAmountInLCY then begin
                CLEAR(TempCurrency);
                TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
                if TempCurrency.INSERT then;
                exit;
            end;
            if TempCurrency.GET("Currency Code") then
                exit;
            if "Currency Code" <> '' then
                Currency.GET("Currency Code")
            else begin
                CLEAR(Currency);
                Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            end;
            TempCurrency := Currency;
            TempCurrency.INSERT;
        end;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer;
    var
        i: Integer;
    begin
        for i := 1 to ARRAYLEN(PeriodEndDate) do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    local procedure UpdateCurrencyTotals();
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.INSERT then;
        with TempCurrencyAmount do begin
            for i := 1 to ARRAYLEN(TotalVendorLedgEntry) do begin
                "Currency Code" := CurrencyCode;
                Date := PeriodStartDate[i];
                if FIND then begin
                    Amount := Amount + TotalVendorLedgEntry[i]."Remaining Amount";
                    MODIFY;
                end else begin
                    "Currency Code" := CurrencyCode;
                    Date := PeriodStartDate[i];
                    Amount := TotalVendorLedgEntry[i]."Remaining Amount";
                    INSERT;
                end;
            end;
            "Currency Code" := CurrencyCode;
            Date := DMY2DATE(31, 12, 9999);
            if FIND then begin
                Amount := Amount + TotalVendorLedgEntry[1].Amount;
                MODIFY;
            end else begin
                "Currency Code" := CurrencyCode;
                Date := DMY2DATE(31, 12, 9999);
                Amount := TotalVendorLedgEntry[1].Amount;
                INSERT;
            end;
        end;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewNewPagePerVendor: Boolean);
    begin
        //>>2.3.1.2018
        //EndingDate := NewEndingDate;
        EndingDate := NewEndingDate;
        EndingDatePriority := EndingDate;
        EndingDateNoPriority := EndingDate;
        //<<2.3.1.2018
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePerVendor := NewNewPagePerVendor;
    end;

    local procedure CopyDimFiltersFromVendor(var VendorLedgerEntry: Record "Vendor Ledger Entry");
    begin
        if Vendor.GETFILTER("Global Dimension 1 Filter") <> '' then
            VendorLedgerEntry.SETFILTER("Global Dimension 1 Code", Vendor.GETFILTER("Global Dimension 1 Filter"));
        if Vendor.GETFILTER("Global Dimension 2 Filter") <> '' then
            VendorLedgerEntry.SETFILTER("Global Dimension 2 Code", Vendor.GETFILTER("Global Dimension 2 Filter"));
    end;

    local procedure UpdateVendorLedgerEntryTMP(pGJL: Record "Gen. Journal Line");
    var
        lVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        //>>
        // Pick only entries selected in the journal
        if pGJL."Applies-to Doc. No." <> '' then begin
            lVendorLedgerEntry.SETCURRENTKEY("Document No.");
            lVendorLedgerEntry.SETRANGE("Vendor No.", pGJL."Account No.");
            lVendorLedgerEntry.SETRANGE("Document Type", pGJL."Applies-to Doc. Type");
            lVendorLedgerEntry.SETRANGE("Document No.", pGJL."Applies-to Doc. No.");
            lVendorLedgerEntry.FindFirst();
            if not VendorLedgerEntryTMP.GET(lVendorLedgerEntry."Entry No.") then begin
                VendorLedgerEntryTMP.INIT();
                VendorLedgerEntryTMP.TRANSFERFIELDS(lVendorLedgerEntry);
                VendorLedgerEntryTMP.INSERT();
            end;
        end else begin
            if pGJL."Applies-to ID" <> '' then begin
                lVendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
                lVendorLedgerEntry.SETRANGE("Vendor No.", pGJL."Account No.");
                lVendorLedgerEntry.SETRANGE("Applies-to ID", pGJL."Applies-to ID");
                if lVendorLedgerEntry.FindSet() then begin
                    repeat
                        if not VendorLedgerEntryTMP.GET(lVendorLedgerEntry."Entry No.") then begin
                            VendorLedgerEntryTMP.INIT();
                            VendorLedgerEntryTMP.TRANSFERFIELDS(lVendorLedgerEntry);
                            VendorLedgerEntryTMP.INSERT();
                        end;
                    until lVendorLedgerEntry.NEXT() = 0;
                end;
            end;
        end
        //<<
    end;

    local procedure GetLastPaidDateTxt(pVendorNo: Code[20]): Text;
    var
        lVendor: Record Vendor;
        lVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        //>>
        lVendorLedgerEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date", "Currency Code");
        lVendorLedgerEntry.SETRANGE("Vendor No.", pVendorNo);
        lVendorLedgerEntry.SETRANGE("Document Type", lVendorLedgerEntry."Document Type"::Payment);
        if lVendorLedgerEntry.FindLast() then
            exit(FORMAT(lVendorLedgerEntry."Posting Date"));

        exit('');
        //<<
    end;
}

