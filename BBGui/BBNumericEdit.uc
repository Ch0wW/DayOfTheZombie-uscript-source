// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * BBNumericEdit
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class BBNumericEdit extends GUINumericEdit;

defaultproperties
{
     Begin Object Class=GUIEditBox Name=cMyEditBox
         bIntOnly=True
         StyleName="BBRoundReadable"
         Name="cMyEditBox"
     End Object
     MyEditBox=GUIEditBox'BBGui.BBNumericEdit.cMyEditBox'
     Begin Object Class=BBSpinnerButton Name=cMyPlus
         PlusButton=True
         StyleName="BBSquareButton"
         Name="cMyPlus"
     End Object
     MyPlus=BBSpinnerButton'BBGui.BBNumericEdit.cMyPlus'
     Begin Object Class=BBSpinnerButton Name=cMyMinus
         StyleName="BBSquareButton"
         Name="cMyMinus"
     End Object
     MyMinus=BBSpinnerButton'BBGui.BBNumericEdit.cMyMinus'
     StyleName="BBSquareButton"
}
