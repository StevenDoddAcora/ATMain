namespace Acora.AvTrade.MainApp;

table 50106 "ACO_AdditionalSetup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Rec.Get() then begin
            Init();
            Rec.Insert(true);
        end;
    end;


}