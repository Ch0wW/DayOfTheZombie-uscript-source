// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UWindowSmallCancelButton extends UWindowButton;

var localized string CancelText;

function Created()
{
	Super.Created();
	SetText(CancelText);
}

defaultproperties
{
     CancelText="Cancel"
}
