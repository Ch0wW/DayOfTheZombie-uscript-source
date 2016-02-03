// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
 /**
 * XDotzPlayerController - The location for all the xbox specific crap to go!
 *
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    May 2003
 */
class XDOTZPlayerController extends DOTZPlayerControllerBase;

var Material icon_friend_recv;
var Material icon_invite_recv;

var XboxConnectionChecker connectionCheck;
var bool was_filled;
var bool never_set;
var bool bPauseRumble;

/****************************************************************
 * PostLoad
 *
 ****************************************************************
 */

function PostLoad(){
    super.PostLoad();
}

/****************************************************************
 * PostBeginPlay
 *
 ****************************************************************
 */

function PostNetBeginPlay() {

    Log("!!!!Preloading menus!!!!");

    if(connectionCheck == none)
        connectionCheck = Spawn(class'XboxConnectionChecker');

    Super.PostNetBeginPlay();
}

/*****************************************************************
 * PostNetReceive
 * Handles the case (albiet awkwardly) of trying to close the menu
 * when the player controller doesn't have a 'player' yet.
 *****************************************************************
 */
simulated event PostNetReceive(){
    super.PostNetReceive();

    if (class'UtilsXbox'.static.Get_Reboot_Type() == 4 && GameReplicationInfo != none) {
        // CARROT: Update player join flag
        if (never_set) {
            if (GameReplicationInfo.GameFilled) {
                class'UtilsXbox'.static.Set_Player_Not_Joinable ();
            } else {
                class'UtilsXbox'.static.Set_Player_Joinable ();
            }
        } else {
            if (was_filled && !GameReplicationInfo.GameFilled) {
                class'UtilsXbox'.static.Set_Player_Joinable ();
            } else if (!was_filled && GameReplicationInfo.GameFilled) {
                class'UtilsXbox'.static.Set_Player_Not_Joinable ();
            }
        }

        never_set = false;
        was_filled = GameReplicationInfo.GameFilled;
    }

}


/****************************************************************
 * DrawToHud
 *****************************************************************
 */

function DrawToHud(Canvas c, float scaleX, float scaleY) {
    super.DrawToHud(c, scaleX, scaleY);

    if (class'UtilsXbox'.static.Has_Game_Invite_Notification()) {
        c.SetPos(c.ClipX * 0.65, c.ClipY * 0.1);
        c.DrawTile( icon_invite_recv, 64 * scaleX, 64 * scaleY, 0, 0, 64, 64 );
    } else if (class'UtilsXbox'.static.Has_Friend_Request_Notification()) {
        c.SetPos(c.ClipX * 0.65, c.ClipY * 0.1);
        c.DrawTile( icon_friend_recv, 64 * scaleX, 64 * scaleY, 0, 0, 64, 64 );
    }
}

/*****************************************************************
 * SetControllerSensitivity
 *****************************************************************
 */
function SetControllerSensitivity(float sensitivity){
   super.SetControllerSensitivity(sensitivity);
   XBoxPlayerInput(PlayerInput).SetControllerSensitivity(sensitivity);
}

/*****************************************************************
 * InvertLook
 *****************************************************************
 */
exec function InvertLook(bool bIsChecked){
   if (PlayerInput != none){
      XBoxPlayerInput(PlayerInput).InvertVLook(bIsChecked);
   }
}


event InitInputSystem()
{
   super.InitInputSystem();
   InvertLook(GetInvertLook());
}

/*****************************************************************
 * ClientFlash
 *****************************************************************
 */
function ClientFlash( float scale, vector fog )
{
   if (!bDoFade){
      super.ClientFlash(scale,fog);
      if (scale == 0.5 && fog == vect(1000,0,0)){
           if (GetUseVibration() && !bPauseRumble &&
               Level.TimeSeconds > 10) {
               Log("Vibration at " $ Level.TimeSeconds);
               class'UtilsXbox'.static.Rumble_Controller(1, 2);
           }
      }
   }
}

function bool SetPause(bool bPause){
   if (bPause == false){
      bPauseRumble = false;
   }
   return super.SetPause(bPause);
}

function Destroyed()
{
    if(connectionCheck != none)
        connectionCheck.Destroy();

    super.Destroyed();
}


/*****************************************************************
 * Default properties
 *****************************************************************
 */





//Joy 9 D-Pad Up
//Joy 10 D-Pad Down
//Joy 11 D-Pad Left
//Joy 12 D-Pad Right

