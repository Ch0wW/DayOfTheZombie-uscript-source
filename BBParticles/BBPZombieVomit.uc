class BBPZombieVomit extends BBPGib;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter14
         UseDirectionAs=PTDU_Up
         Acceleration=(Z=-500.000000)
         FadeOutStartTime=-1.000000
         FadeOut=True
         FadeIn=True
         MaxParticles=75
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=25.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Particles.BloodSpurt'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=400.000000,Max=400.000000))
         MaxAbsVelocity=(X=1000.000000,Y=100.000000,Z=1000.000000)
         AddVelocityMultiplierRange=(X=(Max=2.000000))
         Name="SpriteEmitter14"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPZombieVomit.SpriteEmitter14'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         UseDirectionAs=PTDU_Up
         Acceleration=(Z=-500.000000)
         FadeOutStartTime=0.500000
         FadeOut=True
         FadeInEndTime=0.250000
         FadeIn=True
         MaxParticles=75
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=20.000000,Max=30.000000),Z=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=25.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=None
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=400.000000,Max=400.000000))
         MaxAbsVelocity=(X=1000.000000,Y=100.000000,Z=1000.000000)
         AddVelocityMultiplierRange=(X=(Max=2.000000))
         Name="SpriteEmitter16"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPZombieVomit.SpriteEmitter16'
     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BloodyChunk'
         Acceleration=(Z=-500.000000)
         MaxParticles=75
         RespawnDeadParticles=False
         StartLocationRange=(Y=(Min=-3.000000,Max=3.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.250000),Y=(Min=0.250000),Z=(Min=0.250000))
         InitialParticlesPerSecond=25.000000
         AutomaticInitialSpawning=False
         StartVelocityRange=(X=(Min=300.000000,Max=400.000000),Y=(Min=-30.000000,Max=30.000000))
         Name="MeshEmitter7"
     End Object
     Emitters(2)=MeshEmitter'BBParticles.BBPZombieVomit.MeshEmitter7'
     AutoDestroy=True
     bNoDelete=False
}
