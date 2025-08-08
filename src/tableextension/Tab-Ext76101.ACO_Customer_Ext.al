tableextension 50101 "ACO_Customer_Ext" extends Customer
{
    //#region "Documentation"
    // 1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    // 1.2.0.2018 LBR 13/06/2019 - New fields added for NAV to Excel export (Init Spec point 3.3)
    // 2.0.0.2018 LBR 13/06/2019 - Customer - Average Collection Period (point 3.4.2), New field added;
    // 2.2.2.2018 LBR 12/09/2019 - TCY Credit Limit should be editable and update Credit Limit (LCY) instead;
    // 2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    fields
    {
        field(50100; "ACO_Exposure"; Decimal)
        {
            Caption = 'Exposure';
            DataClassification = CustomerContent;
            Description = 'It specifies value imported via importing exposure Files (Quantum to NAV), Field is used for filtering and searching purpose';
            Editable = true;
        }
        field(50110; "ACO_CancelledInvoicePosting"; Option)
        {
            Caption = 'Cancelled Invoice Posting';
            OptionMembers = "As Zero Line","As Per Source File";
            OptionCaption = 'As Zero Line,As Per Source File';
            DataClassification = CustomerContent;
            Description = 'Used to determine what Unit Price value should be used for Zero Invoice Line imports';
            Editable = true;
        }
        field(50120; "ACO_ZeroLineItemNo"; Code[20])
        {
            Caption = 'Zero Line Item No.';
            DataClassification = CustomerContent;
            Description = 'Used to determine the Item No. to be used for Zero Invoice Line imports';
            TableRelation = Item."No.";
            Editable = true;
        }
        //>>1.2.0.2018
        field(50130; "ACO_CreditLimitTCY"; Decimal)
        {
            Caption = 'Credit Limit (TCY)';
            DataClassification = CustomerContent;
            //>>2.2.2.2018
            //Description = 'Field value is updated by the update routine. The calculation formula is as follow: Credit Limit (LCY) x Active Exchange Rate for the Trading Currency';
            //Editable = false;
            Description = 'The Credit Limit (LCY) field is calculated based on this field, whenever the value is updated by the user';
            trigger OnValidate();
            var
                Currency: Record Currency;
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                ExchangeRateDate: Date;
            begin
                // *** TCY ***
                // Get Exchange Rate for TCY (Trading Currency)
                if "Currency Code" <> '' then begin
                    //*** Confirm how the exchange rate should be calculated
                    CurrencyExchangeRate.GetLastestExchangeRate("Currency Code", ExchangeRateDate, ACO_ActiveExchangeRateTCY);
                    //>>2.2.2.2018
                    "Credit Limit (LCY)" := ROUND(CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                                                    WorkDate, "Currency Code",
                                                    ACO_CreditLimitTCY,
                                                    CurrencyExchangeRate.ExchangeRate(WorkDate, "Currency Code")),
                                                GenLedgerSetup."Amount Rounding Precision");
                end else
                    "Credit Limit (LCY)" := ACO_CreditLimitTCY
            end;
            //<<2.2.2.2018
        }
        field(50140; "ACO_ActiveExchangeRateTCY"; Decimal)
        {
            Caption = 'Active Exchange Rate (TCY)';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. Shows the active exchange rate for the default Trading Currency at the Last Update Date';
            Editable = false;
        }
        field(50150; "ACO_BalanceCurrency1"; Decimal)
        {
            Caption = 'Balance Currency 1';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Customer Ledger Entries where Currency field is Customer Report Currency 1';
            Editable = false;
        }
        field(50160; "ACO_BalanceCurrency2"; Decimal)
        {
            Caption = 'Balance Currency 2';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Customer Ledger Entries where Currency field is Customer Report Currency 2';
            Editable = false;
        }
        field(50170; "ACO_BalanceCurrency3"; Decimal)
        {
            Caption = 'Balance Currency 3';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Customer Ledger Entries where Currency field is Customer Report Currency 3';
            Editable = false;
        }
        field(50180; "ACO_BalanceECY"; Decimal)
        {
            Caption = 'Balance (ECY)';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. The calculation formula is as follow: Balance (LCY) x Active Exchange Rate for the Export Currency';
            Editable = false;
        }
        field(50190; "ACO_CreditLimitECY"; Decimal)
        {
            Caption = 'Credit Limit (ECY)';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. The calculation formula is as follow: Credit Limit (ECY) x Active Exchange Rate for the Export Currency';
            Editable = false;
        }
        field(50200; "ACO_ActiveExchangeRateECY"; Decimal)
        {
            Caption = 'Active Exchange Rate (ECY)';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. Shows the active exchange rate for the Export Currency at the Last Update Date';
            Editable = false;
        }
        field(50210; "ACO_LastCurrencyDataUpdateDate"; Date)
        {
            Caption = 'Last Currency Data Update Date';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY,ECY)';
            Editable = false;
        }
        field(50220; "ACO_LastCurrencyDataUpdateTime"; Time)
        {
            Caption = 'Last Currency Data Update Time';
            DataClassification = CustomerContent;
            Description = 'Field value is updated by the update routine. Shows the last update time when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY,ECY)';
            Editable = false;
        }
        //<<1.2.0.2018
        //>>2.0.0.2018
        field(50230; "ACO_AvgCollectionPeriod"; Decimal)
        {
            Caption = 'Avg. Collection Period';
            DataClassification = CustomerContent;
            Description = 'It is use to calcluate using the same source values as the Customer Entry Statistics page fields, but using the new Additional Setup field to determine the time.period filter.';
        }
        //<<2.0.0.2018
        //>>2.3.0.2018
        field(50240; ACO_CountryRegionName; Text[50])
        {
            Caption = 'Country/Region Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("Country/Region".Name WHERE(Code = FIELD("Country/Region Code")));
        }
        //<<2.3.0.2018
    }

    //#region "Table Functions"

    var
        GenLedgerSetup: Record "General Ledger Setup";
        AdditionalSetup: Record "ACO_AdditionalSetup";

    //>>1.2.0.2018
    procedure GetFieldCaptionClass(pFieldNo: Integer) ReturnValue: Text;
    var
        BalanceLbl: Label 'Balance (%1)';
        CustRepCurr1: Text;
        CustRepCurr2: Text;
        CustRepCurr3: Text;
    begin
        GetAdditionalSetup();
        GetGenrealLegerSetup();

        CustRepCurr1 := AdditionalSetup.ACO_CustomerReportCurrency1;
        CustRepCurr2 := AdditionalSetup.ACO_CustomerReportCurrency2;
        CustRepCurr3 := AdditionalSetup.ACO_CustomerReportCurrency3;

        if CustRepCurr1 = '' then
            CustRepCurr1 := StrSubstNo(BalanceLbl, GenLedgerSetup."LCY Code")
        else
            CustRepCurr1 := StrSubstNo(BalanceLbl, CustRepCurr1);
        if CustRepCurr2 = '' then
            CustRepCurr2 := StrSubstNo(BalanceLbl, GenLedgerSetup."LCY Code")
        else
            CustRepCurr2 := StrSubstNo(BalanceLbl, CustRepCurr2);
        if CustRepCurr3 = '' then
            CustRepCurr3 := StrSubstNo(BalanceLbl, GenLedgerSetup."LCY Code")
        else
            CustRepCurr3 := StrSubstNo(BalanceLbl, CustRepCurr3);


        case pFieldNo of
            FieldNo(ACO_CreditLimitTCY):
                exit('3,' + FieldCaption(ACO_CreditLimitTCY));
            FieldNo(ACO_CreditLimitECY):
                exit('3,' + FieldCaption(ACO_CreditLimitECY));
            FieldNo(ACO_BalanceCurrency1):
                exit('3,' + CustRepCurr1);
            FieldNo(ACO_BalanceCurrency2):
                exit('3,' + CustRepCurr2);
            FieldNo(ACO_BalanceCurrency3):
                exit('3,' + CustRepCurr3);
        end;
    end;

    procedure OpenCurrCustomerLedgerEntries(pCurrencyCode: code[20]; pDate: Date);
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        GetGenrealLegerSetup();

        DetailedCustLedgEntry.SETRANGE("Customer No.", "No.");
        //DetailedCustLedgEntry.SETFILTER(COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        //DetailedCustLedgEntry.SETFILTER(COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        if (pDate <> 0D) then
            DetailedCustLedgEntry.SETFILTER("Posting Date", '<=%1', pDate);
        if (pCurrencyCode = '') or (pCurrencyCode = GenLedgerSetup."LCY Code") then
            DetailedCustLedgEntry.SETFILTER("Currency Code", '%1|%2', '', pCurrencyCode)
        else
            DetailedCustLedgEntry.SETRANGE("Currency Code", pCurrencyCode);
        CustLedgerEntry.DrillDownOnEntries(DetailedCustLedgEntry);
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
    //<<1.2.0.2018
    //#endregion "Table Functions"
}