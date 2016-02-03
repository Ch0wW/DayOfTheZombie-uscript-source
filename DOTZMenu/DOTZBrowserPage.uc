// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZBrowserPage
 * -base page for GUI browsers
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class DOTZBrowserPage extends GUITabPanel;



var DOTZJoinMenu Browser;

var() localized string PageCaption;
var localized string StartQueryString;
var localized string AuthFailString;
var localized string ConnFailString;
var localized string ConnTimeoutString;
var localized string QueryCompleteString;
var localized string RefreshCompleteString;
var localized string ReadyString;


function OnCloseBrowser();

defaultproperties
{
     StartQueryString="Querying Master Server"
     AuthFailString="Authentication Failed"
     ConnFailString="Connection Failed - Retrying"
     ConnTimeoutString="Connection Timed Out"
     QueryCompleteString="Query Complete!"
     RefreshCompleteString="Refresh Complete!"
     ReadyString="Ready"
     bFillHeight=True
     WinTop=0.150000
     WinHeight=0.850000
}
