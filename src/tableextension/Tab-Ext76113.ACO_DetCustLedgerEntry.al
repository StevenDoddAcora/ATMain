namespace Acora.AvTrade.MainApp;

using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Receivables;

tableextension 50113 "ACO_DetCustLedgerEntry" extends "Detailed Cust. Ledg. Entry"
{

    //#region "Documentation"
    //2.3.0.2018 LBR 15/11/2019 - CHG003375 (New fields to some tables Vendor/Cust/Ledg/Det)
    //#endregion "Documentation"

    fields
    {
        //>>2.3.0.2018
        field(50010; ACO_DocumentDate; Date)
        {
            Caption = 'Document Date';
            FieldClass = FlowField;
            CalcFormula = Lookup("Cust. Ledger Entry"."Document Date" WHERE("Entry No." = FIELD("Cust. Ledger Entry No.")));
        }
        //<<2.3.0.2018
    }

    //#region "Table Functions"
    // Nothing in here so far
    //#endregion "Table Functions"

}