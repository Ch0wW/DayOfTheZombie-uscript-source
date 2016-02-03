// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class DOTZBaseCreateMatch extends DOTZMultiPlayerBase;



var Automated GUITabControl TabC;

var GUITabPanel MapsPanel;
var GUITabPanel GamePanel;
var GUITabPanel ServerPanel;

//Maps Page components
var BBComboBox GameTypeSelect;
var BBComboBox MapsSelect;

var BBListBox AllMaps;
var BBListBox SelectedMaps;

var GUIButton Map_Up;
var GUIButton Map_Add;
var GUIButton Map_AddAll;
var GUIButton Map_Remove;
var GUIButton Map_RemoveAll;
var GUIButton Map_Down;

// Game Page components
var BBComboBox TimeLimitSelect;
var BBComboBox ScoreLimitValue;
var BBComboBox MaxPlayersValue;
var BBComboBox FriendlyFireValue;
var GUILabel FriendlyFireTitleLabel;
var BBComboBox EnemyStrengthValue;


//server page components
//var BBCheckBoxButton MyAdvertise;
var BBEditBox PasswordBox;
var BBCheckBoxButton PasswordRequiredBox;
var BBEditBox ServerNameBox;
var BBComboBox NetworkBox;

//persistant storage related to the server panel
var config string GamePassword;
var config bool PasswordRequired;


//var Automated GuiButton  CreateMatchButton;
var localized string PageCaption;

var localized string MapsPanelTxt;
var string MapsPanelStr;
var localized string GamePanelTxt;
var string GamePanelStr;
var localized string ServerPanelTxt;
var string ServerPanelStr;

var localized string InternetTxt;
var localized string LANTxt;

const MAPS_TYPE=1;
//const MAPS_MAPS=3;
const MAPS_ALLMAPS=4;
const MAPS_SELECTEDMAPS=5;
const MAPS_UP_BUTTON=6;
const MAPS_ADD_BUTTON=7;
const MAPS_ADDALL_BUTTON=8;
const MAPS_REMOVE_BUTTON=9;
const MAPS_REMOVEALL_BUTTON=10;
const MAPS_DOWN_BUTTON=11;

const GAME_TIMELIMIT =1;
const GAME_SCORELIMIT =3;
const GAME_MAXPLAYERS =5;
const GAME_FRIENDLYFIRE =9;
const GAME_FRIENDLYFIRE_LABEL = 8;
const GAME_ENEMYSTRENGTH =7;

