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
class DOTZMultiPlayerClientPanelServerList extends DOTZMultiPlayerClientPanel;



var(Object) int DebugFlags;
var GUIButton RefreshButton;
var GUIButton NextButton;

// internal
var private bool bInitialized;
const SERVERLIST = 0;
var() bool bStarted;



/****************************************************************
 * InitComponent
 ****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner) {
   Super.InitComponent(MyController,MyOwner);

   MyServersList = DOTZBrowser_ServersList(GUIMultiColumnListBox(Controls[0]).List);
   RefreshButton = GUIButton(Controls[1]);
   NextButton = GUIButton(Controls[2]);
   NextButton.OnClick=OnNext;
   MyServersList.MyPage        = Self;

   if( MSC == None ){
      MSC = PlayerOwner().Level.Spawn( class'MasterServerClient' );
      MSC.OnReceivedServer    = MyServersList.MyOnReceivedServer;
      MSC.OnQueryFinished     = MyQueryFinished;
      MSC.OnReceivedPingInfo  = MyReceivedPingInfo;
      MSC.OnPingTimeout       = MyPingTimeout;
   }

   RefreshButton.OnClick=RefreshClick;
   bInitialized = true;
}

function InitPanel(){
   super.InitPanel();
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
 * AddQueryTerm
 *****************************************************************
 */
function AddQueryTerm(string Key, string GameType, MasterServerClient.EQueryType QueryType)
{
    local MasterServerClient.QueryData QD;
    local int i;

    QD.Key          = Key;
    QD.Value        = GameType;
    QD.QueryType    = QueryType;

    i = MSC.Query.Length;
    MSC.Query.Length = i + 1;
    MSC.Query[i] = QD;
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

/*****************************************************************
 * RefreshList
 * Called to start a new query to the masterserver. You get results
 * back, and update the display when the query finishes
 *****************************************************************
 */
function RefreshList()
{
    local string NullTest;

    MyServersList.Clear();
    // Build query
    MSC.Query.Length = 0;
    NullTest = ParentPage.Filter_GameTypeBox.GetExtra();
    if (NullTest != ""){
      AddQueryTerm("gametype", ParentPage.Filter_GameTypeBox.GetExtra() , QT_Equals);
    } else {
      AddQueryTerm("gametype", "" , QT_NotEquals);
    }

    if(ParentPage.Filter_PasswordBox.IsChecked() == true){
      AddQueryTerm("password", "false", QT_Equals);
    }

    if(ParentPage.Filter_FullServerBox.IsChecked() == true){
      AddQueryTerm("freespace", "0", QT_GreaterThan);
    }

    //if(Browser.bDontShowEmpty)
    //  AddQueryTerm("currentplayers", "0", QT_GreaterThan);

    MSC.StartQuery(CTM_Query);
}

/*****************************************************************
 * MyQueryFinished
 * A query to requested before has completed. You should update the
 * information you are presenting to the user.
 *****************************************************************
 */
function MyQueryFinished( MasterServerClient.EResponseInfo ResponseInfo, int Info )
{

   log(self @ "Myqueryfinished");

   MyServersList.MyQueryFinished(ResponseInfo, Info);

    switch( ResponseInfo )
    {
    case RI_Success:
        //change the caption
        Log("success");
        break;
    case RI_AuthenticationFailed:
        //change the caption
        Log("autho");
        break;
    case RI_ConnectionFailed:
        Log("con failed");
        //change the caption
        break;
    case RI_ConnectionTimeout:
        Log("conn timout");
        //change the caption
        break;
    case RI_MustUpgrade:
        Log("must upgrade");
        //change the caption
        break;
    }

}


/*****************************************************************
 * OnCloseBrowser
 * This is called from the page that opened it to let this master server
 * stuff clean up.
 *****************************************************************
*/
function OnCloseBrowser()
{
    if( MSC != None )
    {
        MSC.CancelPings();
        MSC.Destroy();
        MSC = None;
    }
}


function ShowPanel(bool bShow){
    Super.ShowPanel(bShow);
    if( bShow ){
        if( !bStarted )
        {
            Log(MyButton.Caption$": Initial refresh");
            RefreshList();
            bStarted = True;
        } else {
            // Resume pings
            Log(MyButton.Caption$": Resuming pings");
            MyServersList.AutoPingServers();
        }
        MyServersList.bLanQuery = false;
    } else {
        // Pause pings
        Log(MyButton.Caption$": Cancelling pings");
        MyServersList.StopPings();
    }
}




// Caught for status bar updating

function UpdateStatusPingCount()
{
    if(MyServersList.NumReceivedPings < MyServersList.Servers.Length)
    {
//        StatusBar.Caption = (PingRecvString@"("$MyServersList.NumReceivedPings$"/"$MyServersList.Servers.Length$")");
    }
    else
    {
  //      StatusBar.Caption = (RefreshFinHead@MyServersList.Servers.Length@RefreshFinMid@MyServersList.NumPlayers@RefreshFinTail);
    }
}

function MyReceivedPingInfo( int ServerID, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s )
{
    MyServersList.MyReceivedPingInfo(ServerID, PingCause, s);

    if(PingCause == PC_AutoPing)
        UpdateStatusPingCount();
}

function MyPingTimeout( int listid, ServerQueryClient.EPingCause PingCause  )
{
    MyServersList.MyPingTimeout(listid, PingCause);

    if(PingCause == PC_AutoPing)
        UpdateStatusPingCount();
}


function bool MyRePing(GUIComponent Sender)
{
    MyServersList.RePingServers();
    return true;
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     DebugFlags=1
     Controls(0)=BBGUIMultiColumnListBox'DOTZMenu.DOTZMultiPlayerClientPanelServerList.ServerListBox'
     Controls(1)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelServerList.aRefreshButton'
     Controls(2)=GUIButton'DOTZMenu.DOTZMultiPlayerClientPanelServerList.NextButtonLabel_lbl'
}
