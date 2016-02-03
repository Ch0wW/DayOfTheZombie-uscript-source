// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
// ====================================================================
// (C) 2002, Epic Games
// ====================================================================

class ExtendedConsole extends Console;

#exec OBJ LOAD FILE=GUIContent.utx

// Visible Console stuff

var globalconfig int MaxScrollbackSize;

var array<string> Scrollback;
var int SBHead, SBPos;	// Where in the scrollback buffer are we
var bool bCtrl;
var bool bConsoleHotKey;

var float   ConsoleSoundVol;

var localized string AddedCurrentHead;
var localized string AddedCurrentTail;


var config EInputKey	LetterKeys[10];
var        EInputKey	NumberKeys[10];

var config bool bSpeechMenuUseLetters;
var config bool bSpeechMenuUseMouseWheel;

var int HighlightRow;

////// End Speech Menu

struct StoredPassword
{
	var config string	Server,
						Password;
};

var config array<StoredPassword>	SavedPasswords;
var config string					PasswordPromptMenu;
var string							LastConnectedServer,
									LastURL;


struct ChatStruct
{
	var string	Message;
    var int		team;
};


event ConnectFailure(string FailCode,string URL)
{
	local string			Server;
	local int				Index;

	LastURL = URL;
	Server = Left(URL,InStr(URL,"/"));

	if(FailCode == "NEEDPW")
	{
		for(Index = 0;Index < SavedPasswords.Length;Index++)
		{
			if(SavedPasswords[Index].Server == Server)
			{
				ViewportOwner.Actor.ClearProgressMessages();
				ViewportOwner.Actor.ClientTravel(URL$"?password="$SavedPasswords[Index].Password,TRAVEL_Absolute,false);
				return;
			}
		}

		LastConnectedServer = Server;
		ViewportOwner.Actor.ClientOpenMenu(
			PasswordPromptMenu,
			false,
			URL,
			""
			);
		return;
	}
	else if(FailCode == "WRONGPW")
	{
		ViewportOwner.Actor.ClearProgressMessages();

		for(Index = 0;Index < SavedPasswords.Length;Index++)
		{
			if(SavedPasswords[Index].Server == Server)
			{
				SavedPasswords.Remove(Index,1);
				SaveConfig();
			}
		}

		LastConnectedServer = Server;
		ViewportOwner.Actor.ClientOpenMenu(
			PasswordPromptMenu,
			false,
			URL,
			""
			);
		return;
	}
}


event NotifyLevelChange()
{
	Super.NotifyLevelChange();
//	GUIController(ViewportOwner.GUIController).CloseAll(false);
}


////// End Speech Menu

exec function CLS()
{
	SBHead = 0;
	ScrollBack.Remove(0,ScrollBack.Length);
}

function PostRender( canvas Canvas );	// Subclassed in state

event Message( coerce string Msg, float MsgLife)
{
	if (ScrollBack.Length==MaxScrollBackSize)	// if full, Remove Entry 0
	{
		ScrollBack.Remove(0,1);
		SBHead = MaxScrollBackSize-1;
	}
	else
		SBHead++;

	ScrollBack.Length = ScrollBack.Length + 1;

	Scrollback[SBHead] = Msg;
	Super.Message(Msg,MsgLife);
}

event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	if (Key==ConsoleKey)
	{
		if(Action==IST_Release)
			ConsoleOpen();
		return true;
	}

    return Super.KeyEvent(Key,Action,Delta);
}


function PlayConsoleSound(Sound S)
{
	if(ViewportOwner == None || ViewportOwner.Actor == None || ViewportOwner.Actor.Pawn == None)
		return;

	ViewportOwner.Actor.ClientPlaySound(S);//,true,ConsoleSoundVol);
}

//-----------------------------------------------------------------------------
// State used while typing a command on the console.

event NativeConsoleOpen()
{
	ConsoleOpen();
}

exec function ConsoleOpen()
{
	TypedStr = "";
	GotoState('ConsoleVisible');
}

exec function ConsoleClose()
{
	TypedStr="";
    if( GetStateName() == 'ConsoleVisible' )
	{
        GotoState( '' );
	}
}

exec function ConsoleToggle()
{
    if( GetStateName() == 'ConsoleVisible' )
        ConsoleClose();
    else
        ConsoleOpen();
}

