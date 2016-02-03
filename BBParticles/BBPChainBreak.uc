class BBPChainBreak extends BBPDestruction;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSObjects.Keys.Chainlink'
         Acceleration=(Z=-1000.000000)
         MaxParticles=14
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Z=(Min=10.000000,Max=50.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Max=150.000000),Z=(Max=300.000000))
         Name="MeshEmitter2"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPChainBreak.MeshEmitter2'
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSObjects.Keys.Lock'
         Acceleration=(Z=-1000.000000)
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         Name="MeshEmitter4"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPChainBreak.MeshEmitter4'
     AutoDestroy=True
     bNoDelete=False
}
