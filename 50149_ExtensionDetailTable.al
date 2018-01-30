table 50149 "Extension Detail Information"
{

    fields
    {
        field(1;"Extension Id";Integer)
        {
            Caption = 'Extension Id';
        }
        field(2;"Extension Name";Text[80])
        {
            Caption = 'Extension Name';
        }
        field(3;"Object Type";Option)
        {
            OptionCaption = ',Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,,,,,PageExtension,TableExtension';
            OptionMembers = ,"Table",,"Report",,"Codeunit","XMLport",MenuSuite,"Page","Query",,,,,"PageExtension","TableExtension";
        }
        field(4;"Object ID";Integer)
        {
        }
        field(5;"Table ID";Integer)
        {
            Caption = 'Table ID';
        }
        field(6;"Object Name";Text[80])
        {
            Caption = 'Object Name';
        }
        field(7;"Field ID";Integer)
        {
            Caption = 'Field ID';
        }
        field(8;"Field Name";Text[80])
        {
            Caption = 'Field Name';
        }
        field(9;"Field Datatype";Text[30])
        {
            Caption = 'Field Datatype';
        }
        field(10;"Field FieldClass";Text[30])
        {
            Caption = 'Field FieldClass';
        }
        field(11;"Field Enabled";Boolean)
        {
            Caption = 'Field Enabled';
        }
        field(12;"Field Obsolete State";Text[30])
        {
            Caption = 'Field Obsolete State';
        }
    }

    keys
    {
        key(Key1;"Extension Id","Object Type","Object ID","Table ID","Field ID")
        {
        }
    }

    fieldgroups
    {
    }
}

