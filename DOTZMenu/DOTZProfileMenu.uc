// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZProfileMenu - Profile Main Menu with tabs for Manager, Game, & Control Settings
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #4 $
 * @date    March 2005
 */
class DOTZProfileMenu extends DOTZProfileBase;





var Automated BBListBox ProfileList;

var Automated GUILabel ListLabel;
var Automated GUILabel NameLabel;
var Automated GUILabel DiffLabel;
//var Automated GUILabel SubtitleLabel;

var Automated GUILabel NameValue;
var Automated BBComboBox DifficultyList;
//var Automated BBCheckBoxButton SubtitleCheck;

var Automated GUIButton NewProfileButton;
var Automated GUIButton LoadProfileButton;
var Automated GUIButton DeleteProfileButton;
var Automated GUIButton BackButton;

var string NewProfileMenu;
var localized string PageCaption;

var sound ClickSound;

var localized string EasyTxt;
var localized string NormalTxt;
var localized string DifficultTxt;




/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   SetPageCaption( PageCaption );

   AddBackButton();

   DifficultyList.AddItem(EasyTxt);
   DifficultyList.AddItem(NormalTxt);
   DifficultyList.AddItem(DifficultTxt);

   DifficultyList.OnChange = DifficultyChange;
   //SubtitleCheck.OnChange = SubtitlesChange;
}

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */
function Refresh_Profiles_List ()
{
    local int profile_count;
    local int current;
    local int p;
    local string tmp;

    current = 0;
    profile_count = DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount();

    ProfileList.List.Clear();
    for (p = 0; p < profile_count; ++p)
    {
        // Need to toss out the .prof
        tmp = DOTZPlayerControllerBase(PlayerOwner()).GetProfileName(p);
        //DOTZPlayerControllerBase(PlayerOwner()).ReplaceText(tmp, ".prof", "");
        ProfileList.List.Add(tmp);

        // Select the current profile
        if (tmp == DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName()) {
            current = p;
        }
    }

    Log("Setting selection to item " $ current);
    ProfileList.List.SetIndex(current);
    ProfileList.bHasFocus = true;
}

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */
function Refresh_Current_Profile ()
{
    NameValue.Caption = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
    Log("Difficulty: " $ DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel());

    DifficultyList.SetIndex(DOTZPlayerControllerBase(PlayerOwner()).GetDifficultyLevel());
    //SubtitleCheck.bChecked = DOTZPlayerControllerBase(PlayerOwner()).GetUseSubtitles();
}

/*****************************************************************
 * Closed
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Refresh_Profiles_List();
    Refresh_Current_Profile();
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
 event Closed( GUIComponent Sender, bool bCancelled ) {
   Super.Closed( Sender, bCancelled );
   Controller.MouseEmulation( false );
}

/*****************************************************************
 * ButtonClicked
 *****************************************************************
 */
function bool ButtonClicked( GUIComponent Sender )
{
    local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected)
    {
        //NEW PROFILE BUTTON
        case NewProfileButton:
            return Controller.OpenMenu( NewProfileMenu ); break;

        //LOAD PROFILE BUTTON
        case LoadProfileButton:
            LoadProfile();
            return true;

        //DELETE PROFILE BUTTON
        case DeleteProfileButton:
            DeleteProfile();
            return true;
    }

   return true;
}

/*****************************************************************
 * LoadProfile
 *****************************************************************
 */
function LoadProfile()
{
    local int list_index;

    // Load up the selected profile
    list_index = ProfileList.List.Index;
    if (list_index < 0 || list_index >= ProfileList.List.ItemCount)
        return;

    if(DOTZPlayerControllerBase(PlayerOwner()).LoadProfile(list_index)){
        Refresh_Current_Profile ();
        Controller.OpenMenu( "DOTZMenu.DOTZProfileLoaded"  );
    }
}

/*****************************************************************
 * DeleteProfile
 *****************************************************************
 */
function DeleteProfile()
{
    local int list_index;

    // Load up the selected profile
    list_index = ProfileList.List.Index;
    if (list_index < 0 || list_index >= ProfileList.List.ItemCount)
        return;

    if(DOTZPlayerControllerBase(PlayerOwner()).DeleteProfile(list_index)) {
        Refresh_Profiles_List();
        Refresh_Current_Profile();
    }
}


/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */
event NotifyLevelChange() {
   Controller.CloseMenu( true );
}

/*****************************************************************
 * Change settings
 *****************************************************************
 */

function DifficultyChange( GUIComponent Sender ) {
    Log("Difficulty changed: " $ DifficultyList.GetIndex());
    DOTZPlayerControllerBase(PlayerOwner()).SetDifficultyLevel(DifficultyList.GetIndex());
}

