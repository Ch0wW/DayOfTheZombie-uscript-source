// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveSignInCross extends XDOTZLiveSignIn;

defaultproperties
{
     PasswordMenu="DOTZMenu.XDOTZLivePasswordCross"
     ErrorMenu="DOTZMenu.XDOTZLiveErrorCross"
     SigningInMenu="DOTZMenu.XDOTZLiveSigningInCross"
     __OnKeyEvent__Delegate=XDOTZLiveSignInCross.HandleKeyEvent
}
