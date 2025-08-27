namespace Acora.AvTrade.MainApp;

using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Foundation.Address;
using System.DateTime;

pageextension 50311 "ACO_VendorList" extends "Vendor List"
{
    //#region "Documentation"
    // 2.2.0.2018 LBR 14/08/2019 - Vendor Balance and Credit Limit Fields (point 3.9.7)
    // 2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    layout
    {
        addlast(Control1)
        {
            //>>2.2.0.2018
            field(ACO_CreditLimitLCY; Rec.ACO_CreditLimitLCY)
            {
                ApplicationArea = All;
                Editable = false;
                BlankZero = false;
            }
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
            field(ACO_BalanceCurrency1; Rec.ACO_BalanceCurrency1)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Vendor Ledger Entries wher Currency field is Customer/Vendor Report Currency 1';
                Editable = false;
                BlankZero = false;
                CaptionClass = Rec.GetFieldCaptionClass(Rec.FieldNo(ACO_BalanceCurrency1));

                trigger OnDrillDown();
                begin
                    GetGenrealLegerSetup();
                    Rec.OpenCurrVendorLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency1, Today);
                end;
            }
            field(ACO_BalanceCurrency2; Rec.ACO_BalanceCurrency2)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Vendor Ledger Entries wher Currency field is Customer/Vendor Report Currency 2';
                Editable = false;
                BlankZero = false;
                CaptionClass = Rec.GetFieldCaptionClass(Rec.FieldNo(ACO_BalanceCurrency2));

                trigger OnDrillDown();
                begin
                    GetAdditionalSetup();
                    Rec.OpenCurrVendorLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency2, Today);
                end;
            }
            field(ACO_BalanceCurrency3; Rec.ACO_BalanceCurrency3)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Vendor Ledger Entries wher Currency field is Customer/Vendor Report Currency 3';
                Editable = false;
                BlankZero = false;
                CaptionClass = Rec.GetFieldCaptionClass(Rec.FieldNo(ACO_BalanceCurrency3));

                trigger OnDrillDown();
                begin
                    GetAdditionalSetup();
                    Rec.OpenCurrVendorLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency3, Today);
                end;
            }
            field(ACO_LastCurrencyDataUpdateDate; Rec.ACO_LastCurrencyDataUpdateDate)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY)';
                Editable = false;
            }
            field(ACO_LastCurrencyDataUpdateTime; Rec.ACO_LastCurrencyDataUpdateTime)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY)';
                Editable = false;
            }
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
    }

    actions
    {
        //>>2.2.0.2018
        addlast(Processing)
        {
            action(RecalculateCurrencyData)
            {
                ApplicationArea = All;
                Caption = 'Recalculate Currency Data';
                ToolTip = 'Routine updates values in fields like: Active Exchange Rate TCY, Credit Limit TCY, Balnace Currency 1,2,3';
                Image = Recalculate;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    VendRec: record Vendor;
                    RecalcVendCurrencyData: Report ACO_RecalcVendCurrencyData;
                begin
                    VendRec.SetRange("No.", Rec."No.");

                    RecalcVendCurrencyData.SetTableView(VendRec);
                    RecalcVendCurrencyData.RunModal();

                    CurrPage.Update(true);
                end;
            }
        }
        //<<2.2.0.2018
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


