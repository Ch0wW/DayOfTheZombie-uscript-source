// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZProfilePlayer
 * NOT USED ANYMORE
 * -users can change their in-game player settings using this GUI
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #3 $
 * @date    May 2005
 */
class DOTZProfilePlayer extends DOTZProfilePanel;




var Automated GUILabel PlayerNameLabel;
var Automated GUILabel FOVLabel;
var Automated GUILabel TeamLabel;
var Automated GUILabel OnlineCharacterLabel;
var Automated GUILabel ProfileErrorLabel;

var Automated GUIEditBox PlayerNameBox;
var Automated GUINumericEdit FOVBox;
var Automated GuiComboBox TeamBox;
var Automated GuiComboBox OnlineCharacterBox;

var localized Array<String> Teams;
var localized Array<String> Characters;
var localized string NameErrorText;

var sound clickSound;

const constFOV = "DEFAULTFOV";
const constTEAM = "PREFERREDTEAM";
const constCHARACTER = "CHARACTER";



/****************************************************************
 * InitComponents
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
   local int i;

   Super.InitComponent(MyController,MyOwner);

   for ( i = 0; i < Teams.length; ++i )
   {
      TeamBox.AddItem( Teams[i] );
   }

   for ( i = 0; i < Characters.length; ++i )
   {
      OnlineCharacterBox.AddItem( Characters[i] );
   }

   LoadValues();
}


/****************************************************************
 * LoadValues
 * -populates GUI fields with info from currently loaded profile
 ****************************************************************
 */
function LoadValues()
{
    local string name;
    local int fov;
    local string team;

    name = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
    if(name != "")
    {
        // Load the player name
        PlayerNameBox.SetText(name);

        // Load the FOV
        fov = int(class'Profiler'.static.GetValue(constFOV));
        if(fov < 80)
            fov = 80;
        else if(fov > 100)
            fov = 100;
        FOVBox.SetValue(fov);

        // Load the team
        team = class'Profiler'.static.GetValue(constTEAM);
        if(team != "Red" && team != "Blue")
            team = "Red";
        TeamBox.SetText(team);

        // Load the multiplayer character
//        character = class'Profiler'.static.GetValue(constCHARACTER);
//        if(character != "Jack" && character != "Otis")
  //          character = "Jack";
  //      OnlineCharacterBox.SetText(character);
    }
}


/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled)
{
    UpdateProfile();
    Super.Closed(Sender,bCancelled);
    Controller.MouseEmulation(false);
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */
event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}



/*****************************************************************
 * HandleNameChange
 * -if name is already used, then this does not change it
 *****************************************************************
 */
function HandleNameChange(GUIComponent Sender)
{
    local int count, p;

    if(PlayerNameBox.GetText() == DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName())
        return;

    count = DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount();
    for (p = 0; p < count; ++p)
    {
        if(PlayerNameBox.GetText() == DOTZPlayerControllerBase(PlayerOwner()).GetProfileName(p))
        {
            ProfileErrorLabel.Caption = NameErrorText;
            ProfileErrorLabel.Show();
            return;
        }

        // This does not change actual name; when we close window, then it changes.
        //DOTZPlayerControllerBase(PlayerOwner()).RenameCurrentProfileName(PlayerNameBox.GetText());
    }
    ProfileErrorLabel.Hide();
}

/*****************************************************************
 * HandleFOVChange
 *****************************************************************
 */
function HandleFOVChange(GUIComponent Sender)
{
    class'Profiler'.static.SetValue(constFOV, FOVBox.Value);
}

/*****************************************************************
 * HandleTeamChange
 *****************************************************************
 */
function HandleTeamChange(GUIComponent Sender)
{
    class'Profiler'.static.SetValue(constTEAM, TeamBox.GetText());
}

/*****************************************************************
 * HandleCharacterChange
 *****************************************************************
 */
function HandleCharacterChange(GUIComponent Sender)
{
    class'Profiler'.static.SetValue(constCHARACTER, OnlineCharacterBox.GetText());
}

/*****************************************************************
 * UpdateProfile
 *****************************************************************
 */
