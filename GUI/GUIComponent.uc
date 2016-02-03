// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIComponent
//
//	GUIComponents are the most basic building blocks of menus.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIComponent extends GUI
		Native;

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

var		GUIComponent 		MenuOwner;				// Callback to the Component that owns this one
var		eMenuState		MenuState;					// Used to determine the current state of this component

// RenderStyle and MenuColor are usually pulled from the Parent menu, unless specificlly overridden

var(Menu)	string				IniOption;					// Points to the INI option to load for this component
var(Menu)	string				IniDefault;					// The default value for a missing ini option
var(Menu)	string				StyleName;					// Name of my Style
var(Menu)	bool				bBoundToParent;				// Use the Parents Bounds for all positioning
var(Menu)	bool				bScaleToParent;				// Use the Parent for scaling
var(Menu)	bool				bHasFocus;					// Does this component currently have input focus
var(Menu)	bool				bVisible;					// Is this component currently visible
var(Menu)	bool				bAcceptsInput;				// Does this control accept input
var(Menu)	bool				bCaptureTabs;				// This control wants tabs
var(Menu)	bool				bCaptureMouse;				// Set this if the control should capture the mouse when pressed
var(Menu)	bool				bNeverFocus;				// This control should never fully receive focus
var(Menu)	bool				bRepeatClick;				// Have the system accept holding down of the mouse
var(Menu)	bool				bRequireReleaseClick;		// If True, this component wants the click on release even if it's not active
var(Menu)	GUIComponent		FocusInstead;				// Who should get the focus instead of this control if bNeverFocus
var(Menu)	localized string	Hint;						// The hint that gets displayed for this component
var(Menu)	float				WinTop,WinLeft;				// Where does this component exist (in world space) - Grr.. damn Left()
var(Menu)	float				WinWidth,WinHeight;			// Where does this component exist (in world space) - Grr.. damn Left()
var(Menu)	int					MouseCursorIndex;			// The mouse cursor to use when over this control
var(Menu)	bool				bTabStop;					// Does a TAB/Shift-Tab stop here
var(Menu)   int					TabOrder;					// Used to figure out tabbing
var(Menu)	bool				bFocusOnWatch;				// If true, watching focuses
var(Menu)	float				RenderWeight;				// Used to determine sorting in the controls stack
var(Menu)	int					Tag;						// Not used.
var(Menu)	GUILabel			FriendlyLabel;				// My state is projected on this objects state.
var(Menu)	bool				bMouseOverSound;			// Should component bleep when mouse goes over it
var(Menu)	enum				EClickSound
{
	CS_None,
	CS_Click,
	CS_Edit,
	CS_Up,
	CS_Down
} OnClickSound;

// Style holds a pointer to the GUI style of this component.

var			GUIStyles		 Style;						// My GUI Style

// Notes about the Top/Left/Width/Height : This is a somewhat hack but it's really good for functionality.  If
// the value is <=1, then the control is considered to be scaled.  If they are >1 they are considered to be normal world coords.
// 0 = 0, 1 = 100%

var			float		Bounds[4];								// Internal normalized positions in world space
var			float		ClientBounds[4];						// The bounds of the actual client area (minus any borders)

var			bool		bPendingFocus;							// Big big hack for ComboBoxes..

// Timer Support
var const	int			TimerIndex;			// For easier maintenance
var			bool		bTimerRepeat;
var			float		TimerCountdown;
var			float		TimerInterval;

// Used for Saving the last state before drawing natively

var		float 	SaveX,SaveY;
var 	color	SaveColor;
var		font	SaveFont;
var		byte	SaveStyle;

// If you want to override a link to force this component to point to a given
// component on your page, set it here.

// 0 = Up
// 1 = Down
// 2 = Left
// 3 = Right
var GUIComponent LinkOverrides[4];
var GUIComponent Links[4];

// Delegates

// Drawing delegates return true if you want to short-circuit the default drawing code

Delegate bool OnPreDraw(Canvas Canvas);
Delegate bool OnDraw(Canvas Canvas);

Delegate OnActivate();													// Called when the component gains focus
Delegate OnDeActivate();												// Called when the component loses focus
Delegate OnWatch();														// Called when the component is being watched
Delegate OnHitTest(float MouseX, float MouseY);							// Called when Hit test is performed for mouse input
Delegate OnRender(canvas Canvas);										// Called when the component is rendered
Delegate OnMessage(coerce string Msg, float MsgLife); 					// When a message comes down the line

Delegate OnHide();
Delegate OnShow();

Delegate OnInvalidate(GUIComponent Who);	// Called when the background is clicked

// -- Input event delegates

Delegate bool OnClick(GUIComponent Sender);			// The mouse was clicked on this control
Delegate bool OnDblClick(GUIComponent Sender);		// The mouse was double-clicked on this control
Delegate bool OnRightClick(GUIComponent Sender);	// Control was right clicked.

Delegate OnMousePressed(GUIComponent Sender, bool bRepeat);		// Sent when a mouse is pressed (initially)
Delegate OnMouseRelease(GUIComponent Sender);		// Sent when the mouse is released.

