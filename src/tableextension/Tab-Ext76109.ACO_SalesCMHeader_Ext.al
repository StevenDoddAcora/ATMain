namespace Acora.AvTrade.MainApp;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;

tableextension 50109 "ACO_SalesCMHeader_Ext" extends "Sales Cr.Memo Header"
{
    //#region "Documentation"
    //2.2.3.2018 LBR 13/09/2019 - CHG003321 (Import Log) Import Data Validation table for error log (additiona scope forInitial Spec point 3.2);    
    //#endregion "Documentation"

    fields
    {
        field(50000; "ACO_ImportNo"; Integer)
        {
            Caption = 'Import No.';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(ACO_FK1; ACO_ImportNo)
        {

        }
    }

}