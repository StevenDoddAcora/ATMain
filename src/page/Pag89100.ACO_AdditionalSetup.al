namespace Acora.AvTrade.MainApp;

using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;

page 50206 "ACO_AdditionalSetup"
{

    //#region "Documentation"
    //>>FRAMEWORK - This page is acting as skeleton for Framework "Additional Setup" page
    //#endregion "Documentation"

    PageType = Card;
    SourceTable = ACO_AdditionalSetup;
    Caption = 'Additional Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(General)
            {
                //>>FRAMEWORK - GENERAL GROUP FOR ADDITIONAL SETUP               
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}