defaultproperties
{
     icon_friend_recv=Texture'DOTZTInterface.XBoxIcons.FriendRequest'
     icon_invite_recv=Texture'DOTZTInterface.XBoxIcons.Invite'
     was_filled=True
     never_set=True
     MyLifeBar=XDOTZHealthBar'DOTZEngine.XDOTZPlayerController.LifeBar0'
     AdvancedCheatClass=Class'DOTZEngine.xBoxCheatManager'
     PreLoadActors(0)="XDOTZCharacters.TeenagerHuman"
     PreLoadActors(1)="XDOTZCharacters.MilitaryHuman"
     PreLoadActors(2)="DOTZWeapons.BaseBallBatAmmunition"
     PreLoadActors(3)="DOTZWeapons.BaseBallBatAttachment"
     PreLoadActors(4)="DOTZWeapons.BaseBallBatWeapon"
     PreLoadActors(5)="DOTZWeapons.FireAxeAmmunition"
     PreLoadActors(6)="DOTZWeapons.FireAxeAttachment"
     PreLoadActors(7)="DOTZWeapons.FireAxeWeapon"
     PreLoadActors(8)="DOTZWeapons.FistAmmunition"
     PreLoadActors(9)="DOTZWeapons.FistWeapon"
     PreLoadActors(10)="DOTZWeapons.GlockAmmunition"
     PreLoadActors(11)="DOTZWeapons.GlockAttachment"
     PreLoadActors(12)="DOTZWeapons.GlockWeapon"
     PreLoadActors(13)="DOTZWeapons.GolfClubAmmunition"
     PreLoadActors(14)="DOTZWeapons.GolfClubAttachment"
     PreLoadActors(15)="DOTZWeapons.GolfClubWeapon"
     PreLoadActors(16)="DOTZWeapons.GrenadeAmmunition"
     PreLoadActors(17)="DOTZWeapons.GrenadeAttachment"
     PreLoadActors(18)="DOTZWeapons.GrenadeWeapon"
     PreLoadActors(19)="DOTZWeapons.HammerAmmunition"
     PreLoadActors(20)="DOTZWeapons.HammerAttachment"
     PreLoadActors(21)="DOTZWeapons.HammerWeapon"
     PreLoadActors(22)="DOTZWeapons.KungFuAmmunition"
     PreLoadActors(23)="DOTZWeapons.KungFuWeapon"
     PreLoadActors(24)="DOTZWeapons.LeadPipeAmmunition"
     PreLoadActors(25)="DOTZWeapons.LeadPipeAttachment"
     PreLoadActors(26)="DOTZWeapons.LeadPipeWeapon"
     PreLoadActors(27)="DOTZWeapons.M16Ammunition"
     PreLoadActors(28)="DOTZWeapons.M16Attachment"
     PreLoadActors(29)="DOTZWeapons.M16Weapon"
     PreLoadActors(30)="DOTZWeapons.MolotovAmmunition"
     PreLoadActors(31)="DOTZWeapons.MolotovAttachment"
     PreLoadActors(32)="DOTZWeapons.MolotovWeapon"
     PreLoadActors(33)="DOTZWeapons.RevolverAmmunition"
     PreLoadActors(34)="DOTZWeapons.RevolverAttachment"
     PreLoadActors(35)="DOTZWeapons.RevolverWeapon"
     PreLoadActors(36)="DOTZWeapons.RifleAmmunition"
     PreLoadActors(37)="DOTZWeapons.RifleAttachment"
     PreLoadActors(38)="DOTZWeapons.RifleWeapon"
     PreLoadActors(39)="DOTZWeapons.ShotGunAmmunition"
     PreLoadActors(40)="DOTZWeapons.ShotgunAttachment"
     PreLoadActors(41)="DOTZWeapons.ShotgunWeapon"
     PreLoadActors(42)="DOTZWeapons.ShovelAmmunition"
     PreLoadActors(43)="DOTZWeapons.ShovelAttachment"
     PreLoadActors(44)="DOTZWeapons.ShovelWeapon"
     PreLoadActors(45)="DOTZWeapons.SniperAmmunition"
     PreLoadActors(46)="DOTZWeapons.SniperAttachment"
     PreLoadActors(47)="DOTZWeapons.SniperWeapon"
     PreLoadActors(48)="DOTZWeapons.MountedWeaponA"
     PreLoadActors(49)="DOTZWeapons.MountedWeaponAmmunitionA"
     PreLoadActors(50)="DOTZWeapons.MountedWeaponAttachmentA"
     PreLoadActors(51)="XDOTZCharacters.MiddleAgedHuman"
     InputClass=Class'AdvancedEngine.XBoxPlayerInput'
}
