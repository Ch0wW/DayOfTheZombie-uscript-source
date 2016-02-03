/**

 * $Revision: #1 $

 */

class BBPPockMark extends Projector;



var float Lifetime;









function PostBeginPlay () {

    AttachProjector ();

    AbandonProjector (Lifetime);

    Destroy ();

}









/* Reset()

reset actor to initial state - used when restarting level without reloading.

*/

function Reset () { Destroy (); }

defaultproperties
{
     Lifetime=2.000000
     MaterialBlendingOp=PB_Modulate
     FrameBufferBlendingOp=PB_AlphaBlend
     ProjTexture=Texture'SpecialFX.Fire.BulletHole'
     MaxTraceDistance=32
     bProjectActor=False
     bClipBSP=True
     bProjectOnUnlit=True
     bStatic=False
     DrawScale=0.500000
}
