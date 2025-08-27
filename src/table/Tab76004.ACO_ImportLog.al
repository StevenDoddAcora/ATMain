namespace Acora.AvTrade.MainApp;

using Microsoft.Sales.Customer;
using System.DateTime;

table 50104 "ACO_ImportLog"
{
    //#region "Documentation"
    //2.2.3.2018 LBR 13/09/2019 - CHG003321 (Import Log) Import Data Validation table for error log (additiona scope forInitial Spec point 3.2);    
    //2.2.7.2018 LBR 24/10/2019 - Snagging New document Date added;
    //#endregion "Documentation"

    Caption = 'Import Log';
    DataClassification = CustomerContent;

    fields
    {
        field(2; "ACO_ImportType"; Option)
        {
            Caption = 'Import Type';
            OptionMembers = "","Invoice","Credit";
            OptionCaption = ' ,Invoice,Credit';
            DataClassification = ToBeClassified;
        }
        field(4; "ACO_ImportNo"; Integer)
        {
            Caption = 'Import No.';
            DataClassification = ToBeClassified;
        }
        field(10; "ACO_EntryNo"; Integer)
        {
            Caption = 'Entry/Line No.';
            DataClassification = ToBeClassified;
        }
        field(15; "ACO_FileLineNo"; Integer)
        {
            Caption = 'File Line No.';
            DataClassification = ToBeClassified;
            Description = 'This field is one to one with the imported file. Helps find line in imported file';
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
        field(2000; "ACO_FileName"; Text[100])
        {
            Caption = 'File Name';
            DataClassification = ToBeClassified;
        }
        field(2010; "ACO_ImportDate"; Date)
        {
            Caption = 'Import Date';
            DataClassification = ToBeClassified;
        }
        field(2020; "ACO_ImportTime"; Time)
        {
            Caption = 'Import Time';
            DataClassification = ToBeClassified;
        }
        field(2090; "ACO_Error"; Boolean)
        {
            Caption = 'Error';
            DataClassification = ToBeClassified;
        }
        field(2100; "ACO_ErrorDescription"; Text[250])
        {
            Caption = 'Error Description';
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                ACO_Error := (ACO_ErrorDescription <> '');
            end;
        }
    }

    keys
    {
        key(PK; ACO_ImportType, ACO_ImportNo, ACO_EntryNo)
        {
            Clustered = true;
        }
        key(FK1; ACO_FileName, ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode)
        {
            ObsoleteState = Pending;
        }
        key(FK2; ACO_ImportNo, ACO_ImportTime)
        {
            ObsoleteState = Pending;
        }
        key(FK3; ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode, ACO_Error)
        {
        }
        key(FK4; ACO_ImportDate, ACO_ImportTime)
        {
        }
    }

}