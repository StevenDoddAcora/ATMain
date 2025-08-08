codeunit 50603 "ACO_DisputeManagement"
{
    //#region "Documentation"
    //ABS001 - PMC 01/08/2019 - Function "InsertDisputeComment" created to generate the required Comment related to "Dispute Code" within the document related to a Customer Ledger Entry or/and Vendor Ledger Entry
    //      - To meet intial specification requirement  03.09.03 the following changes have been introduced:
    //3.1.0.2018 LBR 20/02/2020 - CHG003406 (Vendor Entry Query Audit Trail for Dispute Codes) - New permissions added, new functions and posting logic;
    //#endregion "Documentation"

    Permissions = TableData "Purch. Inv. Header" = rm, TableData "Purch. Cr. Memo Hdr." = rm;

    //>> 
    // Issue fix for not modifing record
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure UpdateDisputeCodeOnBeforeCustLedgEntryModify(VAR CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.ACO_DisputeCode := FromCustLedgEntry.ACO_DisputeCode;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vend. Entry-Edit", 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure UpdateDisputeCodeOnBeforeVendLedgEntryModify(VAR VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        //>>3.1.0.2018
        // Update Audit Log    
        VendLedgEntry.CalcFields(Amount);
        TryInsertVendorDisputeEntry(VendLedgEntry, VendLedgEntry.Amount, VendLedgEntry.ACO_DisputeCode, FromVendLedgEntry.ACO_DisputeCode);
        //<<3.1.0.2018

        VendLedgEntry.ACO_DisputeCode := FromVendLedgEntry.ACO_DisputeCode;
    end;
    //<<

    //>>3.1.0.2018
    local procedure TryInsertVendorDisputeEntry(VAR VendLedgEntry: Record "Vendor Ledger Entry"; Amt: Decimal; oldDisputeCode: Code[20]; newDisputeCode: Code[20]);
    var
        DisputeCode: Record ACO_DisputeCode;
        VendDisputeEntry: Record ACO_VendorDisputeEntry;
        EntryNo: Integer;
        Vendor: Record Vendor;
    begin
        if (oldDisputeCode = newDisputeCode) then
            exit;

        EntryNo := 0;
        if VendDisputeEntry.FindLast() then begin
            VendDisputeEntry.LockTable();
            EntryNo := VendDisputeEntry.ACO_EntryNo;
        end;

        EntryNo += 1;

        Vendor.get(VendLedgEntry."Vendor No.");

        VendDisputeEntry.Init();
        VendDisputeEntry.ACO_EntryNo := EntryNo;
        VendDisputeEntry.ACO_VendorNo := Vendor."No.";
        VendDisputeEntry.ACO_VendorName := Vendor.Name;
        VendDisputeEntry.ACO_VendorLedgerEntryNo := VendLedgEntry."Entry No.";
        VendDisputeEntry.ACO_DocumentType := VendLedgEntry."Document Type";
        VendDisputeEntry.ACO_DocumentNo := VendLedgEntry."Document No.";
        VendDisputeEntry.ACO_PostingDate := VendLedgEntry."Posting Date";
        VendDisputeEntry.ACO_DocumentDate := VendLedgEntry."Document Date";
        VendDisputeEntry.ACO_ExteranlDocNo := VendLedgEntry."External Document No.";
        //VendLedgEntry.calcfields(Amount);
        VendDisputeEntry.ACO_Amount := Amt;//VendLedgEntry.Amount;
        VendDisputeEntry.ACO_CurrencyCode := VendLedgEntry."Currency Code";
        VendDisputeEntry.ACO_UserID := Database.UserId;
        VendDisputeEntry.ACO_UserName := Database.UserId;
        VendDisputeEntry.ACO_CreationDate := TODAY;
        VendDisputeEntry.ACO_CreationTime := TIME;
        VendDisputeEntry.ACO_OldDisputeCode := oldDisputeCode;
        VendDisputeEntry.ACO_NewDisputeCode := newDisputeCode;
        VendDisputeEntry.Insert(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure ProceedOnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine.VALIDATE(ACO_DisputeCode, PurchaseHeader.ACO_DisputeCode);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure ProceedOnAfterCopyVendLedgerEntryFromGenJnlLine(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry.ACO_DisputeCode := GenJournalLine.ACO_DisputeCode;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer', '', false, false)]
    local procedure ProceedOnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
        // Insert Audit Log    
        TryInsertVendorDisputeEntry(VendorLedgerEntry, CVLedgerEntryBuffer.Amount, '', VendorLedgerEntry.ACO_DisputeCode);
    end;


    procedure UpdDocumentDisputeCode(TableID: Integer; EntryNo: Integer; Dispute: Record ACO_DisputeCode)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHdr: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        case TableID of
            Database::"Cust. Ledger Entry":
                begin
                    // Currently not requested
                end;
            Database::"Vendor Ledger Entry":
                begin
                    if VendLedgerEntry.get(EntryNo) then begin
                        if VendLedgerEntry."Document Type" = VendLedgerEntry."Document Type"::Invoice then begin
                            if PurchInvHdr.get(VendLedgerEntry."Document No.") then begin
                                PurchInvHdr.ACO_DisputeCode := VendLedgerEntry.ACO_DisputeCode;
                                PurchInvHdr.Modify();
                                exit;
                            end;
                        end;

                        if VendLedgerEntry."Document Type" = VendLedgerEntry."Document Type"::"Credit Memo" then begin
                            if PurchCrMemoHdr.get(VendLedgerEntry."Document No.") then begin
                                PurchCrMemoHdr.ACO_DisputeCode := VendLedgerEntry.ACO_DisputeCode;
                                PurchCrMemoHdr.Modify();
                                exit;
                            end;
                        end;
                    end;
                end;
        end;    //End Case
    end;
    //<<3.1.0.2018

    ///<summary>It inserts the Dispute Comment related to the dispute as part of the comments related to the related documents</summary>
    procedure InsertDisputeComment(TableID: Integer; EntryNo: Integer; Dispute: Record ACO_DisputeCode)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        case TableID of
            Database::"Cust. Ledger Entry":
                begin
                    CustLedgerEntry.Reset;
                    CustLedgerEntry.SetRange("Entry No.", EntryNo);
                    if CustLedgerEntry.FindFirst() then begin
                        InsertCustLedgerEntryComment(CustLedgerEntry, Dispute);
                    end;
                end;    //>> End "Cust. Ledger Entry"
            Database::"Vendor Ledger Entry":
                begin
                    VendLedgerEntry.Reset;
                    VendLedgerEntry.SetRange("Entry No.", EntryNo);
                    if VendLedgerEntry.FindFirst() then begin
                        InsertVendLedgerEntryComment(VendLedgerEntry, Dispute);
                    end;
                end;    //>> End Vendor Ledger Entry
        end;    //>> End Case
    end;

    ///<summary>It inserts the required comment related to the Customer Ledger Entry</summary>
    local procedure InsertCustLedgerEntryComment(CustLedgerEntry: Record "Cust. Ledger Entry"; Dispute: Record ACO_DisputeCode)
    var
        CommentLine: Record "Comment Line";
        //>> ----------------------------
        SalesCommentLine: Record "Sales Comment Line";
        //>> ------------------------
        ReminderCommentLine: Record "Reminder Comment Line";
        FinChargeCommentLine: Record "Fin. Charge Comment Line";
        //>> ------------------------
        NextLineNo: Integer;
        DocType: Integer;
        DocumentCommentCreated: Boolean;

    begin

        if DocumentExists(Database::"Cust. Ledger Entry", CustLedgerEntry."Document Type", CustLedgerEntry."Document No.") then begin
            case CustLedgerEntry."Document Type" of
                CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo":
                    begin
                        if CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice then begin
                            DocType := SalesCommentLine."Document Type"::"Posted Invoice";
                        end else begin
                            DocType := SalesCommentLine."Document Type"::"Posted Credit Memo";
                        end;
                        SalesCommentLine.Reset;
                        SalesCommentLine.SetRange("Document Type", DocType);
                        SalesCommentLine.SetRange("No.", CustLedgerEntry."Document No.");
                        SalesCommentLine.SetRange("Document Line No.", 0);
                        if SalesCommentLine.FindLast() then begin
                            NextLineNo := (SalesCommentLine."Line No." + 10000);
                        end else begin
                            NextLineNo := 10000;
                        end;
                        //>> -----------------------------------------------------------------------------------
                        SalesCommentLine.Reset;
                        SalesCommentLine.Init;
                        SalesCommentLine."Document Type" := DocType;
                        SalesCommentLine."No." := CustLedgerEntry."Document No.";
                        SalesCommentLine."Line No." := NextLineNo;
                        SalesCommentLine.Date := WorkDate;
                        SalesCommentLine.Comment := StrSubstNo(DocumentCommentPattern, Dispute.ACO_Code, Dispute.ACO_Description);
                        SalesCommentLine.Insert(true);
                        DocumentCommentCreated := true;
                    end;    //>> End Posted Invoice or Posted Credit Memo
                CustLedgerEntry."Document Type"::Reminder:
                    begin
                        ReminderCommentLine.Reset;
                        ReminderCommentLine.SetRange(Type, ReminderCommentLine.Type::"Issued Reminder");
                        ReminderCommentLine.SetRange("No.", CustLedgerEntry."Document No.");
                        if ReminderCommentLine.FindLast() then begin
                            NextLineNo := (ReminderCommentLine."Line No." + 10000);
                        end else begin
                            NextLineNo := 10000;
                        end;
                        //>> -----------------------------------------------------------------------------------
                        ReminderCommentLine.Reset;
                        ReminderCommentLine.Init;
                        ReminderCommentLine.Type := ReminderCommentLine.Type::"Issued Reminder";
                        ReminderCommentLine."No." := CustLedgerEntry."Document No.";
                        ReminderCommentLine."Line No." := NextLineNo;
                        ReminderCommentLine.Date := WorkDate;
                        ReminderCommentLine.Comment := StrSubstNo(DocumentCommentPattern, Dispute.ACO_Code, Dispute.ACO_Description);
                        ReminderCommentLine.Insert(true);
                        DocumentCommentCreated := true;
                    end;    //>> End Reminder
                CustLedgerEntry."Document Type"::"Finance Charge Memo":
                    begin
                        FinChargeCommentLine.Reset;
                        FinChargeCommentLine.SetRange(Type, FinChargeCommentLine.Type::"Issued Finance Charge Memo");
                        FinChargeCommentLine.SetRange("No.", CustLedgerEntry."Document No.");
                        if FinChargeCommentLine.FindLast() then begin
                            NextLineNo := (FinChargeCommentLine."Line No." + 10000);
                        end else begin
                            NextLineNo := 10000;
                        end;
                        //>> -----------------------------------------------------------------------------------
                        FinChargeCommentLine.Reset;
                        FinChargeCommentLine.Init;
                        FinChargeCommentLine.Type := FinChargeCommentLine.Type::"Issued Finance Charge Memo";
                        FinChargeCommentLine."No." := CustLedgerEntry."Document No.";
                        FinChargeCommentLine."Line No." := NextLineNo;
                        FinChargeCommentLine.Date := WorkDate;
                        FinChargeCommentLine.Comment := StrSubstNo(DocumentCommentPattern, Dispute.ACO_Code, Dispute.ACO_Description);
                        FinChargeCommentLine.Insert(true);
                        DocumentCommentCreated := true;
                    end;    //>> End Reminder
            end;    //>> End Case
        end;    //>> End Document Exists

        if DocumentCommentCreated then begin
            CommentLine.Reset;
            CommentLine.SetRange("Table Name", CommentLine."Table Name"::Customer);
            CommentLine.SetRange("No.", CustLedgerEntry."Customer No.");
            if CommentLine.FindLast() then begin
                NextLineNo := (CommentLine."Line No." + 10000);
            end else begin
                NextLineNo := 10000;
            end;
            //>> -----------------------------
            CommentLine.Reset;
            CommentLine.Init;
            CommentLine."Table Name" := CommentLine."Table Name"::Customer;
            CommentLine."No." := CustLedgerEntry."Customer No.";
            CommentLine."Line No." := NextLineNo;
            CommentLine.Date := WorkDate;
            CommentLine.Comment := StrSubstNo(CommentPattern, CustLedgerEntry."Document No.", Dispute.ACO_Code, Dispute.ACO_Description);
            CommentLine.Insert(true);
        end;    // End Document Comment Created

    end;

    ///<summary>It inserts the required comment related to the Vendor Ledger Entry</summary>
    local procedure InsertVendLedgerEntryComment(VendLedgerEntry: Record "Vendor Ledger Entry"; Dispute: Record ACO_DisputeCode)
    var
        CommentLine: Record "Comment Line";
        //>> ----------------------------
        PurchaseCommentLine: Record "Purch. Comment Line";
        //>> ------------------------
        DocType: Integer;
        NextLineNo: Integer;
        //>> ------------------------
        DocumentCommentCreated: Boolean;
    begin
        if DocumentExists(Database::"Vendor Ledger Entry", VendLedgerEntry."Document Type", VendLedgerEntry."Document No.") then begin
            case VendLedgerEntry."Document Type" of
                VendLedgerEntry."Document Type"::Invoice, VendLedgerEntry."Document Type"::"Credit Memo":
                    begin
                        if VendLedgerEntry."Document Type" = VendLedgerEntry."Document Type"::Invoice then begin
                            DocType := PurchaseCommentLine."Document Type"::"Posted Invoice";
                        end else begin
                            DocType := PurchaseCommentLine."Document Type"::"Posted Credit Memo";
                        end;
                        PurchaseCommentLine.Reset;
                        PurchaseCommentLine.SetRange("Document Type", DocType);
                        PurchaseCommentLine.SetRange("No.", VendLedgerEntry."Document No.");
                        PurchaseCommentLine.SetRange("Document Line No.", 0);
                        if PurchaseCommentLine.FindLast() then begin
                            NextLineNo := (PurchaseCommentLine."Line No." + 10000);
                        end else begin
                            NextLineNo := 10000;
                        end;
                        //>> -----------------------------------------------------------------------------------
                        PurchaseCommentLine.Reset;
                        PurchaseCommentLine.Init;
                        PurchaseCommentLine."Document Type" := DocType;
                        PurchaseCommentLine."No." := VendLedgerEntry."Document No.";
                        PurchaseCommentLine."Line No." := NextLineNo;
                        PurchaseCommentLine.Date := WorkDate;
                        PurchaseCommentLine.Comment := StrSubstNo(DocumentCommentPattern, Dispute.ACO_Code, Dispute.ACO_Description);
                        PurchaseCommentLine.Insert(true);
                        DocumentCommentCreated := true;
                    end;    //>> End Posted Invoice or Posted Credit Memo
            end;    //>> End Case
        end;    //>> End Document Exists

        if DocumentCommentCreated then begin
            CommentLine.Reset;
            CommentLine.SetRange("Table Name", CommentLine."Table Name"::Vendor);
            CommentLine.SetRange("No.", VendLedgerEntry."Vendor No.");
            if CommentLine.FindLast() then begin
                NextLineNo := (CommentLine."Line No." + 10000);
            end else begin
                NextLineNo := 10000;
            end;
            //>> -----------------------------
            CommentLine.Reset;
            CommentLine.Init;
            CommentLine."Table Name" := CommentLine."Table Name"::Vendor;
            CommentLine."No." := VendLedgerEntry."Vendor No.";
            CommentLine."Line No." := NextLineNo;
            CommentLine.Date := WorkDate;
            CommentLine.Comment := StrSubstNo(CommentPattern, VendLedgerEntry."Document No.", Dispute.ACO_Code, Dispute.ACO_Description);
            CommentLine.Insert(true);
        end;    // End Document Comment Created
    end;

    ///<summary>It determines if the specified document exists</summary>
    local procedure DocumentExists(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]) Result: Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        //>> -------------------------------------------------------
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrHdr: Record "Sales Cr.Memo Header";
        IssuedReminderHdr: Record "Issued Reminder Header";
        issuedFinChargeHdr: Record "Issued Fin. Charge Memo Header";
        //>> --------------------------------------------------------
        PurchInvHdr: Record "Purch. Inv. Header";
        PurchCrHdr: Record "Purch. Cr. Memo Hdr.";

    begin

        Result := false;

        case TableID of
            Database::"Cust. Ledger Entry":
                begin
                    case DocumentType of
                        CustLedgerEntry."Document Type"::Invoice:
                            begin
                                SalesInvHdr.Reset;
                                SalesInvHdr.SetRange("No.", DocumentNo);
                                Result := (not SalesInvHdr.IsEmpty);
                            end;    //>> End Invoice
                        CustLedgerEntry."Document Type"::"Credit Memo":
                            begin
                                SalesCrHdr.Reset;
                                SalesCrHdr.SetRange("No.", DocumentNo);
                                Result := (not SalesCrHdr.IsEmpty);
                            end;    //>> End Credit Memo
                        CustLedgerEntry."Document Type"::Reminder:
                            begin
                                IssuedReminderHdr.Reset;
                                IssuedReminderHdr.SetRange("No.", DocumentNo);
                                Result := (not IssuedReminderHdr.IsEmpty);
                            end;    //>> End Reminder
                        CustLedgerEntry."Document Type"::"Finance Charge Memo":
                            begin
                                issuedFinChargeHdr.Reset;
                                issuedFinChargeHdr.SetRange("No.", DocumentNo);
                                Result := (not issuedFinChargeHdr.IsEmpty);
                            end;    //>> End Finance Charge Credit Memo
                    end; //>> End Document Type Case on Customer Ledger Entry
                end;    //>> End Customer Ledger Entry
            Database::"Vendor Ledger Entry":
                begin
                    case DocumentType of
                        VendLedgerEntry."Document Type"::Invoice:
                            begin
                                PurchInvHdr.Reset;
                                PurchInvHdr.SetRange("No.", DocumentNo);
                                Result := (not PurchInvHdr.IsEmpty);
                            end;    //>> End Purchase Invoice
                        VendLedgerEntry."Document Type"::"Credit Memo":
                            begin
                                PurchCrHdr.Reset;
                                PurchCrHdr.SetRange("No.", DocumentNo);
                                Result := (not PurchCrHdr.IsEmpty);
                            end;    //>> End Purchase Credit Memo
                    end; //>> End Document Type Case on Vendor Ledger Entry
                end;    //>> End Vendor Ledger Entry
        end;

    end;

    var
        DocumentCommentPattern: Label '%1 - %2', MaxLength = 999, Comment = '', Locked = true;
        CommentPattern: Label '%1 - %2 - %3', MaxLength = 999, Comment = '', Locked = true;


}

