// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveComplaintBadName extends XDOTZLiveComplaintConfirmBase;

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
/*
    GREAT_SESSION = 0
	GOOD_ATTITUDE = 1
	BAD_NAME = 2
	CURSING = 3
	SCREAMING = 4
	CHEATING = 5
	THREATS = 6
*/
    class'UtilsXbox'.static.Friends_Send_Feedback(Gamertag, Xuid, 2);
    BBGuiController(Controller).CloseTo ('XDOTZLivePlayerSelectIG');
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     __OnKeyEvent__Delegate=XDOTZLiveComplaintBadName.HandleKeyEvent
}
