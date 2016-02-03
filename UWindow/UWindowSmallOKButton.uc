// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UWindowSmallOKButton extends UWindowSmallCloseButton;

var localized string OKText;

function Created()
{
	Super.Created();
	SetText(OKText);
}

defaultproperties
{
     OKText="OK"
}