function bool UpdateProfile()
{
    // Save the current profile first
    // The player name
    /*if(PlayerNameBox.GetText() != DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName())
    {
        DOTZPlayerControllerBase(PlayerOwner()).RenameCurrentProfileName(PlayerNameBox.GetText());
    }*/

    // The FOV
    class'Profiler'.static.SetValue(constFOV, FOVBox.Value);

    // The preferred team
    class'Profiler'.static.SetValue(constTEAM, TeamBox.GetText());

    // The online character
    class'Profiler'.static.SetValue(constCHARACTER, OnlineCharacterBox.GetText());

    // Save it
    DOTZPlayerControllerBase(PlayerOwner()).SaveProfile();

    return true;
}

defaultproperties
{
     Begin Object Class=GUILabel Name=PlayerName_label
         Caption="Player Name"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.100000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="PlayerName_label"
     End Object
     PlayerNameLabel=GUILabel'DOTZMenu.DOTZProfilePlayer.PlayerName_label'
     Begin Object Class=GUILabel Name=FOV_label
         Caption="Default FOV"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.225000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="FOV_label"
     End Object
     FOVLabel=GUILabel'DOTZMenu.DOTZProfilePlayer.FOV_label'
     Begin Object Class=GUILabel Name=Team_label
         Caption="Preferred Team"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.350000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="Team_label"
     End Object
     TeamLabel=GUILabel'DOTZMenu.DOTZProfilePlayer.Team_label'
     Begin Object Class=GUILabel Name=Character_label
         Caption="Multiplayer Character"
         TextColor=(B=119,G=243,R=248)
         TextFont="BoldGuiFont"
         WinTop=0.475000
         WinLeft=0.170000
         WinWidth=0.275000
         WinHeight=0.060000
         Name="Character_label"
     End Object
     OnlineCharacterLabel=GUILabel'DOTZMenu.DOTZProfilePlayer.Character_label'
     Begin Object Class=GUILabel Name=ProfileError_lbl
         TextAlign=TXTA_Center
         TextColor=(B=119,G=243,R=248)
         TextFont="BigGuiFont"
         bVisible=False
         WinTop=0.600000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.060000
         Name="ProfileError_lbl"
     End Object
     ProfileErrorLabel=GUILabel'DOTZMenu.DOTZProfilePlayer.ProfileError_lbl'
     Begin Object Class=BBEditBox Name=PlayerName_edit
         Hint="Enter the new player name"
         WinTop=0.100000
         WinLeft=0.550000
         WinHeight=0.060000
         __OnChange__Delegate=DOTZProfilePlayer.HandleNameChange
         Name="PlayerName_edit"
     End Object
     PlayerNameBox=BBEditBox'DOTZMenu.DOTZProfilePlayer.PlayerName_edit'
     Begin Object Class=BBNumericEdit Name=FOV_box
         Value="90"
         bLeftJustified=True
         MinValue=80
         MaxValue=100
         Step=5
         WinTop=0.225000
         WinLeft=0.550000
         WinWidth=0.130000
         TabOrder=1
         Name="FOV_box"
     End Object
     FOVBox=BBNumericEdit'DOTZMenu.DOTZProfilePlayer.FOV_box'
     Begin Object Class=BBComboBox Name=Team_box
         Hint="Choose your preferred team"
         WinTop=0.350000
         WinLeft=0.550000
         WinWidth=0.200000
         TabOrder=2
         Name="Team_box"
     End Object
     TeamBox=BBComboBox'DOTZMenu.DOTZProfilePlayer.Team_box'
     Begin Object Class=BBComboBox Name=OnlineCharacter_box
         Hint="Choose who you want to play as online"
         WinTop=0.480000
         WinLeft=0.550000
         WinWidth=0.200000
         TabOrder=2
         Name="OnlineCharacter_box"
     End Object
     OnlineCharacterBox=BBComboBox'DOTZMenu.DOTZProfilePlayer.OnlineCharacter_box'
     Teams(0)="Red"
     Teams(1)="Blue"
     Characters(0)="Jack"
     Characters(1)="Otis"
     NameErrorText="Player name already exists.  Choose another."
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=55.980499
     WinHeight=0.807813
}
