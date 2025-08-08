pageextension 50300 "ACO_CustomerList" extends "Customer List"
{
    //#region "Documentation"
    // 1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    // 1.2.0.2018 LBR 13/06/2019 - New fields added for NAV to Excel export (Init Spec point 3.3)
    // 2.0.0.2018 LBR 13/06/2019 - Customer - Average Collection Period (point 3.4.2), New field added;
    // 2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    layout
    {
        addlast(Control1)
        {
            field(ACO_Exposure; Rec.ACO_Exposure)
            {
                ApplicationArea = All;
                Editable = false;
            }
            //>>1.2.0.2018
            field(ACO_ActiveExchangeRateTCY; Rec.ACO_ActiveExchangeRateTCY)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the active exchange rate for the default Trading Currency at the Last Update Date';
                Editable = false;
                BlankZero = false;
            }
            field(ACO_CreditLimitTCY; Rec.ACO_CreditLimitTCY)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: Credit Limit (LCY) x Active Exchange Rate for the Trading Currency';
                Editable = false;
                BlankZero = false;
            }
            field(ACO_ActiveExchangeRateECY; Rec.ACO_ActiveExchangeRateECY)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the active exchange rate for the Export Currency at the Last Update Date';
                Editable = false;
                BlankZero = false;
            }
            field(ACO_CreditLimitECY; Rec.ACO_CreditLimitECY)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: Credit Limit (LCY) x Active Exchange Rate for the Export Currency';
                Editable = false;
                BlankZero = false;
            }
            field(ACO_BalanceECY; Rec.ACO_BalanceECY)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: Balance (LCY) x Active Exchange Rate for the Export Currency';
                Editable = false;
                BlankZero = false;

                // trigger OnDrillDown();
                // begin
                //     GetAdditionalSetup();
                //     OpenCurrCustomerLedgerEntries('', Today);
                // end;
            }
            field(ACO_BalanceCurrency1; Rec.ACO_BalanceCurrency1)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Customer Ledger Entries wher Currency field is Customer Report Currency 1';
                Editable = false;
                BlankZero = false;
                CaptionClass = Rec.GetFieldCaptionClass(FieldNo(Rec.ACO_BalanceCurrency1));

                trigger OnDrillDown();
                begin
                    GetGenrealLegerSetup();
                    OpenCurrCustomerLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency1, Today);
                end;
            }
            field(ACO_BalanceCurrency2; Rec.ACO_BalanceCurrency2)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Customer Ledger Entries wher Currency field is Customer Report Currency 2';
                Editable = false;
                BlankZero = false;
                CaptionClass = Rec.GetFieldCaptionClass(FieldNo(Rec.ACO_BalanceCurrency2));

                trigger OnDrillDown();
                begin
                    GetAdditionalSetup();
                    OpenCurrCustomerLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency2, Today);
                end;
            }
            field(ACO_BalanceCurrency3; Rec.ACO_BalanceCurrency3)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Customer Ledger Entries wher Currency field is Customer Report Currency 3';
                Editable = false;
                BlankZero = false;
                CaptionClass = Rec.GetFieldCaptionClass(FieldNo(Rec.ACO_BalanceCurrency3));

                trigger OnDrillDown();
                begin
                    GetAdditionalSetup();
                    OpenCurrCustomerLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency3, Today);
                end;
            }
            field(ACO_LastCurrencyDataUpdateDate; Rec.ACO_LastCurrencyDataUpdateDate)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY,ECY)';
                Editable = false;
            }
            field(ACO_LastCurrencyDataUpdateTime; Rec.ACO_LastCurrencyDataUpdateTime)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY,ECY)';
                Editable = false;
            }
            //<<1.2.0.2018
            //>>2.0.0.2018
            //*** This field has been made invisible as the calculation happen on card level
            // field(ACO_AvgCollectionPeriod; Rec.ACO_AvgCollectionPeriod){
            //     ApplicationArea = All;
            //     ToolTip = 'It is use to calcluate using the same source values as the Customer Entry Statistics page fields, but using the new Additional Setup field to determine the time.period filter.';
            // }
            //<<2.0.0.2018
        }

        addafter("Country/Region Code")
        {
            //>>2.3.0.2018
            field(ACO_CountryRegionName; Rec.ACO_CountryRegionName)
            {
                Visible = false;
                Editable = false;
            }
            //<<2.3.0.2018
        }

        addlast(FactBoxes)
        {
            //>>2.0.0.2018
            part(ACO_CustomerEntryStatFactBox; ACO_CustomerEntryStatFactBox)
            {
                SubPageLink = "No." = field("No.");
                Rec.ApplicationArea = all;
            }
            //<<2.0.0.2018
        }
    }

    actions
    {
        //>>1.2.0.2018
        addlast(Processing)
        {
            action(RecalculateCurrencyData)
            {
                ApplicationArea = All;
                Caption = 'Recalculate Currency Data';
                ToolTip = 'Routine updates values in fields like: Active Exchange Rate TCY/ECY, Credit Limit TCY/ECY, Balnace Currency 1,2,3';
                Image = Recalculate;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    CustomerRec: record customer;
                    RecalcCustCurrencyData: Report ACO_RecalcCustCurrencyData;
                begin
                    CustomerRec.SETRANGE("No.", "No.");

                    RecalcCustCurrencyData.SetTableView(CustomerRec);
                    RecalcCustCurrencyData.RunModal();

                    CurrPage.Update(true);
                end;
            }
        }
        //<<1.2.0.2018
    }

    var
        GenLedgerSetup: Record "General Ledger Setup";
        AdditionalSetup: Record "ACO_AdditionalSetup";
        GeneralFunctions: Codeunit ACO_GeneralFunctions;

    //>>1.2.0.2018
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
}


