// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class UWindowTabControlItem extends UWindowList;

var string					Caption;
var string					HelpText;

var UWindowTabControl		Owner;
var float					TabTop;
var float					TabLeft;
var float					TabWidth;
var float					TabHeight;

var int						RowNumber;
var bool					bFlash;

function SetCaption(string NewCaption)
{
	Caption=NewCaption;
}

function RightClickTab()
{
}

defaultproperties
{
}
