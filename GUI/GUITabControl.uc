// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//	GUITabControl - This control has a number of tabs
//
//  Written by Joe Wilcox
//  (c) 2003, Epic Games, Inc.  All Rights Reserved
//
//	Modified by Ron Prestenback
// ====================================================================

class GUITabControl extends GUIMultiComponent
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

var(Menu)	bool				bDockPanels;		// If true, associated panels will dock vertically with this control

var			array<GUITabButton> TabStack;
var			GUITabButton		ActiveTab;

var			string				BackgroundStyleName;
var			GUIStyles			BackgroundStyle;
var			Material			BackgroundImage;
var			float 				TabHeight;
var			bool				bFillSpace;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{

	Super.InitComponent(MyController, MyOwner);

	if (BackgroundStyleName != "")
		BackgroundStyle = Controller.GetStyle(BackgroundStyleName);

	OnKeyEvent = InternalOnKeyEvent;
    OnXControllerEvent = InternalOnXControllerEvent;

}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local int i,aTabIndex, StartIndex;

	if ( (FocusedControl!=None) || (State!=3) || (TabStack.Length<=0) )
		return false;

	if (ActiveTab == None)
		return false;

    for(i=0;i<TabStack.Length;i++)
    {
        if (TabStack[i]==ActiveTab)
        {
            aTabIndex = i;
            break;
        }
    }

	if ( (Key==0x25) || (Key==0x64) )	// Left
	{
		StartIndex = aTabIndex;
		while (true)
		{
			if (aTabIndex==0)
				aTabIndex=TabStack.Length-1;
			else
				aTabIndex--;

			if (aTabIndex == StartIndex || ActivateTab(TabStack[aTabIndex],true))
				break;
		}
		return true;

	}

	if ( (Key==0x27) || (Key==0x66) )	// Right
	{
		StartIndex = aTabIndex;
		while (true)
		{
			aTabIndex++;
			if (aTabIndex==TabStack.Length)
				aTabIndex=0;

			if (StartIndex == aTabIndex || ActivateTab(TabStack[aTabIndex],true))
				break;
		}
		return true;
	}

	return false;
}

function bool InternalOnXControllerEvent(byte Id, eXControllerCodes iCode)
{

 	if (iCode == XC_LeftTrigger)
    {
    	NextPage();
        return true;
    }

    else if (iCode == XC_RightTrigger)
    {
		PrevPage();
        return true;
    }

    return false;

}


function GUITabPanel AddTab(string Caption, string PanelClass, optional GUITabPanel ExistingPanel, optional string Hint, optional bool bForceActive)
{
	local class<GUITabPanel> NewPanelClass;

	local GUITabButton NewTabButton;
	local GUITabPanel  NewTabPanel;

	local int i;

	// Make sure this doesn't exist first
	for (i=0;i<TabStack.Length;i++)
	{
		if (TabStack[i].Caption ~= Caption)
		{
			log("A Tab with the caption"@Caption@"already exists.");
			return none;
		}
	}

	if (ExistingPanel==None)
		NewPanelClass = class<GUITabPanel>(DynamicLoadObject(PanelClass,class'class'));

	if ( (ExistingPanel!=None) || (NewPanelClass != None) )
	{
		if (ExistingPanel != None)
	        NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel));
	    else if (NewPanelClass != None)
			NewTabPanel = GUITabPanel(AddComponent(PanelClass));

		if (NewTabPanel == None)
		{
			log("Could not create panel for"@NewPanelClass);
			return None;
		}

		if (NewTabPanel.MyButton != None)
			NewTabButton = NewTabPanel.MyButton;
		else
		{
			NewTabButton = new class'GUITabButton';
			if (NewTabButton==None)
			{
				log("Could not create tab for"@NewPanelClass);
				return None;
			}

			NewTabButton.InitComponent(Controller, Self);
			NewTabPanel.MyButton = NewTabButton;
		}

		NewTabPanel.MyButton .Hint			= Hint;
		NewTabPanel.MyButton .Caption		= Caption;
		NewTabPanel.MyButton .OnClick		= InternalTabClick;
		NewTabPanel.MyButton .MyPanel		= NewTabPanel;
		NewTabPanel.MyButton .FocusInstead	= self;
		NewTabPanel.MyButton .bNeverFocus	= true;

		NewTabPanel.InitPanel();
		NewTabPanel.Hide();

		// Add the tab to controls
		TabStack[TabStack.Length] = NewTabPanel.MyButton;
		if ( (TabStack.Length==1) || (bForceActive) )
        {
			ActivateTab(NewTabPanel.MyButton,true);
            NewTabPanel.FocusFirst(none);
        }

		Return NewTabPanel;

	}
	else
		return none;
}

