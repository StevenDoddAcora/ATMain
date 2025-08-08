codeunit 50602 "ACO_GeneralFunctions"
{
    //#region "Documentation"
    // 1.2.0.2018 LBR 13/06/2019 - New object created for NAV to Excel export (Init Spec point 3.3)
    // 2.2.0.2018 LBR 14/08/2019 - Vendor Balance and Credit Limit Fields (point 3.9.7)
    // 2.2.2.2018 LBR 12/09/2019 - CHG003320 (TCY Credit Limit Bespoke) TCY Credit Limit should be editable and update Credit Limit (LCY) instead
    // 2.2.4.2018 LBR 04/10/2019 - Snagging corrected issue with wrong dates on Avg Colleciton Period;
    // 2.2.9.2018 LBR 06/11/2019 - Snagging (Balance (GBP) vendor calculation corrected)
    // 2.3.2.2018 LBR 26/11/2019 - Fixing an issue with the ECY beeing not calculated correctly;
    // 3.0.0.2018 LBR 19/12/2019 - ECY should be calc based on the exch rate for each transaction, new CalcCustomerBalanceForExchCurrency function added
    // 3.0.1.2018 LBR 24/01/2020 - Corrected issue related to the Average Calculate Period for year and last year as per James email 
    //                             from 22/01/2020 (this year is alwasy current year from jan to dec, last year is alwas current year - 1 year form jan to dec)
    // 3.0.4.2018 LBR 28/01/2020 - Corrected issue related to the Average Calculate Period: to period should be calc based on workdate - perdiod (req by James)
    //#endregion "Documentation"

    //>>2.2.0.2018
    //#region VendorBalanceAndCreditLimit
    local procedure _____VENDOR_____()
    begin

    end;

    procedure RecalculateVendorCurrencyData(var Vendor: Record Vendor; pAtDate: Date);
    var
        ProgressDialog: Dialog;
        ProgressLbl: Label 'Recalculating Currency Data ...';
    begin
        if GuiAllowed() then
            ProgressDialog.Open(ProgressLbl);

        // Calc Customer Currency Data
        with Vendor do begin
            if FindSet(true) then begin
                repeat
                begin
                    RecalculateVendorCurrencyDataRec(Vendor, pAtDate);
                end;
                until next() = 0;
            end;
        end;

        if GuiAllowed() then
            ProgressDialog.Close();
    end;

    local procedure RecalculateVendorCurrencyDataRec(var pVendor: Record Vendor; pAtDate: Date);
    var
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ExchangeRateDate: Date;
        ExchangeRateAmtTCY: Decimal;
        ExchangeRateAmtECY: Decimal;
    begin
        if pVendor."No." = '' then
            exit;

        GetAdditionalSetup();
        GetGenrealLegerSetup();

        if pAtDate = 0D then
            pAtDate := TODAY;

        with pVendor do begin
            // Clear Values            
            //>>2.2.2.2018
            //Clear(ACO_ActiveExchangeRateTCY);
            //Clear(ACO_CreditLimitTCY);
            //<<2.2.2.2018
            Clear(ACO_BalanceCurrency1);
            Clear(ACO_BalanceCurrency2);
            Clear(ACO_BalanceCurrency3);

            // Update Last update Date/Time
            ACO_LastCurrencyDataUpdateDate := pAtDate;
            ACO_LastCurrencyDataUpdateTime := TIME;

            //>>2.2.2.2018
            /*
            // This is no longer automated 
            // *** TCY ***
            // Get Exchange Rate for TCY (Trading Currency)
            if "Currency Code" <> '' then begin
                CurrencyExchangeRate.GetLastestExchangeRate("Currency Code", ExchangeRateDate, ACO_ActiveExchangeRateTCY);
                ACO_CreditLimitTCY := ROUND(CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                                                pAtDate, "Currency Code",
                                                ACO_CreditLimitLCY,
                                                CurrencyExchangeRate.GetCurrentCurrencyFactor("Currency Code")),
                                            GenLedgerSetup."Amount Rounding Precision");
            end;
            */
            //<<2.2.2.2018

            //>>
            //This will ensure the calculation of the Credit Limit LCY is done correctly
            Validate(ACO_CreditLimitTCY);
            //<<

            // Currency 1
            //>>2.2.9.2018
            //if AdditionalSetup.ACO_CustomerReportCurrency1 <> '' then
            //<<2.2.9.2018
            ACO_BalanceCurrency1 := CalcVendorBalance("No.", AdditionalSetup.ACO_CustomerReportCurrency1, 0D);
            // Currency 2
            //>>2.2.9.2018
            //if AdditionalSetup.ACO_CustomerReportCurrency2 <> '' then
            //<<2.2.9.2018
            ACO_BalanceCurrency2 := CalcVendorBalance("No.", AdditionalSetup.ACO_CustomerReportCurrency2, 0D);
            // Currency 3
            //>>2.2.9.2018
            //if AdditionalSetup.ACO_CustomerReportCurrency3 <> '' then
            //<<2.2.9.2018
            ACO_BalanceCurrency3 := CalcVendorBalance("No.", AdditionalSetup.ACO_CustomerReportCurrency3, 0D);

            Modify(true);
        end;
    end;

    local procedure CalcVendorBalance(pVendorCode: Code[20]; pCurrencyCode: code[20]; pDate: Date) ReturnValue: Decimal;
    var
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        GetGenrealLegerSetup();

        DetailedVendLedgEntry.SetRange("Vendor No.", pVendorCode);
        //DetailedCustLedgEntry.SetFilter(COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        //DetailedCustLedgEntry.SetFilter(COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        if (pDate <> 0D) then
            DetailedVendLedgEntry.SetFilter("Posting Date", '<=%1', pDate);
        if (pCurrencyCode = '') or (pCurrencyCode = GenLedgerSetup."LCY Code") then
            DetailedVendLedgEntry.SetFilter("Currency Code", '%1|%2', '', pCurrencyCode)
        else
            DetailedVendLedgEntry.SetRange("Currency Code", pCurrencyCode);
        DetailedVendLedgEntry.CalcSums(Amount);

        exit(DetailedVendLedgEntry.Amount * -1);
    end;
    //#endregion VendorBalanceAndCreditLimit

    //#region VendorAvgCollPeriod
    //<<2.2.4.2018
    // Code in the function has been copied from the standard NAV page "Customer Entry Statistics" (ID 302)
    procedure CalculateVendorAvgDaysToPay(var Vendor: Record Vendor; var AvgDaysToPay: array[3] of Decimal; AvgCalcPerdiod: Option "Month","Quarter","Year","YTD"; pDate: Date);
    var
        //CustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Vendor Ledger Entry";
        //TotalRemainAmountLCY: array[6] of Decimal;
        DateFilterCalc: Codeunit "DateFilter-Calc";
        CustDateFilter: array[3] of Text[30];
        CustDateName: array[3] of Text[30];
        DtldCustLedgEntry2: record "Detailed Vendor Ledg. Entry";
        DaysToPay: Decimal;
        NoOfInv: Integer;
        NoOfDoc: array[3, 6] of Integer;
        CustLedgEntry3: Record "Vendor Ledger Entry";
        j: Integer;
        i: Integer;
        DateRec: Record Date;
    begin
        if Vendor."No." = '' then
            exit;

        CLEAR(AvgDaysToPay);

        with Vendor do begin
            // This period filter which depends on the settings in AvgCalcPerdiod parameter
            DateFilterCalc.CreateAccountingPeriodFilter(CustDateFilter[1], CustDateName[1], pDate, 0);
            // This Year
            DateFilterCalc.CreateFiscalYearFilter(CustDateFilter[2], CustDateName[2], pDate, 0);
            // Last Year
            DateFilterCalc.CreateFiscalYearFilter(CustDateFilter[3], CustDateName[3], pDate, -1);

            // Format the CustDateFilter[1] date filter base on the option selected
            case AvgCalcPerdiod of
                AvgCalcPerdiod::Month:
                    begin
                        CustDateFilter[1] := CustDateFilter[1]; // is this same as the this period
                    end;
                AvgCalcPerdiod::Quarter:
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Quarter);
                        DateRec.SetFilter("Period Start", '<=%1', pDate);
                        DateRec.FindLast();
                        CustDateFilter[1] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
                    end;
                AvgCalcPerdiod::Year:
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                        DateRec.SetFilter("Period Start", '<=%1', pDate);
                        DateRec.FindLast();
                        CustDateFilter[1] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
                        //CustDateFilter[2]; // is this same as the this year calculation
                    end;
                AvgCalcPerdiod::YTD:
                    begin
                        //>>3.0.4.2018
                        //DateRec.Reset();
                        //DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                        //DateRec.SetFilter("Period Start", '<=%1', pDate);
                        //DateRec.FindLast()();
                        //CustDateFilter[1] := Format(DateRec."Period Start") + '..' + Format(pDate);

                        CustDateFilter[1] := FORMAT(CALCDATE('-1Y', pDate)) + '..' + FORMAT(pDate);
                        //<<3.0.4.2018
                    end;

            end; // end of case

            //>>3.0.1.2018
            // Update other
            // This Year
            DateRec.Reset();
            DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
            DateRec.SetFilter("Period Start", '<=%1', pDate);
            DateRec.FindLast();
            CustDateFilter[2] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
            // Last Year
            DateRec.Reset();
            DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
            DateRec.SetFilter("Period Start", '<=%1', CALCDATE('-1Y', pDate));
            DateRec.FindLast();
            CustDateFilter[3] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
            //<<3.0.1.2018

            FOR i := 1 TO 3 DO BEGIN
                CustLedgEntry2.RESET;
                CustLedgEntry2.SETCURRENTKEY("Vendor No.", "Posting Date");
                CustLedgEntry2.SetRange("Vendor No.", "No.");

                CustLedgEntry2.SetFilter("Posting Date", CustDateFilter[i]);
                CustLedgEntry2.SetRange("Posting Date", 0D, CustLedgEntry2.GETRANGEMAX("Posting Date"));
                DtldCustLedgEntry2.SETCURRENTKEY("Vendor No.", "Posting Date");
                CustLedgEntry2.COPYFILTER("Vendor No.", DtldCustLedgEntry2."Vendor No.");
                CustLedgEntry2.COPYFILTER("Posting Date", DtldCustLedgEntry2."Posting Date");
                DtldCustLedgEntry2.CalcSums("Amount (LCY)");
                DaysToPay := 0;
                NoOfInv := 0;

                CustLedgEntry2.SetFilter("Posting Date", CustDateFilter[i]);
                IF CustLedgEntry2.Find('+') THEN
                    REPEAT
                    BEGIN
                        j := CustLedgEntry2."Document Type";
                        IF j > 0 THEN
                            NoOfDoc[i] [j] := NoOfDoc[i] [j] + 1;

                        CustLedgEntry2.CalcFields("Amount (LCY)");

                        // Optimized Approximation
                        IF (CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
                            NOT CustLedgEntry2.Open
                        THEN BEGIN
                            IF CustLedgEntry2."Closed at Date" > CustLedgEntry2."Posting Date" THEN
                                UpdateDaysToPay(CustLedgEntry2."Closed at Date" - CustLedgEntry2."Posting Date", DaysToPay, NoOfInv)
                            ELSE IF CustLedgEntry2."Closed by Entry No." <> 0 THEN BEGIN
                                IF CustLedgEntry3.GET(CustLedgEntry2."Closed by Entry No.") THEN
                                    UpdateDaysToPay(CustLedgEntry3."Posting Date" - CustLedgEntry2."Posting Date", DaysToPay, NoOfInv);
                            END ELSE BEGIN
                                CustLedgEntry3.SETCURRENTKEY("Closed by Entry No.");
                                CustLedgEntry3.SetRange("Closed by Entry No.", CustLedgEntry2."Entry No.");
                                IF CustLedgEntry3.FindLast() THEN
                                    UpdateDaysToPay(CustLedgEntry3."Posting Date" - CustLedgEntry2."Posting Date", DaysToPay, NoOfInv);
                            END;
                        END;
                    END;
                    UNTIL CustLedgEntry2.NEXT(-1) = 0;

                IF NoOfInv <> 0 THEN
                    AvgDaysToPay[i] := DaysToPay / NoOfInv;
            END;
        end;

    end;
    //<<2.2.4.2018
    //#endregion VendorAvgCollPeriod

    //#region CustomerBalanceAndCreditLimit
    local procedure _____CUSTOMER_____()
    begin

    end;

    procedure RecalculateCustomerCurrencyData(var Customer: Record Customer; pAtDate: Date);
    var
        ProgressDialog: Dialog;
        ProgressLbl: Label 'Recalculating Currency Data ...';
    begin
        if GuiAllowed() then
            ProgressDialog.Open(ProgressLbl);

        // Calc Customer Currency Data
        with Customer do begin
            if FindSet(true) then begin
                repeat
                begin
                    RecalculateCustomerCurrencyDataRec(Customer, pAtDate);
                end;
                until next() = 0;
            end;
        end;

        if GuiAllowed() then
            ProgressDialog.Close();
    end;

    local procedure RecalculateCustomerCurrencyDataRec(var pCustomer: Record Customer; pAtDate: Date);
    var
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ExchangeRateDate: Date;
        ExchangeRateAmtTCY: Decimal;
        ExchangeRateAmtECY: Decimal;
        BalanceCurrency1: Decimal;
        BalanceCurrency2: Decimal;
        BalanceCurrency3: Decimal;
    begin
        if pCustomer."No." = '' then
            exit;

        GetAdditionalSetup();
        GetGenrealLegerSetup();

        if pAtDate = 0D then
            pAtDate := TODAY;

        with pCustomer do begin
            // Clear Values            
            Clear(ACO_ActiveExchangeRateECY);
            //>>2.2.2.2018
            //Clear(ACO_ActiveExchangeRateTCY);
            //Clear(ACO_CreditLimitTCY);
            //<<2.2.2.2018
            Clear(ACO_CreditLimitECY);
            Clear(ACO_BalanceECY);
            Clear(ACO_BalanceCurrency1);
            Clear(ACO_BalanceCurrency2);
            Clear(ACO_BalanceCurrency3);

            // Update Last update Date/Time
            ACO_LastCurrencyDataUpdateDate := pAtDate;
            ACO_LastCurrencyDataUpdateTime := TIME;

            //>>2.2.2.2018
            /*
            // This is no longer automated 
            // *** TCY ***
            // Get Exchange Rate for TCY (Trading Currency)
            if "Currency Code" <> '' then begin
                CurrencyExchangeRate.GetLastestExchangeRate("Currency Code", ExchangeRateDate, ACO_ActiveExchangeRateTCY);
                ACO_CreditLimitTCY := ROUND(CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                                                pAtDate, "Currency Code",
                                                "Credit Limit (LCY)",
                                                CurrencyExchangeRate.GetCurrentCurrencyFactor("Currency Code")),
                                            GenLedgerSetup."Amount Rounding Precision");
            end;
            */
            //<<2.2.2.2018

            //>>
            //This will ensure the calculation of the Credit Limit LCY is done correctly
            Validate(ACO_CreditLimitTCY);
            //<<

            // *** ECY ***
            // Get Exchange Rate for ECY (Export Currency)
            if AdditionalSetup.ACO_ExportCurrency <> '' then begin
                CurrencyExchangeRate.GetLastestExchangeRate(AdditionalSetup.ACO_ExportCurrency, ExchangeRateDate, ACO_ActiveExchangeRateECY);
                ACO_CreditLimitECY := ROUND(CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                                            pAtDate, AdditionalSetup.ACO_ExportCurrency,
                                            "Credit Limit (LCY)",
                                            CurrencyExchangeRate.GetCurrentCurrencyFactor(AdditionalSetup.ACO_ExportCurrency)),
                                        GenLedgerSetup."Amount Rounding Precision");
                CalcFields("Balance (LCY)");
                //>>2.3.2.2018
                //ACO_BalanceECY := ROUND(CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                //                            pAtDate, AdditionalSetup.ACO_ExportCurrency,
                //                            "Balance (LCY)",
                //                            CurrencyExchangeRate.GetCurrentCurrencyFactor(AdditionalSetup.ACO_ExportCurrency)),
                //                        GenLedgerSetup."Amount Rounding Precision");

                //3.1.6.2018 ACO_BalanceECY := CalcCustomerBalanceForExchCurrency("No.", AdditionalSetup.ACO_ExportCurrency, 0D);
                //<<2.3.2.2018
            end;

            // Currency 1
            //>>2.2.4.2018
            //if AdditionalSetup.ACO_CustomerReportCurrency1 <> '' then
            //<<2.2.4.2018
            ACO_BalanceCurrency1 := CalcCustomerBalance("No.", AdditionalSetup.ACO_CustomerReportCurrency1, 0D);
            // Currency 2
            //>>2.2.4.2018
            //if AdditionalSetup.ACO_CustomerReportCurrency2 <> '' then
            //<<2.2.4.2018
            ACO_BalanceCurrency2 := CalcCustomerBalance("No.", AdditionalSetup.ACO_CustomerReportCurrency2, 0D);
            // Currency 3
            //>>2.2.4.2018
            //if AdditionalSetup.ACO_CustomerReportCurrency3 <> '' then
            //<<2.2.4.2018
            ACO_BalanceCurrency3 := CalcCustomerBalance("No.", AdditionalSetup.ACO_CustomerReportCurrency3, 0D);

            //>>3.1.6.2018 Change of way ECY Total is calculated. The three reporting currencies are now added together together
            //to get the total exposure amount. If the reporting currency amount is not already in ECY currency then it is converted 
            //to ECY amount. 
            //>>3.1.7.2018
            Clear(BalanceCurrency1);
            Clear(BalanceCurrency2);
            Clear(BalanceCurrency3);
            Clear(ACO_BalanceECY);
            if AdditionalSetup.ACO_CustomerReportCurrency1 <> AdditionalSetup.ACO_ExportCurrency then
                BalanceCurrency1 := ROUND(CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                                Today,
                                                  AdditionalSetup.ACO_CustomerReportCurrency1,
                                                    AdditionalSetup.ACO_ExportCurrency,
                                                      ACO_BalanceCurrency1));
            if AdditionalSetup.ACO_CustomerReportCurrency2 <> AdditionalSetup.ACO_ExportCurrency then
                BalanceCurrency2 := ROUND(CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                                Today,
                                                  AdditionalSetup.ACO_CustomerReportCurrency2,
                                                    AdditionalSetup.ACO_ExportCurrency,
                                                      ACO_BalanceCurrency2));
            if AdditionalSetup.ACO_CustomerReportCurrency3 <> AdditionalSetup.ACO_ExportCurrency then
                BalanceCurrency3 := ROUND(CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                                Today,
                                                  AdditionalSetup.ACO_CustomerReportCurrency3,
                                                    AdditionalSetup.ACO_ExportCurrency,
                                                      ACO_BalanceCurrency3));
            //<<3.1.7.2018
            //>>3.1.8.2018
            if BalanceCurrency1 <> 0 then
                ACO_BalanceECY := ACO_BalanceECY + BalanceCurrency1
            else
                ACO_BalanceECY := ACO_BalanceECY + ACO_BalanceCurrency1;
            if BalanceCurrency2 <> 0 then
                ACO_BalanceECY := ACO_BalanceECY + BalanceCurrency2
            else
                ACO_BalanceECY := ACO_BalanceECY + ACO_BalanceCurrency2;
            if BalanceCurrency3 <> 0 then
                ACO_BalanceECY := ACO_BalanceECY + BalanceCurrency3
            else
                ACO_BalanceECY := ACO_BalanceECY + ACO_BalanceCurrency3;
            //<<3.1.8.2018
            //<<3.1.6.2018

            Modify(true);
        end;
    end;

    //>>3.0.0.2018
    local procedure CalcCustomerBalanceForExchCurrency(pCustomerCode: Code[20]; pFCYCurrencyCode: code[20]; pFilterDate: Date) ReturnValue: Decimal;
    var
        //DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CurrExchRate: record "Currency Exchange Rate";
    begin
        GetGenrealLegerSetup();

        CustLedgerEntry.SetCurrentKey("Customer No.", "Open", "Positive", "Due Date", "Currency Code");
        CustLedgerEntry.SetRange("Customer No.", pCustomerCode);
        CustLedgerEntry.SetRange(Open, true);
        if (pFilterDate <> 0D) then
            CustLedgerEntry.SetFilter("Posting Date", '<=%1', pFilterDate);
        if CustLedgerEntry.FindSet(false) then begin
            repeat
            begin
                CustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                // Update Amount as per required currency
                if (pFCYCurrencyCode = '') or (pFCYCurrencyCode = 'GBP') then
                    ReturnValue += CustLedgerEntry."Remaining Amt. (LCY)"
                else
                    ReturnValue += ROUND(CurrExchRate.ExchangeAmtLCYToFCY(
                                                    CustLedgerEntry."Posting Date", pFCYCurrencyCode,
                                                    CustLedgerEntry."Remaining Amt. (LCY)",
                                                    CurrExchRate.ExchangeRate(CustLedgerEntry."Posting Date", pFCYCurrencyCode)),
                                                GenLedgerSetup."Amount Rounding Precision");
            end;
            until CustLedgerEntry.Next() = 0;
        end;
    end;
    //<<3.0.0.2018

    local procedure CalcCustomerBalance(pCustomerCode: Code[20]; pCurrencyCode: code[20]; pDate: Date) ReturnValue: Decimal;
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        GetGenrealLegerSetup();

        DetailedCustLedgEntry.SetRange("Customer No.", pCustomerCode);
        //DetailedCustLedgEntry.SetFilter(COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        //DetailedCustLedgEntry.SetFilter(COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        if (pDate <> 0D) then
            DetailedCustLedgEntry.SetFilter("Posting Date", '<=%1', pDate);
        if (pCurrencyCode = '') or (pCurrencyCode = GenLedgerSetup."LCY Code") then
            DetailedCustLedgEntry.SetFilter("Currency Code", '%1|%2', '', pCurrencyCode)
        else
            DetailedCustLedgEntry.SetRange("Currency Code", pCurrencyCode);
        DetailedCustLedgEntry.CalcSums(Amount);

        exit(DetailedCustLedgEntry.Amount);
    end;

    local procedure GetActiveExchRate(pCurrCode: Code[20]) ReturnValue: Decimal;
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.SetRange("Currency Code", pCurrCode);
        if CurrExchRate.FindLast() then
            exit(CurrExchRate."Exchange Rate Amount");

        exit(0);
    end;
    //#endregion CustomerBalanceAndCreditLimit

    //#region CustomerAvgCollPeriod

    // Code in the function has been copied from the standard NAV page "Customer Entry Statistics" (ID 302)
    procedure CalculateCustomerAvgDaysToPay(var Customer: Record Customer; var AvgDaysToPay: array[3] of Decimal; AvgCalcPerdiod: Option "Month","Quarter","Year","YTD"; pDate: Date);
    var
        //CustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        //TotalRemainAmountLCY: array[6] of Decimal;
        DateFilterCalc: Codeunit "DateFilter-Calc";
        CustDateFilter: array[3] of Text[30];
        CustDateName: array[3] of Text[30];
        DtldCustLedgEntry2: record "Detailed Cust. Ledg. Entry";
        DaysToPay: Decimal;
        NoOfInv: Integer;
        NoOfDoc: array[3, 6] of Integer;
        CustLedgEntry3: Record "Cust. Ledger Entry";
        j: Integer;
        i: Integer;
        DateRec: Record Date;
    begin
        // The AvgDaysToPay[1] is used to calculated based on the AvgCalcPerdiod options
        // The AvgDaysToPay[2] is this year
        // The AvgDaysToPay[3] is last year

        if Customer."No." = '' then
            exit;

        CLEAR(AvgDaysToPay);

        with Customer do begin
            // Commented to speed up the calculation, however if in future others fieds would need to be visible then it can be uncommented 
            // FOR j := 1 TO 6 DO
            // BEGIN
            //     CustLedgEntry[j].SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
            //     CustLedgEntry[j].SetRange("Document Type", j); // Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund
            //     CustLedgEntry[j].SetRange("Customer No.", "No.");
            //     IF CustLedgEntry[j].FindLast() THEN
            //         CustLedgEntry[j].CalcFields(Amount, "Remaining Amount");
            // END;
            // CustLedgEntry2.SETCURRENTKEY("Customer No.", Open);
            // CustLedgEntry2.SetRange("Customer No.", "No.");
            // CustLedgEntry2.SetRange(Open, TRUE);
            // IF CustLedgEntry2.Find('+') THEN begin
            //     REPEAT
            //     begin
            //         j := CustLedgEntry2."Document Type";
            //         IF j > 0 THEN BEGIN
            //             CustLedgEntry2.CalcFields("Remaining Amt. (LCY)");
            //             TotalRemainAmountLCY[j] := TotalRemainAmountLCY[j] + CustLedgEntry2."Remaining Amt. (LCY)";
            //         END;
            //     end;
            //     UNTIL CustLedgEntry2.NEXT(-1) = 0;
            // end;

            // This period filter which depends on the settings in AvgCalcPerdiod parameter
            DateFilterCalc.CreateAccountingPeriodFilter(CustDateFilter[1], CustDateName[1], pDate, 0);
            // This Year
            DateFilterCalc.CreateFiscalYearFilter(CustDateFilter[2], CustDateName[2], pDate, 0);
            // Last Year
            DateFilterCalc.CreateFiscalYearFilter(CustDateFilter[3], CustDateName[3], pDate, -1);

            // Format the CustDateFilter[1] date filter base on the option selected
            case AvgCalcPerdiod of
                AvgCalcPerdiod::Month:
                    begin
                        CustDateFilter[1] := CustDateFilter[1]; // is this same as the this period
                    end;
                AvgCalcPerdiod::Quarter:
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Quarter);
                        //>>2.2.4.2018
                        //DateRec.SetFilter("Period Start", '>=%1', pDate);
                        //DateRec.SetFilter("Period End", '<=%1', pDate);
                        //DateRec.FindFirst()();
                        DateRec.SetFilter("Period Start", '<=%1', pDate);
                        DateRec.FindLast();
                        //<<2.2.4.2018
                        CustDateFilter[1] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
                    end;
                AvgCalcPerdiod::Year:
                    begin
                        DateRec.Reset();
                        DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                        //>>2.2.4.2018
                        //DateRec.SetFilter("Period Start", '>=%1', pDate);
                        //DateRec.SetFilter("Period End", '<=%1', pDate);
                        //DateRec.FindFirst()();
                        DateRec.SetFilter("Period Start", '<=%1', pDate);
                        DateRec.FindLast();
                        //<<2.2.4.2018
                        CustDateFilter[1] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
                        //CustDateFilter[2]; // is this same as the this year calculation
                    end;
                AvgCalcPerdiod::YTD:
                    begin
                        //>>3.0.4.2018
                        //DateRec.Reset();
                        //DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
                        ////>>2.2.4.2018
                        ////DateRec.SetFilter("Period Start", '>=%1', pDate);
                        ////DateRec.SetFilter("Period End", '<=%1', pDate);
                        ////DateRec.FindFirst()();
                        //DateRec.SetFilter("Period Start", '<=%1', pDate);
                        //DateRec.FindLast()();
                        ////<<2.2.4.2018
                        //CustDateFilter[1] := Format(DateRec."Period Start") + '..' + Format(pDate);

                        CustDateFilter[1] := FORMAT(CALCDATE('-1Y', pDate)) + '..' + FORMAT(pDate);
                        //<<3.0.4.2018
                    end;
            end; // end of case

            //>>3.0.1.2018
            // Update other
            // This Year
            DateRec.Reset();
            DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
            DateRec.SetFilter("Period Start", '<=%1', pDate);
            DateRec.FindLast();
            CustDateFilter[2] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
            // Last Year
            DateRec.Reset();
            DateRec.SetRange("Period Type", DateRec."Period Type"::Year);
            DateRec.SetFilter("Period Start", '<=%1', CALCDATE('-1Y', pDate));
            DateRec.FindLast();
            CustDateFilter[3] := Format(DateRec."Period Start") + '..' + Format(DateRec."Period End");
            //<<3.0.1.2018

            FOR i := 1 TO 3 DO BEGIN
                CustLedgEntry2.RESET;
                CustLedgEntry2.SETCURRENTKEY("Customer No.", "Posting Date");
                CustLedgEntry2.SetRange("Customer No.", "No.");

                CustLedgEntry2.SetFilter("Posting Date", CustDateFilter[i]);
                CustLedgEntry2.SetRange("Posting Date", 0D, CustLedgEntry2.GETRANGEMAX("Posting Date"));
                DtldCustLedgEntry2.SETCURRENTKEY("Customer No.", "Posting Date");
                CustLedgEntry2.COPYFILTER("Customer No.", DtldCustLedgEntry2."Customer No.");
                CustLedgEntry2.COPYFILTER("Posting Date", DtldCustLedgEntry2."Posting Date");
                DtldCustLedgEntry2.CalcSums("Amount (LCY)");
                //CustBalanceLCY := DtldCustLedgEntry2."Amount (LCY)";
                //HighestBalanceLCY[i] := CustBalanceLCY;
                DaysToPay := 0;
                NoOfInv := 0;

                CustLedgEntry2.SetFilter("Posting Date", CustDateFilter[i]);
                IF CustLedgEntry2.Find('+') THEN
                    REPEAT
                    BEGIN
                        j := CustLedgEntry2."Document Type";
                        IF j > 0 THEN
                            NoOfDoc[i] [j] := NoOfDoc[i] [j] + 1;

                        CustLedgEntry2.CalcFields("Amount (LCY)");
                        //CustBalanceLCY := CustBalanceLCY - CustLedgEntry2."Amount (LCY)";
                        //IF CustBalanceLCY > HighestBalanceLCY[i] THEN
                        //    HighestBalanceLCY[i] := CustBalanceLCY;

                        // Optimized Approximation
                        IF (CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
                            NOT CustLedgEntry2.Open
                        THEN BEGIN
                            IF CustLedgEntry2."Closed at Date" > CustLedgEntry2."Posting Date" THEN
                                UpdateDaysToPay(CustLedgEntry2."Closed at Date" - CustLedgEntry2."Posting Date", DaysToPay, NoOfInv)
                            ELSE IF CustLedgEntry2."Closed by Entry No." <> 0 THEN BEGIN
                                IF CustLedgEntry3.GET(CustLedgEntry2."Closed by Entry No.") THEN
                                    UpdateDaysToPay(CustLedgEntry3."Posting Date" - CustLedgEntry2."Posting Date", DaysToPay, NoOfInv);
                            END ELSE BEGIN
                                CustLedgEntry3.SETCURRENTKEY("Closed by Entry No.");
                                CustLedgEntry3.SetRange("Closed by Entry No.", CustLedgEntry2."Entry No.");
                                IF CustLedgEntry3.FindLast() THEN
                                    UpdateDaysToPay(CustLedgEntry3."Posting Date" - CustLedgEntry2."Posting Date", DaysToPay, NoOfInv);
                            END;
                        END;
                    END;
                    UNTIL CustLedgEntry2.NEXT(-1) = 0;

                IF NoOfInv <> 0 THEN
                    AvgDaysToPay[i] := DaysToPay / NoOfInv;
            END;
        end;

    end;

    local procedure UpdateDaysToPay(NoOfDays: Integer; var DaysToPay: Decimal; var NoOfInv: Integer);
    begin
        DaysToPay := DaysToPay + NoOfDays;
        NoOfInv := NoOfInv + 1;
    end;
    //#endregion CustomerAvgCollPeriod


    //#region Address
    local procedure _____ADDRESS_____()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnBeforeFormatAddress', '', false, false)]
    local procedure RunOnBeforeFormatAddress(Country: Record "Country/Region"; VAR AddrArray: ARRAY[8] OF Text[90]; Name: Text[90]; Name2: Text[90]; Contact: Text[90]; Addr: Text[50]; Addr2: Text[50]; City: Text[50]; PostCode: Code[20]; County: Text[50]; CountryCode: Code[10]; NameLineNo: Integer; Name2LineNo: Integer; AddrLineNo: Integer; Addr2LineNo: Integer; ContLineNo: Integer; PostCodeCityLineNo: Integer; CountyLineNo: Integer; CountryLineNo: Integer; var Handled: Boolean)
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();

        AddrArray[NameLineNo] := Name;
        AddrArray[Name2LineNo] := Name2;
        AddrArray[AddrLineNo] := Addr;
        AddrArray[Addr2LineNo] := Addr2;
        //AddrArray[ContLineNo] := Contact;
        if CompanyInfo.Name = Name then begin
            AddrArray[PostCodeCityLineNo] := City;
            if County <> '' then
                AddrArray[CountyLineNo] := County + ', ' + PostCode
            else
                AddrArray[CountyLineNo] := PostCode;
        end else begin
            AddrArray[PostCodeCityLineNo] := City;
            AddrArray[CountyLineNo] := PostCode;
        end;
        AddrArray[CountryLineNo] := Country.Name;
        COMPRESSARRAY(AddrArray);

        Handled := true;
    end;
    //#endregion Address

    //#region HelpFunctions
    local procedure ____GENERAL____()
    begin
    end;

    local procedure GetAdditionalSetup()
    begin
        if AdditionalSetup.ACO_ExportCurrency = '' then
            AdditionalSetup.GET();
    end;

    local procedure GetGenrealLegerSetup()
    begin
        if (GenLedgerSetup."LCY Code" = '') then
            GenLedgerSetup.GET();
    end;

    procedure AddSlashAtTheEnd(pFile: Text) ReturnValue: text;
    var
        myInt: Integer;
    begin
        if CopyStr(pFile, StrLen(pFile)) <> '\' then
            exit(pFile + '\')
        else
            exit(pFile);
    end;
    //#endregion HelpFunctions

    var
        AdditionalSetup: Record ACO_AdditionalSetup;
        GenLedgerSetup: Record "General Ledger Setup";

}
