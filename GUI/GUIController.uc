// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  Engine.GUIController
//
//  The GUIController is a simple FILO menu stack.  You have 3 things
//  you can do.  You can Open a menu which adds the menu to the top of the
//  stack.  You can Replace a menu which replaces the current menu with the
//  new menu.  And you can close a menu, which returns you to the last menu
//  on the stack.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIController extends BaseGUIController
		Native;

#exec OBJ LOAD FILE=GUIContent.utx

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var	editinline export	array<GUIPage>		MenuStack;			// Holds the stack of menus
var						GUIPage				ActivePage;			// Points to the currently active page
var editinline 			Array<GUIFont>		FontStack;			// Holds all the possible fonts
var 					Array<GUIStyles>	StyleStack;			// Holds all of the possible styles
var						Array<string>		StyleNames;			// Holds the name of all styles to use
var editinline 			Array<Material>		MouseCursors;		// Holds a list of all possible mouse
var editinline			Array<vector>		MouseCursorOffset;  // Only X,Y used, between 0 and 1. 'Hot Spot' of cursor material.
var						Array<GUIPage>		PersistentStack;	// Holds the set of pages which are persistent across close/open

var						byte				ControllerMask;		// Used to mask input for various Controllers
var						byte				ControllerId;		// The current Controller ID #
var						float				MouseX,MouseY;		// Where is the mouse currently located

var						float				LastMouseX, LastMouseY;

var						bool				ShiftPressed;		// Shift key is being held
var						bool				AltPressed;			// Alt key is being held
var						bool				CtrlPressed;		// Ctrl key is being held


var						float				DblClickWindow;			// How long do you have for a double click
var						float				LastClickTime;			// When did the last click occur
var						int					LastClickX,LastClickY;	// Who was the active component

var						float				ButtonRepeatDelay;		// The amount of delay for faking button repeats
var						byte				RepeatKey[4];			// Used to determine what should repeat
var						float				RepeatDelta[4];			// Data var
var						float				RepeatTime[4];			// How long until the next repeat;
var						float				CursorFade;				// How visible is the cursor
var						int					CursorStep;				// Are we fading in or out

var						float				FastCursorFade;			// How visible is the cursor
var						int					FastCursorStep;			// Are we fading in or out

var						GUIComponent		FocusedControl;			// Top most Focused control
var						GUIComponent 		ActiveControl;			// Which control is currently active
var						GUIComponent		SkipControl;			// This control should be skipped over and drawn at the end
var						GUIComponent		MoveControl;			// Used for visual design

var						bool				bIgnoreNextRelease;		// Used to make sure discard errant releases.

var config				bool 				bModAuthor;				// Allows bDesign Mode
var 					bool				bDesignMode;			// Are we in design mode;
var						bool				bHighlightCurrent;		// Highlight the current control being edited


var						bool				bCurMenuInitialized;	// Has the current Menu Finished initialization

var						string				GameResolution;
var config				float				MenuMouseSens;

var						bool				MainNotWanted;			// Set to true if you don't want main to appear.

// Sounds
var						sound				MouseOverSound;
var						sound				ClickSound;
var						sound				EditSound;
var						sound				UpSound;
var						sound				DownSound;

var						bool				bForceMouseCheck;		// HACK
var						bool				bIgnoreUntilPress;		// HACK

var	config				array<string>		AutoLoad;	// Any menu classes in here will be automatically loaded


// Joystick/JoyPad/Console Specific

var	config	bool	bEmulatedJoypad;	// Have the cursor keys emulate a XBox controller
var	config	bool	bJoyMouse;			// When true, right control stick acts as a 1 button mouse
var config  bool	bHideMouseCursor;	// When true, the mouse cursor will be hidden
var config  float	JoyDeadZone;		// The DeadZone for joysticks

var		Float	JoyLeftXAxis[4];
var		Float 	JoyLeftYAxis[4];
var		Float	JoyRightXAxis[4];
var		Float	JoyRightYAxis[4];
var		Byte	JoyButtons[64];

var float JoyControlsDelta[16];	// How long since a joystick was converted



// Temporary for Design Mode
var Material WhiteBorder;

native event GUIFont GetMenuFont(string FontName); 	// Finds a given font in the FontStack
native event GUIStyles GetStyle(string StyleName); 	// Find a style on the stack
native function string GetCurrentRes();				// Returns the current res as a string
native function string GetMainMenuClass();			// Returns GameEngine.MainMenuClass

// Utility functions for the UI

native function GetMapList(string Prefix, GUIList list);

native function ResetKeyboard();
native function MouseEmulation(bool On);

delegate bool OnNeedRawKeyPress(byte NewKey);

// ================================================
// CreateMenu - Attempts to Create a menu.  Returns none if it can't