/*function SubtitlesChange( GUIComponent Sender ) {
    DOTZPlayerControllerBase(PlayerOwner()).SetUseSubtitles(SubtitleCheck.bChecked);
}*/


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=BBListBox Name=ProfileList_box
         bVisibleWhenEmpty=True
         StyleName="BBRoundButton"
         bNeverFocus=True
         WinTop=0.460000
         WinLeft=0.350000
         WinWidth=0.500000
         WinHeight=0.400000
         Name="ProfileList_box"
     End Object
     ProfileList=BBListBox'DOTZMenu.DOTZProfileMenu.ProfileList_box'
     Begin Object Class=GUILabel Name=List_lbl
         Caption="Select a profile:"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.400000
         WinLeft=0.350000
         WinWidth=0.300000
         WinHeight=0.060000
         Name="List_lbl"
     End Object
     ListLabel=GUILabel'DOTZMenu.DOTZProfileMenu.List_lbl'
     Begin Object Class=GUILabel Name=Name_lbl
         Caption="Name:"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.250000
         WinLeft=0.170000
         WinWidth=0.250000
         WinHeight=0.060000
         Name="Name_lbl"
     End Object
     NameLabel=GUILabel'DOTZMenu.DOTZProfileMenu.Name_lbl'
     Begin Object Class=GUILabel Name=Diff_lbl
         Caption="Single Player Difficulty:"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.320000
         WinLeft=0.170000
         WinWidth=0.350000
         WinHeight=0.060000
         Name="Diff_lbl"
     End Object
     DiffLabel=GUILabel'DOTZMenu.DOTZProfileMenu.Diff_lbl'
     Begin Object Class=GUILabel Name=NameValue_lbl
         Caption="?????"
         TextColor=(B=119,G=243,R=248)
         TextFont="PlainGuiFont"
         WinTop=0.250000
         WinLeft=0.550000
         WinWidth=0.250000
         WinHeight=0.060000
         Name="NameValue_lbl"
     End Object
     NameValue=GUILabel'DOTZMenu.DOTZProfileMenu.NameValue_lbl'
     Begin Object Class=BBComboBox Name=DifficultyList_lbl
         StyleName="BBTextButton"
         Hint="Choose how difficult the game is"
         WinTop=0.320000
         WinLeft=0.550000
         WinWidth=0.350000
         Name="DifficultyList_lbl"
     End Object
     DifficultyList=BBComboBox'DOTZMenu.DOTZProfileMenu.DifficultyList_lbl'
     Begin Object Class=GUIButton Name=NewProfile_btn
         Caption="New"
         StyleName="BBRoundButton"
         Hint="Create a new profile."
         WinTop=0.520000
         WinLeft=0.125000
         WinWidth=0.200000
         WinHeight=0.050000
         RenderWeight=0.900000
         __OnClick__Delegate=DOTZProfileMenu.ButtonClicked
         Name="NewProfile_btn"
     End Object
     NewProfileButton=GUIButton'DOTZMenu.DOTZProfileMenu.NewProfile_btn'
     Begin Object Class=GUIButton Name=LoadProfile_btn
         Caption="Load"
         StyleName="BBRoundButton"
         Hint="Load a profile."
         WinTop=0.600000
         WinLeft=0.125000
         WinWidth=0.200000
         WinHeight=0.050000
         RenderWeight=0.900000
         __OnClick__Delegate=DOTZProfileMenu.ButtonClicked
         Name="LoadProfile_btn"
     End Object
     LoadProfileButton=GUIButton'DOTZMenu.DOTZProfileMenu.LoadProfile_btn'
     Begin Object Class=GUIButton Name=DeleteProfile_btn
         Caption="Delete"
         StyleName="BBRoundButton"
         Hint="Delete a profile."
         WinTop=0.680000
         WinLeft=0.125000
         WinWidth=0.200000
         WinHeight=0.050000
         RenderWeight=0.900000
         __OnClick__Delegate=DOTZProfileMenu.ButtonClicked
         Name="DeleteProfile_btn"
     End Object
     DeleteProfileButton=GUIButton'DOTZMenu.DOTZProfileMenu.DeleteProfile_btn'
     NewProfileMenu="DOTZMenu.DOTZNewProfile"
     PageCaption="Profiles"
     ClickSound=Sound'DOTZXInterface.Select'
     Easytxt="Easy"
     Normaltxt="Normal"
     DifficultTxt="Difficult"
     __OnKeyEvent__Delegate=DOTZProfileMenu.HandleKeyEvent
}
