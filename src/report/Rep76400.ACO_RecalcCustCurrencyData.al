namespace Acora.AvTrade.MainApp;

using Microsoft.Finance.Currency;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using System.DateTime;

report 50400 "ACO_RecalcCustCurrencyData"
{
    //#region "Documentation"
    // 1.2.0.2018 LBR 13/06/2019 - New object created for NAV to Excel export (Init Spec point 3.3)
    //#endregion "Documentation"

    Caption = 'Recalculate Customer Currency Data';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnPreDataItem();
            var
                GeneralFunctions: Codeunit ACO_GeneralFunctions;
            begin
                GeneralFunctions.RecalculateCustomerCurrencyData(Customer, Today);
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

