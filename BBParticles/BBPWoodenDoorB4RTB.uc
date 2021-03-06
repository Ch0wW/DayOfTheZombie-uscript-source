class BBPWoodenDoorB4RTB extends BBPDoors;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB4RTBPieceA'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=-40.000000,Z=155.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         Sounds(0)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood1',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(1)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood2',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(2)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood3',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         Sounds(3)=(Sound=Sound'DOTZXDestruction.Destructables.DestructablesWood4',Radius=(Min=200.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=99999997952.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=50.000000))
         Name="MeshEmitter6"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPWoodenDoorB4RTB.MeshEmitter6'
     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB4RTBPieceB'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=-91.000000,Z=145.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=50.000000))
         Name="MeshEmitter7"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPWoodenDoorB4RTB.MeshEmitter7'
     Begin Object Class=MeshEmitter Name=MeshEmitter8
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Woodshard'
         Acceleration=(Z=-900.000000)
         MaxParticles=15
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=-50.000000,Z=145.000000)
         StartLocationRange=(Y=(Min=-45.000000,Max=45.000000),Z=(Max=50.000000))
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.100000,Max=0.300000),Y=(Min=0.100000,Max=0.300000),Z=(Min=0.100000,Max=0.300000))
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=200.000000))
         Name="MeshEmitter8"
     End Object
     Emitters(2)=MeshEmitter'BBParticles.BBPWoodenDoorB4RTB.MeshEmitter8'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         Acceleration=(Z=-100.000000)
         UseColorScale=True
         ColorScale(0)=(Color=(B=72,G=72,R=72))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeOut=True
         MaxParticles=6
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=-50.000000,Z=140.000000)
         StartLocationRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Max=50.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         Texture=Texture'SpecialFX.Particles.dust2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=2.000000,Max=2.000000)
         Name="SpriteEmitter2"
     End Object
     Emitters(3)=SpriteEmitter'BBParticles.BBPWoodenDoorB4RTB.SpriteEmitter2'
     AutoDestroy=True
     bNoDelete=False
}
