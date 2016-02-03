// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLivePasswordCross extends XDOTZLivePassword;

defaultproperties
{
     ErrorMenu="DOTZMenu.XDOTZLiveErrorCross"
     SigningInMenu="DOTZMenu.XDOTZLiveSigningInCross"
     __OnKeyEvent__Delegate=XDOTZLivePasswordCross.HandleKeyEvent
}
