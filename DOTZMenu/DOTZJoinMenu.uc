// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZJoinMenu
 * -contains all the multiplayer join game panels
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class DOTZJoinMenu extends DOTZMultiPlayerBase;




var Automated GUITabControl TabC;

//All the panels
var DOTZMultiPlayerClientPanel InternetListPage;
var DOTZMultiPlayerClientPanel DirectConnectionPage;
var DOTZMultiPlayerClientPanel FilterPage;
var DOTZMultiPlayerClientPanel LANPage;

var bool bCreatedQueryTabs;
var bool bCreatedStandardTabs;
var localized string PageCaption;

var localized string InternetTxt;
var localized string InternetFilterTxt;
var localized string LANTxt;
var localized string ManualTxt;

var bool bInitialized;

//A reference to the controls that are on the panels
var BBComboBox Filter_GameTypeBox;
const FILTER_GAMETYPE = 0;

var moCheckBox Filter_FullServerBox;
const FILTER_FULLSERVER = 2;

var moCheckBox Filter_PasswordBox;
const FILTER_PASSWORD = 4;

/*****************************************************************
 * InitComponents
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    //make page pretty
    SetPageCaption(PageCaption);
    AddBackButton();

    // delegates
    OnClose = InternalOnClose;

    // Add pages
    if(!bCreatedStandardTabs){
       AddBrowserPage(InternetListPage, InternetTxt);
       AddBrowserPage(FilterPage, InternetFilterTxt);
       AddBrowserPage(LANPage, LANTxt);
       AddBrowserPage(DirectConnectionPage, ManualTxt);
       bCreatedStandardTabs=true;
    }

    //add references to the sub controls
    Filter_GameTypeBox = BBComboBox(FilterPage.Controls[FILTER_GAMETYPE]);
    Filter_FullServerBox = moCheckBox(FilterPage.Controls[FILTER_FULLSERVER]);
    Filter_PasswordBox = moCheckBox(FilterPage.Controls[FILTER_PASSWORD]);
    bInitialized = true;
}

/*****************************************************************
 *
 *****************************************************************
 */
function AddBrowserPage( DOTZMultiPlayerClientPanel NewPage, string caption )
{
    TabC.AddTab(Caption,"", NewPage);
    NewPage.ParentPage = self;
}

/*****************************************************************
 * TabChange
 *****************************************************************
 */
function TabChange( GUIComponent Sender ) {
   if ( GUITabButton(Sender) == none ) return;
   if (!bInitialized) return;
  	PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
}


/*****************************************************************
 * InternalOnClose
 *****************************************************************
 */
function InternalOnClose(optional Bool bCanceled)
{
    local int i;
    for( i=0;i<TabC.TabStack.Length;i++ ){
        DOTZMultiPlayerClientPanel(TabC.TabStack[i].MyPanel).OnCloseBrowser();
    }
    Super.OnClose(bCanceled);
}

defaultproperties
{
     Begin Object Class=GUITabControl Name=ServerBrowserTabs
         bDockPanels=True
         TabHeight=0.050000
         bAcceptsInput=True
         WinTop=0.165000
         WinLeft=0.110000
         WinHeight=48.000000
         __OnChange__Delegate=DOTZJoinMenu.TabChange
         Name="ServerBrowserTabs"
     End Object
     TabC=GUITabControl'DOTZMenu.DOTZJoinMenu.ServerBrowserTabs'
     Begin Object Class=DOTZMultiPlayerClientPanelServerList Name=InternetListPanel
         Controls(0)=BBGUIMultiColumnListBox'DOTZMenu.DOTZMultiPlayerClientPanelServerList.ServerListBox'
         Controls(1)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelServerList.aRefreshButton'
         Controls(2)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelServerList.NextButtonLabel_lbl'
         Name="InternetListPanel"
     End Object
     InternetListPage=DOTZMultiPlayerClientPanelServerList'DOTZMenu.DOTZJoinMenu.InternetListPanel'
     Begin Object Class=DOTZMultiPlayerClientPanelManual Name=DirectConnectionPanel
         Name="DirectConnectionPanel"
     End Object
     DirectConnectionPage=DOTZMultiPlayerClientPanelManual'DOTZMenu.DOTZJoinMenu.DirectConnectionPanel'
     Begin Object Class=DOTZMultiPlayerClientPanelFilter Name=FilterPanel
         Controls(0)=BBComboBox'DOTZMenu.DOTZMultiPlayerClientPanelFilter.matchtype_cbox'
         Controls(1)=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelFilter.GameType_lbl'
         Controls(2)=moCheckBox'DOTZMenu.DOTZMultiPlayerClientPanelFilter.FullServers_check'
         Controls(3)=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelFilter.FullServer_lbl'
         Controls(4)=moCheckBox'DOTZMenu.DOTZMultiPlayerClientPanelFilter.Password_check'
         Controls(5)=GUILabel'DOTZMenu.DOTZMultiPlayerClientPanelFilter.Password_lbl'
         Name="FilterPanel"
     End Object
     FilterPage=DOTZMultiPlayerClientPanelFilter'DOTZMenu.DOTZJoinMenu.FilterPanel'
     Begin Object Class=DOTZMultiPlayerClientPanelLAN Name=LANPanel
         Controls(0)=BBGUIMultiColumnListBox'DOTZMenu.DOTZMultiPlayerClientPanelLAN.ServerListBox'
         Controls(1)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelLAN.aRefreshButton'
         Controls(2)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelLAN.NextButtonLabel_lbl'
         Name="LANPanel"
     End Object
     LANPage=DOTZMultiPlayerClientPanelLAN'DOTZMenu.DOTZJoinMenu.LANPanel'
     PageCaption="Join Multiplayer"
     InternetTxt="Internet"
     InternetFilterTxt="Internet Filter"
     LANTxt="LAN"
     ManualTxt="Connect to IP"
     Background=Texture'DOTZTInterface.Menu.MultiplayerBackground'
     __OnKeyEvent__Delegate=DOTZJoinMenu.HandleKeyEvent
}
