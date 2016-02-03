// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class NotifyProperties extends Object
	native
	hidecategories(Object)
	collapsecategories;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var int OldArrayCount;
var const int WBrowserAnimationPtr;

struct native NotifyInfo
{
	var() FLOAT NotifyFrame;
	var() editinlinenotify AnimNotify Notify;
	var INT OldRevisionNum;
};

var() Array<NotifyInfo> Notifys;

cpptext
{
	void PostEditChange();

}


defaultproperties
{
}
