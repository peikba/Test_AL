page 50149 "Extension Detail Information"
{
    PageType = List;
    SourceTable = "Extension Detail Information";
    SourceTableTemporary = true;
    Editable=false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Extension Id";"Extension Id")
                {
                }
                field("Extension Name";"Extension Name")
                {
                }
                field("Object Type";"Object Type")
                {
                }
                field("Object ID";"Object ID")
                {
                }
                field("Table ID";"Table ID")
                {
                  ApplicationArea=ALL;
                }
                field("Object Name";"Object Name")
                {
                }
                field("Field ID";"Field ID")
                {
                    BlankNumbers = BlankZero;
                }
                field("Field Name";"Field Name")
                {
                }
                field("Field Datatype";"Field Datatype")
                {
                }
                field("Field FieldClass";"Field FieldClass")
                {
                }
                field("Field Enabled";"Field Enabled")
                {
                }
                field("Field Obsolete State";"Field Obsolete State")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        PopulateData;
    end;

    var
        tempText : Text;
        tempPos : Integer;
        AppID : array [100000] of Guid;
        AppName : array [100000] of Text[50];
        ExtID : array [100000] of Integer;

    local procedure PopulateData();
    var
        NAVAppObjectMetadata : Record "NAV App Object Metadata";
        RespInputStream : InStream;
        inText : BigText;
        locInput : Text[30];
        "Object" : Record Object;
    begin
        WITH NAVAppObjectMetadata DO BEGIN
          IF FINDSET THEN REPEAT
            Rec.INIT;
            CLEAR(tempText);
            CLEAR(inText);
            CALCFIELDS(Metadata);
            Metadata.CREATEINSTREAM(RespInputStream);
            IF Metadata.HASVALUE THEN BEGIN
              Metadata.CREATEINSTREAM(RespInputStream);
              inText.READ(RespInputStream);
              IF inText.LENGTH<=256 THEN
                inText.GETSUBTEXT(inText,2)
              ELSE
                inText.GETSUBTEXT(inText,3);
              tempText:=FORMAT(inText);
              tempPos:=1;
              IF EVALUATE("Extension Id",FindTagValue('ID')) THEN BEGIN
                "Extension Name":=FindTagValue('Name');
                Rec."Object Type":="Object Type";
                Rec."Object ID":="Object ID";
                IF NOT EVALUATE("Table ID","Object Subtype") THEN
                  "Table ID":="Object ID";
                Rec."Object Name":="Object Name";
                IF (Rec."Object Name"='') THEN BEGIN
                Object.SETRANGE(Type,"Object Type");
                Object.SETRANGE(ID,"Object ID");
                IF Object.FINDFIRST THEN
                  "Object Name":=Object.Name;
                END;
                IF ("Object Type"=1) OR ("Object Type"=15)  THEN BEGIN
                  WHILE ((STRPOS(tempText,'<Field Name')> 0) OR (STRPOS(tempText,'<FieldAdd')> 0)) DO BEGIN
                    "Field Name":=FindTagValue('Name');
                    EVALUATE("Field ID",FindTagValue('ID'));
                    "Field Datatype":=FindTagValue('Datatype');
                    "Field FieldClass":=FindTagValue('FieldClass');
                    "Field Enabled":=FindTagValue('Enabled')='1';
                    "Field Obsolete State":=FindTagValue('ObsoleteState');
                    Rec.INSERT;
                  END;
                END ELSE BEGIN
                  CLEAR(Rec."Field ID");
                  IF "Extension Id"=0 THEN BEGIN
                    FindExtensionID("App Package ID","Extension Name","Extension Id");
                  END;
                  IF "Extension Name"<>'' THEN
                    Rec.INSERT;
                END;
                AddApp("App Package ID","Extension Name","Extension Id");
              END;
            END;
          UNTIL NEXT=0;
        END;
    end;

    local procedure FindTagValue(inTagName : Text[250]) ReturnValue : Text[250];
    begin
        inTagName:=' '+inTagName+'=';
        tempPos:=STRPOS(tempText,inTagName);
        IF tempPos=0 THEN
           EXIT('');

        tempText:=COPYSTR(tempText,tempPos+STRLEN(inTagName)+1);
        ReturnValue:=COPYSTR(tempText,1,STRPOS(tempText,'"')-1);
        tempText:=COPYSTR(tempText,STRPOS(tempText,'"'));
    end;

    local procedure FindExtensionID(inAppID : Guid;var outAppName : Text[50];var outExtID : Integer) : Integer;
    var
        Counter : Integer;
    begin
        FOR Counter:=1 TO ARRAYLEN(AppID) DO BEGIN
          IF AppID[Counter]=inAppID THEN BEGIN
            outAppName:=AppName[Counter];
            outExtID:=ExtID[Counter];
            EXIT;
          END;
        END;
    end;

    local procedure AddApp(inAppID : Guid;inAppName : Text[80];inExtID : Integer);
    var
        Counter : Integer;
    begin
        FOR Counter:=1 TO ARRAYLEN(AppID) DO BEGIN
          IF AppID[Counter]=inAppID THEN
            EXIT;
          IF AppName[Counter]='' THEN BEGIN
            AppID[Counter]:=inAppID;
            AppName[Counter]:=inAppName;
            ExtID[Counter]:=inExtID;
            EXIT;
          END;
        END;
    end;
}

