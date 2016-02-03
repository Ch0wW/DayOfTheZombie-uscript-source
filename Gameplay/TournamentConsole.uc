// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
	class TournamentConsole extends WindowConsole;

var string ManagerWindowClass;
var string SlotWindowType;

var config string SavedPasswords[10];

state UWindow
{
	exec function MenuCmd(int Menu, int Item)
	{
	}
}

state Typing
{
	exec function MenuCmd(int Menu, int Item)
	{
	}
}

function LaunchUWindow()
{
	Super.LaunchUWindow();

	if( !bQuickKeyEnable && 
	    ( Left(Viewport.Actor.Level.GetLocalURL(), 9) ~= "cityintro" || 
	      Left(Viewport.Actor.Level.GetLocalURL(), 9) ~= "utcredits") )
		Viewport.Actor.ClientTravel( "?entry", TRAVEL_Absolute, False );

}

function StartNewGame()
{
}
/*
event ConnectFailure( string FailCode, string URL )
{
	local int i, j;
	local string Server;
	//local UTPasswordWindow W;

	if(FailCode == "NEEDPW")
	{
		Server = Left(URL, InStr(URL, "/"));
		for(i=0; i<10; i++)
		{
			j = InStr(SavedPasswords[i], "=");
			if(Left(SavedPasswords[i], j) == Server)
			{
				Viewport.Actor.ClearProgressMessages();
				Viewport.Actor.ClientTravel(URL$"?password="$Mid(SavedPasswords[i], j+1), TRAVEL_Absolute, false);
				return;
			}
		}
	}
* FIXME
	if(FailCode == "NEEDPW" || FailCode == "WRONGPW")
	{
		Viewport.Actor.ClearProgressMessages();
		CloseUWindow();
		bQuickKeyEnable = True;
		LaunchUWindow();
		W = UTPasswordWindow(Root.CreateWindow(class'UTPasswordWindow', 100, 100, 100, 100));
		UTPasswordCW(W.ClientArea).URL = URL;
	}

}
*/

function ConnectWithPassword(string URL, string Password)
{
	local int i;
	local string Server;
	local bool bFound;

	if(Password == "")
	{
		Viewport.Actor.ClientTravel(URL, TRAVEL_Absolute, false);
		return;
	}

	bFound = False;
	Server = Left(URL, InStr(URL, "/"));
	for(i=0; i<10; i++)
	{
		if(Left(SavedPasswords[i], InStr(SavedPasswords[i], "=")) == Server)
		{
			SavedPasswords[i] = Server$"="$Password;
			bFound = True;
			break;
		}
	}
	if(!bFound)
	{
		for(i=9; i>0; i--)
			SavedPasswords[i] = SavedPasswords[i-1];
		SavedPasswords[0] = Server$"="$Password;	
	}
	SaveConfig();
	Viewport.Actor.ClientTravel(URL$"?password="$Password, TRAVEL_Absolute, false);
}

defaultproperties
{
     ManagerWindowClass="NotifyWindow"
     SlotWindowType="UWindowWindow"
     ShowDesktop=True
}
