// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * MasterMountPoint -
 *
 * A MasterMountPoint is a mount point that controls kill timers and
 * all the stuff that goes along with that, audio cues, the HUD... It
 * also manages slave mount points that have the same MountGroup
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class MasterMountPoint extends MountPoint
   implements(HudDrawable)
   hidedropdown;



//should you start the timer when you enable
var() bool EnableStartsTimer;
var() bool ControlsSlaveStates;

struct WarningInfo {
   var() sound WarningSound;
   var() int WarningTime;
};

var() const Material MountPointIcon;
var() const int IconSize;
var() const int IconPosX;
var() const int IconPosY;

var bool bIsHUDRegistered;
const HUD_TIMER_HACK = 11717;

//===========================================================================
// Editable properties
//===========================================================================

//This is the amount of time that you have to get to the mountpoint
//before the TimerExpired Event is created.
var() int iKillTimer;
//This is the array of stuff to play for the player to let them know
//that the time is running out. (ie. The sound of a seargent yelling
//at the player)
var() array<WarningInfo> TheWarningInfo;

//===========================================================================
// Event data
//===========================================================================

//goes when the kill timer is done, doesn't actually kill the player
var(Events) Name TimerExpiredEvent;

//turns the kill timer on
var(Events) editconst const Name hEnableTimer;
//turns the kill timer off
var(Events) editconst const Name hDisableTimer;


//===========================================================================
// Internal data
//===========================================================================

var int iTimeRemaining;
var bool bSlaveContainsPawn;
var array<SlaveMountPoint> TheSlaves;
var AdvancedHud theHUD;
var HQuantityBar TimerBar;


/****************************************************************
 * PostBeginPlay
 ****************************************************************
 */
function PostBeginPlay()
{
   //   iTimeRemaining = iKillTimer;
   Super.PostBeginPlay();
}


function int ActionPriority(){
   return 1;
}

function Action(){
}

/****************************************************************
 * ChangeSlaveState
 * Any slaves that have registered with this master have their state
 * changed to match the newstate.
 ****************************************************************
 */
function ChangeSlaveState(name NewState){
   local int i;

   if (!ControlsSlaveStates){
      return;
   }

   for ( i = 0; i < TheSlaves.Length ; i++){
      TheSlaves[i].GotoState(NewState);
      Log("Changing state for " $ TheSlaves[i] );
   }
}


/****************************************************************
 * ActivateTimer
 * Starts the timer, sets itself up to start drawing information to
 * the HUD.
 ****************************************************************
 */
function ActivateTimer(){


   //reset the real timer
   iTimeRemaining = iKillTimer;

   if (iKillTimer > 0){

      EnsureHUDRegistration();
      SetTimer(1,true);
      // set up the bar on the hud...
      if ( TimerBar != None && theHUD != None ) {
          if ( iKillTimer > TimerBar.MaxQuantity ) {
              Warn( "Mount-time limit of" @ iKillTimer
                    @ "s on" @ self @ "exceeds defined limit of"
                    @ TimerBar.MaxQuantity );
                          if ( !(iKillTimer <= TimerBar.MaxQuantity ) ) {            Log( "(" $ self $ ") assertion violated: (iKillTimer <= TimerBar.MaxQuantity )", 'DEBUG' );           assert( iKillTimer <= TimerBar.MaxQuantity  );        }//    ;
          }
          TimerBar.TimerMax = iKillTimer;
      }
   }
}


/****************************************************************
 * EnsureHUDRegistration
 ****************************************************************
 */
function EnsureHUDRegistration(){

   local PlayerController pc;

   //Get the hud for drawing the timer
   pc = Level.GetLocalPlayerController();
   theHUD = AdvancedHud(pc.MyHUD);

   //basically if there is no hud to register, then try again in a
   //little bit
   if (theHUD == None){
      SetMultiTimer(HUD_TIMER_HACK, 1, false);
      return;
   } else {
      theHUD.register( self );
      bIsHUDRegistered = true;
   }
}


/****************************************************************
 * PostLoad
 ****************************************************************
 */
function PostLoad()
{
   if (bIsHUDRegistered){
      TimerBar.TimerMax = iKillTimer;
      EnsureHUDRegistration();

   }
   Super.PostLoad();
}

/****************************************************************
 * MultiTimer
 ****************************************************************
 */
function MultiTimer(int ID){
   if (ID == HUD_TIMER_HACK){
      EnsureHUDRegistration();
   }
   Super.MultiTimer(ID);
}

/****************************************************************
 * DeactivateTimer
 * Stops the timer, stops writing HUD stuff
 ****************************************************************
 */
function DeactivateTimer(){
    SetTimer(0, false);
    if (theHUD != None){
        theHUD.unregister( self );
        bIsHUDRegistered = false;
    }
}

/**
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {
   local AdvancedPlayerController apc;

   apc = AdvancedPlayerController(Level.GetLocalPlayerController());

   //only draw if you are not in a mount (mount=none)
   if (apc!=None && AdvancedPawn(apc.Pawn) !=None &&
       AdvancedPawn(apc.Pawn).objMount ==None){

      // for the sake of quickness, we'll assume the timer bar is not None
      TimerBar.drawQuantity( iTimeRemaining, c, scaleX, scaleY );
      c.setPos( iconPosX * scaleX, iconPosY * scaleY );
      c.DrawTile( MountPointIcon, iconSize * scaleX, iconSize * scaleY,
                  0, 0, iconSize, iconSize );
   }
}

/**
 * Analogous to drawHUD, but used for debugging info (e.g. for LDs)
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY ) {
      C.SetPos( 640 * scaleX , 870 * scaleY );
      //C.Font = C.MedFont;
      C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetStandardFontRef();
      C.DrawText( iTimeRemaining );
}


//===========================================================================
// Events
//===========================================================================

/****************************************************************
 * NotifyExistance
 * The slaves can tell the master that they want to be in the same
 * state as the master.
 ****************************************************************
 */