Delegate OnChange(GUIComponent Sender);	// Called when a component changes it's value

Delegate bool OnKeyType(out byte Key, optional string Unicode)  	// Key Strokes
{
	return false;
}

Delegate bool OnKeyEvent(out byte Key, out byte State, float delta)
{
	return false;
}

Delegate bool OnCapturedMouseMove(float deltaX, float deltaY)
{
	return false;
}

// Allows a control to process raw Console controller events

Delegate bool OnRawXController(byte Id, out byte Key, out byte State, out float Axis)
{
	return false;
}

Delegate bool OnXControllerEvent(byte Id, eXControllerCodes iCode); // XBox Controller Events


Delegate OnLoadINI(GUIComponent Sender, string s);		// Do the actual work here
Delegate string OnSaveINI(GUIComponent Sender); 		// Do the actual work here

event Opened(GUIComponent Sender);	// Called when the Menu Owner is opened
event Closed(GUIComponent Sender, bool bCancelled);	// Called when the Menu Owner is closed

event Free() 			// This control is no longer needed
{
	MenuOwner 		= None;
    Controller	 	= None;
    FocusInstead 	= None;
    FriendlyLabel 	= None;
    Style			= None;
}

function PlayerController PlayerOwner()
{
	return Controller.ViewportOwner.Actor;
}


event Timer();		// Should be subclassed

function native final SetTimer(float Interval, optional bool bRepeat);
function native final KillTimer();

function string LoadINI()
{
	local string s;

	if ( (PlayerOwner()==None) || (INIOption=="") )
		return "";

	if(!(INIOption~="@INTERNAL"))
		s = PlayerOwner().ConsoleCommand("get"@IniOption);

	if (s=="")
		s = IniDefault;

	OnLoadINI(Self,s);

	return s;
}

function SaveINI(string Value)
{
	local string s;

	if (INIOption=="")
		return;

	if (PlayerOwner()==None)
		return;

	s = OnSaveINI(Self);
	if ( s!="" )
	{
	}
}

function string ParseOption(string URL, string Key, string DefaultVal)
{
	local string s;

	if (PlayerOwner()==None)
		return DefaultVal;

	s = PlayerOwner().Level.Game.ParseOption( URL, Key);
	if (s=="")
		return DefaultVal;
	else
		return s;
}

// Take a string and strip out colour codes
static function string StripColorCodes(string InString)
{
	local int CodePos;

	CodePos = InStr(InString, Chr(27));
	while(CodePos != -1 && CodePos < Len(InString)-3) // ignore colour codes at the end of the string
	{
		InString = Left(InString, CodePos)$Mid(InString, CodePos+4);

		CodePos = InStr(InString, Chr(27));
	}

	return InString;
}

static function string MakeColorCode(color NewColor)
{
	// Text colours use 1 as 0.
	if(NewColor.R == 0)
		NewColor.R = 1;

	if(NewColor.G == 0)
		NewColor.G = 1;

	if(NewColor.B == 0)
		NewColor.B = 1;

	return Chr(0x1B)$Chr(NewColor.R)$Chr(NewColor.G)$Chr(NewColor.B);
}

// Functions

event MenuStateChange(eMenuState Newstate)
{

	// Check for never focus

	bPendingFocus=false;

	if (NewState==MSAT_Focused && bNeverFocus)
		NewState = MSAT_Blurry;

	MenuState = NewState;

	switch (MenuState)
	{
		case MSAT_Blurry:
			bHasFocus = false;
			OnDeActivate();
			break;

		case MSAT_Watched:

			if (bFocusOnWatch)
			{
				SetFocus(None);
				return;
			}

			OnWatch();
			break;

		case MSAT_Focused:
			bHasFocus = true;
			OnActivate();
			break;

	}

	if (FriendlyLabel!=None)
		FriendlyLabel.MenuState=MenuState;

}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{

	Controller = MyController;
	MenuOwner = MyOwner;

	Style = Controller.GetStyle(StyleName);
}

function InitDelegates();

function bool IsInBounds()	// Script version of PerformHitTest
{
	return ( (Controller.MouseX >= Bounds[0] && Controller.MouseX<=Bounds[2]) && (Controller.MouseY >= Bounds[1] && Controller.MouseY <=Bounds[3]) );
}

function bool IsInClientBounds()
{
	return ( (Controller.MouseX >= ClientBounds[0] && Controller.MouseX<=ClientBounds[2]) && (Controller.MouseY >= ClientBounds[1] && Controller.MouseY <=ClientBounds[3]) );
}

event SetFocus(GUIComponent Who)
{
	if (bNeverFocus)
	{
		if (FocusInstead != None)
			FocusInstead.SetFocus(Who);

		return;
	}

	MenuStateChange(MSAT_Focused);

	if (Controller.FocusedControl!=None)
    {
    	if  (Controller.FocusedControl == Self)	// Already Focused
			return;
        else
			Controller.FocusedControl.LoseFocus(None);
	}

	bPendingFocus = true;

	Controller.FocusedControl = self;

	if (MenuOwner!=None)
		MenuOwner.SetFocus(self);
}

