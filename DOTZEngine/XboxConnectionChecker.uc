// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XboxConnectionChecker extends Actor;

const CHECK_CONTROLLER_AND_SYSLINK    = 6969;

function PostNetBeginPlay() {
    DynamicLoadObject("DOTZMenu.XDOTZNoController",class'class');
    DynamicLoadObject("DOTZMenu.XDOTZSLNoNetworkCable",class'class');

    SetMultiTimer( CHECK_CONTROLLER_AND_SYSLINK, 0.1, true);
}


/****************************************************************
 * MultiTimer
 *
 ****************************************************************
 */

simulated function MultiTimer(int TimerID){

   switch(TimerID){

   case CHECK_CONTROLLER_AND_SYSLINK:

   //LOTD2 IS PC ONLY
                     /*
        if (class'UtilsXbox'.static.Is_Kicked()) {
            if (!BBGUIController(Level.GetLocalPlayerController().Player.GUIController).CheckTop ('XDOTZKicked')) {
                //Level.GetLocalPlayerController().Player.GUIController.CloseAll(true);
                Level.GetLocalPlayerController().Player.GUIController.OpenMenu("DOTZMenu.XDOTZKicked");
            }
        }

        if (class'UtilsXbox'.static.Get_Captured_Controller() >= 0
            && !class'UtilsXbox'.static.Check_Captured_Controller() ) {

            if (!BBGUIController(Level.GetLocalPlayerController().Player.GUIController).CheckExists ('XDOTZNoController') &&
                !BBGUIController(Level.GetLocalPlayerController().Player.GUIController).CheckExists ('XDOTZLoadingMenu')) {

                // Open unplugged controller menu
                if (Level.Netmode==NM_Standalone){
                  AdvancedGameInfo(Level.Game).NoMenuPause(true, Level.GetLocalPlayerController());
                }
                //Level.GetLocalPlayerController().Player.GUIController.CloseAll(true);
                Level.GetLocalPlayerController().Player.GUIController.OpenMenu("DOTZMenu.XDOTZNoController");
            }
        }

        if (class'UtilsXbox'.static.Network_Is_Unplugged()
            && ((class'UtilsXbox'.static.Get_Reboot_Type() >= 1 && class'UtilsXbox'.static.Get_Reboot_Type() <= 4)
            || class'UtilsXbox'.static.Is_Signed_In())) {

            if (!BBGUIController(Level.GetLocalPlayerController().Player.GUIController).CheckExists ('XDOTZSLNoNetworkCable') &&
                !BBGUIController(Level.GetLocalPlayerController().Player.GUIController).CheckExists ('XDOTZLoadingMenu')) {
                // Open unplugged controller menu
                //Level.GetLocalPlayerController().Player.GUIController.CloseAll(true);
                Level.GetLocalPlayerController().Player.GUIController.OpenMenu("DOTZMenu.XDOTZSLNoNetworkCable");
            }
        }

       break;
                       */
   default:
       super.MultiTimer( timerID );
   }
}

defaultproperties
{
     bHidden=True
     bAlwaysTick=True
}
