// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZProfileSelectForce extends XDOTZProfileSelect;

/*****************************************************************
 * Add buttons
 *****************************************************************
 */

function AddButtons () {
   AddSelectButton ();
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{

}

/*****************************************************************
 *****************************************************************
 */

defaultproperties
{
     __OnKeyEvent__Delegate=XDOTZProfileSelectForce.HandleKeyEvent
}
