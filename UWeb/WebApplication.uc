// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class WebApplication extends Object;
	
// Set by the webserver
var LevelInfo Level;
var WebServer WebServer;
var string Path;

function Init();
function Cleanup();
function Query(WebRequest Request, WebResponse Response);

defaultproperties
{
}
