// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DOTZObjectivesManager extends ObjectivesManager;

/*
function Font GetStandardFont(){
   return HGHud( Level.GetLocalPlayerController().myHUD).GetStandardFontRef();
}

function DrawToHud(Canvas c, float scaleX, float scaleY){
  C.Font= GetStandardFont();
  Super.DrawToHud(c, scaleX, scaleY);
}
*/

defaultproperties
{
     Backdrop=Texture'DOTZTInterface.HUD.ObjectivesBackdrop'
     RevealSound=Sound'DOTZXInterface.Dong'
}
