// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ActionableMover - a mover that is triggered by the use-key.
 *
 * @version $Rev: 5335 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    June 2004
 */
class ActionableMover extends Mover;



//default message to user
var() localized string OpenActionMessage;
var() localized string CloseActionMessage;
//different message while locked
var() localized string LockedActionMessage;
//different message for directional doors
var() localized string OneWayDoorMessage;

//displays a message and accepts user action input
var() bool bActionable;
//if it can be moved or not
var() bool bLocked;
var() bool bStartsClosed;

//number of seconds before we automatically close
var() int iAutoCloseTime;

//sound to play when the player tries to open a locked door
var() Sound LockedSound;
var() Array<Sound> OpeningSounds;
var() Array<Sound> ClosingSounds;
var() Name DoorOpenedEvent;
var() Name DoorClosedEvent;

var(Events) const editconst Name hLock;
var(Events) const editconst Name hUnlock;
var(Events) const editconst Name hOpen;
var(Events) const editconst Name hClose;

//internal

const ACTIONDELAYID = 14;
const CLOSEDELAY    = 15;

var bool bClosed;
var int iActionablePriority;
var Pawn Activator;
var float actiondelay;
var bool bDoingActionDelay;

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
   if (bStartsClosed == false){
      bLocked = false;
      bClosed = false;
      DoOpen();
   }
   Super.PostBeginPlay();
}


function PostNetBeginPlay(){
  if (bStartsClosed == false){
      bLocked = false;
      bClosed = false;
      DoOpen();
   }
  super.PostNetBeginPlay();
}



simulated function Timer()
{

   // Log("Location: " $ Location);
    //Log("SimOldPos: " $ SimOldPos);
    //Log("RealPostion: " $ RealPosition);
    //Log("RealRotation: " $ RealRotation);

    if ( Velocity != vect(0,0,0) )
    {
        bClientPause = false;
        return;
    }
    if ( Level.NetMode == NM_Client )
    {
        if ( ClientUpdate == 0 ) // not doing a move
        {
            if ( bClientPause )
            {
                if ( VSize(RealPosition - Location) > 3 )
                    SetLocation(RealPosition);
                else
                    RealPosition = Location;
                SetRotation(RealRotation);
                bClientPause = false;
            }
            else if ( RealPosition != Location )
                bClientPause = true;
        }
        else
            bClientPause = false;
    }
    else
    {
        RealPosition = Location;
        RealRotation = Rotation;
    }
}


/*****************************************************************
 * IsPlayerOnRightSide
 *****************************************************************
 */
function bool IsPlayerOnRightSide(){
   if (bDirectional==true){
       return IsInFront( Level.GetLocalPlayerController().Pawn );
   }
   //not directional implies all are correct
   return true;
}

/**
 * Returns true if the specified actor is located in front of this
 * mover, false if behind.
 */
function bool IsInFront( Actor a ) {
    local vector relativePosn;

    relativePosn = a.Location - Location;
                // Log( self @ "relativePosn vector:" $ relativePosn )    ;
                // Log( self @ "mover Rotation:" $ Rotation )    ;
                // Log( self @ "Dot" $ (vector(Rotation) dot relativePosn) )    ;
    return ( (vector(Rotation) dot relativePosn) > 0 );
}



/*****************************************************************
 * GetActionablePriority
 *****************************************************************
 */
function int GetActionablePriority(Controller C){
   return iActionablePriority;
}

/*****************************************************************
 * GetActionableMessage
 *****************************************************************
 */
function string GetActionableMessage(Controller C){

   if (bDoingActionDelay == true){
      return "";
   }

   if (IsPlayerOnRightSide()==false && bClosed && bHidden == false ){
      return OneWayDoorMessage;
   }

   if (bHidden == false && bActionable == true){
      if (bLocked){
         return LockedActionMessage;
      } else if (bClosed) {
         return OpenActionMessage;
      } else {
         return CloseActionMessage;
      }
   } else {
      return "";
   }
}

/*****************************************************************
 * DoActionableAction
 *****************************************************************
 */
function DoActionableAction(Controller thecontroller){

   Activator = thecontroller.Pawn;

   //can't open closed directional doors
   if (IsPlayerOnRightSide()==false && bClosed){
      PlaySound(LockedSound);
      return ;
   }

   if (bLocked) {
      PlaySound(LockedSound);
      return;
   }

   //if opening or closing do a quick delay to make things look more sensible
   bDoingActionDelay=true;
   SetMultiTimer(ACTIONDELAYID, actionDelay, false);

   if (bClosed){
      Open();
   } else {
      Close();
   }
}

/*****************************************************************
 * Open
 *****************************************************************
 */
function Open(){
local int SoundIndex;
   TriggerEvent(DoorOpenedEvent,self,none);
   DoOpen();
   if (OpeningSounds.Length > 0){
    SoundIndex = int(Frand()*OpeningSounds.length);
      PlaySound(OpeningSounds[SoundIndex]);
   }

   if (iAutoCloseTime > -1){
      SetMultiTimer(CLOSEDELAY, iAutoCloseTime,false);
   }

   bLocked = false;
   bClosed = false;
}

/*****************************************************************
 * Close
 *****************************************************************
 */
function Close(){

   local int SoundIndex;
   TriggerEvent(DoorClosedEvent,self,none);
   DoClose();
   if (ClosingSounds.Length > 0){
      SoundIndex = int(Frand()*ClosingSounds.length);
      PlaySound(ClosingSounds[SoundIndex]);
   }
   bClosed = true;
}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int ID){

   //handles messages to they don't switch instantly
   if (ID == ACTIONDELAYID){
      bDoingActionDelay = false;

   //handles closing the door automatically
   } else if (ID == CLOSEDELAY) {
    if (bClosed == false){
      Close();
    }
   } else {
      Super.MultiTimer(ID);
   }
}


/*****************************************************************
 * TriggerEx
 *****************************************************************
 */
function TriggerEx(Actor Other,Pawn Instigator, Name handler){
   switch (handler){
   case hLock:
      bLocked = true;
      break;
   case hUnlock:
      bLocked = false;
      break;
   case hOpen:
      Open();
      break;
   case hClose:
      Close();
      break;
   }
   Super.TriggerEx(Other,Instigator,handler);
}

defaultproperties
{
     OpenActionMessage="Press Action to open door"
     CloseActionMessage="Press Action to close door"
     LockedActionMessage="Locked"
     OneWayDoorMessage="Can't open door from this side"
     bActionable=True
     bStartsClosed=True
     iAutoCloseTime=-1
     hLock="Lock"
     hUnlock="UNLOCK"
     hOpen="Open"
     hClose="Close"
     bClosed=True
     iActionablePriority=2
     actiondelay=0.500000
     MoverEncroachType=ME_IgnoreWhenEncroach
     bHasHandlers=True
     bPathColliding=False
     SoundVolume=254
     SoundOcclusion=OCCLUSION_None
     TransientSoundRadius=1000.000000
}
