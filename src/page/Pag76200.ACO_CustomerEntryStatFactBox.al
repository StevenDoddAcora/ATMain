page 50200 "ACO_CustomerEntryStatFactBox"
{
    //#region Documentation
    // 2.0.0.2018 LBR 13/06/2019 - Customer - Average Collection Period (point 3.4.2), New object created;
    // 3.0.2.2018 LBR 28/01/2020 - Corrected issue related to the Average Calculate Period
    //#endregion Documentation

    Caption = 'Customer Entry Statistics FactBox';
    PageType = CardPart;
    SourceTable = Customer;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(ACO_Data)
            {
                Caption = 'Avg. Collection Period (Days)';
                field(ACO_ThisPeriod; AvgDaysToPay[1])
                {
                    Caption = 'This Period';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ACO_ThisYear; AvgDaysToPay[2])
                {
                    Caption = 'This Year';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(ACO_LastYear; AvgDaysToPay[3])
                {
                    Caption = 'Last Year';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    var
        GeneralFunctions: codeunit ACO_GeneralFunctions;
        AdditionalSetup: Record ACO_AdditionalSetup;
    begin
        //>>3.0.2.2018
        //GeneralFunctions.CalculateCustomerAvgDaysToPay(Rec, AvgDaysToPay, AdditionalSetup.ACO_AvgCollectionPeriodCalc::Month, WorkDate);
        IF NOT AdditionalSetup.GET() then
            AdditionalSetup.INIT();
        GeneralFunctions.CalculateCustomerAvgDaysToPay(Rec, AvgDaysToPay, AdditionalSetup.ACO_AvgCollectionPeriodCalc, WorkDate);
        //<<3.0.2.2018
    end;

    var
        AvgDaysToPay: array[3] of Decimal;
}