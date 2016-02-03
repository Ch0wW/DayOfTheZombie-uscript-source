// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * QuitConfirm - YES/NO to quit confirmation.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    Sept 2003
 */
class DOTZQuitGameConfirm extends DOTZErrorPage;



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
        PlayerOwner().ConsoleCommand("Disconnect");
        PlayerOwner().ConsoleCommand("start MainMenu.day");

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
         __OnClick__Delegate=DOTZQuitGameConfirm.InternalOnClick
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZQuitGameConfirm.cYesButton'
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
         __OnClick__Delegate=DOTZQuitGameConfirm.InternalOnClick
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZQuitGameConfirm.cNoButton'
     quit_string="Are you sure you wish to quit? Unsaved progress will be lost."
     ClickSound=Sound'DOTZXInterface.Select'
     WinHeight=0.250000
}
