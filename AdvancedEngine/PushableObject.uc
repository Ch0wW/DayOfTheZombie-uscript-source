// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class PushableObject extends Advancedactor
placeable;

enum eMoveType{
   MT_KICK,
   MT_SLIDE
};

var() localized string ActionMsg;
var() int PushRange;
var() int iMinimumWallDistance;
var() Sound SlidingSound;
var() Sound KickedSound;
var() float iSlideTime;
var() eMoveType MoveType;


const KICKED = 1;
const SLIDING = 2;
const POLLING_TIME = 0.05;

//internal
var float iCurrentSlideTime;


/****************************************************************
 * PostBeginPlay
 ****************************************************************
 */
function PostBeginPlay(){
   SetPhysics(PHYS_Falling);
}


/****************************************************************
 * GetActionablePriority
 ****************************************************************
 */
function int GetActionablePriority(Controller C){
   return 1;
}

/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function DoActionableAction(Controller C){

   local Pawn Player;
   if (!InRange()){
      return;
   }
   if (NearWall()){
      return;
   }
   Player = Level.GetLocalPlayerController().Pawn;

   if (MoveType==MT_SLIDE){
      Slide(Player);
   } else if (MoveType == MT_KICK){
      Kick(Player);
   }

}


/****************************************************************
 * Slide
 ****************************************************************
 */
function Slide(Pawn Player){
   SetMultiTimer(SLIDING,POLLING_TIME,true);
   PlaySound(SlidingSound);
   SetPhysics(PHYS_Projectile);
   Velocity = (Normal(vector(Player.Rotation)) * vect(700,700,0));
}


/****************************************************************
 * CheckForSlideStop
 ****************************************************************
 */
function CheckForSlideStop(){

   if (VSize(velocity) > 0){
      if (NearWall()){
         SetMultiTimer(SLIDING,0,false);
         velocity = vect(0,0,0);
      }
      velocity -= velocity*(POLLING_TIME/iSlideTime);
   }


   iCurrentSlideTime += POLLING_TIME;
   if (iCurrentSlideTime >= iSlideTime){
      iCurrentSlideTime = 0;
      SetMultiTimer(SLIDING, 0, false);
      SetPhysics(PHYS_Falling);
   }
}


/****************************************************************
 * Kick
 ****************************************************************
 */
function Kick(Pawn Player){

   SetMultiTimer(KICKED,POLLING_TIME,true);
   PlaySound(KickedSound);
   Velocity = (vector(Player.Rotation) * 700) + vect(0,0,90);
   SetPhysics(PHYS_Falling);
}


/****************************************************************
 * CheckForKickedStop
 ****************************************************************
 */
function CheckForKickedStop(){
      if (VSize(velocity) > 0){
         if (NearWall()){
            SetMultiTimer(KICKED,0,false);
            velocity = vect(0,0,0);
         }
      } else {
         SetMultiTimer(KICKED, 0, false);
      }
}

/****************************************************************
 * MultiTimer
 ****************************************************************
 */
function MultiTimer(int ID){

   if (ID == KICKED){
      CheckForKickedStop();
   } else if (ID == SLIDING){
      CheckForSlideStop();
   }
}


/****************************************************************
 * NearWall
 ****************************************************************
 */
function bool NearWall(){

   local vector checkloc;
   local vector checkright;
   local vector checkleft;
   local Pawn Player;
   local rotator playerRot;
   Player = Level.GetLocalPlayerController().Pawn;

   //look ahead
   playerRot = Player.Rotation;
   checkloc = Normal(vector(PlayerRot))*iMinimumWallDistance + Location;

   //look right
   playerRot = Player.Rotation + rot(0,8192,0);
   checkright = Normal(vector(PlayerRot))*iMinimumWallDistance + Location;

   //look left
   playerRot = Player.Rotation + rot(0,-8192,0);
   checkleft = Normal(vector(PlayerRot))*iMinimumWallDistance + Location;

   if (FastTrace(Location,checkloc) &&
       FastTrace(Location,checkLeft) &&
       FastTrace(Location,checkright)){
       //all traces suceeded, nothing around you
       return false;
   }
   return true;
}


/****************************************************************
 * GetActionableMessage
 ****************************************************************
 */
function string GetActionableMessage(Controller C){
   if ( InRange()){
      return ActionMsg;
   } else {
      return "";
   }
}

/****************************************************************
 * InRange
 ****************************************************************
 */
function bool InRange(){
   local Pawn Player;
   Player = Level.GetLocalPlayerController().Pawn;
   if ( VSize(location - Player.Location) < PushRange ){
      return true;
   }
   return false;
}


/****************************************************************
 * PlayerOnTop
 ****************************************************************
 */
function bool PlayerOnTop(){
   return false;
}

defaultproperties
{
     ActionMsg="Press Action to push"
     PushRange=120
     iMinimumWallDistance=150
     iSlideTime=0.200000
     MoveType=MT_SLIDE
     Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
