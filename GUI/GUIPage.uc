// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIPage
//
//	GUIPages are the base for a full page menu.  They contain the
//	Control stack for the page.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIPage extends GUIMultiComponent
	Native 	Abstract;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Variables

var(Menu)   					Material				Background;			// The background image for the menu
var(Menu)						Color					BackgroundColor;	// The color of the background
var(Menu)						Color					InactiveFadeColor;	// Color Modulation for Inactive Page
var(Menu)						EMenuRenderStyle		BackgroundRStyle;
var(Menu)						bool					bRenderWorld;		// Should this menu hide the world
var(Menu)						bool					bPauseIfPossible;	// Should this menu pause the game if possible
var(Menu)						bool					bCheckResolution;	// If true, the menu will be force to run at least 640x480
var(Menu)						Sound					OpenSound;			// Sound to play when opened
var(Menu)						Sound					CloseSound;			// Sound to play when closed


var								bool					bRequire640x480;	// Does this menu require at least 640x480
var								bool					bPersistent;		// If set in defprops, page is saved across open/close/reopen.

var								GUIPage					ParentPage;			// The page that exists before this one
var	const						array<GUIComponent>		Timers;				// List of components with Active Timers
var 							bool					bAllowedAsLast;		// If this is true, closing this page will not bring up the main menu
																			// if last on the stack.

var								bool					bDisconnectOnOpen;	// Should this menu for a disconnect when opened.


// Delegates

delegate OnOpen()
{
	PageLoadINI();
}

delegate bool OnCanClose(optional Bool bCancelled)
{
	return true;
}

delegate OnClose(optional Bool bCancelled)
{
	if (!bCancelled)
		PageSaveINI();
}

event Opened(GUIComponent Sender)
{
	Super.Opened(Sender);
    OnOpen();
}

event Closed(GUIComponent Sender, bool bCancelled)
{
	Super.Closed(Sender, bCancelled);
    OnClose(bCancelled);
}


function PageLoadINI()
{
	local int i;

	for (i=0;i<Controls.Length;i++)
		Controls[i].LoadINI();

	return;
}

function PageSaveINI()
{
	local int i;

	for (i=0;i<Controls.Length;i++)
		Controls[i].SaveINI("");
}

//=================================================
// PlayOpenSound / PlayerClosedSound

function PlayOpenSound()
{
	PlayerOwner().PlayOwnedSound(OpenSound,SLOT_Interface,1.0);
}

function PlayCloseSound()
{
	PlayerOwner().PlayOwnedSound(CloseSound,SLOT_Interface,1.0);
}


//=================================================
// InitComponent is responsible for initializing all components on the page.

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	MapControls();		// Figure out links

    FocusFirst(none);
}

//=================================================
// CheckResolution - Tests to see if this menu requires a resoltuion of at least 640x480 and if so, switches

function CheckResolution(bool Closing)
{
	local string CurrentRes;
	local int I,X,Y;

	if (!Closing)
	{
		CurrentRes = PlayerOwner().ConsoleCommand( "GETCURRENTRES" );
	    I = InStr( CurrentRes, "x" );
	    if( i > 0 )
	    {
			X = int( Left ( CurrentRes, i )  );
			Y = int( Mid( CurrentRes, i+1 ) );
	    }
		else
		{
			log("Couldn't parse GetCurrentRes call");
			return;
		}
		if ( ( (x<640) || (y<480) ) && (bRequire640x480) )
		{
			Controller.GameResolution = CurrentRes;
			PlayerOwner().ConsoleCommand("TEMPSETRES 640x480");
		}

		return;

	}

	if ( (bRequire640x480) || (Controller.GameResolution=="") )
		return;

	CurrentRes = PlayerOwner().ConsoleCommand( "GETCURRENTRES" );
	if (CurrentRes != Controller.GameResolution)
	{
		PlayerOwner().Player.Console.ConsoleCommand("SETRES"@Controller.GameResolution);
		Controller.GameResolution = "";
	}

}

event ChangeHint(string NewHint)
{
	Hint = NewHint;
}

event MenuStateChange(eMenuState Newstate)
{
	Super(GUIComponent).MenuStateChange(NewState);	// Skip the Multicomp's state change
}

event SetFocus(GUIComponent Who)
{
	if (Who==None)
		return;

	Super.SetFocus(Who);
}

event HandleParameters(string Param1, string Param2);	// Should be subclassed
event NotifyLevelChange();

event Free() 			// This control is no longer needed
{
	local int i;
    for (i=0;i<Timers.Length;i++)
    	Timers[i]=None;

    Super.Free();
}

cpptext
{
		void Draw(UCanvas* Canvas);
		UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta );
		void UpdateTimers(float DeltaTime);
		UBOOL PerformHitTest(INT MouseX, INT MouseY);
		UBOOL MousePressed(UBOOL IsRepeat);					// The Mouse was pressed
		UBOOL MouseReleased();								// The Mouse was released

        UBOOL XControllerEvent(int Id, eXControllerCodes iCode);


}


defaultproperties
{
     BackgroundColor=(B=255,G=255,R=255,A=255)
     InactiveFadeColor=(B=128,G=128,R=128,A=255)
     BackgroundRStyle=MSTY_Normal
     bRequire640x480=True
     bAcceptsInput=True
     bTabStop=False
}
