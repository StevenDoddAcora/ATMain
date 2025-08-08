tableextension 50108 "ACO_SalesInvLine_Ext" extends "Sales Invoice Line"
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
        field(50010; "ACO_ImportEntryNo"; Integer)
        {
            Caption = 'Import Entry/Line No.';
            DataClassification = ToBeClassified;
        }

    }

}