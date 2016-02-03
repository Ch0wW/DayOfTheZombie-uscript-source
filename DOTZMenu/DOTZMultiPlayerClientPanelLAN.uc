// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * A one-page configuration panel, which covers coarse graphics and
 * sound settings.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #2 $
 * @date    Oct 2003
 */
class DOTZMultiPlayerClientPanelLAN extends DOTZMultiPlayerClientPanel;

var LANQueryClient LQC;
var GUIButton RefreshButton;
var GUIButton NextButton;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.Initcomponent(MyController, MyOwner);

   MyServersList = DOTZBrowser_ServersList(GUIMultiColumnListBox(Controls[0]).List);
   RefreshButton = GUIButton(Controls[1]);
   NextButton = GUIButton(Controls[2]);
   NextButton.OnClick=OnNext;
   MyServersList.MyPage        = Self;

    if( LQC == none )
    {
        LQC = PlayerOwner().Level.Spawn( class'LANQueryClient' );
        LQC.OnReceivedPingInfo = MyReceivedPingInfo;
        LQC.OnPingTimeout      = MyServersList.MyPingTimeout;
    }

   RefreshButton.OnClick=RefreshClick;
    // Change server list spacing a bit (no icons)
//  MyServersList.InitColumnPerc[0]=0.0;
//  MyServersList.InitColumnPerc[1]=0.47;
//  MyServersList.InitColumnPerc[2]=0.25;
//  MyServersList.InitColumnPerc[3]=0.13;
//  MyServersList.InitColumnPerc[4]=0.15;

    RefreshList();
}

/*****************************************************************
 * Next Button
 *****************************************************************
 */
function bool OnNext( GUIComponent Sender ) {

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    MyServersList.Connect(false);
    return true;
}

/*****************************************************************
 * RefreshClick
 * calls refresh list
 *****************************************************************
 */
function bool RefreshClick(GUIComponent Sender)
{
   log(self @ "refreshclick");
 PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    RefreshList();
    return true;
}

function OnCloseBrowser()
{
    if( LQC != none )
    {
        LQC.Destroy();
        LQC = None;
    }
}

function MyReceivedPingInfo( int ServerID, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s ){
    local int i;
    if( ServerID < 0 ){
        for( i=0;i<MyServersList.Servers.Length;i++ ){
            // dupe
            if( MyServersList.Servers[i].IP==s.IP && MyServersList.Servers[i].Port==s.Port )
                return;
        }
        MyServersList.MyOnReceivedServer( s );
    }   else    {
        MyServersList.MyReceivedPingInfo( ServerID, PingCause, s );
    }
}


function PingServer( int listid, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s ){
    LQC.PingServer( listid, PingCause, s.IP, s.QueryPort, QI_RulesAndPlayers, s );
}

function CancelPings()
{
    LQC.CancelPings();
}

function RefreshList()
{
    MyServersList.Clear();
    CancelPings();
    LQC.BroadcastPingRequest();
}

function ShowPanel(bool bShow){
   super.ShowPanel(bShow);
   MyServersList.bLanQuery = true;
}

defaultproperties
{
     Controls(0)=BBGUIMultiColumnListBox'DOTZMenu.DOTZMultiPlayerClientPanelLAN.ServerListBox'
     Controls(1)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelLAN.aRefreshButton'
     Controls(2)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelLAN.NextButtonLabel_lbl'
}
