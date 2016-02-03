// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #3 $
 * @date    January 19, 2005
 */

class XDOTZSPLevelList extends XDOTZSinglePlayerBase;




//Page components
var Automated BBXListBox  LevelList;

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

var localized string Level01txt;
var localized string Level02txt;
var localized string Level03txt;
var localized string Level04txt;
var localized string Level05txt;
var localized string Level06txt;
var localized string Level07txt;
var localized string Level08txt;
var localized string Level09txt;
var localized string Level10txt;
var localized string Level11txt;
var localized string Level12txt;
var localized string Level13txt;
var localized string Level14txt;

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */

function Refresh_Profiles_List () {

    LevelList.List.Add(Level01txt,,"Level-01.day");
    LevelList.List.Add(Level02txt,,"Level-02.day");
    LevelList.List.Add(Level03txt,,"Level-03.day");
    LevelList.List.Add(Level04txt,,"Level-04.day");
    LevelList.List.Add(Level05txt,,"Level-05.day");
    LevelList.List.Add(Level06txt,,"Level-06.day");
    LevelList.List.Add(Level07txt,,"Level-07.day");
    LevelList.List.Add(Level08txt,,"Level-08.day");
    LevelList.List.Add(Level09txt,,"Level-09.day");
    LevelList.List.Add(Level10txt,,"Level-10.day");
    LevelList.List.Add(Level11txt,,"Level-11.day");
    LevelList.List.Add(Level12txt,,"Level-12.day");
    LevelList.List.Add(Level13txt,,"Level-13.day");
    LevelList.List.Add(Level14txt,,"Level-14.day");

    /*
    LevelList.List.Add(ch02atxt,,"CH02a.dz");
    LevelList.List.Add(ch02btxt,,"CH02b.dz");
    LevelList.List.Add(ch03atxt,,"CH03a.dz");
    LevelList.List.Add(ch03btxt,,"CH03b.dz");
    LevelList.List.Add(ch03ctxt,,"CH03c.dz");
    LevelList.List.Add(ch04atxt,,"CH04a.dz");
    LevelList.List.Add(ch04btxt,,"CH04b.dz");
    LevelList.List.Add(ch05atxt,,"CH05a.dz");
    LevelList.List.Add(ch05btxt,,"CH05b.dz");
    LevelList.List.Add(ch06atxt,,"CH06a.dz");
    LevelList.List.Add(ch06btxt,,"CH06b.dz");
    LevelList.List.Add(ch07atxt,,"CH07a.dz");
    LevelList.List.Add(ch07btxt,,"CH07b.dz");
    LevelList.List.Add(ch08txt,,"CH08.dz");
    LevelList.List.Add(ch09atxt,,"CH09a.dz");
    LevelList.List.Add(ch09btxt,,"CH09b.dz");
    LevelList.List.Add(ch10txt,,"CH10.dz");
    LevelList.List.Add(ch11atxt,,"CH11a.dz");
    LevelList.List.Add(ch11btxt,,"CH11b.dz");
    LevelList.List.Add(ch12atxt,,"CH12a.dz");
    LevelList.List.Add(ch12btxt,,"CH12b.dz");
    LevelList.List.Add(ch13atxt,,"CH13a.dz");
    LevelList.List.Add(ch13btxt,,"CH13b.dz");
    LevelList.List.Add(ch13ctxt,,"CH13c.dz");
    LevelList.List.Add(ch13dtxt,,"CH13d.dz");
      */
}

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();

   Refresh_Profiles_List ();
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;
    local string list_item;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;


    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case LevelList:
             list_index = LevelList.List.Index;
             list_item = LevelList.List.GetExtraAtIndex(list_index);

             class'UtilsXbox'.static.Set_Reboot_Type(5);   // Is single player
             //class'UtilsXbox'.static.SinglePlayer_Set_Map_Name(list_item);

             // Display loading screen
             Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

             // Reboot!
             //Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox

             PlayerOwner().Level.ServerTravel(list_item,false);
             break;
    };

   return true;
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * NotifyLevelChange
 *
 *****************************************************************
 */
event NotifyLevelChange() {
    Controller.CloseMenu(true);
}



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=BBXListBox Name=LevelList_btn
         bVisibleWhenEmpty=True
         bNeverFocus=True
         WinTop=0.188000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.631000
         __OnClick__Delegate=XDOTZSPLevelList.ButtonClicked
         Name="LevelList_btn"
     End Object
     LevelList=BBXListBox'DOTZMenu.XDOTZSPLevelList.LevelList_btn'
     PageCaption="SinglePlayer  Levels"
     ClickSound=Sound'DOTZXInterface.Select'
     Level01txt="Level 1 Description"
     Level02txt="Level 2 Description"
     Level03txt="Level 3 Description"
     Level04txt="Level 4 Description"
     Level05txt="Level 5 Description"
     Level06txt="Level 6 Description"
     Level07txt="Level 7 Description"
     Level08txt="Level 8 Description"
     Level09txt="Level 9 Description"
     Level10txt="Level 10 Description"
     Level11txt="Level 11 Description"
     Level12txt="Level 12 Description"
     Level13txt="Level 13 Description"
     Level14txt="Level 14 Description"
     __OnKeyEvent__Delegate=XDOTZSPLevelList.HandleKeyEvent
}
