// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class BBGuiSlider extends GUISlider;

var bool lastWasOut;

function bool InternalCapturedMouseMove(float deltaX, float deltaY)
{
    local bool ret;

	if (Controller.MouseX < Bounds[0] || Controller.MouseX > Bounds[2] ||
        Controller.MouseY < Bounds[1] || Controller.MouseY > Bounds[3]) {
	   if (!lastWasOut) {
           OnChange(self);
	       lastWasOut = true;
	   }
	   ret = false;
	} else {
	   ret = super.InternalCapturedMouseMove(deltaX, deltaY);
	   lastWasOut = false;
	}

	return ret;
}


Delegate OnMouseRelease(GUIComponent Sender)
{
    OnChange(self);
}

defaultproperties
{
     CaptionStyleName="BBSlider"
     StyleName="BBSquareButton"
     WinWidth=0.300000
}
