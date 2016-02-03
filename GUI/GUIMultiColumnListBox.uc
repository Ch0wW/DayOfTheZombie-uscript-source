// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class GUIMultiColumnListBox extends GUIListBoxBase
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var Automated GUIMultiColumnListHeader 	Header;

var GUIMultiColumnList	List;
var string				DefaultListClass;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

    if (DefaultListClass!="")
    {
    	List = GUIMultiColumnList(AddComponent(DefaultListClass));
        if (List==None)
        {
        	log("GUIMultiColumnListBox::InitComponent - Could not create default list ["$DefaultListClass$"]");
            return;
        }
    }

	Header.MyList = List;
    InitBaseList(List);
}

cpptext
{
	void PreDraw(UCanvas* Canvas);

}


defaultproperties
{
     Begin Object Class=GUIMultiColumnListHeader Name=MyHeader
         Name="MyHeader"
     End Object
     Header=GUIMultiColumnListHeader'GUI.GUIMultiColumnListBox.MyHeader'
}
