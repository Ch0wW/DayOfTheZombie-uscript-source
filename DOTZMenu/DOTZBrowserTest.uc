// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZBrowserTest
 * -GUI page for testing client/server interaction
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class DOTZBrowserTest extends DOTZBrowserPage;



var MasterServerClient MSC;

var GUITitleBar StatusBar;

var float ReReadyPause;



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    StatusBar = GUITitleBar(GUIPanel(Controls[0]).Controls[3]);
    StatusBar.Caption = ReadyString;

    MSC = PlayerOwner().Level.Spawn( class'MasterServerClient' );
    //MSC.OnReceivedMOTDData = MyReceivedMOTDData;
    MSC.OnQueryFinished  = MyQueryFinished;
    MSC.OnReceivedServer = MyOnReceivedServer;

    //MSC.StartQuery(CTM_GetMOTD);

    StatusBar.Caption = StartQueryString;
    SetTimer(0, false); // Stop it going back to ready from a previous timer!

    GUIButton(GUIPanel(Controls[0]).Controls[0]).OnClick=BackClick;
    GUIButton(GUIPanel(Controls[0]).Controls[1]).OnClick=RefreshClick;

    //Controls[2].bBoundToParent=false;
    //GUILabel(Controls[2]).Caption = "DOTZ TEST BROWSER";
}

event Timer()
{
    StatusBar.Caption=ReadyString;
}


function MyQueryFinished( MasterServerClient.EResponseInfo ResponseInfo, int Info )
{
    switch( ResponseInfo )
    {
    case RI_Success:
        StatusBar.Caption = QueryCompleteString;
        SetTimer(ReReadyPause, false);

        Log("MyQueryFinished(): RI_Success");
        break;
    case RI_AuthenticationFailed:
        StatusBar.Caption = AuthFailString;
        SetTimer(ReReadyPause, false);

        Log("MyQueryFinished(): RI_AuthenticationFailed");
        break;
    case RI_ConnectionFailed:
        StatusBar.Caption = ConnFailString;
        SetTimer(ReReadyPause, false);
        // try again
        //MSC.StartQuery(CTM_GetMOTD);

        Log("MyQueryFinished(): RI_ConnectionFailed");
        break;
    case RI_ConnectionTimeout:
        StatusBar.Caption = ConnTimeoutString;
        SetTimer(ReReadyPause, false);

        Log("MyQueryFinished(): RI_ConnectionTimeout");
        break;
    }
}

function OnCloseBrowser()
{
    if( MSC != None )
    {
        MSC.CancelPings();
        MSC.Destroy();
        MSC = None;
    }
}

// delegates
function bool BackClick(GUIComponent Sender)
{
    Controller.CloseMenu(true);
    return true;
}

function bool RefreshClick(GUIComponent Sender)
{
    //MustUpgrade = false;
    //UpgradeButton.bVisible = false;
    MSC.Stop();
    //MSC.StartQuery(CTM_GetMOTD);
    //BuildNewQuery();

    RefreshList();

    StatusBar.Caption = StartQueryString;
    SetTimer(0, false);

    return true;
}

function BuildNewQuery()
{
    local MasterServerClient.QueryData QD;
    local int i;

    MSC.Query.Length = 0;

    QD.Key = "key";
    QD.QueryType = QT_Equals;
    QD.Value = "value";

    i = MSC.Query.Length;
    MSC.Query.Length = i + 1;
    MSC.Query[i] = QD;

    MSC.StartQuery(CTM_Query);

    StatusBar.Caption=StartQueryString;
    Log("BuildNewQuery(): sending query");
}

function MyOnReceivedServer( GameInfo.ServerResponseLine s )
{

    Log("received: " $ s.PORT);

    //i = Servers.Length;
    //Servers.Length=i+1;
    //Servers[i] = s;
    //if( Servers[i].Ping == 0 )
    //  Servers[i].Ping = 9999;
    //ItemCount++;
    //AddedItem();
}

function AddQueryTerm(string Key, string GameType, MasterServerClient.EQueryType QueryType)
{
    local MasterServerClient.QueryData QD;
    local int i;

    //Log("["$Key$"] ["$GameType$"] ["$QueryType$"]");

    QD.Key          = Key;
    QD.Value        = GameType;
    QD.QueryType    = QueryType;

    i = MSC.Query.Length;
    MSC.Query.Length = i + 1;
    MSC.Query[i] = QD;
}

