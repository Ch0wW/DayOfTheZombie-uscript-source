// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
//  Class:  GUI.GUIVertScrollBar

// ====================================================================

class GUIVertScrollBar extends GUIScrollBarBase
		Native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Automated GUIVertScrollZone MyScrollZone;
var Automated GUIVertScrollButton MyUpButton;
var Automated GUIVertScrollButton MyDownButton;
var Automated GUIVertGripButton MyGripButton;


var		float			GripTop;		// Where in the ScrollZone is the grip	- Set Natively
var		float			GripHeight;		// How big is the grip - Set Natively

var		float			GrabOffset; // distance from top of button that the user started their drag. Set natively.


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	MyScrollZone.OnScrollZoneClick = ZoneClick;
	MyUpButton.OnClick = UpTickClick;
	MyDownButton.OnClick = DownTickClick;
	MyGripButton.OnCapturedMouseMove = GripMouseMove;
	MyGripButton.OnClick = GripClick;

    ReFocus(MyList);

}

function UpdateGripPosition(float NewPos)
{
	MyList.MakeVisible(NewPos);
	GripTop = NewPos;
}

// Record location you grabbed the grip
function bool GripClick(GUIComponent Sender)
{
	GrabOffset = Controller.MouseY - MyGripButton.ActualTop();

	return true;
}

function bool GripMouseMove(float deltaX, float deltaY)
{
	local float NewPerc,NewTop;

	// Calculate the new Grip Top using the mouse cursor location.
	NewPerc = (  Controller.MouseY - (GrabOffset + MyScrollZone.ActualTop()) )  /(MyScrollZone.ActualHeight()-GripHeight);
	NewTop = FClamp(NewPerc,0.0,1.0);

	UpdateGripPosition(Newtop);

	return true;
}

function ZoneClick(float Delta)
{
	if ( Controller.MouseY < MyGripButton.Bounds[1] )
		MoveGripBy(-MyList.ItemsPerPage);
	else if ( Controller.MouseY > MyGripButton.Bounds[3] )
		MoveGripBy(MyList.ItemsPerPage);

	return;
}

function MoveGripBy(int items)
{
	local int TopItem;

	TopItem = MyList.Top + items;
	if (MyList.ItemCount > 0)
	{
		MyList.SetTopItem(TopItem);
		AlignThumb();
	}
}

function bool UpTickClick(GUIComponent Sender)
{
	WheelUp();
	return true;
}

function bool DownTickClick(GUIComponent Sender)
{
	WheelDown();
	return true;
}

function WheelUp()
{
	if (!Controller.CtrlPressed)
		MoveGripBy(-1);
	else
		MoveGripBy(-MyList.ItemsPerPage);
}

function WheelDown()
{
	if (!Controller.CtrlPressed)
		MoveGripBy(1);
	else
		MoveGripBy(MyList.ItemsPerPage);
}

function AlignThumb()
{
	local float NewTop;

	if (MyList.ItemCount==0)
		NewTop = 0;
	else
	{
		NewTop = Float(MyList.Top) / Float(MyList.ItemCount-MyList.ItemsPerPage);
		NewTop = FClamp(NewTop,0.0,1.0);
	}

	GripTop = NewTop;
}


// NOTE:  Add graphics for no-man's land about and below the scrollzone, and the Scroll nub.

cpptext
{
		void PreDraw(UCanvas* Canvas);

}


defaultproperties
{
     Begin Object Class=GUIVertScrollZone Name=ScrollZone
         Name="ScrollZone"
     End Object
     MyScrollZone=GUIVertScrollZone'GUI.GUIVertScrollBar.ScrollZone'
     Begin Object Class=GUIVertScrollButton Name=UpBut
         UpButton=True
         Name="UpBut"
     End Object
     MyUpButton=GUIVertScrollButton'GUI.GUIVertScrollBar.UpBut'
     Begin Object Class=GUIVertScrollButton Name=DownBut
         Name="DownBut"
     End Object
     MyDownButton=GUIVertScrollButton'GUI.GUIVertScrollBar.DownBut'
     Begin Object Class=GUIVertGripButton Name=Grip
         Name="Grip"
     End Object
     MyGripButton=GUIVertGripButton'GUI.GUIVertScrollBar.Grip'
     bAcceptsInput=True
     WinWidth=0.037500
}
