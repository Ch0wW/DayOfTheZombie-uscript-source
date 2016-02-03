// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZKeyboard - Virtual keyboard for name input.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZKeyboard extends XDOTZProfileBase;



 // Left border for action keys
       // Width of action keys

      // Where do the keys start on the left side
        // Top border of keyboard
           // Height of keys
           // Width of keys
           // 6 * KEYSWIDTH + KEYSBORDERLEFT
           // 8 * KEYSWIDTH + KEYSBORDERLEFT

const MAX_PROFILE_LEN = 10;

//Page components
var Automated GuiButton  ShiftButton;
var Automated GuiButton  CapsLockButton;

var Automated GuiButton  SpaceButton;
var Automated GuiButton  BackspaceButton;

var Automated GuiButton  DoneButton;

var Automated GuiLabel   CurrentNameLabel;

var int                  CurrentKeyboard; // 0 - lowercase, 1 - uppercase shift, 2 - uppercase caps, 3 - symbols

// Profiles
//var Profiler profiles;


struct KeyButton {
    var GuiButton    guibutton;
    var string       lowercaselabel;
    var string       uppercaselabel;
    var string       symbollabel;
};

var Automated KeyButton keyboardlayout[40];

var sound ClickSound;

//configurable stuff
var localized string PageCaption;

/*****************************************************************
 * GetChar
 * Given the index of the key, the appropriate character is
 * returned.
 *****************************************************************
 */

function string GetKeyboardChar(int button_index) {
    if (CurrentKeyboard == 0)
       return keyboardlayout[button_index].lowercaselabel;

    if (CurrentKeyboard == 1 || CurrentKeyboard == 2)
       return keyboardlayout[button_index].uppercaselabel;

    if (CurrentKeyboard == 3)
       return keyboardlayout[button_index].symbollabel;
}

/*****************************************************************
 * LayoutKeyboard
 *****************************************************************
 */

// This function lays out the GUI buttons for the keyboard programatically
function LayoutKeyboard () {
   local float button_width;
   local int button_index;
   local float xpos;
   local float ypos;

   button_width = ( - 0.29) / 10.0;

   for (button_index = 0; button_index < 36; ++button_index) {
       xpos = 0.29 + (0.045 + 0.015) * (button_index % 10);
       ypos = 0.3 + (0.06 + 0.015) * (button_index / 10);

       keyboardlayout[button_index].guibutton = GUIButton(AddComponent("BBGui.BBXButtonBorder"));

       //keyboardlayout[button_index].guibutton =
       keyboardlayout[button_index].guibutton.Caption = GetKeyboardChar(button_index);
       keyboardlayout[button_index].guibutton.Hint = "";
       keyboardlayout[button_index].guibutton.OnClick = ButtonClicked;
       //keyboardlayout[button_index].guibutton.StyleName = "BBTextButton";
       keyboardlayout[button_index].guibutton.TabOrder = 1;
       keyboardlayout[button_index].guibutton.bBoundToParent = true;
       keyboardlayout[button_index].guibutton.bScaleToParent = true;
       keyboardlayout[button_index].guibutton.WinWidth = 0.045;
       keyboardlayout[button_index].guibutton.WinHeight = 0.06;
       keyboardlayout[button_index].guibutton.WinLeft = xpos + 0.01;
       keyboardlayout[button_index].guibutton.WinTop = ypos + 0.01;
       keyboardlayout[button_index].guibutton.bFocusOnWatch = true;

       //AppendComponent(keyboardlayout[button_index].guibutton);
   }

   MapControls();
}

