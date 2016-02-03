// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * MeleeWeapon
 *
 * Short ranged weapons, that don't have a reticle, and have two
 * modes of swinging.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 *****************************************************************
 */
class MeleeWeapon extends AdvancedWeapon;



//name of the alt fire animation
var name AltFireAnim;
var int StdTraceDist;
var int AltTraceDist;

var name AltFireAnimName;

//interal
var bool bDoAltFire;

/*****************************************************************
 * Notify_MeleeDamage
 *****************************************************************
 */
function Notify_MeleeDamage(){
               // Log( self @ "MeleeDamage" )    ;
   TraceFire(0,0,0); //note the zero inaccuracy value
}


simulated function ToggleAimedMode() {
 //   ForceReload();
}

/*****************************************************************
 * PlayFiring
 * Normal fire has occured by this point, we just need to make it look
 * like it has now, so play an animation.
 *****************************************************************
 */
simulated function PlayFiring(){

   // Log (self $ " Melee PlayFiring: ");

   if (bDoAltFire == true){
      PlayAnim(AltFireAnim, SingleFireRate);
   } else {
      PlayAnim(FireAnim, SingleFireRate);
   }
   IncrementFlashCount();
}


/*****************************************************************
 * ServerAltFire
 * Called when the player presses the alt key, follows the same path
 * as normal fire.
 *****************************************************************
 */
function ServerAltFire(){
   // Log("ServeraltFire");
    TraceDist = StdTraceDist;
    default.TraceDist = StdTraceDist;
    bDoAltFire = true;
    GotoState('NormalFire');
    LocalFire();
}

/*****************************************************************
 * ServerFire
 *
 *****************************************************************
 */
function ServerFire(){
   // Log("Server Fire");
    TraceDist = AltTraceDist;
    default.TraceDist = AltTraceDist;
    bDoAltFire = false;
    GotoState('NormalFire');
    LocalFire();
}

/*****************************************************************
 * AltFire
 * Player has pressed alt fire, notify the server, play anim
 *****************************************************************
 */
simulated function AltFire( float Value )
{
    bDoAltFire = true;
   // Log("AltFire");
    ServerAltFire();
    GotoState('ClientFiring');
    LocalFire();
}

/*****************************************************************
 * Fire
 * Player has pressed fire, notify the server, play anim
 *****************************************************************
 */

simulated function Fire( float Value )
{
    bDoAltFire = false;
  //  Log("Fire");
    ServerFire();
    GotoState('ClientFiring');
    LocalFire();
}


/*****************************************************************
 *
 *****************************************************************
*/
function name GetFireAnim(){
   if (bDoAltFire == true){
      return AltFireAnimName;
   } else {
      return FireAnimName;
   }

}

defaultproperties
{
     AltFireAnim="AltFire"
     StdTraceDist=100
     AltTraceDist=100
     bInfiniteAmmo=True
     HitSpread=0.000000
     DebugFlags=0
}
