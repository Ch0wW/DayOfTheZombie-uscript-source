// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision $
 * @date    Sept 2003
 */
class BBComboBox extends GUIComboBox;

var Material Select;
var Material Highlighted;

/**
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
   Super.InitComponent(MyController,MyOwner);
   /*
   Edit.Style = MyController.GetStyle( "HGSquareButton" );
   MyShowListBtn.Style = MyController.GetStyle( "HGSquareButton" );
   MyShowListBtn.Graphic = Select;

   MyListBox.Style = MyController.GetStyle( "HGSquareButton" );
   List.Style = MyController.GetStyle( "HGSquareButton" );
   */

   Edit.Style = MyController.GetStyle( "BBListButton" );
   MyShowListBtn.Style = MyController.GetStyle( "BBListButton" );
   MyShowListBtn.Graphic = Select;

   MyListBox.Style = MyController.GetStyle( "BBListButton" );
   List.Style = MyController.GetStyle( "BBListButton" );
   List.SelectedImage=Highlighted;

   // CARROT
   Edit.OnClick = ShowListBox;
   Edit.FocusInstead = List;

}

defaultproperties
{
     Select=ColorModifier'BBTGuiContent.General.ArrowDown'
     Highlighted=Texture'BBTGuiContent.General.ComboBox_Selected'
     Begin Object Class=BBListBox Name=TheListBox
         Name="TheListBox"
     End Object
     MyListBox=BBListBox'BBGui.BBComboBox.TheListBox'
     bReadOnly=True
}
