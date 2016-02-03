class BBPWoodenDoorB3RTD extends BBPDoors;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTDPieceA'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         StartLocationOffset=(Y=-70.000000,Z=90.000000)
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
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Max=50.000000))
         Name="MeshEmitter6"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPWoodenDoorB3RTD.MeshEmitter6'
     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTDPieceB'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(X=-5.000000,Y=-39.000000,Z=80.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=60.000000))
         Name="MeshEmitter7"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPWoodenDoorB3RTD.MeshEmitter7'
     Begin Object Class=MeshEmitter Name=MeshEmitter10
         StaticMesh=StaticMesh'DOTZSObjects.Doors.WoodenDoorB3RTDPieceC'
         Acceleration=(Z=-900.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         StartLocationOffset=(X=-2.000000,Y=-58.000000,Z=35.000000)
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=200.000000))
         Name="MeshEmitter10"
     End Object
     Emitters(2)=MeshEmitter'BBParticles.BBPWoodenDoorB3RTD.MeshEmitter10'
     Begin Object Class=MeshEmitter Name=MeshEmitter8
         StaticMesh=StaticMesh'DOTZSSpecial.Particles.Woodshard'
         Acceleration=(Z=-900.000000)
         MaxParticles=15
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=-50.000000,Z=50.000000)
         StartLocationRange=(Y=(Min=-45.000000,Max=45.000000),Z=(Min=-20.000000,Max=100.000000))
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=0.100000,Max=0.300000),Y=(Min=0.100000,Max=0.300000),Z=(Min=0.100000,Max=0.300000))
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=200.000000))
         Name="MeshEmitter8"
     End Object
     Emitters(3)=MeshEmitter'BBParticles.BBPWoodenDoorB3RTD.MeshEmitter8'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         Acceleration=(Z=-100.000000)
         UseColorScale=True
         ColorScale(0)=(Color=(B=72,G=72,R=72))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeOut=True
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(Y=-50.000000,Z=50.000000)
         StartLocationRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Max=100.000000))
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
     Emitters(4)=SpriteEmitter'BBParticles.BBPWoodenDoorB3RTD.SpriteEmitter2'
     AutoDestroy=True
     bNoDelete=False
}
