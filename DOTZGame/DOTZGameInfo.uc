// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * FOTZGameInfo - the single player game type for DOTZ
 *
 * @version $1.0$
 * @author  Jesse Lachapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class DOTZGameInfo extends DOTZGameInfoBase;

var config string PauseMenuSP;
var config string DeadMenuSP;
var config string DeadMenuSPParam;

var config string ProfileMenu;
var localized string PCMsg;

//===========================================================================
// Internal data
//===========================================================================


var int tickcount;

//dead message stuff
var Material SpectatingOverlay;


/*****************************************************************
 * Login
 *****************************************************************
 */
event PlayerController Login(   string Portal,  string Options,out string Error){
    local PlayerController NewPlayer;
    NewPlayer = super.Login(Portal,Options,Error);
    //if the level has a particular choice for the pawn, then overwrite the one
    //previously set in the super class
    if (GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PlayerClass != ""){
        NewPlayer.SetPawnClass(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PlayerClass, "");
    }
    return NewPlayer;
}

/*******************************************************************
 * Initialize the game.  The GameInfo's InitGame() function is called
 * before any other scripts (including PreBeginPlay() ), and is used
 * by the GameInfo to initialize parameters and spawn its helper
 * classes.  Warning: this is called before actors' PreBeginPlay.
 *******************************************************************
 */
event InitGame(String options, out String error){
   Super.InitGame(options, error);
   //Level.NetMode = NM_StandAlone;
   theObjMgr = Spawn( class'DOTZObjectivesManager' );
}

 /**
 * override normal hud with spectating overlay...
 */
function DrawToHud( Canvas c, float scaleX, float scaleY ) {
   local PlayerController pc;
   local float textWidth, textHeight;

   pc = Level.GetLocalPlayerController();


   if (pc.IsDead())
   {
      if (pc.IsA('XDotzPlayerController') == true){
        //set by the level
        //SpectatingMsg = "Game Over. Press START to continue.";
      } else {
        SpectatingMsg = PCMsg;
      }

      if ( SpectatingOverlay != none ) {
         c.SetPos( 384 * scaleX, 352 * scaleY );
         c.SetDrawColor( 255, 255, 255 );
         c.DrawTile( SpectatingOverlay, 512 * scaleX, 256 * scaleY,
                                              0, 0, 512, 256 );
      } else if ( SpectatingMsg != "" ) {
         c.TextSize( SpectatingMsg, textWidth, textHeight );
         c.SetPos( 640 * scaleX - (textWidth/2), 480 * scaleY );
         //c.Font = c.
         c.SetDrawColor( 255, 255, 255 );
//         c.bCenter = true;
         c.DrawText(SpectatingMsg );
  //       c.bCenter = false;
      }
   }
}

/*****************************************************************
 * SetPause
 *****************************************************************
 */
function bool SetPause( bool bPause, PlayerController pc ) {
   //if you are pausing and there is a pawn then bring up the menu
   // and pause the game, if you have no pawn and are still alive
   // (you are in a cinematic) then do nothing

   //short circuit the normal menu pause crap
   if (AdvancedPlayerController(pc).objVideoPlayer.VideoIsPlaying() ||
       AdvancedPlayerController(pc).IsMoviePlaying() ||
       AdvancedPlayerController(pc).bNoPauseMenu)
   {
        if (AdvancedPlayerController(pc).objVideoPlayer.VideoIsPlaying() && bPause == false){
            AdvancedPlayerController(pc).objVideoPlayer.StopVideo();
        }

        if (AdvancedPlayerController(pc).IsMoviePlaying() && bPause == false){
            AdvancedPlayerController(pc).StopMovie();
        }

        return super.SetPause(bPause,pc);
   }

   //if you are dead
   if (pc.IsDead()){
      GuiController(pc.Player.InteractionMaster.GlobalInteractions[0])
           .OpenMenu(DeadMenuSP, DeadMenuSPParam);
      return Super.SetPause(bPause, pc);
   }

   //pausing and not in a cinematic
   if (bPause && !(pc.Pawn == None && pc.IsDead()==false))
   {
      GuiController(pc.Player.InteractionMaster.GlobalInteractions[0])
               .OpenMenu(PauseMenuSP);
      return Super.SetPause(bPause, pc);
   }
   //if you are unpausing then unpause
   else if (!bPause){
       return Super.SetPause(bPause, pc);
   }

   return true;
}

/*****************************************************************
 * Tick
 *****************************************************************
 */
event Tick(float delta){
    super.Tick(delta);
    if (Tickcount == 0){
        Tickcount++;
    } else if (tickcount == 1){
        tickcount++;
        LevelStart();
    }
}


