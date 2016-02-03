class BBPM16MuzzleFlash extends BBPMuzzleFlash;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Z=-4.000000)
         StartLocationRange=(Z=(Min=4.000000,Max=4.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Max=0.010000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.100000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000))
         UniformSize=True
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.MuzzleFlash.M16mFlash'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.150000,Max=0.150000)
         GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
         Name="SpriteEmitter1"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPM16MuzzleFlash.SpriteEmitter1'
     AutoDestroy=True
     bNoDelete=False
     bHardAttach=True
     Tag="BBPM16MuzzleFlash"
}
