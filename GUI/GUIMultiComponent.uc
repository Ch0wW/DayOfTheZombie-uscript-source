// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIMultiComponent
//
//	GUIMultiComponents are collections of components that work together.
//  When initialized, GUIMultiComponents transfer all of their components
//	to the to the GUIPage that owns them.
//
//  Written by Joe Wilcox
//  (c) 2002, Epic Games, Inc.  All Rights Reserved
// ====================================================================

class GUIMultiComponent extends GUIComponent
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

var		array<GUIComponent>		Controls;				// An Array of Components that make up this Control
var 	array<GUIComponent>		Components;				// An Array of Controls that can be tabbed to
var		GUIComponent			FocusedControl;			// Which component inside this one has focus
var		bool					PropagateVisibility;	// Does changes to visibility propagate down the line


function native InitializeControls();

// Stub
function InternalOnShow();

event int FindComponentIndex(GUIComponent Who)
{
	local int i;

	if (Who != None && Components.Length > 0)
    {
		for (i=0;i<Components.Length;i++)
        {
			if (Who==Components[i])
				return i;
    	}
    }

	return -1;
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local int i;

	Super.Initcomponent(MyController, MyOwner);

	// Set OnShow delegate - SetVisibility will be called in next step
	OnShow = InternalOnShow;

    InitializeControls();	// Build the Controls array
	for (i=0;i<Controls.Length;i++)
	{
		if (Controls[i] == None)
		{
			log("Invalid control found in"@string(Class)$"!! (Control"@i$")",'GUI ERROR');
			Controls.Remove(i--,1);
			continue;
		}
		Controls[i].InitComponent(MyController, Self);
	}

    // Propagate some defaults
    if (PropagateVisibility)
    	SetVisibility(bVisible);

    RemapComponents();

}

event GUIComponent AddComponent(string ComponentClass)
{
    local class<GUIComponent> NewCompClass;
    local GUIComponent NewComp;

    NewCompClass = class<GUIComponent>(DynamicLoadObject(ComponentClass,class'class'));
    if (NewCompClass != None)
    {

        NewComp = new(None) NewCompClass;
        if (NewComp!=None)
        {
        	NewComp = AppendComponent(NewComp);
			return NewComp;
        }
    }

    log("GUIMultiComponent::AddComponent - Could not create component"@ComponentClass,'GUI');
	return none;
}

event GUIComponent InsertComponent(GUIComponent NewComp, int Index)
{
	if (Index < 0 || Index >= Controls.Length)
		return AppendComponent(NewComp);

	Controls.Insert(Index, 1);
	Controls[Index] = NewComp;
	RemapComponents();
	return NewComp;
}

event GUIComponent AppendComponent(GUIComponent NewComp)
{
	local int index;

    // Attempt to add it sorted in to the array.  The Controls array is sorted by
    // Render Weight.

    while (Index<Controls.Length)
    {
    	if (NewComp.RenderWeight <= Controls[Index].RenderWeight)	// We found our spot
        {
			Controls.Insert(Index,1);
			break;
        }
        Index++;
    }

    // Couldn't find a spot, add it at the end
    Controls[Index] = NewComp;
   	NewComp.InitComponent(Controller, Self);
	RemapComponents();
    return NewComp;
}

event bool RemoveComponent(GUIComponent Comp, optional bool bRemap)
{
	local int i;
    for (i=0;i<Controls.Length;i++)
    {
		if (Controls[i] == Comp)
        {
        	Controls.Remove(i,1);
        	if (bRemap)
	        	RemapComponents();
            return true;
        }
	}
    return false;
}

function FindCenterPoint(GUIComponent What, out float X, out float Y)
{
	X = What.ActualLeft() + (What.ActualWidth()/2);
    Y = What.ActualTop() + (What.ActualHeight()/2);
}

function float FindDist(GUIComponent Source, GUIComponent Target)
{
	local float a,b;
    local float x[2],y[2];

    FindCenterPoint(Source,x[0],y[0]);
    FindCenterPoint(Target,x[1],y[1]);

  	a = abs(x[0]-x[1]);
    a = square(a);
    b = abs(y[0]-y[1]);
    b = square(b);

    return sqrt(a+b);
}