state ConsoleVisible
{
	function bool KeyType( EInputKey Key, optional string Unicode )
	{
		local PlayerController PC;

		if (bIgnoreKeys || bConsoleHotKey)
			return true;

		if (ViewportOwner != none)
			PC = ViewportOwner.Actor;

		if (bCtrl && PC != none)
		{
			if (Key == 3) //copy
			{
				PC.CopyToClipboard(TypedStr);
				return true;
			}
			else if (Key == 22) //paste
			{
				TypedStr = TypedStr$PC.PasteFromClipboard();
				return true;
			}
			else if (Key == 24) // cut
			{
				PC.CopyToClipboard(TypedStr);
				TypedStr="";
				return true;
			}
		}

		if( Key>=0x20 )
		{
			if( Unicode != "" )
				TypedStr = TypedStr $ Unicode;
			else
				TypedStr = TypedStr $ Chr(Key);
            return( true );
		}

		return( true );
	}

	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string Temp;

		if( Key==IK_Ctrl )
		{
			if (Action == IST_Press)
				bCtrl = true;
			else if (Action == IST_Release)
				bCtrl = false;
		}

		if (Action== IST_PRess)
		{
			bIgnoreKeys = false;
		}

		if(Key == ConsoleKey)
		{
			if(Action == IST_Press)
				bConsoleHotKey = true;
			else if(Action == IST_Release && bConsoleHotKey)
				ConsoleClose();
			return true;
		}
		else if (Key==IK_Escape)
		{
			if (Action==IST_Release)
			{
				if (TypedStr!="")
				{
					TypedStr="";
					HistoryCur = HistoryTop;
				}
				else
				{
	                ConsoleClose();
					return true;
				}
			}
			return true;
		}
		else if( Action != IST_Press )
            return( true );

		else if( Key==IK_Enter )
		{
			if( TypedStr!="" )
			{
				// Print to console.

				History[HistoryTop] = TypedStr;
                HistoryTop = (HistoryTop+1) % ArrayCount(History);

				if ( ( HistoryBot == -1) || ( HistoryBot == HistoryTop ) )
                    HistoryBot = (HistoryBot+1) % ArrayCount(History);

				HistoryCur = HistoryTop;

				// Make a local copy of the string.
				Temp=TypedStr;
				TypedStr="";

				if( !ConsoleCommand( Temp ) )
					Message( Localize("Errors","Exec","Core"), 6.0 );

				Message( "", 6.0 );
			}

            return( true );
		}
		else if( Key==IK_Up )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryBot)
					HistoryCur = HistoryTop;
				else
				{
					HistoryCur--;
					if (HistoryCur<0)
                        HistoryCur = ArrayCount(History)-1;
				}

				TypedStr = History[HistoryCur];
			}
            return( true );
		}
		else if( Key==IK_Down )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryTop)
					HistoryCur = HistoryBot;
				else
                    HistoryCur = (HistoryCur+1) % ArrayCount(History);

				TypedStr = History[HistoryCur];
			}

		}
		else if( Key==IK_Backspace || Key==IK_Left )
		{
			if( Len(TypedStr)>0 )
				TypedStr = Left(TypedStr,Len(TypedStr)-1);
            return( true );
		}

		else if ( Key==IK_PageUp || key==IK_MouseWheelUp )
		{
			if (SBPos<ScrollBack.Length-1)
			{
				if (bCtrl)
					SBPos+=5;
				else
					SBPos++;

				if (SBPos>=ScrollBack.Length)
				  SBPos = ScrollBack.Length-1;
			}

			return true;
		}
		else if ( Key==IK_PageDown || key==IK_MouseWheelDown)
		{
			if (SBPos>0)
			{
				if (bCtrl)
					SBPos-=5;
				else
					SBPos--;

				if (SBPos<0)
					SBPos = 0;
			}
		}

        return( true );
	}

    function BeginState()
	{
		SBPos = 0;
        bVisible= true;
		bIgnoreKeys = true;
		bConsoleHotKey = false;
        HistoryCur = HistoryTop;
		bCtrl = false;
    }
    function EndState()
    {
        bVisible = false;
		bCtrl = false;
		bConsoleHotKey = false;
    }

	function PostRender( canvas Canvas )
	{

		local float fw,fh;
		local float yclip,y;
		local int idx;

//		Canvas.Font = class'HudBase'.static.GetConsoleFont(Canvas);
		yclip = canvas.ClipY*0.5;
		Canvas.StrLen("X",fw,fh);

		Canvas.SetPos(0,0);
		Canvas.SetDrawColor(255,255,255,200);
		Canvas.Style=4;
		Canvas.DrawTileStretched(material'ConsoleBack',Canvas.ClipX,yClip);
		Canvas.Style=1;

		Canvas.SetPos(0,yclip-1);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.DrawTile(texture 'GUIContent.Menu.BorderBoxA',Canvas.ClipX,2,0,0,64,2);

		Canvas.SetDrawColor(255,255,255,255);

		Canvas.SetPos(0,yclip-5-fh);
		Canvas.DrawText("(>"@TypedStr$"_");

		idx = SBHead - SBPos;
		y = yClip-y-5-(fh*2);

		if (ScrollBack.Length==0)
			return;

		Canvas.SetDrawColor(255,255,255,255);
		while (y>fh && idx>=0)
		{
			Canvas.SetPos(0,y);
			Canvas.DrawText(Scrollback[idx],false);
			idx--;
			y-=fh;
		}
	}
}

defaultproperties
{
     MaxScrollbackSize=128
     ConsoleSoundVol=0.300000
     AddedCurrentHead="Added Server:"
     AddedCurrentTail="To Favorites!"
     LetterKeys(0)=IK_Q
     LetterKeys(1)=IK_W
     LetterKeys(2)=IK_E
     LetterKeys(3)=IK_R
     LetterKeys(4)=IK_A
     LetterKeys(5)=IK_S
     LetterKeys(6)=IK_D
     LetterKeys(7)=IK_F
     LetterKeys(8)=IK_Z
     LetterKeys(9)=IK_X
     NumberKeys(0)=IK_0
     NumberKeys(1)=IK_1
     NumberKeys(2)=IK_2
     NumberKeys(3)=IK_3
     NumberKeys(4)=IK_4
     NumberKeys(5)=IK_5
     NumberKeys(6)=IK_6
     NumberKeys(7)=IK_7
     NumberKeys(8)=IK_8
     NumberKeys(9)=IK_9
     bSpeechMenuUseMouseWheel=True
}
