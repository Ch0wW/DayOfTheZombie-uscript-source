// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CTFFlag extends CarriedObject;


var int                 TeamType;
var CTFBase             HomeBase;
var TeamInfo            Team;
var float               MaxDropTime;
var float               TakenTime;
var GameReplicationInfo GRI;
var Pawn                OldHolder;
var name                AttachmentBone;

var array<Sound> RedTeamHasFlag;
var array<Sound> BlueTeamHasFlag;

var array<Sound> RedTeamLostFlag;
var array<Sound> BlueTeamLostFlag;

var rotator HomeRotation;


replication{
    reliable if ( Role == ROLE_Authority )
        Team;
}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay()
{
   HomeBase = CTFBase(Owner);
   SetOwner(None);
   if ( Level.Game != None ){
      SetGRI(Level.Game.GameReplicationInfo);
   }
   Super.PostBeginPlay();
}

simulated function PostNetBeginPlay(){
   HomeRotation = Rotation;
}

simulated function PostNetReceive(){
   if (bHome) {
      SetRotation(HomeRotation);
   }
}

/*****************************************************************
 * SetHolder
 *****************************************************************
 */
function SetHolder(Controller C){
     Holder = C.Pawn;
    Holder.SpawnTime = -100000;
    HolderPRI =Holder.PlayerReplicationInfo;
    HolderPRI.SetFlag(self);
    C.PlayerReplicationInfo.SetFlag(self);
    GotoState('Held');
}

/*****************************************************************
 * Score
 *****************************************************************
 */
function Score(){
    Disable('Touch');
    GotoState('Home');
}

/*****************************************************************
 * Dropped
 *****************************************************************
 */
function Drop(vector newVel){
    RotationRate.Yaw = Rand(200000) - 100000;
    RotationRate.Pitch = Rand(200000 - Abs(RotationRate.Yaw)) - 0.5 * (200000 - Abs(RotationRate.Yaw));
   Velocity = (0.2 + FRand()) * (newVel + 400 * FRand() * VRand());
    if ( PhysicsVolume.bWaterVolume )
        Velocity *= 0.5;

    SetLocation(Holder.Location);
   Velocity = newVel;
   GotoState('Dropped');
}

/*****************************************************************
 * SendHome
 *****************************************************************
*/
function SendHome(){
   Log(self $ "SendHome");
    GotoState('Home');
}

/*****************************************************************
 * ClearHolder
 *****************************************************************
 */
function ClearHolder()
{
    local int i;
    local GameReplicationInfo GRI;

    if (Holder == None)
        return;

    if ( Holder.PlayerReplicationInfo == None ){
        GRI = Level.Game.GameReplicationInfo;
        for (i=0; i<GRI.PRIArray.Length; i++)
            if ( GRI.PRIArray[i].HasFlag == self )
                GRI.PRIArray[i].SetFlag(None);
    } else {
        Holder.PlayerReplicationInfo.SetFlag(None);
      Holder.Controller.PlayerReplicationInfo.SetFlag(None);
   }
    Holder = None;
    HolderPRI = None;
}

/*****************************************************************
 * Position
 *****************************************************************
 */
function Actor Position()
{
    if (bHeld) { return Holder; }
    if (bHome) { return HomeBase; }
    return self;
}

/*****************************************************************
 * IsHome
 *****************************************************************
 */
function bool IsHome(){
    return false;
}

/*****************************************************************
 * ValidHolder
 *****************************************************************
 */
function bool ValidHolder(Actor Other)
{
   local Controller c;
   local Pawn p;

   p = Pawn(other);
   if (p == None || p.Health <= 0 || !p.IsPlayerPawn())
       return false;

   c = Pawn(Other).Controller;
    if (SameTeam(c))    {
        SameTeamTouch(c);
        return false;
    }
    return true;
}

/*****************************************************************
 * Touch
 *****************************************************************
 */
function Touch(Actor Other)
{
    if (!ValidHolder(Other))
        return;
    SetHolder(Pawn(Other).Controller);
}

/*****************************************************************
 * FellOutOfWorld
 *****************************************************************
 */
event FellOutOfWorld(eKillZType KillType){
    SendHome();
}

/*****************************************************************
 * Landed
 *****************************************************************
 */
event Landed(vector HitNormall)
{
    local rotator NewRot;

    NewRot = Rot(16384,0,0);
    NewRot.Yaw = Rotation.Yaw;
    SetRotation(NewRot);
}

/*****************************************************************
 * SameTeamTouch
 *****************************************************************
 */
function SameTeamTouch(Controller c){
}

/*****************************************************************
 * CheckPain
 *****************************************************************
 */
function CheckPain();



/*****************************************************************
 * SetGRI
 *****************************************************************
 */
simulated function SetGRI(GameReplicationInfo NewGRI)
{
    GRI = NewGRI;
}

/*****************************************************************
 * SameTeam
 *****************************************************************
 */
function bool SameTeam(Controller c)
{
    if (c == None || c.PlayerReplicationInfo.Team != Team) { return false; }
    return true;
}


/*****************************************************************
 * GlobalAnnouncement
 *****************************************************************
 */