event GUIPage CreateMenu(string NewMenuName)
{
	local class<GUIPage> NewMenuClass;
	local GUIPage NewMenu;
	local int i;

	// Load the menu's package if needed

	NewMenuClass = class<GUIPage>(DynamicLoadObject(NewMenuName,class'class'));
	if (NewMenuClass != None)
	{
		// If it's persistent, try to find an instance in the PersistentStack.
		if( NewMenuClass.default.bPersistent )
		{
			for( i=0;i<PersistentStack.Length;i++ )
            {
				if( PersistentStack[i].Class == NewMenuClass )
				{
					NewMenu = PersistentStack[i];
					break;
				}
            }
		}

		// Not found, spawn a new menu
		if( NewMenu == None )
		{
			NewMenu = new(None) NewMenuClass;

			// Check for errors
			if (NewMenu == None)
			{
				log("Could not create requested menu"@NewMenuName);
				return None;
			}
			else
			if( NewMenuClass.default.bPersistent )
			{
				// Save in PersistentStack if it's persistent.
				i = PersistentStack.Length;
				PersistentStack.Length = i+1;
				PersistentStack[i] = NewMenu;
			}
		}
		return NewMenu;
	}
	else
	{
		log("Could not DLO menu '"$NewMenuName$"'");
		return none;
	}

}
// ================================================
// OpenMenu - Opens a new menu and places it on top of the stack



event bool OpenMenu(string NewMenuName, optional string Param1, optional string Param2)
{
	local GUIPage NewMenu,CurMenu;

	// Sanity Check

	//log("GUIController::OpenMenu - Attempt to open menu ["$NewMenuName$"]");
	//log("GUIController::MenuMouseSens="$MenuMouseSens);

	NewMenu = CreateMenu(NewMenuName);

	bCurMenuInitialized=false;
	if (NewMenu!=None)
	{

		CurMenu = ActivePage;

		NewMenu.ParentPage = CurMenu;

		// Add this menu to the stack and give it focus

		MenuStack.Length = MenuStack.Length+1;
		MenuStack[MenuStack.Length-1] = NewMenu;

		ActivePage = NewMenu;

		ResetFocus();

		// If not persistent, Initialize this Menu

        if (NewMenu.Controller == None)
			NewMenu.InitComponent(Self, none);

		// Remove focus from the last menu

		if (CurMenu!=None)
		{
			CurMenu.MenuState = MSAT_Blurry;
			CurMenu.OnDeActivate();
		}

		NewMenu.CheckResolution(false);
		NewMenu.Opened(None);	// Pass along the event
		NewMenu.MenuState = MSAT_Focused;
		NewMenu.PlayOpenSound();

		SetControllerStatus(true);
		bCurMenuInitialized=true;

		NewMenu.HandleParameters(Param1, Param2);

		bForceMouseCheck = true;

        if (NewMenu.bDisconnectOnOpen)
        {
        	ConsoleCommand("disconnect");
        }

		return true;
	}
	else
	{
		log("Could not open menu"@NewMenuName);
		return false;
	}
}

event AutoLoadMenus()
{
	local GUIPage NewMenu;
    local int i;

    super.AutoLoadMenus();

    for (i=0;i<AutoLoad.Length;i++)
	{
    	NewMenu = CreateMenu(AutoLoad[i]);
		if (NewMenu==None)
        	log("Could not auto-load"@AutoLoad[i]);
	}
}

// ================================================
// Replaces a menu in the stack.  returns true if success

event bool ReplaceMenu(string NewMenuName, optional string Param1, optional string Param2)
{
	local GUIPage NewMenu,CurMenu;

	NewMenu = CreateMenu(NewMenuName);
	bCurMenuInitialized=false;
	if (NewMenu!=None)
	{
		CurMenu = ActivePage;

		// Add this menu to the stack and give it focus

		NewMenu.MenuState = MSAT_Focused;

		if (CurMenu==None)
			MenuStack.Length = MenuStack.Length+1;
        else
       		CurMenu.OnClose(false);

		MenuStack[MenuStack.Length-1] = NewMenu;
		ActivePage = NewMenu;
		NewMenu.ParentPage = CurMenu.ParentPage;

		ResetFocus();

        if (NewMenu.Controller == None)
			NewMenu.InitComponent(Self, None);

		NewMenu.CheckResolution(false);
		NewMenu.Opened(None);						// Pass along the event
		NewMenu.MenuState = MSAT_Focused;
		NewMenu.OnActivate();
		NewMenu.PlayOpenSound();

		SetControllerStatus(true);
		bCurMenuInitialized=true;

		NewMenu.HandleParameters(Param1, Param2);
		bForceMouseCheck = true;

        if (CurMenu!=None) // Close out the current page
        {
		    CurMenu.ParentPage=None;

	        if (!CurMenu.bPersistent)       // keep access to the controller if we are not up
	            CurMenu.Free();
        }


		return true;
	}
	else
		return false;
}