function GUITabPanel InsertTab(int Pos, string Caption, string PanelClass, optional GUITabPanel ExistingPanel, optional string Hint, optional bool bForceActive)
{
	local class<GUITabPanel> NewPanelClass;
	local GUITabPanel NewTabPanel;
	local GUITabButton NewTabButton;

	if (ExistingPanel == None)
		NewPanelClass = class<GUITabPanel>(DynamicLoadObject(PanelClass,class'Class'));

	if ( ExistingPanel != None || NewPanelClass != None)
	{
		if (ExistingPanel != None)
	        NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel));
	    else if (NewPanelClass != None)
			NewTabPanel = GUITabPanel(AddComponent(PanelClass));

		if (NewTabPanel == None)
		{
			log("Could not create panel for"@NewPanelClass);
			return None;
		}

		if (NewTabPanel.MyButton != None)
			NewTabButton = NewTabPanel.MyButton;

		else
		{
			NewTabButton = new class'GUITabButton';
			if (NewTabButton==None)
			{
				log("Could not create tab for"@NewPanelClass);
				return None;
			}

			NewTabButton.InitComponent(Controller, Self);
			NewTabPanel.MyButton = NewTabButton;
		}


		NewTabPanel.MyButton.Caption = Caption;
		NewTabPanel.MyButton.Hint = Hint;

		NewTabPanel.MyButton.OnClick = InternalTabClick;
		NewTabPanel.MyButton.FocusInstead = self;
		NewTabPanel.MyButton.bNeverFocus = true;
		NewTabPanel.InitPanel();
		NewTabPanel.Hide();

		TabStack.Insert(Pos, 1);
		TabStack[Pos] = NewTabPanel.MyButton;
		if ( (TabStack.Length==1) || (bForceActive) )
        {
			ActivateTab(NewTabPanel.MyButton,true);
            NewTabPanel.FocusFirst(none);
        }

		Return NewTabPanel;
	}

	return None;
}

// At present, this function causes RemapComponents() to be called twice,
// once when the new component is added, once when the old is removed
function GUITabPanel ReplaceTab(GUITabButton Which, string Caption, string PanelClass, optional GUITabPanel ExistingPanel, optional string Hint, optional bool bForceActive)
{
	local class<GUITabPanel> NewPanelClass;

	local GUITabPanel  NewTabPanel, OldTabPanel;

	if (ExistingPanel==None)
		NewPanelClass = class<GUITabPanel>(DynamicLoadObject(PanelClass,class'class'));

	if ( (ExistingPanel!=None) || (NewPanelClass != None) )
	{

   		OldTabPanel = Which.MyPanel;

    	if (ExistingPanel==None)
	        NewTabPanel = GUITabPanel(AddComponent(PanelClass));
    	else
        	NewTabPanel = GUITabPanel(AppendComponent(ExistingPanel));

		if (NewTabPanel==None)
		{
			log("Could not create panel"@NewPanelClass);
			return none;
		}

		Which.Caption			= Caption;
		Which.Hint				= Hint;
		Which.MyPanel			= NewTabPanel;
		NewTabPanel.MyButton	= Which;

	    // Init new panel
    	NewTabPanel.InitPanel();
	    NewTabPanel.Hide();

		// Make sure to notify old tab - so use ActivateTab
		if ( bForceActive )
			ActivateTab(NewTabPanel.MyButton, True);

		// Notify old panel
	    OldTabPanel.OnDestroyPanel(True);
		RemoveComponent(OldTabPanel);

		return NewTabPanel;

	}
	else
		return none;
}

