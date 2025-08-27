namespace Acora.AvTrade.MainApp;

using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;

pageextension 50319 "ACO_PurchInvoice" extends "Purchase Invoice"
{
    //#region "Documentation"
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New fields added;
    //#endregion "Documentation"

    layout
    {
        addlast(General)
        {
            field(ACO_DisputeCode; Rec.ACO_DisputeCode)
            {
                ApplicationArea = All;
                trigger OnValidate();
                begin
                    Rec.CalcFields(ACO_DisputeName);
                end;
            }
            field(ACO_DisputeName; Rec.ACO_DisputeName)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
    }
}