event bool CloseMenu(optional bool bCanceled)	// Close the top menu.  returns true if success.
{

	local GUIPage CurMenu;
	local int 	  CurIndex;

	if (MenuStack.Length <= 0)
	{
		log("Attempting to close a non-existing menu page");
		return false;
	}

	CurIndex = MenuStack.Length-1;
	CurMenu = MenuStack[CurIndex];

	log("GUIController::CloseMenu - "@CurMenu);

	// Remove the menu from the stack
	MenuStack.Remove(MenuStack.Length-1,1);

	// Look for the resolution switch

	CurMenu.PlayCloseSound();		// Play the closing sound
	CurMenu.Closed(None,bCanceled);

    CurMenu.ParentPage=None;

	if (!CurMenu.bPersistent)		// keep access to the controller if we are not up
		CurMenu.Free();				// Free up this menu

	MoveControl = None;
	SkipControl = None;

	// Gab the next page on the stack
	bCurMenuInitialized=false;
	if (MenuStack.Length>0)	// Pass control back to the previous menu
	{
		ActivePage = MenuStack[MenuStack.Length-1];
		ActivePage.MenuState = MSAT_Focused;
		ActivePage.CheckResolution(true);

		ActivePage.Opened(none);
		ActivePage.OnActivate();

		ActiveControl = none;

		ActivePage.FocusFirst(None);
	}
	else
	{

		if (!CurMenu.bAllowedAsLast)
		{
			OpenMenu(GetMainMenuClass());
			return true;
		}

		ActivePage = None;
 		SetControllerStatus(false);
	}

	bCurMenuInitialized=true;

	bForceMouseCheck = true;

	return true;
}

function bool CloseTo (name menu)
{
    while (!self.TopPage().IsA(menu) && MenuStack.Length>0)
        CloseMenu(false);
    return true;
}

function GUIPage TopPage()
{
	return ActivePage;
}

function bool CheckExists (name menu)
{
    local int i;

    for (i = 0; i < MenuStack.Length; ++i)
        if (self.MenuStack[i].IsA(menu))
            return true;

    return false;
}

function SetControllerStatus(bool On)
{
	bActive = On;
	bVisible = On;
	bRequiresTick=On;

	// Attempt to Pause as well as show the windows mouse cursor.

//	ViewportOwner.Actor.Level.Game.SetPause(On, ViewportOwner.Actor);
	ViewportOwner.bShowWindowsMouse=On;

	// Add code to pause/unpause/hide/etc the game here.

	if (On)
		bIgnoreUntilPress = true;
	else
		ViewportOwner.Actor.ConsoleCommand("toggleime 0");
}


event CloseAll(bool bCancel)
{
	local int i;

	// Close the current menu manually before we clean up the stack.
	if( MenuStack.Length >= 0 )
	{
		if ( !CloseMenu(bCancel) )
			return;
	}

	for (i=0;i<MenuStack.Length;i++)
	{
		MenuStack[i].CheckResolution(true);
        MenuStack[i].ParentPage = None;

    	if (!MenuStack[i].bPersistent)
        	MenuStack[i].Free();

		MenuStack[i] = None;
	}

	if (GameResolution!="")
	{
		ViewportOwner.Actor.ConsoleCommand("SETRES"@GameResolution);
		GameResolution="";
	}


    ActivePage=None;
	MenuStack.Remove(0,MenuStack.Length);
	SetControllerStatus(false);

}

event InitializeController()
{
	local int i;
	local class<GUIStyles> NewStyleClass;

	for (i=0;i<StyleNames.Length;i++)
	{
		NewStyleClass = class<GUIStyles>(DynamicLoadObject(StyleNames[i],class'class'));

		if (NewStyleClass != None)
			if (!RegisterStyle(NewStyleClass))
				log("Could not create requested style"@StyleNames[i]);

	}
}

function bool RegisterStyle(class<GUIStyles> StyleClass)
{
local GUIStyles NewStyle;

	if (StyleClass != None && !StyleClass.default.bRegistered)
	{
		NewStyle = new(None) StyleClass;

		// Check for errors

		if (NewStyle != None)
		{
			// Dynamic Array Auto Sizes StyleStack.
			StyleStack[StyleStack.Length] = NewStyle;
			NewStyle.Controller = self;
			NewStyle.Initialize();
			return true;
		}
	}
	return false;
}

event ChangeFocus(GUIComponent Who)
{
	return;
}

