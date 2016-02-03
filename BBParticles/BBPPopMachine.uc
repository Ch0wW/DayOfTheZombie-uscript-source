class BBPPopMachine extends BBPEnvironmental;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'DOTZSObjects.Decoration.SodaCan'
         Acceleration=(Z=-900.000000)
         UseCollision=True
         DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.250000,Max=0.500000))
         MaxParticles=1
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationOffset=(X=-20.000000,Y=-20.000000,Z=40.000000)
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.250000))
         Sounds(0)=(Sound=Sound'DOTZXActionObjects.SodaMachine.SodaMachineCanImpact',Radius=(Min=300.000000,Max=300.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_Random
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=20.000000,Max=20.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-240.000000,Max=-195.000000),Z=(Max=10.000000))
         Name="MeshEmitter2"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPPopMachine.MeshEmitter2'
     AutoDestroy=True
     bNoDelete=False
}
