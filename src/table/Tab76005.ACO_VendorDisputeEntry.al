table 50105 "ACO_VendorDisputeEntry"
{
    //#region "Documentation"
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New object created
    //#endregion "Documentation"

    DataClassification = ToBeClassified;
    Caption = 'Dispute Audit Trail Entry';
    LookupPageId = ACO_VendorDisputeEntries;
    DrillDownPageId = ACO_VendorDisputeEntries;

    fields
    {
        field(10; "ACO_EntryNo"; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(20; "ACO_VendorNo"; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(30; "ACO_VendorName"; Text[50])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(40; "ACO_VendorLedgerEntryNo"; Integer)
        {
            Caption = 'Vendor Ledger Entry No.';
            DataClassification = CustomerContent;
        }
        field(50; "ACO_DocumentType"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ","Payment","Invoice","Credit Memo","Finance Charge Memo","Reminder","Refund";
            DataClassification = CustomerContent;
        }
        field(60; "ACO_DocumentNo"; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(70; "ACO_PostingDate"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(80; "ACO_DocumentDate"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(90; "ACO_ExteranlDocNo"; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(100; "ACO_Amount"; Decimal)
        {
            Caption = 'Amount';
            //DataClassification = CustomerContent;
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Ledger Entry Amount" = CONST(true), "Vendor Ledger Entry No." = FIELD(ACO_VendorLedgerEntryNo)));
        }
        field(110; "ACO_CurrencyCode"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(120; "ACO_UserID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(130; "ACO_UserName"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(140; "ACO_CreationDate"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(145; "ACO_CreationTime"; Time)
        {
            Caption = 'Creation Time';
            DataClassification = CustomerContent;
        }
        field(150; "ACO_OldDisputeCode"; Code[10])
        {
            Caption = 'Old Dispute Code';
            DataClassification = CustomerContent;
        }
        field(160; ACO_OldDisputeName; text[50])
        {
            Caption = 'Old Dispute Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(ACO_DisputeCode.ACO_Description WHERE(ACO_Code = FIELD(ACO_OldDisputeCode)));
        }
        field(170; "ACO_NewDisputeCode"; Code[10])
        {
            Caption = 'New Dispute Code';
            DataClassification = CustomerContent;
        }
        field(180; ACO_NewDisputeName; text[50])
        {
            Caption = 'New Dispute Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(ACO_DisputeCode.ACO_Description WHERE(ACO_Code = FIELD(ACO_NewDisputeCode)));
        }
        /*
        //TODO Ask James if this field should be in use - no info in spec about it        
        field(170;"ACO_MsgToRecipient"; Text[100])
        {
            Caption = 'Message to Recipient';
            Description = 'Currently this field is not in use';
            DataClassification = CustomerContent;
        }
        */
    }

    keys
    {
        key(PK; "ACO_EntryNo")
        {
            Clustered = true;
        }
    }

}