function ResetFocus()
{
	local int i;

	if (ActiveControl!=None)
	{
		ActiveControl.MenuStateChange(MSAT_Blurry);
		ActiveControl=None;
	}

    for (i=0;i<4;i++)
    {
		RepeatKey[i]=0;
		RepeatTime[i]=0;
    }
}

event MoveFocused(GUIComponent Ctrl, int bmLeft, int bmTop, int bmWidth, int bmHeight, float ClipX, float ClipY)
{
	local float val;


	if (AltPressed)
		val = 5;
	else
		val = 1;

	if (bmLeft!=0)
	{
		if (Ctrl.WinLeft<1)
			Ctrl.WinLeft = Ctrl.WinLeft + ( (Val/ClipX) * bmLeft);
		else
			Ctrl.WinLeft += (Val*bmLeft);
	}

	if (bmTop!=0)
	{
		if (Ctrl.WinTop<1)
			Ctrl.WinTop = Ctrl.WinTop + ( (Val/ClipY) * bmTop);
		else
			Ctrl.WinTop+= (Val*bmTop);
	}

	if (bmWidth!=0)
	{
		if (Ctrl.WinWidth<1)
			Ctrl.WinWidth = Ctrl.WinWidth + ( (Val/ClipX) * bmWidth);
		else
			Ctrl.WinWidth += (Val*bmWidth);
	}

	if (bmHeight!=0)
	{
		if (Ctrl.WinHeight<1)
			Ctrl.WinHeight = Ctrl.WinHeight + ( (Val/ClipX) * bmHeight);
		else
			Ctrl.WinHeight += (Val*bmHeight);
	}
}

function bool HasMouseMoved()
{
	if (MouseX==LastMouseX && MouseY==LastMouseY)
		return false;
	else
		return true;
}

event bool NeedsMenuResolution()
{

	if ( (ActivePage!=None) && (ActivePage.bRequire640x480) )
		return true;
	else
		return false;
}

event SetRequiredGameResolution(string GameRes)
{
	GameResolution = GameRes;
}

event NotifyLevelChange()
{
	local int i;

    for (i=0;i<MenuStack.Length;i++)
    	MenuStack[i].NotifyLevelChange();
}

cpptext
{
		void  NativeMessage(const FString Msg, FLOAT MsgLife);
		UBOOL NativeKeyType(BYTE& iKey, TCHAR Unicode );
		UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta );
		void  NativeTick(FLOAT DeltaTime);
		void  NativePreRender(UCanvas* Canvas);
		void  NativePostRender(UCanvas* Canvas);

		virtual void LookUnderCursor(FLOAT dX, FLOAT dY);
		UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

		UBOOL virtual MousePressed(UBOOL IsRepeat);
		UBOOL virtual MouseReleased();

		UBOOL HasMouseMoved();

		void PlayInterfaceSound(USound* sound);
		void PlayClickSound(BYTE SoundNum);

}


defaultproperties
{
     FontStack(0)=fntMenuFont'GUI.GUIController.GUIMenuFont'
     FontStack(1)=fntDefaultFont'GUI.GUIController.GUIDefaultFont'
     FontStack(2)=fntLargeFont'GUI.GUIController.GUILargeFont'
     FontStack(3)=fntHeaderFont'GUI.GUIController.GUIHeaderFont'
     FontStack(4)=fntSmallFont'GUI.GUIController.GUISmallFont'
     FontStack(5)=fntSmallHeaderFont'GUI.GUIController.GUISmallHeaderFont'
     StyleNames(0)="GUI.STY_RoundButton"
     StyleNames(1)="GUI.STY_RoundScaledButton"
     StyleNames(2)="GUI.STY_SquareButton"
     StyleNames(3)="GUI.STY_ListBox"
     StyleNames(4)="GUI.STY_ScrollZone"
     StyleNames(5)="GUI.STY_TextButton"
     StyleNames(6)="GUI.STY_Header"
     StyleNames(7)="GUI.STY_Footer"
     StyleNames(8)="GUI.STY_TabButton"
     StyleNames(9)="GUI.STY_NoBackground"
     StyleNames(10)="GUI.STY_SliderCaption"
     StyleNames(11)="GUI.STY_SquareBar"
     StyleNames(12)="GUI.STY_TextLabel"
     StyleNames(13)="GUI.STY_ComboListBox"
     MouseCursors(0)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(1)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(2)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(3)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(4)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(5)=Texture'GUIContent.Menu.MouseCursor'
     MouseCursors(6)=Texture'GUIContent.Menu.MouseCursor'
     ControllerMask=255
     DblClickWindow=0.500000
     ButtonRepeatDelay=0.250000
     CursorStep=1
     FastCursorStep=1
     bHighlightCurrent=True
     MenuMouseSens=1.000000
     JoyDeadZone=0.300000
     WhiteBorder=Texture'GUIContent.Menu.WhiteBorder'
}
