// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * QuitConfirm - YES/NO to quit confirmation.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #3 $
 * @date    Sept 2003
 */
class DOTZNewProfile extends DOTZErrorPage;



var automated GUIButton CreateButton;
var automated GUIButton CancelButton;
var automated GUIEditBox NameEditBox;

var localized string msg_string;
var localized string valid_chars_string;

var sound ClickSound;
var bool bSuccess;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);

    SetErrorCaption(msg_string);
}

/*****************************************************************
 * InternalOnClick
 *****************************************************************
 */

function bool InternalOnClick(GUIComponent Sender) {
    local int profile_count;
    local int p;
    local bool existing;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    if ( Sender == CreateButton ) {
         existing = false;

         profile_count = DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount();

         for (p = 0; p < profile_count; ++p) {
            if (DOTZPlayerControllerBase(PlayerOwner()).GetProfileName(p) == NameEditBox.GetText()) {
                existing = true;
                break;
            }
         }

         Log("Creating profile " $ NameEditBox.GetText());

         if (NameEditBox.GetText() != ""){
            if (existing) {
                return BBGuiController(Controller).SwitchMenu("DOTZMenu.DOTZProfileAlreadyOne");
            } else {
                Log("Creating profile " $ NameEditBox.GetText());
                DOTZPlayerControllerBase(PlayerOwner()).NewProfile(NameEditBox.GetText());

                if (DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName() ==
                    NameEditBox.GetText()){

                    Log("Loaded successfully " $ NameEditBox.GetText());

                    DOTZPlayerControllerBase(PlayerOwner()).SetDifficultyLevel(1);
                    DOTZPlayerControllerBase(PlayerOwner()).SetInvertLook(false);
                    //DOTZPlayerControllerBase(PlayerOwner()).SetVoiceThruSpeakers(false);
                    DOTZPlayerControllerBase(PlayerOwner()).SetVoiceMasking(false);
                    DOTZPlayerControllerBase(PlayerOwner()).SetUseSubtitles(true);
                    DOTZPlayerControllerBase(PlayerOwner()).SetUseVibration(true);
                    DOTZPlayerControllerBase(PlayerOwner()).SetControllerSensitivity(4);
                    //let'em know it worked as far as we can tell
                    bSuccess = true;
                }
                Controller.CloseMenu(false);
            }
         }

    } else {
        Controller.CloseMenu(false);
    }
    return true;
}


/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   if (bSuccess == true){
    Controller.OpenMenu("DOTZMenu.DOTZProfileLoaded");
   } else {
    Controller.OpenMenu("DOTZMenu.DOTZProfileFailed");
   }

}

//DOTZProfileLoaded

/*****************************************************************
 * InternalOnClick
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUIButton Name=cCreateButton
         Caption="Create"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.650000
         WinWidth=0.250000
         WinHeight=0.120000
         __OnClick__Delegate=DOTZNewProfile.InternalOnClick
         Name="cCreateButton"
     End Object
     CreateButton=GUIButton'DOTZMenu.DOTZNewProfile.cCreateButton'
     Begin Object Class=GUIButton Name=cCancelButton
         Caption="Cancel"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.150000
         WinWidth=0.250000
         WinHeight=0.120000
         TabOrder=1
         __OnClick__Delegate=DOTZNewProfile.InternalOnClick
         Name="cCancelButton"
     End Object
     CancelButton=GUIButton'DOTZMenu.DOTZNewProfile.cCancelButton'
     Begin Object Class=BBEditBox Name=cNameEditBox
         AllowedCharSet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
         MaxWidth=15
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.350000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.120000
         Name="cNameEditBox"
     End Object
     NameEditBox=BBEditBox'DOTZMenu.DOTZNewProfile.cNameEditBox'
     msg_string="Enter a name for the new profile:"
     ClickSound=Sound'DOTZXInterface.Select'
}
