namespace Acora.AvTrade.MainApp;

using Microsoft.Sales.Customer;

table 50100 "ACO_ImportBuffer"
{
    //#region "Documentation"
    // DO NOT USE THIS TABLE AS IT IS NO LONGER IN USE!!!!
    //
    //
    //
    //1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    //                          - This table is used as a temp table for importing Invoices and Credits;
    //2.2.7.2018 LBR 24/10/2019 - Snagging New document Date added;
    //#endregion "Documentation"

    Caption = 'Import Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "ACO_EntryNo"; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(30; "ACO_DocumentNo"; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(40; "ACO_CustomerNo"; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }
        field(50; "ACO_ExternalDocumentNo"; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = ToBeClassified;
        }
        field(60; "ACO_NormCode"; Code[20])
        {
            Caption = 'Norm Code';
            DataClassification = ToBeClassified;
        }
        field(70; "ACO_TaxCode"; Code[10])
        {
            Caption = 'Tax Code';
            DataClassification = ToBeClassified;
        }
        field(80; "ACO_PostingDate"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        //>>2.2.7.2018
        field(85; "ACO_DocumentDate"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        //<<2.2.7.2018
        field(90; "ACO_ProductNo"; Code[20])
        {
            Caption = 'Product No.';
            DataClassification = ToBeClassified;
        }
        field(95; "ACO_Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(100; "ACO_UnitPrice"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
        }
        field(110; "ACO_CurrencyCode"; Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; ACO_EntryNo)
        {
            Clustered = true;
        }
        key(FK1; ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode)
        {
        }
    }


}