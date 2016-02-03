// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZBrowser_ServerListPageBase
 * -lists game servers received from Master Server
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class DOTZBrowser_ServerListPageBase extends DOTZBrowserPage;



// Internal
var DOTZBrowser_ServersList  MyServersList;
var bool ConnectLAN;
var GUITitleBar StatusBar;
var bool bInitialized;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);

    if( !bInitialized )
    {
        MyServersList = DOTZBrowser_ServersList(GUIMultiColumnListBox(GUIPanel(GUISplitter(Controls[0]).Controls[0]).Controls[0]).List);
      //  MyServersList.MyPage        = Self;
       // MyServersList.MyRulesList   = DOTZBrowser_RulesList  (GUIMultiColumnListBox(GUIPanel(GUISplitter(GUISplitter(Controls[0]).Controls[1]).Controls[0]).Controls[0]).List);
//        MyServersList.MyPlayersList = DOTZBrowser_PlayersList(GUIMultiColumnListBox(GUIPanel(GUISplitter(GUISplitter(Controls[0]).Controls[1]).Controls[1]).Controls[0]).List);
  //      MyServersList.MyRulesList.MyPage = Self;
    //    MyServersList.MyRulesList.MyServersList = MyServersList;
//        MyServersList.MyPlayersList.MyPage = Self;
//        MyServersList.MyPlayersList.MyServersList = MyServersList;

        StatusBar = GUITitleBar(GUIPanel(Controls[1]).Controls[5]);
    }
    StatusBar.Caption = ReadyString;

    if( !bInitialized )
    {
        GUIButton(GUIPanel(Controls[1]).Controls[0]).OnClick=BackClick;
        GUIButton(GUIPanel(Controls[1]).Controls[1]).OnClick=RefreshClick;
        GUIButton(GUIPanel(Controls[1]).Controls[2]).OnClick=JoinClick;
      //  GUIButton(GUIPanel(Controls[1]).Controls[3]).OnClick=SpectateClick;
//        GUIButton(GUIPanel(Controls[1]).Controls[4]).OnClick=AddFavoriteClick;
    }

    bInitialized = True;
}
// functions

function RefreshList()
{

}

function PingServer( int i, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s )
{
}

function CancelPings()
{
}

// delegates
function bool BackClick(GUIComponent Sender)
{
    Controller.CloseMenu(true);
    return true;
}

function bool RefreshClick(GUIComponent Sender)
{
    RefreshList();
    return true;
}

function bool JoinClick(GUIComponent Sender)
{
    MyServersList.Connect(false);
    return true;
}

function bool SpectateClick(GUIComponent Sender)
{
    MyServersList.Connect(true);
    return true;
}

function bool AddFavoriteClick(GUIComponent Sender)
{
    //MyServersList.AddFavorite(Browser);
    return true;
}

defaultproperties
{
     ConnectLAN=True
     Controls(0)=GUISplitter'DOTZMenu.DOTZBrowser_ServerListPageBase.MainSplitter'
     WinTop=0.000000
     WinHeight=1.000000
}