function RemoveTab(optional string Caption, optional GUITabButton who)
{
	local int i;

	if ( (caption=="") && (Who==None) )
		return;

	if (Who==None)
		i = TabIndex(Caption);
	else i = TabIndex(Who.Caption);

	if (i < 0)
		return;

	if (TabStack[i] == ActiveTab)
		LostActiveTab();

	TabStack[i].OnClick = None;
	TabStack[i].MyPanel.OnDestroyPanel(True);
	TabStack.Remove(i,1);
	RemoveComponent(TabStack[i].MyPanel);
}

function bool LostActiveTab()
{
	local int i;

	for (i = 0; i < TabStack.Length; i++)
		if (ActivateTab(TabStack[i],true))
			return true;

	return false;
}

function bool ActivateTab(GUITabButton Who, bool bFocusPanel)
{
	if (Who == none || !Who.CanShowPanel())		// null or not selectable
		return false;

	if (Who==ActiveTab)	// Same Tab, just accept
		return true;

	// Deactivate the Active tab
	if (ActiveTab != None)
	{
		ActiveTab.bActive = False;
		if (ActiveTab.MyPanel != None)
			ActiveTab.MyPanel.ShowPanel(False);
	}

	// Set the new active Tab
	ActiveTab = Who;
	Who.bActive = True;
	Who.MyPanel.ShowPanel(bFocusPanel);
	OnChange(Who);

	return true;
}

function bool ActivateTabByName(string tabname, bool bFocusPanel)
{
	local int i;

	i = TabIndex(TabName);
	if (i < 0 || i >= TabStack.Length) return false;
	else return ActivateTab(TabStack[i], bFocusPanel);
}

function bool InternalTabClick(GUIComponent Sender)
{
	local GUITabButton But;

	But = GUITabButton(Sender);
	if (But==None)
		return false;

	ActivateTab(But,true);
    if (ActiveTab!=None && ActiveTab.MyPanel!=None)
    	ActiveTab.MyPanel.FocusFirst(none);

	return true;
}

event bool NextPage()
{
	local int i;

	// If 1 or no tabs in the stack, then query parents
	if (TabStack.Length < 2)
		return Super.NextPage();

	if (ActiveTab == None)
		i = 0;
	else
	{
		i = TabIndex(ActiveTab.Caption) + 1;
		if ( i >= TabStack.Length )
			i = 0;
	}
	return ActivateTab(TabStack[i], true);
}

event bool PrevPage()
{
	local int i;

	if (TabStack.Length < 2)
		return Super.NextPage();

	if (ActiveTab == None)
		i = TabStack.Length - 1;
	else
	{
		i = TabIndex(ActiveTab.Caption) - 1;
		if ( i < 0 )
			i = TabStack.Length - 1;
	}
	return ActivateTab(TabStack[i], true);
}

event SetFocus(GUIComponent Who)
{
	if (Who==None)
	{
    	if (Controller.FocusedControl!=None && Controller.FocusedControl!=Self)
        {
        	Super(GUIComponent).SetFocus(Who);
            return;
        }
        else
        {
			FocusFirst(None);
        }

		return;
	}
    Super.SetFocus(Who);
}

event bool NextControl(GUIComponent Sender)
{

	if (Sender!=None && Sender.MenuOwner==self)
    	return Super(GUIComponent).NextControl(Sender);
    else
    	FocusFirst(None);

    return true;
}

event bool PrevControl(GUIComponent Sender)
{

	if (Sender!=None && Sender.MenuOwner==self)
    {
    	SetFocus(None);
        return true;
    }
    else if (Sender==None)
    	return Super(GUIComponent).PrevControl(Sender);
    else
    	FocusLast(None);

    return true;

}

function int TabIndex(string TabName)
{
	local int i;

	for (i = 0; i < TabStack.Length; i++)
		if (TabStack[i].Caption ~= TabName)
			return i;

	return -1;
}

cpptext
{
		void PreDraw(UCanvas* Canvas);
		void Draw(UCanvas* Canvas);

		UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);
		UBOOL SpecialHit();
		UBOOL MousePressed(UBOOL IsRepeat);					// The Mouse was pressed
		UBOOL MouseReleased();								// The Mouse was released


}


defaultproperties
{
     TabHeight=48.000000
}
