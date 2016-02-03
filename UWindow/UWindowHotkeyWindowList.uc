// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UWindowHotkeyWindowList extends UWindowList;


var UWindowWindow		Window;


function UWindowHotkeyWindowList FindWindow(UWindowWindow W)
{
	local UWindowHotkeyWindowList l;

	l = UWindowHotkeyWindowList(Next);
	while(l != None) 
	{
		if(l.Window == W) return l;
		l = UWindowHotkeyWindowList(l.Next);
	}
	return None;
}

defaultproperties
{
}
