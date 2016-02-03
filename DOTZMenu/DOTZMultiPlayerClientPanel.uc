// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * A one-page configuration panel, which covers coarse graphics and
 * sound settings.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Oct 2003
 */
class DOTZMultiPlayerClientPanel extends DOTZMultiPlayerPanel;



var DOTZBrowser_ServersList  MyServersList;
var() MasterServerClient    MSC;

var DOTZJoinMenu ParentPage; //init by the parent page




/****************************************************************
 * InitComponent
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
   Super.InitComponent(MyController,MyOwner);

}


/*****************************************************************
 * OnCloseBrowser
 *****************************************************************
 */
function OnCloseBrowser()
{
    if( MSC != none ){
        MSC.CancelPings();
        MSC.Destroy();
        MSC = None;
    }
}

function PingServer( int listid, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s )
{
    if( PingCause == PC_Clicked )
        MSC.PingServer( listid, PingCause, s.IP, s.QueryPort, QI_RulesAndPlayers, s );
    else
        MSC.PingServer( listid, PingCause, s.IP, s.QueryPort, QI_Ping, s );
}

function CancelPings()
{
    MSC.CancelPings();
}

function RefreshList(){}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     WinTop=55.980499
     WinHeight=0.807813
}