const SERVER_ADVERTISESERVER = 9;
const SERVER_PASSWORDBOX = 7;
const SERVER_PASSWORDREQUIREDBOX = 5;
const SERVER_SERVERNAMEBOX = 1;
const SERVER_NETWORKTYPE= 3;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
    local int i;

    Super.Initcomponent(MyController, MyOwner);
    // init my components...

    SetPageCaption(PageCaption);
    AddBackButton();
    AddNextButton();


    MapsPanel = TabC.AddTab( MapsPanelTxt,MapsPanelStr,,
                "" );
    GamePanel = TabC.AddTab( GamePanelTxt,GamePanelStr,,
                "" );
    ServerPanel = TabC.AddTab( ServerPanelTxt ,ServerPanelStr,,
                "" );

    for ( i = 0; i < TabC.TabStack.length; ++i ) {
      TabC.TabStack[i].Style = MyController.getStyle("BBTabButton");
    }


    // Copy references to controls

    // Maps Page
    GameTypeSelect = BBComboBox(MapsPanel.Controls[MAPS_TYPE]);
    GameTypeSelect.OnChange = GameTypeChange;
    //MapsSelect = BBComboBox(MapsPanel.Controls[MAPS_MAPS]);

    AllMaps = BBListBox(MapsPanel.Controls[MAPS_ALLMAPS]);
    SelectedMaps = BBListBox(MapsPanel.Controls[MAPS_SELECTEDMAPS]);

    Map_Up = GUIButton(MapsPanel.Controls[MAPS_UP_BUTTON]);
    Map_Up.OnClick=MapsButtonClicked;

    Map_Add = GUIButton(MapsPanel.Controls[MAPS_ADD_BUTTON]);
    Map_Add.OnClick=MapsButtonClicked;

    Map_AddAll = GUIButton(MapsPanel.Controls[MAPS_ADDALL_BUTTON]);
    Map_AddAll.OnClick=MapsButtonClicked;

    Map_Remove = GUIButton(MapsPanel.Controls[MAPS_REMOVE_BUTTON]);
    Map_Remove.OnClick=MapsButtonClicked;

    Map_RemoveAll = GUIButton(MapsPanel.Controls[MAPS_REMOVEALL_BUTTON]);
    Map_RemoveAll.OnClick=MapsButtonClicked;

    Map_Down = GUIButton(MapsPanel.Controls[MAPS_DOWN_BUTTON]);
    Map_Down.OnClick=MapsButtonClicked;

    // Game Page
    TimeLimitSelect = BBComboBox(GamePanel.Controls[GAME_TIMELIMIT]);
    ScoreLimitValue = BBComboBox(GamePanel.Controls[GAME_SCORELIMIT]);
    MaxPlayersValue = BBComboBox(GamePanel.Controls[GAME_MAXPLAYERS]);
    FriendlyFireValue = BBComboBox(GamePanel.Controls[GAME_FRIENDLYFIRE]);
    FriendlyFireTitleLabel = GUILabel(GamePanel.Controls[GAME_FRIENDLYFIRE_LABEL]);
    EnemyStrengthValue = BBComboBox(GamePanel.Controls[GAME_ENEMYSTRENGTH]);


    //servers page
//    MyAdvertise = BBCheckBoxButton(ServerPanel.Controls[SERVER_ADVERTISESERVER]);
//    MyAdvertise.bChecked = class'MasterServerUplink'.default.DoUplink;
//    MyAdvertise.SetChecked(class'MasterServerUplink'.default.DoUplink);

    NetworkBox = BBComboBox(ServerPanel.Controls[SERVER_NETWORKTYPE]);
    NetworkBox.AddItem(InternetTxt);
    NetworkBox.AddItem(LANTxt);


    PasswordBox = BBEditBox(ServerPanel.Controls[SERVER_PASSWORDBOX]);
    PasswordBox.bConvertSpaces = true;
    PasswordBox.SetText(self.default.GamePassword);

    PasswordRequiredBox = BBCheckBoxButton(ServerPanel.Controls[SERVER_PASSWORDREQUIREDBOX]);
    PasswordRequiredBox.bChecked = self.default.PasswordRequired;
    PasswordRequiredBox.SetChecked(self.default.PasswordRequired);

    ServerNameBox = BBEditBox(ServerPanel.Controls[SERVER_SERVERNAMEBOX]);
    ServerNameBox.SetText(class'GameReplicationInfo'.default.ServerName);

    // Populate Menus

    // Game type
    FillInGameTypes(GameTypeSelect);

    // Time limit
    FillInTimeLimits(TimeLimitSelect);
    TimeLimitSelect.SetIndex(9);

    // Score limit
    //FillInScoreLimits(ScoreLimitValue, GametypeSelect.List.Index);
    //   ScoreLimitValue.AddItem(UnlimitedText);

    // Max players
    //   FillInPlayerLimits(MaxPlayersValue);
    //   MaxPlayersValue.SetIndex(7);

    //Friendly Fire
    FriendlyFireValue.AddItem(IntToYesNo(0));
    FriendlyFireValue.AddItem(IntToYesNo(1));

    EnemyStrengthValue.AddItem(EnemyPatheticTxt);
    EnemyStrengthValue.AddItem(EnemyNormalTxt);
    EnemyStrengthValue.AddItem(EnemyImpossibleTxt);
    EnemyStrengthValue.SetIndex(1);
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
}


/*****************************************************************
 * TabChange
 *****************************************************************
 */