function bool TestControls(int Mode, int SourceIndex, int TargetIndex)
{
	local float sX1,sY1,sX2,sY2;
    local float tX1,tY1,tX2,tY2;

	if (SourceIndex==TargetIndex)
    	return false;

    if (Controls[TargetIndex].bNeverFocus)
    	return false;

	sX1 = Controls[SourceIndex].ActualLeft();
    sX2 = sX1 + Controls[SourceIndex].ActualWidth();
	sY1 = Controls[SourceIndex].ActualTop();
    sY2 = sY1 + Controls[SourceIndex].ActualHeight();

	tX1 = Controls[TargetIndex].ActualLeft();
    tX2 = tX1 + Controls[TargetIndex].ActualWidth();
	tY1 = Controls[TargetIndex].ActualTop();
    tY2 = tY1 + Controls[TargetIndex].ActualHeight();

    switch (mode)
    {
    	case 0 :	// Up
        	return (tY2 <= sY1);
            break;
        case 1 :	// Down
        	return (tY1 >= sY2);
            break;

        case 2 : 	// Left
        	return (tX2 <= sX1);
            break;
        case 3 :	// Right
        	return (tX1 >= sX2);
            break;
	}

    return false;
}


function MapControls()
{
	local int c,i,p;
    local float cd,dist;
    local GUIComponent Closest;

    for (c=0;c<Controls.Length;c++)
    {
    	if (!Controls[c].bNeverFocus)
        {

	        for (p=0;p<4;p++)
	        {
	            Closest = none;
	            if (Controls[c].LinkOverrides[p]!=None)
	                Controls[c].Links[p] = Controls[c].LinkOverrides[p];
	            else
	            {
	                for (i=0;i<Controls.Length;i++)
	                    if ( TestControls(p,c,i) )
	                    {
	                        dist = FindDist(Controls[c],Controls[i]);
	                        if ( (Closest == None) || (dist < cd) )
	                        {
	                            Closest = Controls[i];
	                            cd = dist;
	                        }
	                    }
	                Controls[c].Links[p] = Closest;
	            }
	        }
        }
    }
}


// RemapComponents - This sets the tab order for all the components on this page
event RemapComponents()
{
	local int i,j;

// Remove from 0 instead of 1, in case control was removed, and that control was components[0]
// Otherwise, get access nones
	if (Components.Length>0)
	 	Components.Remove(0,Components.Length);	// Clear the Component Array

	for (i=0;i<Controls.Length;i++)
    {
    	if (Controls[i].bTabStop)
        {
        	for (j=0;j<Components.Length;j++)
            	if ( Controls[i].TabOrder <= Components[j].TabOrder )
                    break;

			if (j < Components.Length)
				Components.Insert(j, 1);

			Components[j] = Controls[i];
         }
    }
}

event SetFocus(GUIComponent Who)
{
	if (Who==None)
	{
		FocusFirst(None);
		return;
	}
	else
		FocusedControl = Who;

	MenuStateChange(MSAT_Focused);

	if (MenuOwner!=None)
		MenuOwner.SetFocus(self);
}

event LoseFocus(GUIComponent Sender)
{
	FocusedControl = None;
	Super.LoseFocus(Sender);
}


event bool FocusFirst(GUIComponent Sender)
{
    local int i;

	if (Components.Length>0)
	{
    	for (i=0;i<Components.Length;i++)
        {
        	if (Components[i].bVisible && Components[i].MenuState != MSAT_Disabled)
            {
		  		Components[i].SetFocus(None);
				return true;
            }
        }
    }

	for (i=0;i<Controls.Length;i++)
    {
    	if ( Controls[i].FocusFirst(Sender) )
        	return true;
    }

    return false;
}


event bool FocusLast(GUIComponent Sender)
{
	local int i;

	if (Components.Length>0)
	{
    	for (i=Components.Length-1;i>=0;i--)
        {
        	if (Components[i].bVisible && Components[i].MenuState != MSAT_Disabled)
            {
				Components[i].SetFocus(None);
				return true;
            }
        }
	}

	for (i=Controls.Length-1;i>=0;i--)
    {
    	if ( Controls[i].FocusLast(Sender) )
        	return true;
    }

    return false;

}

