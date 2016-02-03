class BBPWoodenDoor1LTB extends BBPDoors;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoor1LTBPieceA'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(X=5.000000,Y=63.000000,Z=168.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood1',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood2',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood3',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood4',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Max=20.000000))
         Name="MeshEmitter1"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPWoodenDoor1LTB.MeshEmitter1'
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoor1LTBPieceB'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(X=3.000000,Y=74.000000,Z=145.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=20.000000))
         Name="MeshEmitter0"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPWoodenDoor1LTB.MeshEmitter0'
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Woodshard'
         Acceleration=(Z=-900.000000)
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=60.000000,Z=150.000000)
         StartLocationRange=(Y=(Min=-30.000000,Max=30.000000),Z=(Min=-40.000000,Max=40.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.100000,Max=0.250000),Y=(Min=0.100000,Max=0.250000),Z=(Min=0.100000,Max=0.250000))
         InitialParticlesPerSecond=10000000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=100.000000))
         Name="MeshEmitter2"
     End Object
     Emitters(2)=MeshEmitter'BBParticles.BBPWoodenDoor1LTB.MeshEmitter2'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         Acceleration=(Z=-50.000000)
         UseColorScale=True
         ColorScale(0)=(Color=(B=79,G=79,R=79))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeOut=True
         MaxParticles=8
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=60.000000,Z=160.000000)
         StartLocationRange=(Y=(Min=-40.000000,Max=40.000000),Z=(Min=-40.000000,Max=40.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.010000,Max=0.010000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=50.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Particles.dust2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         StartVelocityRange=(X=(Min=-60.000000,Max=60.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=10.000000,Max=10.000000))
         Name="SpriteEmitter0"
     End Object
     Emitters(3)=SpriteEmitter'BBParticles.BBPWoodenDoor1LTB.SpriteEmitter0'
     AutoDestroy=True
     bNoDelete=False
}