function TabChange( GUIComponent Sender ) {
   if ( GUITabButton(Sender) == none ) return;
  	PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
}

/*****************************************************************
 * Closed
 *****************************************************************
 */

event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);
   SaveSettings();
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
 * Game type change
 *****************************************************************
 */

function GameTypeChange( GUIComponent Sender ) {
   // Maps
   MapsSelect.List.Clear();
   FillInMapTitles(MapsSelect.List, GametypeSelect.List.Index);

   AllMaps.List.Clear();
   SelectedMaps.List.Clear();
   FillInMapTitles(AllMaps.List, GametypeSelect.List.Index);

   //score limits
   ScoreLimitValue.List.Clear();
   FillInScoreLimits(ScoreLimitValue, GametypeSelect.List.Index);

   FillInPlayerLimits(MaxPlayersValue, GameTypeSelect.List.Index);
}


function SaveSettings(){
   //set to advertise to the master server or not
    //class'MasterServerUplink'.default.DoUplink = MyAdvertise.bChecked;
//  	 class'MasterServerUplink'.Static.StaticSaveConfig();

    if (NetworkBox.GetIndex() == 0){
      class'MasterServerUplink'.default.DoUplink = true;
      class'MasterServerUplink'.default.LANPort= 11777;
      class'MasterServerUplink'.default.LANServerPort=10777;

    } else {
      class'MasterServerUplink'.default.DoUplink = false;
      class'MasterServerUplink'.default.LANPort= 11777;
      class'MasterServerUplink'.default.LANServerPort=10777;

    }
  	 class'MasterServerUplink'.Static.StaticSaveConfig();

    class'GameReplicationInfo'.default.ServerName = ServerNameBox.GetText();
  	 class'GameReplicationInfo'.Static.StaticSaveConfig();

    self.default.PasswordRequired = PasswordRequiredBox.bChecked;
    self.default.GamePassword = PasswordBox.GetText();
    self.static.StaticSaveConfig();
}

/*****************************************************************
 * Next Button
 *****************************************************************
 */

function Click_Next ()
{
    local string matchname;
    local string mapname;
    local int gametype;
    local int scorelimit;
    local int timelimit;
    local int maxplayers;
    //local bool privateslots;
    local bool friendlyfire;
    local int enemystrength;
    local MapList MyMapList;
    local int i;

    if (SelectedMaps.List.Elements.Length <= 0) {
        Controller.OpenMenu("DOTZMenu.DOTZEmptyMapRotation");
        return;
    }

    matchname = "Match";                                            // Use live name as match name
    gametype = GametypeSelect.List.Index;                           // index is value
    //mapname = GetActualMapName (gametype, MapsSelect.List.Index);
    scorelimit = int(ScoreLimitValue.GetExtra()); //ScoreLimitIndexToScore (ScoreLimitValue.List.Index);
    timelimit = int(TimeLimitSelect.GetExtra()); //TimeLimitIndexToMinutes (TimeLimitSelect.List.Index);
    maxplayers = MaxPlayersValue.List.Index + 1;
    //privateslots = (PrivateSlotsValue.List.Index == 1);
    friendlyfire = (FriendlyFireValue.List.Index == 1);              // index is value (0 or 1)
    enemystrength = EnemyStrengthValue.List.Index;

    //Add stuff to map list
    MyMapList = GetMapList("AdvancedEngine.AdvancedMapList");
    MyMapList.Maps.Length = 0;
    for (i=0;i<SelectedMaps.List.Elements.Length;i++){
      MyMapList.Maps.Insert(i,1);
      MyMapList.Maps[i] = SelectedMaps.List.GetExtraAtIndex(i);
      Log(MyMapList.Maps[i]);
    }
    Mapname = MyMapList.Maps[0];
    MyMapList.SaveConfig();

    if (PasswordRequiredBox.bChecked == true){
      GamePassword = PasswordBox.GetText();
      Controller.OpenMenu("DOTZMenu.DOTZCharacterSelect",mapname
                $ "?FriendlyFire=" $ friendlyfire
                $ "?TimeLimit=" $ timelimit
                $ "?GoalScore=" $ scorelimit
                $ "?IsTeam=" $ bIsTeamMatch
                $ "?EnemyStrength=" $ enemystrength
                $ "?MaxPlayers=" $ maxplayers
                $ "?GamePassword=" $ gamePassword
                $ "?Listen");
    } else {
      Controller.OpenMenu("DOTZMenu.DOTZCharacterSelect",mapname
                $ "?FriendlyFire=" $ friendlyfire
                $ "?TimeLimit=" $ timelimit
                $ "?GoalScore=" $ scorelimit
                $ "?IsTeam=" $ bIsTeamMatch
                $ "?EnemyStrength=" $ enemystrength
                $ "?MaxPlayers=" $ maxplayers
                $ "?Listen");
    }

    SaveSettings();




}


