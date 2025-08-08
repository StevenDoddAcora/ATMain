pageextension 50303 "ACO_SessionList" extends "Session List"
{
    //#region Documentation
    // 1.1.0.2018 LBR 11/06/2019 - This is temp change to allow to kill user session
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
                begin
                    if Confirm(StrSubstNo(killLbl, "Session ID"), false) then
                        StopSession("Session ID");
                end;
            }
        }
    }
}