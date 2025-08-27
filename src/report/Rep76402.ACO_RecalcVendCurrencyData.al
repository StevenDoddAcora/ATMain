namespace Acora.AvTrade.MainApp;

using Microsoft.Finance.Currency;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using System.DateTime;

report 50402 "ACO_RecalcVendCurrencyData"
{
    //#region "Documentation"
    // 2.2.0.2018 LBR 14/08/2019 - Vendor Balance and Credit Limit Fields (point 3.9.7)
    //#endregion "Documentation"

    Caption = 'Recalculate Vendor Currency Data';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnPreDataItem();
            var
                GeneralFunctions: Codeunit ACO_GeneralFunctions;
            begin
                GeneralFunctions.RecalculateVendorCurrencyData(Vendor, Today);
                CurrReport.Break();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

