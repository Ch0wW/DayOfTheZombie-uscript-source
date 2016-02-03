// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveSigningInCross extends XDOTZLiveSigningIn;

defaultproperties
{
     MultiplayerMenu="DOTZMenu.XDOTZLiveGettingMatchCross"
     ErrorMenu="DOTZMenu.XDOTZLiveErrorCross"
     __OnKeyEvent__Delegate=XDOTZLiveSigningInCross.HandleKeyEvent
}
