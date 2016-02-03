class BBPMediumTracer extends BBPWeaponFX;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter31
         UseDirectionAs=PTDU_Right
         UseCollision=True
         UseMaxCollisions=True
         MaxCollisions=(Min=1.000000,Max=1.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(1)=(RelativeTime=0.100000,RelativeSize=1.000000)
         StartSizeRange=(Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=10000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.MuzzleFlash.Trail'
         TextureUSubdivisions=3
         TextureVSubdivisions=3
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=16000.000000,Max=16000.000000))
         Name="SpriteEmitter31"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPMediumTracer.SpriteEmitter31'
     AutoDestroy=True
     bNoDelete=False
     bHardAttach=True
     RemoteRole=ROLE_None
}
