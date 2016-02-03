// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class xBoxCheatManager extends AdvancedCheatManager;

//const A = 1;  //jump
//const B = 2;  //altfire
//const X = 3;  //action
//const Y = 4;  //force reload

//...
//const RightTigger = 8;   //fire
//const DpadUp      = 9;   //next melee
//const DpadDown    = 10;  //next grenade
//const DpadLeft    = 11;  //next gun
//const DpadRight   = 12;  //pre gun

function DoCheat(int CheatNumber){
   switch CheatNumber {
   case 0:
      AdvancedPlayerController(Level.GetLocalPlayerController()).Weapons();
      Log("I am doing cheat 0");
      break;
   case 1:
      DOTZPlayerControllerBase(Level.GetLocalPlayerController()).KungFu();
      Log("I am doing cheat 1");
      break;
   case 2:
      DOTZPlayerControllerBase(Level.GetLocalPlayerController()).MiniGun();
      Log("I am doing cheat 2");
      break;
   case 3:
      DOTZGameInfoBase(Level.Game).bNameCheat = !DOTZGameInfoBase(Level.Game).bNameCheat;
      Log("I am doing cheat 3");
      break;
   case 4:
      DOTZPlayerControllerBase(Level.GetLocalPlayerController()).Nuke();
      Log("I am doing cheat 4");
      break;
   case 5:
      DOTZPlayerControllerBase(Level.GetLocalPlayerController()).NoFall();
      Log("I am doing cheat 5");
      break;
    case 6:
      DOTZPlayerControllerBase(Level.GetLocalPlayerController()).ConsoleCommand( "AllAmmo" );
      Log("I am doing cheat 6");
    case 7:
      DOTZPlayerControllerBase(Level.GetLocalPlayerController()).bGodMode = true;
      Log("I am doing cheat 7");


   default:

   }
}

defaultproperties
{
     Cheats(0)=(Cmd=(9,10,11,12,1,2))
     Cheats(1)=(Cmd=(12,10,11,1))
     Cheats(2)=(Cmd=(9,9,10,10,1,2,1,2))
     Cheats(3)=(Cmd=(9,9,10,10,11,11,12,12,3))
     Cheats(4)=(Cmd=(1,2,4,3,1,2,4,3))
     Cheats(5)=(Cmd=(9,1,9,2,9,4,9,3))
     Cheats(6)=(Cmd=(1,1,1,9,12,9,12))
     Cheats(7)=(Cmd=(9,10,11,12,9,10,11,12))
}
