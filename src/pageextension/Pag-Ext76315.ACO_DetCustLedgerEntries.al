namespace Acora.AvTrade.MainApp;

using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Receivables;

pageextension 50315 "ACO_DetCustLedgerEntries" extends "Detailed Cust. Ledg. Entries"
{
    //#region "Documentation"
    //2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    layout
    {
        addafter("Posting Date")
        {
            //>>2.3.0.2018
            field(ACO_DocumentDate; Rec.ACO_DocumentDate)
            {
                Visible = true;
                Editable = false;
            }
            //<<2.3.0.2018
        }
    }

    actions
    {
        // Nothing in here yet
    }
}

