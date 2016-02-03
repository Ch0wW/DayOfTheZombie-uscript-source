// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision $
 * @date    Sept 2003
 */
class BBXComboBox extends GUIComboBox;

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

   Edit.Style = MyController.GetStyle( "BBXSquareButton" );
   MyShowListBtn.Style = MyController.GetStyle( "BBXSquareButton" );
   MyShowListBtn.Graphic = Select;

   MyListBox.Style = MyController.GetStyle( "BBXSquareButton" );
   List.Style = MyController.GetStyle( "BBXSquareButton" );
   List.SelectedImage=Highlighted;

   // CARROT
   Edit.OnClick = ShowListBox;
   Edit.FocusInstead = List;

}

defaultproperties
{
     Select=ColorModifier'BBTGuiContent.General.ArrowDown'
     Highlighted=Texture'BBTGuiContent.General.ComboBox_Selected'
}
