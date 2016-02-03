// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZPawnBase - The game specific pawn class, mostly ripped from HG
 *
 * @version $1.0$
 * @author  Jesse (jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class XDOTZPawnBase extends AdvancedPawn
abstract notplaceable
   HideDropDown;

var() Class<ExclaimManager> CharacterExclaimMgrClass;
var(Pawn) Material StandPoseIcon;
var(Pawn) Material CrouchPoseIcon;
var(Pawn) Material MountPoseIcon;
var(Pawn) int PoseIconSize;
var(Pawn) Array<Name> LyingAnims;
var(Pawn) Name GettingupAnim;

// internal
var bool bInfected;
var private Material currentPoseIcon;
var bool    bSoakDebug;
var bool    bPlayingGetUp;
var sound FallSound;
var bool IsMale;
var bool bUseNotifyFootStep;



replication
{
    // Variables the server should send to the client.
    reliable if( bNetDirty && (Role==ROLE_Authority) )
      bInfected;
}


/*****************************************************************
 * SetInfectionState
 *****************************************************************
 */
function SetInfectionState(bool iState, optional bool bForce) {}


/*****************************************************************
 * Mount
 *****************************************************************
 */
function Mount() {
    super.Mount();
    currentPoseIcon = MountPoseIcon;
}

/*****************************************************************
 * Unmount
 *****************************************************************
 */
function Unmount() {
    super.Unmount();
    currentPoseIcon = None;
    if ( bIsCrouched ) SwitchToCrouching();
    else SwitchToStanding();
}

/*****************************************************************
 * DrawHud
 *****************************************************************
 */
function DrawToHUD( Canvas c, float scaleX, float scaleY ) {
    super.DrawToHUD( c, scaleX, scaleY );
    // draw pose icon...
    /*
    c.setPos( 64 * scaleX, 829 * scaleY );
    c.DrawTile( currentPoseIcon,
                poseIconSize * scaleX, poseIconSize * scaleY,
                0, 0, poseIconSize, poseIconSize );
    */
}

function Died(Controller killer, class<DamageType> type, vector hitlocation){
   Super.Died(killer,type,hitlocation);
}

/*****************************************************************
 * DisplayDebug
 *****************************************************************
 */
simulated function DisplayDebug (Canvas Canvas, out float YL, out float YPos) {

    local string T;
    local float XL;

    if (!bSoakDebug) {
        Super.DisplayDebug (Canvas, YL, YPos);
        return;
    }

    Canvas.Style = ERenderStyle.STY_Normal;
    Canvas.StrLen ("TEST", XL, YL);
    YPos = YPos + 8*YL;
    Canvas.SetPos (4, YPos);
    Canvas.SetDrawColor (255, 255, 0);
    T = GetDebugName ();
    if (bDeleteMe) { T = T$" DELETED (bDeleteMe == true)"; }
    Canvas.DrawText (T, false);
    YPos += 3 * YL;
    Canvas.SetPos (4, YPos);

    if (Controller == None) {
        Canvas.SetDrawColor (255, 0, 0);
        Canvas.DrawText ("NO CONTROLLER");
        YPos += YL;
        Canvas.SetPos (4, YPos);
    }
    else { Controller.DisplayDebug (Canvas, YL, YPos); }

    YPos += 2*YL;
    Canvas.SetPos (4, YPos);
    Canvas.SetDrawColor (0, 255, 255);
    Canvas.DrawText ("Anchor "$Anchor$" Serpentine Dist "$SerpentineDist$" Time "$SerpentineTime);
    YPos += YL;
    Canvas.SetPos (4, YPos);

    T = "Floor "$Floor$" DesiredSpeed "$DesiredSpeed$" Crouched "$bIsCrouched$" Try to uncrouch "$UncrouchTime;
    if ((OnLadder != None) || (Physics == PHYS_Ladder)) { T = T$" on ladder "$OnLadder; }
    Canvas.DrawText (T);
    YPos += YL;
    Canvas.SetPos (4, YPos);
}

/*****************************************************************
 * Melee_Attack
 * Called by the controller to make the pawn do a melee attack
 *****************************************************************
 */
function Melee_Attack(){

}

/**
 */
function LieDown() {
    Velocity     = vect(0,0,0);
    Acceleration = vect(0,0,0);
    LoopAnim(LyingAnims[Frand()*(LyingAnims.Length -1)]);
    //AdvancedPlayAnim(LyingAnims[Frand()*(LyingAnims.Length -1)],1,0.1,FOCUSCHANNEL,true);

    bGodMode     = true;
    SetBoredomTimer(false);
    GotoState('LyingDown');
}

/**
 */
state LyingDown {
    ignores TakeDamage, PlayTakeHit, AnimateStanding;

    function PostLoad() {
        super.PostLoad();
        LoopAnim( LyingAnims[Frand()*(LyingAnims.Length -1)]);
        //AdvancedPlayAnim( LyingAnims[Frand()*(LyingAnims.Length -1)],1,0.1,FOCUSCHANNEL,true);
    }

    function BeginState() {
         FreezeMovement(true, false);
    }

    function EndState() {
         FreezeMovement(false);
         SetPhysics( PHYS_Falling );
    }

    function MultiTimer( int timerID ) {
        // ignore the boredom system while lying down.
        if ( timerID == BORED_TIMER ) return;
        else global.multitimer( timerID );

    }
}

/**
 */
function GetUp() {
    StopAnimating( true );
    bPlayingGetUp = true;
    AdvancedPlayAnim(GettingUpAnim,,,,,true);
}

/**
 * Reset the pawn for normal use when get-up anim completes...
 */
function FocusedAnimEnd(){

    if ( bPlayingGetUp == true ) {
        bPlayingGetUp = false;
        bGodMode = false;
        SetBoredomTimer(true);
    }
    super.FocusedAnimEnd();
}

/*****************************************************************
 * PlayFallingSound
 * Play a sound when the controller tells you it has fallen
 *****************************************************************
 */
function PlayFallingSound(){
    PlaySound(FallSound);
}


/*****************************************************************
 * NotifyDoFootStep
 * A different system for footsteps
 *****************************************************************
 */
function Notify_FootStep(){
    if (bUseNotifyFootStep == true){
        PlayFootStep();
    }
}

/*****************************************************************
 * PlayDyingAnim
 * Chance to clean up any fire
 *****************************************************************
 */
simulated function PlayDyingAnim(class<DamageType> DamageType,vector HitLoc){
    local Fire temp;

    //fall back death looks stupid with fire
    foreach BasedActors(class'Fire', temp){
        temp.DestroyFire();
    }

    super.PlayDyingAnim(DamageType,HitLoc);
}

//===========================================================================
// default Properties
//===========================================================================

defaultproperties
{
     LyingAnims(0)="LyingPose"
     GettingupAnim="RisingUp"
     IsMale=True
     RedTeamIndicator=Class'DOTZEngine.DOTZRedIndicator'
     BlueTeamIndicator=Class'DOTZEngine.DOTZBlueIndicator'
     AnimJump="'"
     AnimJumpForward="'"
     AnimJumpBack="'"
     AnimJumpLeft="'"
     AnimJumpRight="'"
     AnimStandHitRight(0)="HitRightSide"
     AnimStandHitLeft(0)="HitLeftSide"
     AnimStandHitBack(0)="HitBack"
     AnimStandHitHead(0)="HitHead"
     AnimStandHitFront(0)="HitFront"
     AnimCrouchHitRight(0)="CrouchHitRightSide"
     AnimCrouchHitLeft(0)="CrouchHitLeftSide"
     AnimCrouchHitBack(0)="CrouchHitBack"
     AnimCrouchHitHead(0)="CrouchHitHead"
     AnimCrouchHitFront(0)="CrouchHitFront"
     AnimCrawlHitRight(0)="CrawlHitRightSide"
     AnimCrawlHitLeft(0)="CrawlHitLeftSide"
     AnimCrawlHitBack(0)="CrawlHitBack"
     AnimCrawlHitHead(0)="CrawlHitHead"
     AnimCrawlHitFront(0)="CrawlHitFront"
     CrawlingCollisionHeight=35.000000
     CrawlingCollisionRadius=45.000000
     BloodEmitter=Class'BBParticles.BBPBlood'
     RagdollLifeSpan=30.000000
     RagInvInertia=4.000000
     RagDeathVel=75.000000
     RagShootStrength=4096.000000
     RagSpinScale=75.000000
     RagDeathUpKick=5.000000
     RagImpactSoundInterval=0.500000
     RagImpactVolume=1.000000
     RagdollOverride="Ragdolls"
     RagSkelName="Zombie"
     FootStepSound(0)=Sound'PlayerSounds.FootSteps.FootstepDefault1'
     FootStepSound(1)=Sound'PlayerSounds.FootSteps.FootstepDefault2'
     FootStepSound(2)=Sound'PlayerSounds.FootSteps.FootstepDefault3'
     FootStepDirt(0)=Sound'PlayerSounds.FootSteps.BFootstepDirt1'
     FootStepDirt(1)=Sound'PlayerSounds.FootSteps.BFootstepDirt2'
     FootStepDirt(2)=Sound'PlayerSounds.FootSteps.BFootstepDirt3'
     FootStepMetal(0)=Sound'PlayerSounds.FootSteps.BFootstepMetal1'
     FootStepMetal(1)=Sound'PlayerSounds.FootSteps.BFootstepMetal2'
     FootStepMetal(2)=Sound'PlayerSounds.FootSteps.BFootstepMetal3'
     FootStepPlant(0)=Sound'PlayerSounds.FootSteps.BFootstepPlant1'
     FootStepPlant(1)=Sound'PlayerSounds.FootSteps.BFootstepPlant2'
     FootStepPlant(2)=Sound'PlayerSounds.FootSteps.BFootstepPlant3'
     FootStepRock(0)=Sound'PlayerSounds.FootSteps.BFootstepRock1'
     FootStepRock(1)=Sound'PlayerSounds.FootSteps.BFootstepRock2'
     FootStepRock(2)=Sound'PlayerSounds.FootSteps.BFootstepRock3'
     FootStepWater(0)=Sound'PlayerSounds.FootSteps.FootStepWater'
     FootStepWater(1)=Sound'PlayerSounds.FootSteps.FootstepWater1'
     FootStepWater(2)=Sound'PlayerSounds.FootSteps.FootstepWater2'
     FootStepWood(0)=Sound'PlayerSounds.FootSteps.BFootstepWood1'
     FootStepWood(1)=Sound'PlayerSounds.FootSteps.BFootstepWood2'
     FootStepWood(2)=Sound'PlayerSounds.FootSteps.BFootstepWood3'
     FootStepSnow(0)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush1'
     FootStepSnow(1)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush2'
     FootStepSnow(2)=Sound'PlayerSounds.FootSteps.FootstepRustlingBrush3'
     GrenadeThrowAnim="GrenadeThrow"
     GrenadeAnimLength=1
     bInfiniteAmmo=True
     WeaponBone="Weapon"
     TweenTime=0.200000
     hitblend=0.020000
     bCanCrouch=True
     bJumpCapable=False
     bCanClimbLadders=True
     bCanStrafe=True
     bCanWalkOffLedges=True
     bSameZoneHearing=True
     bAdjacentZoneHearing=True
     bMuffledHearing=True
     bAroundCornerHearing=True
     HearingThreshold=4096.000000
     SightRadius=12000.000000
     MeleeRange=20.000000
     GroundSpeed=150.000000
     JumpZ=480.000000
     AirControl=0.350000
     BaseEyeHeight=59.000000
     EyeHeight=60.000000
     CrouchHeight=43.000000
     UnderWaterTime=20.000000
     bPhysicsAnimUpdate=True
     LightBrightness=70.000000
     LightRadius=6.000000
     LightHue=40
     LightSaturation=128
     bStasis=False
     bHardAttach=True
     CollisionHeight=72.000000
     Buoyancy=99.000000
     RotationRate=(Pitch=0,Roll=2048)
     Begin Object Class=KarmaParamsSkel Name=PawnKParams
         bKDoConvulsions=True
         KConvulseSpacing=(Min=10.000000,Max=15.000000)
         KLinearDamping=0.150000
         KAngularDamping=0.050000
         KBuoyancy=1.000000
         KStartEnabled=True
         KVelDropBelowThreshold=50.000000
         bHighDetailOnly=False
         KFriction=0.600000
         KRestitution=0.300000
         KImpactThreshold=500.000000
         Name="PawnKParams"
     End Object
     KParams=KarmaParamsSkel'DOTZEngine.XDOTZPawnBase.PawnKParams'
     ForceType=FT_DragAlong
     ForceRadius=100.000000
     ForceScale=2.500000
}