event bool NextControl(GUIComponent Sender)
{
	local int Index;

	Index = FindComponentIndex(Sender);

    if (Index==-1)
    {
    	if ( Super.NextControl(Self) )
        	return true;
        else
	    	return FocusFirst(none);
    }

    Index++;

    // Find the next possible component
    while (Index<Components.Length)
    {
    	if (Components[Index].MenuState!=MSAT_Disabled && Components[Index].bVisible)
    	{
        	Components[Index].SetFocus(None);
        	return true;
        }

    	Index++;
    }

   	if ( Super.NextControl(self) )
       	return true;
    else
       	return FocusFirst(none);
}

event bool PrevControl(GUIComponent Sender)
{

	local int Index;

	Index = FindComponentIndex(Sender);

    if (Index==-1)
    {
    	if ( Super.PRevControl(Self) )
        	return true;
        else
	    	return FocusLast(none);
	}

    Index--;

    while (Index>=0)
    {
    	if (Components[Index].MenuState!=MSAT_Disabled)
        {
        	Components[Index].SetFocus(None);
            return true;
        }

        Index--;
    }

    if ( Super.PrevControl(self) )
       	return true;
    else
       	return FocusLast(none);

}

function string LoadINI()
{
	local int i;

	for (i=0;i<Controls.Length;i++)
		Controls[i].LoadINI();

	return Super.LoadINI();
}

function SaveINI(string Value)
{
	local int i;

	for (i=0;i<Controls.Length;i++)
		Controls[i].SaveINI("");

	Super.SaveINI(Value);

	return;
}

event MenuStateChange(eMenuState Newstate)
{

	local int i;

	if (NewState==MSAT_Disabled)
	{
		for (i=0;i<Controls.Length;i++)
			Controls[i].MenuStateChange(MSAT_Disabled);
	}
	else
	{
		for (i=0;i<Controls.Length;i++)
			if (Controls[i].MenuState==MSAT_Disabled)
				Controls[i].MenuStateChange(MSAT_Blurry);
	}

	Super.MenuStateChange(NewState);
}

event SetVisibility(bool bIsVisible)
{
	local int i;

	Super.SetVisibility(bIsVisible);

    if ( !PropagateVisibility )
    	return;

    for (i=0;i<Controls.Length;i++)
    	Controls[i].SetVisibility(bIsVisible);
}

event Opened(GUIComponent Sender)
{
	local int i;

    for (i=0;i<Controls.Length;i++)
    	Controls[i].Opened(Sender);
}

event Closed(GUIComponent Sender, bool bCancelled)
{
	local int i;

    for (i=0;i<Controls.Length;i++)
    	Controls[i].Closed(Sender, bCancelled);
}

event Free() 			// This control is no longer needed
{
	local int i;

    for (i=0;i<Controls.Length;i++)
    {
    	Controls[i].Free();
        Controls[i] = None;
    }

    for (i=0;i<Components.Length;i++)
    	Components[i] = None;

	FocusedControl = None;
    Super.Free();
}

cpptext
{
		void PreDraw(UCanvas* Canvas);		// Do any size/postitioning
		void Draw(UCanvas* Canvas);			// Draw the component

		virtual void InitializeControls();	// Takes all GUIComponent members and assigns them to the controls array

		UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

		UBOOL NativeKeyType(BYTE& iKey, TCHAR Unicode );					// A Key or Mouse button has pressed
		UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta );		// A Key/Mouse event occured

		void NativeInvalidate(UGUIComponent* Who);
		UBOOL SpecialHit();

		UBOOL PerformHitTest(INT MouseX, INT MouseY);

		UBOOL MousePressed(UBOOL IsRepeat);					// The left mouse button was pressed
		UBOOL RightMousePressed();							// The right mouse button was pressed
		UBOOL MouseReleased();								// The mouse button was released

		UBOOL XControllerEvent(int Id, eXControllerCodes iCode);


}


defaultproperties
{
     bTabStop=True
}
