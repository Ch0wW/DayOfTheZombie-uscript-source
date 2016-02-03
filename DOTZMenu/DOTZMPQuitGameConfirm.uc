// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * QuitConfirm - YES/NO to quit confirmation.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    Sept 2003
 */
class DOTZMPQuitGameConfirm extends DOTZErrorPage;



var automated GUIButton YesButton;
var automated GUIButton NoButton;

var localized string quit_string;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
    SetErrorCaption(quit_string);
}

/*****************************************************************
 * InternalOnClick
 *****************************************************************
 */

function bool InternalOnClick(GUIComponent Sender) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    if ( Sender == YesButton ) {
        Controller.OpenMenu("DOTZMenu.DOTZLoadingMenu");
       // class'MasterServerUplink'.default.DoUplink = false;
//       class'MasterServerUplink'.default.LANPort= 0;
//       class'MasterServerUplink'.default.LANServerPort=0;
//        class'MasterServerUplink'.static.StaticSaveConfig();
        PlayerOwner().ConsoleCommand("Disconnect");
        PlayerOwner().ConsoleCommand("start MainMenu.day");
        //PlayerOwner().ClientTravel("MainMenu.dz",TRAVEL_Relative, false);
        //PlayerOwner().Level.ServerTravel("MainMenu.dz",false);
        //PlayerOwner().Level.ServerTravel("?Loadnamed=MainMenu.dz",  false);
    } else {
        Controller.CloseMenu(false);
    }
    return true;
}

defaultproperties
{
     Begin Object Class=GUIButton Name=cYesButton
         Caption="Yes"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.600000
         WinWidth=0.250000
         WinHeight=0.200000
         __OnClick__Delegate=DOTZMPQuitGameConfirm.InternalOnClick
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZMPQuitGameConfirm.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="No"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.200000
         WinWidth=0.250000
         WinHeight=0.200000
         TabOrder=1
         __OnClick__Delegate=DOTZMPQuitGameConfirm.InternalOnClick
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZMPQuitGameConfirm.cNoButton'
     quit_string="Are you sure you wish to quit?"
     ClickSound=Sound'DOTZXInterface.Select'
     WinHeight=0.250000
}
