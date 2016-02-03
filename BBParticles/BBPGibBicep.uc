class BBPGibBicep extends BBPGib;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BloodyChunk'
         Acceleration=(Z=-300.000000)
         MaxParticles=16
         RespawnDeadParticles=False
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.500000,Max=1.500000),Y=(Min=0.500000,Max=1.500000),Z=(Min=0.500000,Max=1.500000))
         Sounds(0)=(Sound=Sound'DOTZXCharacters.ZombieImpactSounds.ImpactGibs1',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXCharacters.ZombieImpactSounds.ImpactGibs2',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXCharacters.ZombieImpactSounds.ImpactGibs3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-100.000000,Max=200.000000))
         Name="MeshEmitter2"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPGibBicep.MeshEmitter2'
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BoneShardB'
         Acceleration=(Z=-300.000000)
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.500000),Y=(Min=0.500000),Z=(Min=0.500000))
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=200.000000))
         Name="MeshEmitter4"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPGibBicep.MeshEmitter4'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         Acceleration=(Z=-300.000000)
         FadeOutStartTime=0.100000
         FadeOut=True
         MaxParticles=300
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-0.050000,Max=0.050000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=2.000000,Max=3.000000),Y=(Min=2.000000,Max=3.000000),Z=(Min=2.000000,Max=3.000000))
         UniformSize=True
         Sounds(0)=(Sound=Sound'DOTZXCharacters.ZombieImpactSounds.ImpactGibsSpray3',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXCharacters.ZombieImpactSounds.ImpactGibsSpray4',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=2.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=100.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Particles.BloodSpurt'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         SecondsBeforeInactive=10.000000
         LifetimeRange=(Min=0.250000,Max=0.500000)
         InitialDelayRange=(Min=0.250000,Max=0.250000)
         StartVelocityRange=(X=(Min=100.000000,Max=500.000000))
         UseVelocityScale=True
         VelocityScale(0)=(RelativeTime=1.000000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         Name="SpriteEmitter2"
     End Object
     Emitters(2)=SpriteEmitter'BBParticles.BBPGibBicep.SpriteEmitter2'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(Y=(Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=40.000000)
         StartSizeRange=(X=(Min=0.250000,Max=1.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=None
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=0.750000)
         Name="SpriteEmitter3"
     End Object
     Emitters(3)=SpriteEmitter'BBParticles.BBPGibBicep.SpriteEmitter3'
     Begin Object Class=MeshEmitter Name=MeshEmitter6
         Acceleration=(Z=-300.000000)
         MaxParticles=2
         RespawnDeadParticles=False
         AutoDestroy=True
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=-200.000000,Max=200.000000))
         Name="MeshEmitter6"
     End Object
     Emitters(4)=MeshEmitter'BBParticles.BBPGibBicep.MeshEmitter6'
     AutoDestroy=True
     bNoDelete=False
}