function NotifyExistance( MountPoint mp){

   local int index;
   index = TheSlaves.Length;
   //increase the length
   TheSlaves.Length = TheSlaves.Length +1;
   //Add this mp to the dynamic array
   TheSlaves[index] = SlaveMountPoint(mp);
   Log (name $ " added " $ mp $ " at " $  index);
}

/****************************************************************
 * NotifyMounted
 * The slave tells the master that somebody is in the mount point
 ****************************************************************
 */
function NotifyMounted( MountPoint mp){
   iTimeRemaining = iKillTimer;
   bSlaveContainsPawn = true;
}


/****************************************************************
 * NotifyUnMounted
 * The slave tells the master that somebody has left the mount point
 ****************************************************************
 */
function NotifyUnMounted (MountPoint mp) {
   bSlaveContainsPawn = false;
}


/****************************************************************
 * Trigger
 * An event has happened
 ****************************************************************
 */
event TriggerEx( Actor Other, Pawn EventInstigator , Name Handler) {

   if (Handler == hDisableTimer) {
      DeactivateTimer();
      //iTimeRemaining = iKillTimer;
      //iKillTimer = -1;
   }
   else if (Handler == hEnableTimer){
      ActivateTimer();
   }
   Super.TriggerEx( Other, EventInstigator, Handler);
}



//===========================================================================
// States
//===========================================================================



/****************************************************************
 * Enabled
 * This state means that we are 'active' in the sense that the player
 * can jump inside, and we start counting down the kill timer (if
 * there is one greater than zero)
 ****************************************************************
 */
State Enabled{


   /*************************************************************
    * DoUnMount
    *************************************************************
    */
   function bool DoUnMount(){
      //ActivateTimer();
      return Super.DoUnMount();
   }

   /*************************************************************
    * DoUnMount
    *************************************************************
    */
   function bool DoMount(Pawn PawnToMount){
      //DeactivateTimer();
      if (Super.DoMount(PawnToMount)){
         iTimeRemaining = iKillTimer;
         return true;
      }
      return false;
 }

   /*************************************************************
    * BeginState
    * If we are enabled we need to figure out what the HUD is and
    * start the timer stuff
    *************************************************************
    */
   function BeginState(){

      local PlayerController pc;
      Super.BeginState();

      //Get the hud for drawing the timer
      pc = Level.GetLocalPlayerController();
      theHUD = AdvancedHud(pc.MyHUD);

      if (EnableStartsTimer) {
         ActivateTimer();
      }
      ChangeSlaveState('Enabled');
   }

   /*************************************************************
    * Timer
    * Another second has passed, you need to see if there are any
    * audio cues to play, and see if the player needs to be killed.
    *************************************************************
    */
   function Timer(){
      local int i;
      local PlayerController pc;

      //count down if there is nobody in your mountpoints
       if (MountedPawn == None && bSlaveContainsPawn == false && iKillTimer > 0){
            iTimeRemaining = iTimeRemaining - 1;

            //if the warning time is now
            for (i=0; i < TheWarningInfo.Length; i++){
               if (TheWarningInfo[i].WarningTime == iTimeRemaining){
                  pc = Level.GetLocalPlayerController();
                  if (pc.Pawn == None){
                     pc.PlaySound(TheWarningInfo[i].WarningSound ,SLOT_TALK,1.0,true,10000,,false);
                     pc.PlaySound(TheWarningInfo[i].WarningSound ,SLOT_TALK,1.0,true,10000,,false);
                  } else {
                     pc.Pawn.PlaySound(TheWarningInfo[i].WarningSound ,SLOT_TALK,1.0,true,10000,,false);
                     pc.Pawn.PlaySound(TheWarningInfo[i].WarningSound ,SLOT_TALK,1.0,true,10000,,false);
                  }
               }
            }


            //out of time!
            if (iTimeRemaining <= 0){
               Log (name $ " Player has just been killed !!!!!!!!!!!!");
               TriggerEvent( TimerExpiredEvent, self, None );
               GotoState('Disabled');
            }
      }
   }

}



/****************************************************************
 * Disabled
 * This state means no one gets into the mount point, and the timer is
 * not active.
 ****************************************************************
 */
State Disabled{

   /*************************************************************
    * DoUnMount
    *************************************************************
    */
   function bool DoUnMount(){
      return Super.DoUnMount();
   }

   /*************************************************************
    * DoUnMount
    *************************************************************
    */
   function bool DoMount(Pawn PawnToMount){
      return Super.DoMount(PawnToMount);
   }

   /*************************************************************
    * BeginState
    *************************************************************
    */
   function BeginState(){
      DeactivateTimer();
      ChangeSlaveState('Disabled');
      iTimeRemaining = iKillTimer;
      Super.BeginState();
   }

}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     EnableStartsTimer=True
     IconSize=128
     hEnableTimer="ENABLE_TIMER"
     hDisableTimer="DISABLE_TIMER"
}
