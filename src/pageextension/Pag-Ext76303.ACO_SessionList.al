namespace Acora.AvTrade.MainApp;

using System.Environment;

pageextension 50303 "ACO_SessionList" extends "Concurrent Session List"
{
    //#region Documentation
    // 1.1.0.2018 LBR 11/06/2019 - This is temp change to allow to kill user session
    // UPDATED: Changed from "Active Sessions" to "Concurrent Session List" - correct modern BC page name
    //#endregion Documentation

    actions
    {

        addlast(Processing)
        {
            action(KillUserSession)
            {
                ApplicationArea = All;
                Caption = 'Kill Session';
                Image = Import;
                Promoted = true;

                trigger OnAction();
                var
                    killLbl: label 'Do you want to kill session: %1';
                    ActiveSession: Record "Active Session";
                begin
                    if ActiveSession.Get(Rec."Session ID") then
                        if Confirm(StrSubstNo(killLbl, Rec."Session ID"), false) then
                            StopSession(Rec."Session ID");
                end;
            }
        }
    }
}
