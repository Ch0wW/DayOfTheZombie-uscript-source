// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveError extends XDOTZErrorPage;

var sound ClickSound;

// Error code
var int error_code;

// Error strings
var localized string error_0_msg;
var localized string error_3_msg;
var localized string error_4_msg;

var localized string error_10_msg;
var localized string error_11_msg;
var localized string error_12_msg;
var localized string error_14_msg;
var localized string error_15_msg;
var localized string error_16_msg;

var localized string error_20_msg;

var localized string error_32_msg;
var localized string error_33_msg;

var localized string error_40_msg;
var localized string error_41_msg;

var localized string error_60_msg;

/*****************************************************************
 * What happens if the select button is pressed
 *****************************************************************
 */

function DoButtonA() {

    switch (error_code) {
        case 0:     BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;

        // LIVE_NO_ACCOUNTS
        case 3:     //class'UtilsXbox'.static.Do_Create_Account();
                    Controller.OpenMenu("DOTZMenu.XDOTZLiveErrorConfirmCreate");
                    break;

        // NO_SYSLINK_CABLE
        case 4:     //class'UtilsXbox'.static.Do_Troubleshooter();
                    Controller.OpenMenu("DOTZMenu.XDOTZLiveErrorConfirmTroubleshooter");
                    break;

        // LIVE_ERROR_CANNOT_ACCESS_SERVICE
        case 10:    //class'UtilsXbox'.static.Do_Troubleshooter();
                    Controller.OpenMenu("DOTZMenu.XDOTZLiveErrorConfirmTroubleshooter");
                    break;
        // LIVE_ERROR_LOGON_UPDATE_REQUIRED
        case 11:    //class'UtilsXbox'.static.Do_Auto_Update();
                    Controller.OpenMenu("DOTZMenu.XDOTZLiveErrorConfirmUpdate");
                    break;

        // LIVE_ERROR_LOGON_SERVERS_TOO_BUSY
        case 12:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
                    break;
         // LIVE_ERROR_LOGON_USER_ACCOUNT_REQUIRES_MANAGEMENT
        case 14:    //class'UtilsXbox'.static.Do_Management();
                    Controller.OpenMenu("DOTZMenu.XDOTZLiveErrorConfirmManagement");
                    break;
        // LIVE_ERROR_MATCH_INVALID_SESSION_ID
        case 15:    BBGuiController(Controller).CloseTo ('XDOTZLiveMultiplayer');
                    break;
        // LIVE_ERROR_LOGON_INVALID_USER
        case 16:    //class'UtilsXbox'.static.Do_Management();
                    Controller.OpenMenu("DOTZMenu.XDOTZLiveErrorConfirmManagement");
                    break;

        // LIVE_MATCHMAKING_SERVER_ERROR
        case 20:    BBGuiController(Controller).CloseTo ('XDOTZLiveMultiplayer');
                    break;

        // LIVE_CANNOT_JOIN
        case 32:    Controller.CloseMenu(true);
                    break;

        // LIVE_CANNOT_JOIN_BECAUSE_FULL
        case 33:    Controller.CloseMenu(true);
                    break;

        // SYSLINK_UNABLE_TO_HOST
        case 40:    BBGuiController(Controller).CloseTo ('XDOTZSLMainMenu');
                    break;

        // SYSLINK_UNABLE_TO_GET_HOSTS
        case 41:    BBGuiController(Controller).CloseTo ('XDOTZSLMainMenu');
                    break;

        // DAMAGED_DISK_ERROR
        case 60:    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;
    };
}

/*****************************************************************
 *  What happens if the back button is pressed
 *****************************************************************
 */

function DoButtonB() {

    switch (error_code) {

        // LIVE_NO_ACCOUNTS
        case 3:     BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;

        // NO_SYSLINK_CABLE
        case 4:     BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;

        // LIVE_ERROR_CANNOT_ACCESS_SERVICE
        case 10:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
                    break;
        // LIVE_ERROR_LOGON_UPDATE_REQUIRED
        case 11:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
                    break;
        // LIVE_ERROR_LOGON_SERVERS_TOO_BUSY
        case 12:    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;
        // LIVE_ERROR_LOGON_USER_ACCOUNT_REQUIRES_MANAGEMENT
        case 14:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
                    break;
        // LIVE_ERROR_MATCH_INVALID_SESSION_ID
        case 15:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
                    break;
        // LIVE_ERROR_LOGON_INVALID_USER
        case 16:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
                    break;

        // LIVE_MATCHMAKING_SERVER_ERROR
        case 20:    BBGuiController(Controller).CloseTo ('XDOTZLiveMultiplayer');
                    break;

        // LIVE_CANNOT_JOIN
        case 32:    Controller.CloseMenu(true);
                    break;

        // LIVE_CANNOT_JOIN_BECAUSE_FULL
        case 33:    Controller.CloseMenu(true);
                    break;

        // SYSLINK_UNABLE_TO_HOST
        case 40:    BBGuiController(Controller).CloseTo ('XDOTZSLMainMenu');
                    break;

        // SYSLINK_UNABLE_TO_GET_HOSTS
        case 41:    BBGuiController(Controller).CloseTo ('XDOTZSLMainMenu');
                    break;

        // DAMAGED_DISK_ERROR
        case 60:    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;

        default:    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;
    };
}

