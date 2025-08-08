pageextension 50302 "ACO_AddtionalSetup" extends ACO_AdditionalSetup
{
    //#region Documentation
    // 1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    // 1.2.0.2018 LBR 13/06/2019 - New fields added for NAV to Excel export (Init Spec point 3.3)
    // 2.0.0.2018 LBR 13/06/2019 - Customer - Average Collection Period (point 3.4.2), New field added;
    // 2.2.0.2018 LBR 14/08/2019 - fields have been moved from the export location to general group
    // 2.2.3.2018 LBR 18/09/2019 - CHG003321 (Import Log) New field addd for Import no. and round to zero 
    // 2.2.5.2018 LBR 15/10/2019 - CHG003334 (BAC's Export file selection). New field added
    //#endregion Documentation

    layout
    {
        addlast(content)
        {
            group(ACO_General)
            {
                Caption = 'General';
                Visible = true;

                //>>2.0.0.2018
                field(ACO_AvgCollectionPeriodCalc; ACO_AvgCollectionPeriodCalc)
                {
                    ApplicationArea = All;
                    ToolTip = 'It indicates how the Customer Average Days to Pay will be calculated';
                }
                //<<2.0.0.2018

                //>>2.2.0.2018
                field(ACO_CustomerReportCurrency1; ACO_CustomerReportCurrency1)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the currency code which will be used for the Customer/Vendor Balance 1 calculation';
                }
                field(ACO_CustomerReportCurrency2; ACO_CustomerReportCurrency2)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the currency code which will be used for the Customer/Vendor Balance 2 calculation';
                }
                field(ACO_CustomerReportCurrency3; ACO_CustomerReportCurrency3)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the currency code which will be used for the Customer/Vendor Balance 3 calculation';
                }
                //<<2.2.0.2018
                //>>2.2.5.2018
                field(ACO_PaymentRefSeriesNo; "ACO_PaymentRefSeriesNo")
                {
                    Caption = 'Payment Reference Series No.';
                    ApplicationArea = All;
                    ToolTip = 'The series no is used during payment journal line creation to define next number for Payment Refernece';
                }
                //<<2.2.5.2018
            }
            group(QuantumImportGroup)
            {
                Caption = 'Quantum Import';
                Visible = true;

                Group(ACO_ExposureGroup)
                {
                    caption = 'Exposure';
                    field(ACO_ExposureFileSource; ACO_ExposureFileSource)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the File location to be used when importing exposure Files (Quantum to NAV)';
                        Width = 30;
                    }
                    field(ACO_ExposureFileProcessed; ACO_ExposureFileProcessed)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the File location to be used for archive imported exposure Files (Quantum to NAV)';
                        Width = 30;
                    }
                }

                Group(ACO_InvoiceGroup)
                {
                    caption = 'Invoice';
                    field(ACO_InvoiceFileSource; ACO_InvoiceFileSource)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the File location to be used when importing Invoice Files (Quantum to NAV)';
                        Width = 30;
                    }
                    field(ACO_InvoiceFileProcessed; ACO_InvoiceFileProcessed)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the File location to be used for archive imported Invoice Files (Quantum to NAV)';
                        Width = 30;
                    }
                    field(ACO_ImportedInvoicePostedSeriesNo; ACO_ImportedInvoicePostedSeriesNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'The series no is used for the posting purose and it should be configured as manual numbers only';
                    }
                    field(ACO_AutoPostInvoiceFile; ACO_AutoPostInvoiceFile)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies if the created invoice documents should be autoposted.';
                    }
                    field(ACO_DefaultZeroLineItemNo; ACO_DefaultZeroLineItemNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Used to determine the default Item No. to be used for Zero Invoice Line imports if a different Item No.is not defined on the customer record';
                    }
                    //>>2.2.3.2018
                    field(ACO_UnitPriceRoundToZeroTol; ACO_UnitPriceRoundToZeroTol)
                    {
                        ApplicationArea = All;
                        ToolTip = 'If during Invoice import the unit price is in below (+-) Unit Price Round to 0 Tolerance the system will round the value to 0';
                    }
                    field(ACO_LastInvoiceImportNo; ACO_LastInvoiceImportNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the last imported file No for Invoice Import';
                        Editable = false;
                    }
                    //<<2.2.3.2018
                }
                Group(ACO_CreditGroup)
                {
                    caption = 'Credit';
                    field(ACO_CreditFileSource; ACO_CreditFileSource)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the File location to be used when importing Credit Files (Quantum to NAV)';
                        Width = 30;
                    }
                    field(ACO_CreditFileProcessed; ACO_CreditFileProcessed)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the File location to be used for archive imported Credit Files (Quantum to NAV)';
                        Width = 30;
                    }
                    field(ACO_ImportedCreditPostedSeriesNo; ACO_ImportedCreditPostedSeriesNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'The series no is used for the posting purose and it should be configured as manual numbers only';
                    }
                    field(ACO_AutoPostCreditFile; ACO_AutoPostCreditFile)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies if the created credit documents should be autoposted.';
                    }
                    //>>2.2.3.2018
                    field(ACO_LastCreditImportNo; ACO_LastCreditImportNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'It specifies the last imported file No for Credit Import';
                        Editable = false;
                    }
                    //<<2.2.3.2018
                }
            }
            group(QuantumExportGroup)
            {
                Caption = 'Quantum Export';
                Visible = true;
                //>>1.2.0.2018
                field(ACO_QuantumExportLocation; ACO_QuantumExportLocation)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the file location to be used for exporting Quantum files (NAV to Quantum)';
                    Width = 30;
                }
                field(ACO_ExportCurrency; ACO_ExportCurrency)
                {
                    ApplicationArea = All;
                    ToolTip = 'It specifies the currency code the Quantum export should used for the values exported (NAV to Quantum)';
                }
                //<<1.2.0.2018
            }
        }
    }

    actions
    {
        addlast(Creation)
        {
            //////////////////// INIT TEST DATA /////////////////////
            action(CreateTestData)
            {
                ApplicationArea = All;
                Caption = 'Recrate Configuration (TEST)';
                ToolTip = 'It should be NEVER used on LIVE database. ';
                Image = Recalculate;

                trigger OnAction();
                var
                    confirmMsg: Label 'Do you want to recreate bespoke configuration? THIS OPERATION CANNOT BE UNDO!';
                begin
                    if not Confirm(confirmMsg, false) then
                        Error('');

                    RecreateTESTData();

                    CurrPage.Update(true);
                end;
            }
        }
    }

    local procedure RecreateTESTData();
    var
        AdditionalSetup: Record ACO_AdditionalSetup;
    begin
        //Additional Setup
        if not AdditionalSetup.get() then begin
            AdditionalSetup.init();
        end;

        AdditionalSetup.ACO_ExposureFileSource := 'C:\tmp\Avtrade\Import\Exposure';
        AdditionalSetup.ACO_ExposureFileProcessed := 'C:\tmp\Avtrade\Import\Exposure\Archive';
        AdditionalSetup.ACO_InvoiceFileSource := 'C:\tmp\Avtrade\Import\Invoice';
        AdditionalSetup.ACO_InvoiceFileProcessed := 'C:\tmp\Avtrade\Import\Invoice\Archive';
        AdditionalSetup.ACO_ImportedInvoicePostedSeriesNo := 'S-INV-LBR';
        AdditionalSetup.ACO_CreditFileSource := 'C:\tmp\Avtrade\Import\Credit';
        AdditionalSetup.ACO_CreditFileProcessed := 'C:\tmp\Avtrade\Import\Credit\Archive';
        AdditionalSetup.ACO_ImportedCreditPostedSeriesNo := 'S-CM-LBR';
        AdditionalSetup.ACO_ExportCurrency := 'EUR';
        AdditionalSetup.ACO_CustomerReportCurrency1 := 'GBP';
        AdditionalSetup.ACO_CustomerReportCurrency2 := 'USD';
        AdditionalSetup.ACO_CustomerReportCurrency3 := 'EUR';
        AdditionalSetup.ACO_QuantumExportLocation := 'C:\tmp\Avtrade\Export';
        if not AdditionalSetup.Insert() then AdditionalSetup.Modify();


        //Any other init data for testing here:
    end;
}

