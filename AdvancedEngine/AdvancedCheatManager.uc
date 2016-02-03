// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AdvancedCheatManager extends Object within AdvancedPlayerController;

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

struct CheatSeq{
   var Array<int> cmd;
   var int pos;
};

var Array<CheatSeq> Cheats;

/*****************************************************************
 * You can look at the actual keys that were pressed if you co-ordinate
 * with your controller class and call the function right. Rereading this
 * comment, I have written something pretty useless. Great!
 *****************************************************************
 */
function ProcessInput(int Key){

   local int i;
   local int SearchKey;

   for (i=0;i<Cheats.length;++i){
      SearchKey = Cheats[i].cmd[Cheats[i].pos];
      if ( SearchKey == Key){
         Cheats[i].pos++;
         if (Cheats[i].pos == Cheats[i].cmd.length){
            DoCheat(i);
            Cheats[i].pos = 0;
         }
      } else {
        Cheats[i].pos = 0;
      }
   }

}

/*****************************************************************
 * DoCheat
 *****************************************************************
 */
function DoCheat(int CheatNumber){

}

defaultproperties
{
}