function RelabelKeyboard () {
    local int button_index;

    for (button_index = 0; button_index < 36; ++button_index) {
        keyboardlayout[button_index].guibutton.Caption = GetKeyboardChar(button_index);
    }
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
 * X Button pressed
 *
 *****************************************************************
 */

function DoButtonX ()
{
     if (len(CurrentNameLabel.Caption) > 0) {
         CurrentNameLabel.Caption = Left(CurrentNameLabel.Caption, len(CurrentNameLabel.Caption)-1);
     }
}

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
   // init my components...

   //profiles = new(self) class'Profiler';

   SetPageCaption (PageCaption);

   AddBackButton ();
   AddBackspaceButton();

   CurrentNameLabel.Caption = "";

   LayoutKeyboard();
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the menu to load
 * Param2 - the name of the sub menu to load on top of the first menu
 *****************************************************************
 */
/*event HandleParameters( String param1, String param2 ) {

    if (param1 != ""){
        Controller.OpenMenu(param1);
    }
} */


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
    local GUIButton Selected;
    local int button_index;
    local bool existing;

    local int profile_count;
    local int p;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;


   	PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        // Accept and cancel
        case DoneButton:
             existing = false;

             profile_count = DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount();

             for (p = 0; p < profile_count; ++p) {
                if (DOTZPlayerControllerBase(PlayerOwner()).GetProfileName(p) == CurrentNameLabel.Caption) {
                    existing = true;
                    break;
                }
             }

             if (CurrentNameLabel.Caption != ""){
                if (existing) {
                    return BBGuiController(Controller).SwitchMenu("DOTZMenu.XDOTZProfileAlreadyOne");
                } else {
                    DOTZPlayerControllerBase(PlayerOwner()).NewProfile(CurrentNameLabel.Caption);

                    DOTZPlayerControllerBase(PlayerOwner()).SetDifficultyLevel(1);
                    DOTZPlayerControllerBase(PlayerOwner()).SetInvertLook(false);
                    //DOTZPlayerControllerBase(PlayerOwner()).SetVoiceThruSpeakers(false);
                    DOTZPlayerControllerBase(PlayerOwner()).SetVoiceMasking(false);
                    DOTZPlayerControllerBase(PlayerOwner()).SetUseSubtitles(false);
                    DOTZPlayerControllerBase(PlayerOwner()).SetUseVibration(true);
                    DOTZPlayerControllerBase(PlayerOwner()).SetControllerSensitivity(4);

                    return BBGuiController(Controller).SwitchMenu("DOTZMenu.XDOTZProfileEditSettings");
                }
             }
             break;

        // Alternate keyboards
        case ShiftButton:
             // Alternate uppercase and lowercase (Shift)
             if (CurrentKeyboard == 0)
                 CurrentKeyboard = 1;
             else
                 CurrentKeyboard = 0;

             RelabelKeyboard();
             return true;
             break;

        case CapsLockButton:
             // Alternate uppercase and lowercase (Caps lock)
             if (CurrentKeyboard == 0)
                 CurrentKeyboard = 2;
             else
                 CurrentKeyboard = 0;

             RelabelKeyboard();
             return true;
             break;

        // Space and backspace
        case SpaceButton:
             if (Len(CurrentNameLabel.Caption) < MAX_PROFILE_LEN) {
               CurrentNameLabel.Caption = CurrentNameLabel.Caption $ " ";
             }
             return true;
             break;

        case BackspaceButton:
             DoButtonX ();
             return true;
             break;

        default:
             for (button_index = 0; button_index < 36; ++button_index)
                 if (keyboardlayout[button_index].guibutton == Selected) {
                     // Append the character if the string isn't at the limit
                     if (Len(CurrentNameLabel.Caption) < MAX_PROFILE_LEN) {
                        CurrentNameLabel.Caption = CurrentNameLabel.Caption $ GetKeyboardChar(button_index);
                     }

                     // If shifted, switch back to lowercase
                     if (CurrentKeyboard == 1) {
                         CurrentKeyboard = 0;
                         RelabelKeyboard();
                     }

                     return true;
                 }
             break;
    };

   return false;
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
     Begin Object Class=GUIButton Name=ShiftButton_btn
         Caption="Shift"
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Shift Key"
         WinTop=0.310000
         WinLeft=0.110000
         WinWidth=0.170000
         WinHeight=0.060000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZKeyboard.ButtonClicked
         Name="ShiftButton_btn"
     End Object
     ShiftButton=GUIButton'DOTZMenu.XDOTZKeyboard.ShiftButton_btn'
     Begin Object Class=GUIButton Name=CapsLockButton_btn
         Caption="Caps Lock"
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Caps Lock"
         WinTop=0.385000
         WinLeft=0.110000
         WinWidth=0.170000
         WinHeight=0.060000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZKeyboard.ButtonClicked
         Name="CapsLockButton_btn"
     End Object
     CapsLockButton=GUIButton'DOTZMenu.XDOTZKeyboard.CapsLockButton_btn'
     Begin Object Class=GUIButton Name=SpaceButton_btn
         Caption="Space"
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Insert a space"
         WinTop=0.460000
         WinLeft=0.110000
         WinWidth=0.170000
         WinHeight=0.060000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZKeyboard.ButtonClicked
         Name="SpaceButton_btn"
     End Object
     SpaceButton=GUIButton'DOTZMenu.XDOTZKeyboard.SpaceButton_btn'
     Begin Object Class=GUIButton Name=BackspaceButton_btn
         Caption="Backspace"
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         Hint="Delete a character"
         WinTop=0.535000
         WinLeft=0.110000
         WinWidth=0.170000
         WinHeight=0.060000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZKeyboard.ButtonClicked
         Name="BackspaceButton_btn"
     End Object
     BackspaceButton=GUIButton'DOTZMenu.XDOTZKeyboard.BackspaceButton_btn'
     Begin Object Class=GUIButton Name=DoneButton_btn
         Caption="Done"
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.650000
         WinLeft=0.200000
         WinWidth=0.600000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZKeyboard.ButtonClicked
         Name="DoneButton_btn"
     End Object
     DoneButton=GUIButton'DOTZMenu.XDOTZKeyboard.DoneButton_btn'
     Begin Object Class=GUILabel Name=CurrentNameLabel_lbl
         Caption="CarrotsRule"
         TextAlign=TXTA_Center
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="CurrentNameLabel_lbl"
     End Object
     CurrentNameLabel=GUILabel'DOTZMenu.XDOTZKeyboard.CurrentNameLabel_lbl'
     keyboardlayout(0)=(lowercaselabel="1",uppercaselabel="1",symbollabel="!")
     keyboardlayout(1)=(lowercaselabel="2",uppercaselabel="2",symbollabel="@")
     keyboardlayout(2)=(lowercaselabel="3",uppercaselabel="3",symbollabel="#")
     keyboardlayout(3)=(lowercaselabel="4",uppercaselabel="4",symbollabel="$")
     keyboardlayout(4)=(lowercaselabel="5",uppercaselabel="5",symbollabel="%")
     keyboardlayout(5)=(lowercaselabel="6",uppercaselabel="6",symbollabel="^")
     keyboardlayout(6)=(lowercaselabel="7",uppercaselabel="7",symbollabel="&")
     keyboardlayout(7)=(lowercaselabel="8",uppercaselabel="8",symbollabel="*")
     keyboardlayout(8)=(lowercaselabel="9",uppercaselabel="9",symbollabel="(")
     keyboardlayout(9)=(lowercaselabel="0",uppercaselabel="0",symbollabel=")")
     keyboardlayout(10)=(lowercaselabel="a",uppercaselabel="A",symbollabel="?")
     keyboardlayout(11)=(lowercaselabel="b",uppercaselabel="B",symbollabel="?")
     keyboardlayout(12)=(lowercaselabel="c",uppercaselabel="C",symbollabel="?")
     keyboardlayout(13)=(lowercaselabel="d",uppercaselabel="D",symbollabel="?")
     keyboardlayout(14)=(lowercaselabel="e",uppercaselabel="E",symbollabel="?")
     keyboardlayout(15)=(lowercaselabel="f",uppercaselabel="F",symbollabel="?")
     keyboardlayout(16)=(lowercaselabel="g",uppercaselabel="G",symbollabel="?")
     keyboardlayout(17)=(lowercaselabel="h",uppercaselabel="H",symbollabel="?")
     keyboardlayout(18)=(lowercaselabel="i",uppercaselabel="I",symbollabel="?")
     keyboardlayout(19)=(lowercaselabel="j",uppercaselabel="J",symbollabel="?")
     keyboardlayout(20)=(lowercaselabel="k",uppercaselabel="K",symbollabel="?")
     keyboardlayout(21)=(lowercaselabel="l",uppercaselabel="L",symbollabel="?")
     keyboardlayout(22)=(lowercaselabel="m",uppercaselabel="M",symbollabel="?")
     keyboardlayout(23)=(lowercaselabel="n",uppercaselabel="N",symbollabel="?")
     keyboardlayout(24)=(lowercaselabel="o",uppercaselabel="O",symbollabel="?")
     keyboardlayout(25)=(lowercaselabel="p",uppercaselabel="P",symbollabel="?")
     keyboardlayout(26)=(lowercaselabel="q",uppercaselabel="Q",symbollabel="?")
     keyboardlayout(27)=(lowercaselabel="r",uppercaselabel="R",symbollabel="?")
     keyboardlayout(28)=(lowercaselabel="s",uppercaselabel="S",symbollabel="?")
     keyboardlayout(29)=(lowercaselabel="t",uppercaselabel="T",symbollabel="?")
     keyboardlayout(30)=(lowercaselabel="u",uppercaselabel="U",symbollabel="?")
     keyboardlayout(31)=(lowercaselabel="v",uppercaselabel="V",symbollabel="?")
     keyboardlayout(32)=(lowercaselabel="w",uppercaselabel="W",symbollabel="?")
     keyboardlayout(33)=(lowercaselabel="x",uppercaselabel="X",symbollabel="?")
     keyboardlayout(34)=(lowercaselabel="y",uppercaselabel="Y",symbollabel="?")
     keyboardlayout(35)=(lowercaselabel="z",uppercaselabel="Z",symbollabel="?")
     ClickSound=Sound'DOTZXInterface.Select'
     PageCaption="Edit Profile"
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZKeyboard.HandleKeyEvent
}