/*****************************************************************
 *
 *****************************************************************
 */
function PostLoad(){
    local Projector temp;

    super.PostLoad();

    foreach Allactors(class'Projector', temp){
            if (ShadowProjector(temp) == none){
                temp.AttachProjector();
            }
    }
}


/*****************************************************************
 * LevelStart
 *****************************************************************
 */
function LevelStart(){
    local PlayerController pc;
    //local DOTZCheckpoint cp;

   // local int ChapterNum, PageNum, RevealNum;

    pc = Level.GetLocalPlayerController();
   // bPauseWithMenu = false;
    //pc.SetPause(true);
   // bPauseWithMenu = true;

    //ChapterNum = GameSpecificLevelInfo(Level.GameSpecificLevelInfo).ChapterNumber;
   // PageNum = GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PageNumber;
    //RevealNum = GameSpecificLevelInfo(Level.GameSpecificLevelInfo).RevealledTo;

    //close any loading screen menus
    GuiController(pc.Player.InteractionMaster.GlobalInteractions[0]).CloseAll(true);
    /*
    //ensure that menus are set to display proper chapters
    RevealChapter(ChapterNum, RevealNum);

    //open the level start page
    GuiController(pc.Player.InteractionMaster.GlobalInteractions[0])
          .OpenMenu("DOTZMenu.DOTZStoryPageMenu",
          string(ChapterNum),
          string(PageNum));
*/
/* commentted out because FindPlayerStart() below returns the checkpoint to load to
    // SV: lets move player to checkpoint
    if( Level.ActiveCheckPointID > 0 )
    {
        foreach AllActors( class'DOTZCheckPoint', cp )
        {
            if( Level.ActiveCheckPointID == cp.id )
            {
                cp.TransportPlayer();
                //Level.ActiveCheckPointID = cp.id;
                break;
            }
        }
    }
*/
   CheckSearchable();
}


/* Return the checkpoint to spawn at.
 */
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
    local DOTZCheckPoint cp;

    foreach AllActors( class'DOTZCheckPoint', cp )
    {
        if( ( cp.id == 1 ) && ( Level.ActiveCheckPointID == -1 ) )
        {
            // If we are new to this level, then just return the first checkpoint
            cp.bTouchable = true;
            return cp;
        }

        if( Level.ActiveCheckPointID == cp.id )
        {
            cp.bTouchable = true;
            return cp;
        }
    }

    // If we didnt find anything, just return the playerstart
    //tmp.bTouchable = true;
    return super.FindPlayerStart( Player, InTeam, incomingName );
}

/*****************************************************************
 * GiveDefaultInventory
 *****************************************************************
 */
function GiveDefaultInventory(Pawn P){

   local int i;

   AdvancedPawn(P).SetInventoryLimit(1,'MeleeWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'GlockWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'M16Weapon');
   AdvancedPawn(P).SetInventoryLimit(1,'RevolverWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'RifleWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'ShotgunWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'SniperWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'GrenadeWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'MolotovWeapon');

   // give the player default weaponry
   if (level.GameSpecificLevelInfo == none ||
        GameSpecificLevelinfo(Level.GameSpecificLevelInfo).StartingWeapons.length == 0){
      P.GiveWeapon(DefaultInventory);
   //unless there are other specified in the level info
   } else {
      for( i=0; i < GameSpecificLevelinfo(Level.GameSpecificLevelInfo).StartingWeapons.Length; i++){
         P.GiveWeapon(GameSpecificLevelinfo(Level.GameSpecificLevelInfo).StartingWeapons[i]);
      }
   }
   P.Controller.ClientSwitchToBestWeapon();

}


//===========================================================================
// Exec functions
//===========================================================================


/******************************************************************
 * TestEvent
 * Triggers the specified event.  Handy for debugging.
 ******************************************************************
 */
exec function TestEvent( Name eventName ) {
    Log( "Triggering [" $ eventName $ "]" );
    TriggerEvent( eventName, self, none );
}


/******************************************************************
 * NoMusic
 * Stops any music currently playing.
 ******************************************************************
 */
exec function NoMusic() {
   StopAllMusic( 2 );
}





/*****************************************************************
 *
 *****************************************************************
 */
exec function CheckSearchable(){
    local ActionableSkeletalMesh temp;
    foreach AllActors(class'ActionableSkeletalMesh', temp){
        temp.Check();
    }
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PauseMenuSP="DOTZMenu.DOTZSPPause"
     DeadMenuSP="DOTZMenu.DOTZSPDead"
     PCMsg="Game Over. Press fire to continue."
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
     HUDType="DOTZGame.DOTZHud"
     PlayerControllerClass=Class'DOTZEngine.DOTZPlayerController'
}
