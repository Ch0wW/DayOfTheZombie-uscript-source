// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZRecordingVoiceMail extends XDOTZErrorPage;

var sound ClickSound;

var Automated GUIImage   BarFront;

// Error string
var localized string error_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   SetErrorCaption(error_string);
   AddSelectButton (accept_string);

   class'UtilsXbox'.static.VoiceChat_Record_Voice_Mail();
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    class'UtilsXbox'.static.VoiceChat_Stop_Voice_Mail();
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    class'UtilsXbox'.static.VoiceChat_Stop_Voice_Mail();
}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    local bool voice_stopped;
    local float bar_width;

    voice_stopped = class'UtilsXbox'.static.VoiceChat_Is_Stopped();
    if (voice_stopped) {
        Controller.CloseMenu(true);
    }

    bar_width = class'UtilsXbox'.static.VoiceChat_Get_Voice_Mail_Time() / 15.0 * 0.8;
    if (bar_width > 0.8)
        bar_width = 0.8;

    Log ("Bar Width " $ bar_width);

    BarFront.WinWidth = bar_width;
}

/*****************************************************************
 * default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     Begin Object Class=GUIImage Name=BarFront_icn
         Image=Texture'BBTGuiContent.General.SquareBox_Watched'
         ImageStyle=ISTY_Stretched
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.450000
         WinLeft=0.100000
         WinWidth=0.000000
         WinHeight=0.050000
         RenderWeight=0.500000
         Name="BarFront_icn"
     End Object
     BarFront=GUIImage'DOTZMenu.XDOTZRecordingVoiceMail.BarFront_icn'
     error_string="Recording Voice Mail attachment. Press B to cancel."
     period=0.100000
     __OnKeyEvent__Delegate=XDOTZRecordingVoiceMail.HandleKeyEvent
}
