// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UWindowFrameCloseBox extends UWindowButton;

function Created()
{
	bNoKeyboard = True;
	Super.Created();
}

function Click(float X, float Y)
{
	ParentWindow.Close();
}

// No keyboard support
function KeyDown(int Key, float X, float Y)
{
}

defaultproperties
{
}
