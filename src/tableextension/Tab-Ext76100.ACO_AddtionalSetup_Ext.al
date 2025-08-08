tableextension 50100 "ACO_AddtionalSetup_Ext" extends ACO_AdditionalSetup //Acora Framework table
{
    //#region "Documentation"
    // 1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    // 1.2.0.2018 LBR 13/06/2019 - New fields added for NAV to Excel export (Init Spec point 3.3)
    // 1.3.0.2018 LBR 13/06/2019 - Customer - Average Collection Period (point 3.4.2), New field added; 
    // 2.2.3.2018 LBR 18/09/2019 - CHG003321 (Import Log) New field addd for Import no. and round to zero 
    // 2.2.5.2018 LBR 15/10/2019 - CHG003334 (BAC's Export file selection). New field added;
    //#endregion "Documentation"

    fields
    {
        field(50100; "ACO_ExposureFileSource"; Text[250])
        {
            Caption = 'Exposure File Source';
            DataClassification = CustomerContent;
            Description = 'It specifies the File location to be used when importing exposure Files (Quantum to NAV)';
            Editable = true;
        }
        field(50110; "ACO_ExposureFileProcessed"; Text[250])
        {
            Caption = 'Exposure File Processed';
            DataClassification = CustomerContent;
            Description = 'It specifies the File location to be used for archive imported exposure Files (Quantum to NAV)';
            Editable = true;
        }
        //>>2.2.3.2018
        field(50115; ACO_LastInvoiceImportNo; Integer)
        {
            Caption = 'Last Invoice Import No.';
            DataClassification = CustomerContent;
            Description = 'It specifies the last imported file No for Invoice Import';
            Editable = true;
        }
        //<<2.2.3.2018
        field(50120; "ACO_InvoiceFileSource"; Text[250])
        {
            Caption = 'Invoice File Source';
            DataClassification = CustomerContent;
            Description = 'It specifies the File location to be used when importing Invoice Files (Quantum to NAV)';
            Editable = true;
        }
        field(50130; "ACO_InvoiceFileProcessed"; Text[250])
        {
            Caption = 'Invoice File Processed';
            DataClassification = CustomerContent;
            Description = 'It specifies the File location to be used for archive imported Invoice Files (Quantum to NAV)';
            Editable = true;
        }
        field(50135; "ACO_AutoPostInvoiceFile"; Boolean)
        {
            Caption = 'Auto-Post Invoice File';
            DataClassification = CustomerContent;
            Description = 'It specifies if the created invoice documents should be autoposted.';
            Editable = true;
        }
        //>>2.2.3.2018
        field(50137; ACO_LastCreditImportNo; Integer)
        {
            Caption = 'Last Credit Import No.';
            DataClassification = CustomerContent;
            Description = 'It specifies the last imported file No for Credit';
            Editable = true;
        }
        //<<2.2.3.2018
        field(50140; "ACO_CreditFileSource"; Text[250])
        {
            Caption = 'Credit File Source';
            DataClassification = CustomerContent;
            Description = 'It specifies the File location to be used when importing Credit Files (Quantum to NAV)';
            Editable = true;
        }
        field(50150; "ACO_CreditFileProcessed"; Text[250])
        {
            Caption = 'Credit File Processed';
            DataClassification = CustomerContent;
            Description = 'It specifies the File location to be used for archive imported Credit Files (Quantum to NAV)';
            Editable = true;
        }
        field(50155; "ACO_AutoPostCreditFile"; Boolean)
        {
            Caption = 'Auto-Post Credit File';
            DataClassification = CustomerContent;
            Description = 'It specifies if the created credit documents should be autoposted.';
            Editable = true;
        }
        field(50160; "ACO_DefaultZeroLineItemNo"; Code[20])
        {
            Caption = 'Default Zero Line Item No.';
            DataClassification = CustomerContent;
            Description = 'Used to determine the default Item No. to be used for Zero Invoice Line imports if a different Item No.is not defined on the customer record';
            TableRelation = Item."No.";
            Editable = true;
        }
        field(50180; "ACO_ImportedInvoicePostedSeriesNo"; Code[20])
        {
            Caption = 'Imported Inv. Posted Series No.';
            DataClassification = CustomerContent;
            Description = 'The series no is used for the posting purpose and it should be configured as manual numbers only';
            TableRelation = "No. Series".Code;
            Editable = true;
        }
        field(50200; "ACO_ImportedCreditPostedSeriesNo"; Code[20])
        {
            Caption = 'Imported Credit Posted Series No.';
            DataClassification = CustomerContent;
            Description = 'The series no is used for the posting purose and it should be configured as manual numbers only';
            TableRelation = "No. Series".Code;
            Editable = true;
        }
        //>>2.2.3.2018
        field(50205; "ACO_UnitPriceRoundToZeroTol"; Decimal)
        {
            Caption = 'Unit Price Round to 0 Tolerance';
            Description = 'If during Invoice import the unit price is in below (+-) Unit Price Round to 0 Tolerance the system will round the value to 0';
            MinValue = 0;
        }
        //<<2.2.3.2018

        //>>1.2.0.2018
        field(50210; "ACO_QuantumExportLocation"; Text[250])
        {
            Caption = 'Quantum Export Location';
            DataClassification = CustomerContent;
            Description = 'It specifies the file location to be used for exporting Quantum files (NAV to Quantum)';
            Editable = true;
        }
        field(50220; "ACO_ExportCurrency"; Code[20])
        {
            Caption = 'Quantum Export Currency';
            DataClassification = CustomerContent;
            TableRelation = Currency.code;
            Description = 'It specifies the currency code the Quantum export should use for the values exported (NAV to Quantum)';
            Editable = true;
        }
        field(50230; "ACO_CustomerReportCurrency1"; Code[20])
        {
            Caption = 'Customer/Vendor Report Currency 1';
            DataClassification = CustomerContent;
            TableRelation = Currency.code;
            Description = 'It specifies the currency code which will be used for the Customer/Vendor Balance 1 calculation on the Customer/Vendor Card.';
            Editable = true;
        }
        field(50240; "ACO_CustomerReportCurrency2"; Code[20])
        {
            Caption = 'Customer/Vendor Report Currency 2';
            DataClassification = CustomerContent;
            TableRelation = Currency.code;
            Description = 'It specifies the currency code which will be used for the Customer/Vendor Balance 2 calculation on the Customer/Vendor Card.';
            Editable = true;
        }
        field(50250; "ACO_CustomerReportCurrency3"; Code[20])
        {
            Caption = 'Customer/Vendor Report Currency 3';
            DataClassification = CustomerContent;
            TableRelation = Currency.code;
            Description = 'It specifies the currency code which will be used for the Customer/Vendor Balance 3 calculation on the Customer/Vendor Card.';
            Editable = true;
        }
        //<<1.2.0.2018
        //>>2.0.0.2018
        field(50260; "ACO_AvgCollectionPeriodCalc"; Option)
        {
            Caption = 'Avg. Collection Period Calc.';
            OptionMembers = "Month","Quarter","Year","YTD";
            OptionCaption = 'Month,Quarter,Year,YTD';
            DataClassification = CustomerContent;
            Description = 'It indicates how the Customer Average Days to Pay will be calculated';
            Editable = true;
        }
        //<<2.0.0.2018

        //>>2.2.5.2018
        field(50270; "ACO_PaymentRefSeriesNo"; Code[20])
        {
            Caption = 'Payment Reference Series No.';
            DataClassification = CustomerContent;
            Description = 'The series no is used during payment journal line creation to define next number for Payment Refernece';
            TableRelation = "No. Series".Code;
            Editable = true;
        }
        //<<2.2.5.2018
    }

    //#region "Table Functions"

    //#endregion "Table Functions"
}