/*****************************************************************
 *****************************************************************
 */

function Periodic()
{
    local int temp;

    switch (error_code) {
        // LIVE_NO_ACCOUNTS
        case 3:     class'UtilsXbox'.static.Refresh_Accounts ();
                    temp = class'UtilsXbox'.static.Get_Num_Accounts ();

                    if (temp > 0)
                        Controller.CloseMenu(true);
                    break;

    };

}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    local string error_string;

    super.Opened(Sender);

    // Remember the live error code
    error_code = class'UtilsXbox'.static.Get_Last_Error();

    Log ("Responding to error code " $ error_code);

    // Reset the Live error code
    class'UtilsXbox'.static.Set_Last_Error(0);

    switch (error_code) {

        // LIVE_NO_ACCOUNTS
        case 3:     error_string = error_3_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(new_account_string);
                    break;

        // NO_SYSLINK_CABLE
        case 4:     error_string = error_4_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(troubleshooter_string);
                    class'UtilsXbox'.static.Sign_Out();
                    break;

        // LIVE_ERROR_CANNOT_ACCESS_SERVICE
        case 10:    error_string = error_10_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(troubleshooter_string);
                    break;
        // LIVE_ERROR_LOGON_UPDATE_REQUIRED
        case 11:    error_string = error_11_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(update_string);
                    break;
        // LIVE_ERROR_LOGON_SERVERS_TOO_BUSY
        case 12:    error_string = error_12_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(try_again_string);
                    break;
        // LIVE_ERROR_LOGON_USER_ACCOUNT_REQUIRES_MANAGEMENT
        case 14:    error_string = error_14_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(read_now_string);
                    break;
        // LIVE_ERROR_MATCH_INVALID_SESSION_ID
        case 15:    error_string = error_15_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(continue_string);
                    break;
        // LIVE_ERROR_LOGON_INVALID_USER
        case 16:    error_string = error_16_msg;
                    AddBackButton(cancel_string);
                    AddSelectButton(recovery_string);
                    break;

        // LIVE_MATCHMAKING_SERVER_ERROR
        case 20:    error_string = error_20_msg;
                    AddSelectButton(continue_string);
                    break;

        // LIVE_CANNOT_JOIN
        case 32:    error_string = error_32_msg;
                    AddSelectButton(continue_string);
                    break;

        // LIVE_CANNOT_JOIN_BECAUSE_FULL
        case 33:    error_string = error_33_msg;
                    AddSelectButton(continue_string);
                    break;

        // SYSLINK_UNABLE_TO_HOST
        case 40:    error_string = error_40_msg;
                    AddSelectButton(continue_string);
                    break;

        // SYSLINK_UNABLE_TO_GET_HOSTS
        case 41:    error_string = error_41_msg;
                    AddSelectButton(continue_string);
                    break;

        // DAMAGED_DISK_ERROR
        case 60:    error_string = error_60_msg;
                    AddSelectButton(continue_string);
                    break;

        default:    //error_string = "Error code = " $ error_code $ ". Tell Carrot Please. I mean it. Really! TELL HIM!";
                    Controller.CloseMenu(true);
                    break;
    };

    SetErrorCaption(error_string);
}

/*****************************************************************
 * Default Properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_3_msg="Your Xbox console does not have any Xbox Live accounts. Press A to sign up for Xbox Live or B to cancel."
     error_4_msg="The network cable might be disconnected. Please check the cable and try again."
     error_10_msg="Your Xbox console cannot connect to Xbox Live. Press A to start the troubleshooter or B to cancel."
     error_11_msg="A required update is available for the Xbox Live service. Press A to update or B to cancel. You cannot connect to Xbox Live until the update is installed."
     error_12_msg="The Xbox Live service is busy.  Press A to try again or B to cancel."
     error_14_msg="You have an important message from Xbox Live. Press A to read the message."
     error_15_msg="This game session is full or no longer available. Press A to continue."
     error_16_msg="This account is not current. Press A to update the account in Account Recovery or B to cancel."
     error_20_msg="This game cannot be played at this time. Press A to continue."
     error_32_msg="You cannot join this game because it is over. Press A to continue."
     error_33_msg="You cannot join this game because it is full. Press A to continue."
     error_40_msg="Your Xbox console is unable to host a system link match. Press A to continue."
     error_41_msg="Your Xbox console is unable to get a list of system link matches. Press A to continue."
     error_60_msg="There's a problem with the disc you’re using. It may be dirty or damaged."
     __OnKeyEvent__Delegate=XDOTZLiveError.HandleKeyEvent
}
