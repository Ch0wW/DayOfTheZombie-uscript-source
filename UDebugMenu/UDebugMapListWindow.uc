// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UDebugMapListWindow extends UWindowFramedWindow;


function Created() 
{
	bSizable = True;
	MinWinWidth = 200;
	Super.Created();
}

defaultproperties
{
     ClientClass=Class'UDebugMenu.UDebugMapListCW'
     WindowTitle="Select a Map..."
}
