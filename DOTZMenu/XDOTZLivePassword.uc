// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLivePassword extends XDOTZLivePage;

//Page components
var Automated GUIImage  Unfilled1;
var Automated GUIImage  Unfilled2;
var Automated GUIImage  Unfilled3;
var Automated GUIImage  Unfilled4;

var Automated GUIImage  Filled1;
var Automated GUIImage  Filled2;
var Automated GUIImage  Filled3;
var Automated GUIImage  Filled4;

var int       num_entries;
var int       entries[4];
var bool      valid_password;

// Menu locations
var string    PasswordError;
var string    ErrorMenu;
var string    SigningInMenu;

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * Displays the password entry
 *****************************************************************
 */

function Password_Display () {
    if (num_entries >= 1)  {
       Filled1.SetVisibility(true);
       Unfilled1.SetVisibility(false);
    } else {
       Filled1.SetVisibility(false);
       Unfilled1.SetVisibility(true);
    }

    if (num_entries >= 2)  {
       Filled2.SetVisibility(true);
       Unfilled2.SetVisibility(false);
    } else {
       Filled2.SetVisibility(false);
       Unfilled2.SetVisibility(true);
    }

    if (num_entries >= 3)  {
       Filled3.SetVisibility(true);
       Unfilled3.SetVisibility(false);
    } else {
       Filled3.SetVisibility(false);
       Unfilled3.SetVisibility(true);
    }

    if (num_entries >= 4)  {
       Filled4.SetVisibility(true);
       Unfilled4.SetVisibility(false);
    } else {
       Filled4.SetVisibility(false);
       Unfilled4.SetVisibility(true);
    }

}

/*****************************************************************
 * Converts unreal password entries into xbox live entries

    XONLINE_PASSCODE_DPAD_UP = 1
    XONLINE_PASSCODE_DPAD_DOWN = 2
    XONLINE_PASSCODE_DPAD_LEFT = 3
    XONLINE_PASSCODE_DPAD_RIGHT = 4
    XONLINE_PASSCODE_GAMEPAD_X = 5
    XONLINE_PASSCODE_GAMEPAD_Y = 6
    XONLINE_PASSCODE_GAMEPAD_LEFT_TRIGGER = 9
    XONLINE_PASSCODE_GAMEPAD_RIGHT_TRIGGER = 10

 *****************************************************************
 */

function int Translate_Password_Filled (int unreal_key) {
    switch (unreal_key) {
        case 202/*XC_X*/:              return 5;    break;
        case 203/*XC_Y*/:              return 6;    break;
        case 208/*XC_Up*/:             return 1;    break;
        case 209/*XC_Down*/:           return 2;    break;
        case 210/*XC_Left*/:           return 3;    break;
        case 211/*XC_Right*/:          return 4;    break;
        case 206/*XC_LeftTrigger*/:    return 9;    break;
        case 207/*XC_RightTrigger*/:   return 10;   break;
        default:                       return 0;    break;
    };
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

   Password_Display ();
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    // for keeping track of keypresses
    num_entries = 0;
    Password_Display ();

    // Set the microsoft approved caption
    SetPageCaption(PageCaption $ " " $ class'UtilsXbox'.static.Get_Current_Name());
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

/*****************************************************************
 * Enter the password here
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    local int xbox_key;

    Super.HandleKeyEvent(Key,State,delta);

    if (State != 1) return false;

    xbox_key = Translate_Password_Filled(Key);

    if (xbox_key > 0) {

       entries[num_entries] = xbox_key;

       num_entries++;

       // Clamp num_entries just in case
       if (num_entries > 4)            num_entries = 4;
       else if (num_entries < 0)       num_entries = 0;


       // Check for a valid password
       if (num_entries == 4) {

           valid_password = class'UtilsXbox'.static.Check_Password (entries[0], entries[1], entries[2], entries[3]);

           if (valid_password) {
               // Attempt to sign in to live
               BBGuiController(Controller).SwitchMenu (SigningInMenu);

           } else {
               Controller.OpenMenu(PasswordError);
           }

           // Clear the password field
           num_entries = 0;
       }

       // Display the password
       Password_Display ();
       return true;
    }

    return false;
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUIImage Name=Unfilled1_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxA'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.100000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Unfilled1_img"
     End Object
     Unfilled1=GUIImage'DOTZMenu.XDOTZLivePassword.Unfilled1_img'
     Begin Object Class=GUIImage Name=Unfilled2_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxA'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.300000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Unfilled2_img"
     End Object
     Unfilled2=GUIImage'DOTZMenu.XDOTZLivePassword.Unfilled2_img'
     Begin Object Class=GUIImage Name=Unfilled3_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxA'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.500000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Unfilled3_img"
     End Object
     Unfilled3=GUIImage'DOTZMenu.XDOTZLivePassword.Unfilled3_img'
     Begin Object Class=GUIImage Name=Unfilled4_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxA'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.700000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Unfilled4_img"
     End Object
     Unfilled4=GUIImage'DOTZMenu.XDOTZLivePassword.Unfilled4_img'
     Begin Object Class=GUIImage Name=Filled1_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxB'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.120000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Filled1_img"
     End Object
     Filled1=GUIImage'DOTZMenu.XDOTZLivePassword.Filled1_img'
     Begin Object Class=GUIImage Name=Filled2_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxB'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.320000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Filled2_img"
     End Object
     Filled2=GUIImage'DOTZMenu.XDOTZLivePassword.Filled2_img'
     Begin Object Class=GUIImage Name=Filled3_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxB'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.520000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Filled3_img"
     End Object
     Filled3=GUIImage'DOTZMenu.XDOTZLivePassword.Filled3_img'
     Begin Object Class=GUIImage Name=Filled4_img
         Image=Texture'DOTZTInterface.XBoxIcons.HeadBoxB'
         ImageStyle=ISTY_Justified
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.720000
         WinWidth=0.200000
         WinHeight=0.200000
         Name="Filled4_img"
     End Object
     Filled4=GUIImage'DOTZMenu.XDOTZLivePassword.Filled4_img'
     PasswordError="DOTZMenu.XDOTZLivePasswordError"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     SigningInMenu="DOTZMenu.XDOTZLiveSigningIn"
     PageCaption="Please enter the pass code for"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLivePassword.HandleKeyEvent
}
