class BBPRevolverMuzzleFlash extends BBPMuzzleFlash;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.MuzzleFlashTest'
         UseMeshBlendMode=False
         UseParticleColor=True
         FadeOutStartTime=0.025000
         FadeOut=True
         FadeInEndTime=0.025000
         FadeIn=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         SpinParticles=True
         StartSpinRange=(X=(Min=-0.250000,Max=-0.250000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=0.500000,Max=0.550000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.070000,Max=0.070000)
         Name="MeshEmitter1"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPRevolverMuzzleFlash.MeshEmitter1'
     AutoDestroy=True
     bNoDelete=False
     bHardAttach=True
     bDirectional=True
     Tag="BBPRevolverMuzzleFlash"
     Skins(0)=Texture'SpecialFX.MuzzleFlash.MuzzleFlashRevolver'
}
