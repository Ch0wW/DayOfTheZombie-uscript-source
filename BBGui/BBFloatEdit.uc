// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class BBFloatEdit extends GUIFloatEdit;

defaultproperties
{
     Begin Object Class=GUIEditBox Name=cMyEditBox
         bFloatOnly=True
         StyleName="BBRoundReadable"
         Name="cMyEditBox"
     End Object
     MyEditBox=GUIEditBox'BBGui.BBFloatEdit.cMyEditBox'
     Begin Object Class=BBSpinnerButton Name=cMyPlus
         PlusButton=True
         StyleName="BBSquareButton"
         Name="cMyPlus"
     End Object
     MyPlus=BBSpinnerButton'BBGui.BBFloatEdit.cMyPlus'
     Begin Object Class=BBSpinnerButton Name=cMyMinus
         StyleName="BBSquareButton"
         Name="cMyMinus"
     End Object
     MyMinus=BBSpinnerButton'BBGui.BBFloatEdit.cMyMinus'
     StyleName="BBSquareButton"
}
