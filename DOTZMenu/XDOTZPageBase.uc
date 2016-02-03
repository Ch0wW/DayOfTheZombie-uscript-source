// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZPageBase extends GUIPage;

var bool bSignInPump;

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    // Pumping auto sign in
    if (!class'UtilsXbox'.static.Is_Signed_In () &&
        !class'UtilsXbox'.static.Is_Auto_Need_Password() &&
        !class'UtilsXbox'.static.Is_Auto_Failed () &&
        bSignInPump) {

        // Pump sign in
        class'UtilsXbox'.static.Sign_In_Pump();

        // Clear any errors
        class'UtilsXbox'.static.Set_Last_Error(0);
    }
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
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     bSignInPump=True
}
