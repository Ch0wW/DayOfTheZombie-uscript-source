// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZPageBase extends GUIPage;

var bool accept_input;
var float period;

var localized string quicksave;
var localized string autosave;
var localized string newgame;

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    accept_input = false;
    Log("Not Accepting input...");
    SetTimer(0.1,false);
}

/*****************************************************************
 * Introduces a short pause before accepting keystrokes
 *****************************************************************
 */

function Timer ()
{
    if (accept_input == false ) {
        accept_input = true;
        SetTimer(period,true);
        Log("Accepting input...");
    } else {
        Periodic();
    }
}

function Periodic()
{

}

/*****************************************************************
 * Encodes a string so it it safe to pass on the URL
 *****************************************************************
 */

function string EncodeStringURL(string s) {
    local string r;
    local string c;
    local int i;

    for (i = 0; i < Len(s); ++i) {
        c = Mid(s,i,1);

        if (c == " ") {
            r = r $ "_";
        } else {
            r = r $ c;
        }
    }

    return r;
}

/*****************************************************************
 * Decode a string from the command line
 *****************************************************************
 */

function string DecodeStringURL(string s) {
    local string r;
    local string c;
    local int i;

    for (i = 0; i < Len(s); ++i) {
        c = Mid(s,i,1);

        if (c == "_") {
            r = r $ " ";
        } else {
            r = r $ c;
        }
    }

    return r;
}

/*****************************************************************
 * Sorts a list of save games
 *****************************************************************
 */

function bool SaveGameName_IsGreater(string a, string b)
{
    local string a_comp;
    local string b_comp;
    local int i;

    local int chapterA, chapterB;

    if (InStr(a, newgame) != -1)        return true;
    else if (InStr(b, newgame) != -1)   return false;

    if (InStr(a, quicksave) != -1)        return true;
    else if (InStr(b, quicksave) != -1)   return false;

    if (InStr(a, autosave) != -1)        return true;
    else if (InStr(b, autosave) != -1)   return false;

    ChapterA = InStr(a, "Chapter");
    a_comp = Mid(a,ChapterA + 7, ChapterA + 8);

    ChapterB = InStr(b,"Chapter");
    b_comp = Mid(b,ChapterB + 7, ChapterB + 8);

    if (float(b_comp) == float(a_comp)){

        // Extract numeric part of a
        for (i = 0; i < Len(a); ++i)
            if (InStr("0123456789",Mid(a,i,1)) != -1)
                a_comp = a_comp $ Mid(a,i,1);

        // Extract numeric part of b
        for (i = 0; i < Len(b); ++i)
            if (InStr("0123456789",Mid(b,i,1)) != -1)
                b_comp = b_comp $ Mid(b,i,1);
    }

    return float(a_comp) > float(b_comp);

}

function Sort_Games(BBListBox games)
{
    local int i,j;

    Log("Sorting games");

    for (j = 0; j < games.List.ItemCount; ++j) {
        for (i = 0; i < games.List.ItemCount-1; ++i) {
            if ( !SaveGameName_IsGreater(games.List.GetItemAtIndex(i), games.List.GetItemAtIndex(i+1)) ) {
                games.List.Swap(i,i+1);
            }
        }
    }

}

defaultproperties
{
     period=0.500000
     QuickSave="Quicksave"
     AutoSave="Autosave"
     NewGame="<New Save Game>"
}
