// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZProfileManager - Profile Manager Menu
 *      -Create, Load, Delete, and auto-save profiles
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    March 2005
 */
class DOTZProfileManager extends DOTZProfilePanel;






var GUIListBox		lbProfiles;
var moEditBox		ebPlayerName, ebPlayerAge, ebDifficulty;

var localized string Difficulties[8];  // hardcoded for localization.  clamped 0,NumDifficulties where accessed.
var int NumDifficulties;			   // for external class access to size

//var Profiler profileHandle;





function InitComponent(GUIController pMyController, GUIComponent MyOwner)
{
    Log("In ProfileManager InitComponent");
	Super.Initcomponent(pMyController, MyOwner);

	//profileHandle = new class'DOTZProfile';

	lbProfiles=GUIListBox(Controls[0]);
	//lbProfiles.List.OnDblClick=DoubleClickList;
	ebPlayerName=moEditBox(Controls[1]);
	ebPlayerAge=moEditBox(Controls[2]);
	//ebDifficulty=moEditBox(Controls[2]);

    UpdateList();
}

function InitPanel()
{
	Super.InitPanel();
	//MyButton.Hint = class'UT2SinglePlayerMain'.default.TabHintProfileLoad;
	//UT2SinglePlayerMain(MyButton.MenuOwner.MenuOwner).ResetTitleBar(MyButton);
}



function ListInfoChange(GUIComponent Sender)
{
    local string profileName;

    //profileName = lbProfiles.List.Get();
    //DOTZPlayerControllerBase(PlayerOwner()).LoadProfile(profileName $ ".prof");

    ebPlayerName.SetText(profileName);
   // ebPlayerAge.SetText(DOTZPlayerControllerBase(PlayerOwner()).GetValue("blah"));
    //ebDifficulty.SetText(Difficulties[2]);

}


// Updated profile listbox (load from disk)
function UpdateList()
{
    local int i, count;

    lbProfiles.List.Clear();
    // Load up profile list and get total profiles
    //count = profileHandle.GetProfileCount();
    count = DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount();
    for(i=0; i<count; i++)
    {
        lbProfiles.List.Add(DOTZPlayerControllerBase(PlayerOwner()).GetProfileName(i));
    }

}




function SaveAge(GUIComponent Sender)
{
    Log("in save INI");
    //profileHandle.SetValue("blah", ebPlayerAge.GetText());


}



/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {

    Log("In closed");

    //profileHandle.Save();
   DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();

   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);
}

defaultproperties
{
     Difficulties(0)="Easy"
     Difficulties(1)="Normal"
     Difficulties(2)="Hard"
     NumDifficulties=3
     Controls(0)=BBListBox'DOTZMenu.DOTZProfileManager.LBoxProfile'
     Controls(1)=moEditBox'DOTZMenu.DOTZProfileManager.EBoxPlayerName'
     Controls(2)=moEditBox'DOTZMenu.DOTZProfileManager.EBoxPlayerAge'
     Controls(3)=GUILabel'DOTZMenu.DOTZProfileManager.BoxStats'
     Controls(4)=GUILabel'DOTZMenu.DOTZProfileManager.BoxListing'
     WinHeight=1.000000
}