function MapList GetMapList(string MapListType)
{
   local class<MapList> MapListClass;


	if (MapListType != ""){
      MapListClass = class<MapList>(DynamicLoadObject(MapListType, class'Class'));
		if (MapListClass != None){
			 return PlayerOwner().Spawn(MapListClass);
      }
	}
	return None;
}


/*****************************************************************
 * SetTeamMatchStatus
 * Use the notification to determine if a friendlyfire button makes
 * any sense to display
 *****************************************************************
 */
function SetTeamMatchStatus(bool IsTeamGame){
   super.SetTeamMatchStatus(IsTeamGame);
   FriendlyFireValue.bNeverFocus = !IsTeamGame;
   FriendlyFireValue.bVisible = IsTeamGame;
   FriendlyFireTitleLabel.bVisible = IsTeamGame;
   MapControls();
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool MapsButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected)
    {
        case Map_Up:
            SelectedMaps.List.Swap(SelectedMaps.List.Index, SelectedMaps.List.Index-1);
            --SelectedMaps.List.Index;
            break;
        case Map_Down:
            SelectedMaps.List.Swap(SelectedMaps.List.Index, SelectedMaps.List.Index+1);
            ++SelectedMaps.List.Index;
            break;

        case Map_Add:
            if (AllMaps.List.Index >= 0)
                SelectedMaps.List.Add(  AllMaps.List.GetItemAtIndex(AllMaps.List.Index),
                                        AllMaps.List.GetObjectAtIndex(AllMaps.List.Index),
                                        AllMaps.List.GetExtraAtIndex(AllMaps.List.Index)    );
            break;
        case Map_AddAll:
            SelectedMaps.List.LoadFrom(AllMaps.List, false);
            break;

        case Map_Remove:
            SelectedMaps.List.Remove(SelectedMaps.List.Index);
            break;
        case Map_RemoveAll:
            SelectedMaps.List.Clear();
            break;

    }
   return false;
}


/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUITabControl Name=MyTabs
         bDockPanels=True
         TabHeight=0.050000
         bAcceptsInput=True
         WinTop=0.165000
         WinLeft=0.110000
         WinHeight=48.000000
         __OnChange__Delegate=DOTZBaseCreateMatch.TabChange
         Name="MyTabs"
     End Object
     TabC=GUITabControl'DOTZMenu.DOTZBaseCreateMatch.MyTabs'
     PageCaption="Host Multiplayer"
     MapsPanelTxt="Game Type & Map"
     MapsPanelStr="DOTZMenu.DOTZMultiPlayerServerPanelMaps"
     GamePanelTxt="Game Rules"
     GamePanelStr="DOTZMenu.DOTZMultiPlayerServerPanelGame"
     ServerPanelTxt="Server Rules"
     ServerPanelStr="DOTZMenu.DOTZMultiPlayerServerPanelServer"
     InternetTxt="Internet & LAN"
     LANTxt="LAN"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.MultiplayerBackground'
     __OnKeyEvent__Delegate=DOTZBaseCreateMatch.HandleKeyEvent
}