function GlobalAnnouncement(array<sound> Announcements){
   local sound Announcement;
   local Controller P;

   Announcement = class'Utils'.static.RndSound(Announcements);
    for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
        if ( P.IsA('PlayerController')){
         PlayerController(P).PlayAnnouncement(Announcement,0,false);
        }
   }
}



//===========================================================================
// STATE HOME
//===========================================================================
auto state Home
{
    ignores SendHome, Score, Drop;

    function SameTeamTouch(Controller c){
        local CTFFlag flag;
        if (C.PlayerReplicationInfo.HasFlag == None){ return; }

        // Score!
        flag = CTFFlag(C.PlayerReplicationInfo.HasFlag);
        flag.Score();
        Level.Game.ScoreObjective(C.PlayerReplicationInfo, 1 );
          TriggerEvent(HomeBase.Event,HomeBase,C.Pawn);
    }

    function Timer(){
        if ( VSize(Location - HomeBase.Location) > 10 ){
            SendHome();
        }
    }

    function CheckTouching()
    {
        local int i;

        for ( i=0; i<Touching.Length; i++ )
            if ( ValidHolder(Touching[i]) ){
                SetHolder(Pawn(Touching[i]).Controller);
                return;
            }
    }

    function bool IsHome()
    {
      return true;
    }

    function BeginState()
    {
     ClearHolder();
     Disable('Touch');
     bHome = true;
     SetLocation(HomeBase.Location);
     SetRotation(HomeBase.Rotation);
     Enable('Touch');

      Level.Game.GameReplicationInfo.SetCarriedObjectState(TeamType,'Home');
        HomeBase.Timer();
        SetTimer(1.0, true);
    }

    function EndState()
    {
      bHome = false;
      TakenTime = Level.TimeSeconds;
        SetTimer(0.0, false);
    }

Begin:
    // check if an enemy was standing on the base
    Sleep(0.05);
    CheckTouching();

}


//===========================================================================
// STATE HELD
//===========================================================================
state Held
{
   ignores SetHolder, SendHome;

    function Timer(){
        if (Holder == None){
            SendHome();
      }
    }

    function BeginState()
    {
      Level.Game.GameReplicationInfo.SetCarriedObjectState(TeamType,'HeldEnemy');
      //Say some stuff
      if (TeamType == 0){
         GlobalAnnouncement(BlueTeamHasFlag);
      } else {
         GlobalAnnouncement(RedTeamHasFlag);
      }

      bOnlyDrawIfAttached = true;
      bHeld = true;
      bCollideWorld = false;
      SetCollision(false, false, false);
      SetLocation(Holder.Location);
      Holder.HoldCarriedObject(self,AttachmentBone);
        SetTimer(10.0, true);
    }

    function EndState()
    {
        bOnlyDrawIfAttached = false;
        ClearHolder();
        bHeld = false;
        bCollideWorld = true;
        SetCollision(true, false, false);
        SetBase(None);
        SetRelativeLocation(vect(0,0,0));
        SetRelativeRotation(rot(0,0,0));
    }
}

//===========================================================================
// STATE DROPPED
//===========================================================================
state Dropped
{
   ignores Drop;

   function Touch(Actor Other)
   {
    if (!ValidHolder(Other))
        return;
    SetHolder(Pawn(Other).Controller);
   }


   function SameTeamTouch(Controller c)
    {
        SendHome();
    }

    function CheckFit()
    {
        local vector X,Y,Z;

        GetAxes(OldHolder.Rotation, X,Y,Z);
        SetRotation(rotator(-1 * X));
            if ( !SetLocation(OldHolder.Location) ) {
               return;
            }
    }

    function CheckPain()
    {
      if (IsInPain())
         timer();
    }

    function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
    {
        CheckPain();
    }

    singular function PhysicsVolumeChange( PhysicsVolume NewVolume )
    {
        Super.PhysicsVolumeChange(NewVolume);
        CheckPain();
    }

    function Timer()
    {
        SendHome();
    }

    function BeginState()
    {
      //Say some stuff
      if (TeamType == 0){
         GlobalAnnouncement(BlueTeamLostFlag);
      } else {
         GlobalAnnouncement(RedTeamLostFlag);
      }

      Level.Game.GameReplicationInfo.SetCarriedObjectState(TeamType,'Down');
      SetPhysics(PHYS_Falling);
       bCollideWorld = true;
       SetCollisionSize( default.CollisionRadius, default.CollisionHeight * 2);
//      CheckFit();
      CheckPain();
        SetTimer(MaxDropTime, false);
    }

    function EndState()
    {
      SetPhysics(PHYS_None);
        bCollideWorld = false;
        SetCollisionSize(default.CollisionRadius, default.CollisionHeight);
    }
}



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     MaxDropTime=25.000000
     bHome=True
     bUnlit=True
     bCollideActors=True
     bCollideWorld=True
     bNetNotify=True
     bFixedRotationDir=True
     NetPriority=3.000000
     PrePivot=(Z=2.500000)
     CollisionRadius=48.000000
     CollisionHeight=30.000000
     Mass=30.000000
     Buoyancy=20.000000
}
