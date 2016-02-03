// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveErrorCross extends XDOTZLiveError;


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
        case 10:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignInCross');
                    break;
        // LIVE_ERROR_LOGON_UPDATE_REQUIRED
        case 11:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignInCross');
                    break;
        // LIVE_ERROR_LOGON_SERVERS_TOO_BUSY
        case 12:    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
                    break;
        // LIVE_ERROR_LOGON_USER_ACCOUNT_REQUIRES_MANAGEMENT
        case 14:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignInCross');
                    break;
        // LIVE_ERROR_MATCH_INVALID_SESSION_ID
        case 15:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignInCross');
                    break;
        // LIVE_ERROR_LOGON_INVALID_USER
        case 16:    BBGuiController(Controller).CloseTo ('XDOTZLiveSignInCross');
                    break;

        // LIVE_MATCHMAKING_SERVER_ERROR
        case 20:    BBGuiController(Controller).CloseTo ('XDOTZMainMenu');
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

defaultproperties
{
     __OnKeyEvent__Delegate=XDOTZLiveErrorCross.HandleKeyEvent
}
