// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIScrollBarBase
//  Parent: GUI.GUIMultiComponent
//
//  <Enter a description here>
// ====================================================================

class GUIScrollBarBase extends GUIMultiComponent
		Native;

var		GUIListBase		MyList;			// The list this Scrollbar is attached to

function UpdateGripPosition(float NewPos);
function MoveGripBy(int items);
event AlignThumb();

function Refocus(GUIComponent Who)
{
	local int i;
	
	if (Who != None && Controls.Length > 0)
		for (i=0;i<Controls.Length;i++)
	    {
	    	Controls[i].FocusInstead = Who;
	        Controls[i].bNeverFocus=true;
	    }
}

defaultproperties
{
     PropagateVisibility=True
     bTabStop=False
}
