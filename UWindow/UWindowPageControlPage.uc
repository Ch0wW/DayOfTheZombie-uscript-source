// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UWindowPageControlPage extends UWindowTabControlItem;

var UWindowPageWindow	Page;

function RightClickTab()
{
	Page.RightClickTab();
}

function UWindowPageControlPage NextPage()
{
	return UWindowPageControlPage(Next);
}

defaultproperties
{
}
