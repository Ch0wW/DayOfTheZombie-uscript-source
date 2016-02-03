class BBPBoardADestructC extends BBPDestruction;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'DOTZSIndustrial.Breakable.BoardAPieceF'
         Acceleration=(Z=-1000.000000)
         UseCollision=True
         ExtentMultiplier=(X=0.250000,Y=0.250000,Z=0.750000)
         DampingFactorRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.500000))
         MaxParticles=1
         RespawnDeadParticles=False
         StartLocationOffset=(X=-20.000000,Z=-5.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         DampRotation=True
         RotationDampingFactorRange=(X=(Min=0.100000,Max=0.250000),Y=(Min=0.100000,Max=0.250000),Z=(Min=0.100000,Max=0.250000))
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=50.000000,Max=100.000000),Z=(Max=100.000000))
         Name="MeshEmitter0"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPBoardADestructC.MeshEmitter0'
     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'DOTZSIndustrial.Breakable.BoardAPieceE'
         Acceleration=(Z=-1000.000000)
         MaxParticles=5
         RespawnDeadParticles=False
         StartLocationRange=(X=(Max=-50.000000),Z=(Max=2.000000))
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         DampRotation=True
         StartSizeRange=(X=(Min=0.100000,Max=0.500000),Y=(Min=0.100000,Max=0.500000),Z=(Min=0.100000,Max=0.500000))
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Max=50.000000),Z=(Max=300.000000))
         Name="MeshEmitter1"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPBoardADestructC.MeshEmitter1'
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSIndustrial.Breakable.BoardAPieceG'
         Acceleration=(Z=-1000.000000)
         UseCollision=True
         ExtentMultiplier=(X=0.250000,Y=0.250000,Z=0.750000)
         DampingFactorRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.500000))
         MaxParticles=1
         RespawnDeadParticles=False
         StartLocationOffset=(X=-30.000000,Z=5.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         DampRotation=True
         RotationDampingFactorRange=(X=(Min=0.100000,Max=0.250000),Y=(Min=0.100000,Max=0.250000),Z=(Min=0.100000,Max=0.250000))
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=50.000000,Max=100.000000),Z=(Max=100.000000))
         Name="MeshEmitter2"
     End Object
     Emitters(2)=MeshEmitter'BBParticles.BBPBoardADestructC.MeshEmitter2'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
     Tag="BBPBoardADestructC"
}
