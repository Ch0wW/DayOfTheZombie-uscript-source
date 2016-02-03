// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  UPreview.UPreviewRootWindow
//  Parent: UWindow.UWindowRootWindow
//
//  <Enter a description here>
// ====================================================================

class UPreviewRootWindow extends UWindowRootWindow;

var UPreviewMapListClient MapWindow;				

function Created() 
{
	Super.Created();

	MapWindow = UPreviewMapListClient(CreateWindow(class'UPreviewMapListClient', 0, 0, 512, 480));
	MapWindow.HideWindow();
	
}

function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
{ 
	if ( (Action == IST_Press) && ( (Key == IK_Joy5) || (Key == IK_Space) ))
	{
		bAllowConsole=false;
		GotoState('UWindows');
		return true;
	}
	
	return Super.KeyEvent(Key,Action,Delta);
}

state UWindows
{
	function BeginState()
	{
		if (!bAllowConsole)
			MapWindow.ShowWindow();			

		Super.BeginState();
		ViewportOwner.Actor.SetPause( False );
			
	}
	
	function EndState()
	{
		MapWindow.HideWindow();
		Super.EndState();			
	}

}	

defaultproperties
{
     LookAndFeelClass="UDebugMenu.UDebugBlueLookAndFeel"
}
