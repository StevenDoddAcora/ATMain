pageextension 50312 "ACO_VendorCard" extends "Vendor Card"
{
    //#region "Documentation"
    // 2.2.0.2018 LBR 14/08/2019 - Vendor Balance and Credit Limit Fields (point 3.9.7)
    // 2.2.2.2018 LBR 12/09/2019 - TCY Credit Limit should be editable and update Credit Limit (LCY) instead;
    // 2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    layout
    {
        addlast(General)
        {
            //>>2.2.0.2018
            field(ACO_CreditLimitLCY; ACO_CreditLimitLCY)
            {
                ApplicationArea = All;
                Editable = false;
                BlankZero = false;
            }
            field(ACO_ActiveExchangeRateTCY; ACO_ActiveExchangeRateTCY)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the active exchange rate for the default Trading Currency at the Last Update Date';
                Editable = true;
                BlankZero = false;
            }
            field(ACO_CreditLimitTCY; ACO_CreditLimitTCY)
            {
                ApplicationArea = All;
                //>>2.2.2.2018
                ToolTip = 'The Credit Limit (LCY) field is calculated based on this field, whenever the value is updated by the user';
                Editable = true;
                //<<2.2.2.2018
                BlankZero = false;
            }
            field(ACO_BalanceCurrency1; ACO_BalanceCurrency1)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Vendor Ledger Entries where Currency field is Customer/Vendor Report Currency 1';
                Editable = false;
                BlankZero = false;
                CaptionClass = GetFieldCaptionClass(FieldNo(ACO_BalanceCurrency1));

                trigger OnDrillDown();
                begin
                    GetGenrealLegerSetup();
                    OpenCurrVendorLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency1, Today);
                end;
            }
            field(ACO_BalanceCurrency2; ACO_BalanceCurrency2)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Vendor Ledger Entries where Currency field is Customer/Vendor Report Currency 2';
                Editable = false;
                BlankZero = false;
                CaptionClass = GetFieldCaptionClass(FieldNo(ACO_BalanceCurrency2));

                trigger OnDrillDown();
                begin
                    GetAdditionalSetup();
                    OpenCurrVendorLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency2, Today);
                end;
            }
            field(ACO_BalanceCurrency3; ACO_BalanceCurrency3)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. The calculation formula is as follow: SUM of Remaining Amount of the open Vendor Ledger Entries where Currency field is Customer/Vendor Report Currency 3';
                Editable = false;
                BlankZero = false;
                CaptionClass = GetFieldCaptionClass(FieldNo(ACO_BalanceCurrency3));

                trigger OnDrillDown();
                begin
                    GetAdditionalSetup();
                    OpenCurrVendorLedgerEntries(AdditionalSetup.ACO_CustomerReportCurrency3, Today);
                end;
            }
            field(ACO_LastCurrencyDataUpdateDate; ACO_LastCurrencyDataUpdateDate)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY,ECY)';
                Editable = false;
            }
            field(ACO_LastCurrencyDataUpdateTime; ACO_LastCurrencyDataUpdateTime)
            {
                ApplicationArea = All;
                ToolTip = 'Field value is updated by the update routine. Shows the last update date when the currency data has been recalculated (i.e. Balance GBP,USD,EUR,TCY,ECY)';
                Editable = false;
            }
            //<<2.2.0.2018
        }

        addafter("Country/Region Code")
        {
            //>>2.3.0.2018
            field(ACO_CountryRegionName; ACO_CountryRegionName)
            {
                Visible = true;
                Editable = false;
            }
            //<<2.3.0.2018
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
                ToolTip = 'Routine updates values in fields like: Active Exchange Rate TCY, Credit Limit TCY, Balance Currency 1,2,3';
                Image = Recalculate;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    VendorRec: record Vendor;
                    RecalcVendCurrencyData: Report ACO_RecalcVendCurrencyData;
                begin
                    VendorRec.SETRANGE("No.", "No.");

                    RecalcVendCurrencyData.SetTableView(VendorRec);
                    RecalcVendCurrencyData.RunModal();

                    CurrPage.Update(true);
                end;
            }
        }
        //<<1.2.0.2018
    }

    trigger OnAfterGetCurrRecord();
    begin
        //>>2.2.0.2018
        GetAdditionalSetup();
        //<<2.2.0.2018
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";
        AdditionalSetup: Record "ACO_AdditionalSetup";
        GeneralFunctions: Codeunit ACO_GeneralFunctions;

    //>>2.2.0.2018
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
    //<<2.2.0.2018
}