function RefreshList()
{

    //MyServersList.Clear();

    // Build query
    MSC.Query.Length = 0;
    AddQueryTerm("gametype", "DOTZDeathMatch", QT_Equals);

    // Add any extra filtering to the query
    //if(Browser.bOnlyShowStandard)
    //  AddQueryTerm("standard", "true", QT_Equals);

    //if(Browser.bOnlyShowNonPassword)
    //  AddQueryTerm("password", "false", QT_Equals);

    //if(Browser.bDontShowFull)
    //  AddQueryTerm("freespace", "0", QT_GreaterThan);

    //if(Browser.bDontShowEmpty)
        AddQueryTerm("currentplayers", "0", QT_GreaterThan);

//  if(Browser.StatsServerView == SSV_OnlyStatsEnabled)
    //  AddQueryTerm("stats", "true", QT_Equals);
    //else if(Browser.StatsServerView == SSV_NoStatsEnabled)
    //  AddQueryTerm("stats", "false", QT_Equals);
//

    // MUTATOR 1
    // Send only the stuff to the right of the dot...
    //dotPos = InStr(Browser.DesiredMutator, ".");

    //if(dotPos < 0)
    //  TmpString = Browser.DesiredMutator;
    //else
    //  TmpString = Mid(Browser.DesiredMutator, dotPos + 1);

    //if(Browser.ViewMutatorMode == VMM_NoMutators)
    //  AddQueryTerm("mutator", "", QT_Equals); // Empty string indicates 'no mutators please'
    //else if(Browser.ViewMutatorMode == VMM_ThisMutator && TmpString != "")
    //  AddQueryTerm("mutator", TmpString, QT_Equals);
    //else if(Browser.ViewMutatorMode == VMM_NotThisMutator && TmpString != "")
    //  AddQueryTerm("mutator", TmpString, QT_NotEquals);

    // MUTATOR2
    //dotPos = InStr(Browser.DesiredMutator2, ".");

    //if(dotPos < 0)
    //  TmpString = Browser.DesiredMutator2;
    //else
    //  TmpString = Mid(Browser.DesiredMutator2, dotPos + 1);

    //if(Browser.ViewMutator2Mode == VMM_ThisMutator && TmpString != "")
    //  AddQueryTerm("mutator", TmpString, QT_Equals);
    //else if(Browser.ViewMutator2Mode == VMM_NotThisMutator && TmpString != "")
    //  AddQueryTerm("mutator", TmpString, QT_NotEquals);


    //if(Browser.bDontShowWithBots)
    //  AddQueryTerm("nobots", "true", QT_Equals);

//  if(Browser.WeaponStayServerView == WSSV_OnlyWeaponStay)
    //  AddQueryTerm("weaponstay", "true", QT_Equals);
//  else if(Browser.WeaponStayServerView == WSSV_NoWeaponStay)
    //  AddQueryTerm("weaponstay", "false", QT_Equals);

    //if(Browser.TranslocServerView == TSV_OnlyTransloc)
    //  AddQueryTerm("transloc", "true", QT_Equals);
    //else if(Browser.TranslocServerView == TSV_NoTransloc)
    //  AddQueryTerm("transloc", "false", QT_Equals);

    // If not entire range (and valid), add game speed query
    //if( (Browser.MinGamespeed != 0 || Browser.MaxGamespeed != 200) && Browser.MaxGamespeed >= Browser.MinGamespeed )
    //{
        // Master Server stores game speed as 1 = 100% etc
    //  AddQueryTerm("gamespeed", string(float(Browser.MinGamespeed)/100.0), QT_GreaterThanEquals);
    //  AddQueryTerm("gamespeed", string(float(Browser.MaxGamespeed)/100.0), QT_LessThanEquals);
    //}

    //if(Browser.CustomQuery != "")
    //{
    //  TmpString = Left(Browser.CustomQuery, 32); // Only send 32 chars max
    //  AddQueryTerm("custom", TmpString, QT_Equals);
    //}

    MSC.StartQuery(CTM_Query);

    StatusBar.Caption=StartQueryString;
}


/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
 *****************************************************************
 */
function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    //@@@ need to do something about the button-skipping problem here?
    // without this, menu closes quickly
   return true;
}

defaultproperties
{
     ReReadyPause=2.000000
     Controls(0)=GUIPanel'DOTZMenu.DOTZBrowserTest.FooterPanel'
     WinTop=0.000000
     WinHeight=1.000000
}
