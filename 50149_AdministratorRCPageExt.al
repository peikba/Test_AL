pageextension 50149 AdministratorRCPageExt extends "Administrator Role Center"
{
    actions
    {
        // Add changes to page actions here
       addlast(Processing) 
       {
           action("Extension Details")
           {
               CaptionML=ENU='Extension Details';
               RunObject=page "Extension Detail Information";
               Promoted=true;
               PromotedIsBig=true;
               image=ItemGroup;
               ApplicationArea=ALL;
           }
       }
    }
}