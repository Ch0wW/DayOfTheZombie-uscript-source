// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
 /**
 * DOTZPlayerControllerBase - previously HGPlayerControllerBase.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    May 2003
 */
class DOTZPlayerController extends DOTZPlayerControllerBase;

/*****************************************************************
 * SetProfileConfiguration
 * Update the active configuration to reflect the currently loaded profile.
 *****************************************************************
 */
private function SetProfileConfiguration(){

    Log("Setting profile config from profile");

    //SET CURRENT PROFILE
    if (GetCurrentProfileName() != "" && IsLoadedProfileValid()){

        //Set the difficulty level
        AdvancedGameInfo(Level.Game).iDifficultyLevel = int(class'Profiler'.static.GetValue(constDIFFLEVEL));
        SetDifficultyLevel(AdvancedGameInfo(Level.Game).iDifficultyLevel);

   //DEFAULTS
    } else {
        SetDifficultyLevel(1);
    }

    SetUseSubtitles(true);
}

/*****************************************************************
 * SetInvertLook
 *****************************************************************
 */

function SetInvertLook(bool bShouldInvert){
   InvertLook(bShouldInvert);
}

/*****************************************************************
 *
 *****************************************************************
 */

state dead{
   exec function Fire( optional float F ) {
        HandlePlayerInput();
    }

    exec function AltFire( optional float F ) {
        HandlePlayerInput();
    }
    /**
     * Do clever stuff here to restart the game for the player...
     */
    function HandlePlayerInput() {

        if ( Level.NetMode == NM_Standalone ) {
            if ( Level.TimeSeconds - StartedSpectatingTime > MIN_SPECTATE_TIME ) {
                    AdvancedGameInfo(Level.Game).GameOver();
            }
        } else {
            //Log("MP game restarting player");
            ServerRestartPlayer();
        }
    }
}

defaultproperties
{
     MyLifeBar=DOTZHealthBar'DOTZEngine.DOTZPlayerController.LifeBar0'
     AdvancedCheatClass=Class'DOTZEngine.PCCheatManager'
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
}
