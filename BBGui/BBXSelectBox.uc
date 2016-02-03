// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Oct 2003
 * This bad boy spits out a bunch of Accessed Nones cause the GUI list doesn't have
 * a scrollbar. Some intrepid sole might want to fix that
 */
class BBXSelectBox extends GUIMultiComponent;

var Automated GUIList List;
var Automated GUIButton Display;
var Automated GUIGFXButton LeftButton;
var Automated GUIGFXButton RightButton;
var sound ClickSound;

var Material LeftArrow;
var Material RightArrow;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner){
	Super.Initcomponent(MyController, MyOwner);

   LeftButton.SetVisibility(true);
   LeftButton.OnClick=self.LeftClick;
	LeftButton.OnClickSound=CS_Click;
   LeftButton.Graphic = LeftArrow;

   RightButton.SetVisibility(true);
   RightButton.OnClick=self.RightClick;
	RightButton.OnClickSound=CS_Click;
   RightButton.Graphic = RightArrow;

   List.SetVisibility(false);
   List.SetIndex(0);
	List.OnClickSound=CS_Click;
   List.OnChange = self.ListChanged;

   Display.SetVisibility(true);
   Display.Caption = List.Get();
   Display.OnClick = self.OnClick;
	List.OnClickSound=CS_Click;

   FocusInstead=List;

	OnKeyEvent=InternalOnKeyEvent;
   OnXControllerEvent=InternalOnXControllerEvent;
}

/*****************************************************************
 * AddItem
 * Trying to make this control look a little more like other controls
 *****************************************************************
 */
function AddItem(string item, optional Object extra, optional string str){
   if (List != none){
         List.Add(item,extra,str);
   }
}

/*****************************************************************
 *
 *****************************************************************
 */
function string GetExtra(){
   if (List !=None){
      return List.GetExtra();
   }
}

/*****************************************************************
 *
 *****************************************************************
 */
function Object GetObject(){
   if (List != none){
      return List.GetObject();
   }
}

/*****************************************************************
 *
 *****************************************************************
*/
function int GetIndex(){
   if (List != none){
   return List.Index;
   }
}

/*****************************************************************
 * SetIndex
 * Trying to make this control look a little more like other controls
 *****************************************************************
*/
function SetIndex(int index){
   if (List !=None){
      List.SetIndex(index);
   }
}

/*****************************************************************
 * InternalOnKeyEvent
 *****************************************************************
 */
function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	if (key==0x0D && State==3)	// ENTER Pressed
	{
		OnClick(self);
		return true;
	}

	if (key==0x026 && State==1)
	{
		PrevControl(none);
		return true;
	}

	if (key==0x028 && State==1)
	{
		NextControl(none);
		return true;
	}

	return false;
}

function bool InternalOnXControllerEvent(byte Id, eXControllerCodes iCode)
{
	if (iCode==XC_Start){
    	OnClick(Self);
      return true;
    } else if (iCode == XC_PadRight){
      RightClick(self);
    } else if (iCode == XC_PadLeft){
      LeftClick(self);
    }  else if (iCode == XC_PadDown){
      //NextControl(none);
    } else if (iCode == XC_PadUp){
      //PrevControl(none);
    }
}


/*****************************************************************
 * ListChanged
 *****************************************************************
 */
function ListChanged(GUIComponent item){
   if (list != none){
      Display.Caption = List.Get();
      OnChange(self);
   }
}


/*****************************************************************
 * RightClick
 *****************************************************************
 */
function bool RightClick(GUIComponent Sender){

   if (List == none) { return false; }

   if (List.Index == List.Elements.Length -1){
      List.SetIndex(0);
   } else {
      List.SetIndex(List.Index + 1);
   }
   Display.Caption = List.Get();
   self.OnClick(self);
   return true;
}


/*****************************************************************
 * LeftClick
 *****************************************************************
 */
function bool LeftClick(GUIComponent Sender){

   if (List == none) { return false; }

   if (List.index == 0){
      list.Setindex(list.Elements.length - 1);
   } else {
      list.setindex(List.index - 1);
   }
   Display.Caption = List.Get();
   OnClick(self);
   return true;
}

defaultproperties
{
     List=GUIList'GUI.GUIListBox.TheList'
     Begin Object Class=GUIButton Name=TheDisplay
         StyleName="BBXRoundReadable"
         bBoundToParent=True
         bScaleToParent=True
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=1.000000
         RenderWeight=1.000000
         Name="TheDisplay"
     End Object
     Display=GUIButton'BBGui.BBXSelectBox.TheDisplay'
     Begin Object Class=GUIGFXButton Name=TheLeftButton
         Position=ICP_Scaled
         StyleName="BBXRoundButtonStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinWidth=0.100000
         WinHeight=1.000000
         RenderWeight=1.000000
         Name="TheLeftButton"
     End Object
     LeftButton=GUIGFXButton'BBGui.BBXSelectBox.TheLeftButton'
     Begin Object Class=GUIGFXButton Name=TheRightButton
         Position=ICP_Scaled
         StyleName="BBXRoundButtonStatic"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinLeft=0.900000
         WinWidth=0.100000
         WinHeight=1.000000
         RenderWeight=1.000000
         Name="TheRightButton"
     End Object
     RightButton=GUIGFXButton'BBGui.BBXSelectBox.TheRightButton'
     LeftArrow=Texture'BBTGuiContent.General.ArrowLeft'
     RightArrow=Texture'BBTGuiContent.General.ArrowRight'
     StyleName="BBXRoundButtonStatic"
     bAcceptsInput=True
     bMouseOverSound=True
}
