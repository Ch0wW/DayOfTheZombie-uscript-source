// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DOTZGameInfoBase extends AdvancedGameInfo;

//these are in game variables that apply to the current game
var int CurrentChapter;
var int CurrentPage;
var ObjectivesManager theObjMgr;

//these are global values tha apply to the entire game
var config int BestChapter;
var config int BestPage;
//var bool bPauseWithMenu;

var bool bNameCheat;


function string GetCurrentProfileName(){
   return DOTZPlayerControllerBase(Level.GetLocalPlayerController()).GetCurrentProfileName();
}


/*****************************************************************
 * GameOver
 * Call to game over whenever a human pawn dies in singleplayer
 * set the local player controller to 'dead'
 *****************************************************************
 */
function GameOver(){
    AdvancedPlayerController(Level.GetLocalPlayerController()).GameOver();
    Level.Game.SetPause(true,Level.GetLocalPlayerController());
}

/*****************************************************************
 * GiveDefaultInventory
 *****************************************************************
 */
function GiveDefaultInventory(Pawn P){
   AdvancedPawn(P).SetInventoryLimit(1,'MeleeWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'GlockWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'M16Weapon');
   AdvancedPawn(P).SetInventoryLimit(1,'RevolverWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'RifleWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'ShotgunWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'SniperWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'GrenadeWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'MolotovWeapon');
   Log("Giving Weapon to the player");
   P.GiveWeapon(DefaultInventory);
}

/*****************************************************************
 * RevealChapter
 *****************************************************************
 */
function RevealChapter(int ChapterNumber, int PageNumber){

    //update the local game copies
    CurrentChapter = ChapterNumber;
    CurrentPage = PageNumber;

    //Update the global copies, set chapter if it is better
    if (ChapterNumber > class'DOTZGameInfoBase'.default.BestChapter){
        class'DOTZGameInfoBase'.default.BestChapter = ChapterNumber;
    }

    //make sure that an old chapter doesn't adjust this value
    if (CurrentChapter >= class'DOTZGameInfoBase'.default.BestChapter){
        //set page if it is better
        if (PageNumber > class'DOTZGameInfoBase'.default.BestPage || PageNumber == -1){
            class'DOTZGameInfoBase'.default.BestPage  = PageNumber;
        }
    }
    class'DOTZGameInfoBase'.static.StaticSaveConfig();
}

/*****************************************************************
 * GetCurrentChapter
 *****************************************************************
 */
static function int GetBestChapter(){
    return class'DOTZGameInfoBase'.default.BestChapter;
}

/*****************************************************************
 * GetCurrentPage
 *****************************************************************
 */
static function int GetBestPage(){
    return class'DOTZGameInfoBase'.default.BestPage;
}




//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Date0=""
     Date1=""
     Date2=""
     Date3=""
     Date4=""
     Date5=""
     Date6=""
     SlotName8=" - 00:00:00"
     Date8="12/4/2005 - 09:59:05"
     Date9=""
     PreloadObjects(0)="DOTZEngine.SkelHead"
     PreloadObjects(1)="DOTZMenu.XDOTZSPPause"
     PreloadMesh(0)=StaticMesh'DOTZSSpecial.Particles.Rock'
     PreloadMesh(1)=StaticMesh'DOTZSSpecial.Particles.Barrelpiece'
     PreloadMesh(2)=StaticMesh'DOTZSSpecial.Particles.splash'
     PreloadMesh(3)=StaticMesh'DOTZSSpecial.Particles.Woodshard'
     PreloadMesh(4)=StaticMesh'DOTZSSpecial.Particles.Concrete'
     PreloadMesh(5)=StaticMesh'DOTZSSpecial.Gore.BloodyChunk'
     PreloadMesh(6)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmA'
     PreloadMesh(7)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmB'
     PreloadMesh(8)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmC'
     PreloadMesh(9)=StaticMesh'DOTZSSpecial.GibForearm.GibForearmD'
     PreloadMesh(10)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmA'
     PreloadMesh(11)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmB'
     PreloadMesh(12)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmC'
     PreloadMesh(13)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmD'
     PreloadMesh(14)=StaticMesh'DOTZSSpecial.GibUpperArm.UpperArmE'
     PreloadMesh(15)=StaticMesh'DOTZSSpecial.GibLeg.GibLegA'
     PreloadMesh(16)=StaticMesh'DOTZSSpecial.GibLeg.GibLegB'
     PreloadMesh(17)=StaticMesh'DOTZSSpecial.GibLeg.GibLegC'
     PreloadMesh(18)=StaticMesh'DOTZSSpecial.GibLeg.GibLegD'
     PreloadMesh(19)=StaticMesh'DOTZSSpecial.GibLeg.GibLegE'
     PreloadMaterial(3)=Texture'SpecialFX.Blood.Bloodsplatter'
     PreloadMaterial(4)=Texture'SpecialFX.Blood.Bone'
     PreloadMaterial(5)=Texture'SpecialFX.Blood.Muscle'
     PreloadMaterial(7)=Texture'SpecialFX.Fire.Explosion'
     PreloadMaterial(8)=Texture'SpecialFX.Fire.ExplosionFire'
     PreloadMaterial(9)=Texture'SpecialFX.Particles.dust2'
     PreloadMaterial(10)=Texture'SpecialFX.Smoke.smokelight_a'
     PreloadMaterial(11)=Texture'SpecialFX.Smoke.Smoke'
     PreloadMaterial(12)=Texture'SpecialFX.Fire.LargeFlames2'
     DefaultInventory="DOTZWeapons.FistWeapon"
}
