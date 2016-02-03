// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//
//  ShadowProjector
//

class AdvancedShadowProjector extends ShadowProjector;

//
//  InitShadow
//

/*****************************************************************
 * InitShadow
 *****************************************************************
 */
function InitShadow()
{
    local Plane     BoundingSphere;

    if(ShadowActor != None){
        BoundingSphere = ShadowActor.GetRenderBoundingSphere();
        FOV = Atan(BoundingSphere.W * 2 + 160, LightDistance) * 180 / PI;

        ShadowTexture = ShadowBitmapMaterial(Level.ObjectPool.AllocateObject(class'ShadowBitmapMaterial'));
        ProjTexture = ShadowTexture;

        if(ShadowTexture != None){
            SetDrawScale(LightDistance * tan(0.5 * FOV * PI / 180) / (0.5 * ShadowTexture.USize));
            ShadowTexture.Invalid = False;
            ShadowTexture.bBlobShadow = bBlobShadow;
            ShadowTexture.ShadowActor = ShadowActor;
            ShadowTexture.LightDirection = Normal(LightDirection);
            ShadowTexture.LightDistance = LightDistance;
            ShadowTexture.LightFOV = FOV;
            ShadowTexture.CullDistance = CullDistance;
            Enable('Tick');
            UpdateShadow();
        }
        else
            Log(Name$".InitShadow: Failed to allocate texture");
    }
    else
        Log(Name$".InitShadow: No actor");
}

/*****************************************************************
 *
 *****************************************************************
 */
function UpdateShadow()
{
    local coords    C;
  //  local vector adjustment;
    local Pawn p;

    p = Pawn( ShadowActor );
    if ( p != none && p.Health <= 0 ) {
        super.UpdateShadow();
        return;
    }


    DetachProjector(true);

    if(ShadowActor != None && !ShadowActor.bHidden && ShadowTexture != None && bShadowActive)   {
        if(ShadowTexture.Invalid){
            Destroy();
        }else{
             //if(RootMotion && ShadowActor.DrawType == DT_Mesh && ShadowActor.Mesh != None){

                C = ShadowActor.GetBoneCoords('Shadow');
                SetLocation(C.Origin);
//                if (C !=None && C.Origin != vect(0,0,0)){
          //       SetRotation(ShadowActor.GetBoneRotation('Shadow'));
  //              }

  //          }
    //        else {
      //          adjustment = vect(-50,0,100) >> shadowActor.Rotation;
        //        SetLocation(ShadowActor.Location + adjustment);
          //  }

            SetRotation(Rotator(Normal(-LightDirection)));

            ShadowTexture.Dirty = true;
            ShadowTexture.CullDistance = CullDistance;

            AttachProjector();
        }
    }
}

defaultproperties
{
}