event LoseFocus(GUIComponent Sender)
{
	if (Controller!=None)
		Controller.FocusedControl = None;

	MenuStateChange(MSAT_Blurry);

	if (MenuOwner!=None)
		MenuOwner.LoseFocus(Self);
}

event bool FocusFirst(GUIComponent Sender)	// Focus your first child, or yourself if no childrean
{

	if ( (!bVisible) || (bNeverFocus) || (MenuState==MSAT_Disabled) || (!bTabStop) )
		return false;

	return true;
}

event bool FocusLast(GUIComponent Sender) // Focus your last child, or yourself
{
	if ( (!bVisible) || (bNeverFocus) || (MenuState==MSAT_Disabled) || (!bTabStop) )
		return false;

	SetFocus(None);
	return true;
}

event bool NextControl(GUIComponent Sender)
{
	if (MenuOwner!=None)
		return MenuOwner.NextControl(Self);

	return false;
}

event bool PrevControl(GUIComponent Sender)
{
	if (MenuOwner!=None)
		return MenuOwner.PrevControl(Self);

	return false;
}

event bool NextPage()
{
	if (MenuOwner != None)
		return MenuOwner.NextPage();

	return false;
}

event bool PrevPage()
{
	if (MenuOwner != None)
		return MenuOwner.PrevPage();

	return false;
}

// Force control to use same area as its MenuOwner.
function FillOwner()
{
	WinLeft = 0.0;
	WinTop = 0.0;
	WinWidth = 1.0;
	WinHeight = 1.0;
	bScaleToParent = true;
	bBoundToParent = true;
}

event SetVisibility(bool bIsVisible)
{
	bVisible = bIsVisible;

    if (bVisible)
    	OnShow();
    else
    	OnHide();
}

event Hide()
{
	SetVisibility(false);
}

event Show()
{
	SetVisibility(true);
}

function SetFriendlyLabel(GUILabel NewLabel)
{
	FriendlyLabel = NewLabel;
}

function SetHint(string NewHint)
{
	Hint = NewHint;
}

function SetLinks(GUIComponent cUp,GUIComponent cDown,GUIComponent cLeft,GUIComponent cRight)
{
	Links[0] = cUp;
    Links[1] = cDown;
    Links[2] = cLeft;
    Links[3] = cRight;
}

function SetLinkOverrides(GUIComponent cUp,GUIComponent cDown,GUIComponent cLeft,GUIComponent cRight)
{
	LinkOverrides[0] = cUp;
    LinkOverrides[1] = cDown;
    LinkOverrides[2] = cLeft;
    LinkOverrides[3] = cRight;
}


// The ActualXXXX functions are not viable until after the first render so don't
// use them in inits
native function float ActualWidth();
native function float ActualHeight();
native function float ActualLeft();
native function Float ActualTop();

cpptext
{
		virtual void PreDraw(UCanvas *Canvas);	// Should be overridden in a subclass
		virtual void Draw(UCanvas* Canvas);		// Should be overridden in a subclass

		virtual UBOOL PerformHitTest(INT MouseX, INT MouseY);					// Check to see if a mouse press affects the control
		virtual void  UpdateBounds();											// Updates the Bounds for hit tests and such
		virtual FLOAT ActualWidth();											// Returns the actual width (including scaling) of a component
		virtual FLOAT ActualHeight();											// Returns the actual height (including scaling) of a component
		virtual FLOAT ActualLeft();												// Returns the actual left (including scaling) of a component
		virtual FLOAT ActualTop();												// Returns the actual top (including scaling) of a component
		virtual void  SaveCanvasState(UCanvas* Canvas);							// Save the current state of the canvas
		virtual void  RestoreCanvasState(UCanvas* Canvas);						// Restores the state of the canvas

		virtual UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

		virtual UBOOL MouseMove(INT XDelta, INT YDelta);			// The Mouse has moved
		virtual UBOOL MousePressed(UBOOL IsRepeat);					// The Mouse was pressed
		virtual UBOOL MouseReleased();								// The Mouse was released
		virtual UBOOL MouseHover();									// The Mouse is over a non-pressed thing

		virtual UBOOL NativeKeyType(BYTE& iKey, TCHAR Unicode );				// Handle key presses
		virtual UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta);	// Handle key events

		virtual void SetDims(FLOAT Width, FLOAT Height, FLOAT Left, FLOAT Top);	// Set the dims quickly
		virtual void  CloneDims(UGUIComponent* From);	// Clones the Width,Height, Top, Left settings

		virtual UBOOL SpecialHit();
		virtual void  NativeInvalidate(UGUIComponent* Who);
        virtual UBOOL XControllerEvent(int Id, eXControllerCodes iCode);
        virtual UBOOL RawXController(int Id, BYTE& iKey, BYTE& State, FLOAT Axis);

}


defaultproperties
{
     bVisible=True
     WinWidth=1.000000
     RenderWeight=0.500000
     Tag=-1
     TimerIndex=-1
}
