// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class BodyBag extends AdvancedActor
placeable;

var(Events) editconst Name hAnim1;
var(Events) editconst name hAnim2;
var(Events) editconst name hAnim3;
var(Events) editconst name hAnim4;
var(Events) editconst name hActivate;

var() name Anim1;
var() name Anim2;
var() name Anim3;
var() name Anim4;

var() array<sound> DeathSounds;
var() array<sound> PainSounds;

var() int Health;
var class<emitter> DamageEmitter;

const ACTIVATETIMER = 33;

/*****************************************************************
 * TakeDamage
 *****************************************************************
 */
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                     Vector momentum, class<DamageType> damageType){

    if (Health <= 0){
        return;
    }

    super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

    PlaySound(PainSounds[int(Frand() * PainSounds.length)]);
    Spawn(DamageEmitter,,,Hitlocation);
    Activate();

    Health = Health-Damage;

    if (Health <= 0){
        Die();
    }

}

/*****************************************************************
 * Die
 * Do some stuff when you die
 *****************************************************************
 */
function Die(){
    PlaySound(DeathSounds[int(Frand() * DeathSounds.length)]);
    SetMultiTimer(ACTIVATETIMER, 0, false);
}

/*****************************************************************
 * Activate
 * Turn on this body bag and wiggle everyonce and a while
 *****************************************************************
 */
function Activate(){

    local name TheAnim;
    local int delay;

    switch( int(Frand()* 3)){
        case 0:
            TheAnim = Anim1;
            break;
        case 1:
            TheAnim = Anim2;
            break;
        case 2:
            TheAnim = Anim3;
            break;
        case 3:
            TheAnim = Anim4;
            break;
    }

    PlayAnim(TheAnim);

    if (Health > 0){
        delay = 2 + (Frand() * 5);
        //log(delay);
        SetMultiTimer(ACTIVATETIMER, delay, false);
    }
}

/*****************************************************************
 * MultiTimer
 * Drives the wiggling
 *****************************************************************
 */
function MultiTimer(int ID){
    super.MultiTimer(ID);
    switch(ID){
        case ACTIVATETIMER:
            Activate();
            break;
    }
}


/*****************************************************************
 * TriggerEx
 *****************************************************************
 */
function TriggerEx(Actor Other, Pawn EventInstigator, Name Handler){

    if (Health <=0){
        return;
    }

    switch(handler){
        case hActivate:
            Activate();
            break;
        case hAnim1:
            PlayAnim(Anim1);
            break;
        case hAnim2:
            PlayAnim(Anim2);
            break;
        case hAnim3:
            PlayAnim(Anim3);
            break;
        case hAnim4:
            PlayAnim(Anim4);
            break;
    }
}

defaultproperties
{
     hAnim1="Anim1"
     hAnim2="Anim2"
     hAnim3="Anim3"
     hAnim4="Anim4"
     hActivate="Activate"
     Anim1="WiggleA"
     Anim2="WiggleB"
     Anim3="WiggleC"
     Anim4="WiggleD"
     DeathSounds(0)=Sound'DOTZXCharacters.ZombieDeathSounds.DeathMale01'
     DeathSounds(1)=Sound'DOTZXCharacters.ZombieDeathSounds.DeathMale02'
     PainSounds(0)=Sound'DOTZXCharacters.ZombiePainSounds.PainMale01'
     PainSounds(1)=Sound'DOTZXCharacters.ZombiePainSounds.PainMale02'
     PainSounds(2)=Sound'DOTZXCharacters.ZombiePainSounds.PainMale03'
     PainSounds(3)=Sound'DOTZXCharacters.ZombiePainSounds.PainMale04'
     PainSounds(4)=Sound'DOTZXCharacters.ZombiePainSounds.PainMale05'
     PainSounds(5)=Sound'DOTZXCharacters.ZombiePainSounds.PainMale06'
     Health=100
     DamageEmitter=Class'BBParticles.BBPBlood'
     DrawType=DT_Mesh
     bHasHandlers=True
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bUseCylinderCollision=True
     Mesh=SkeletalMesh'DOTZACharacters.SquirmingBodyBag'
     CollisionRadius=50.000000
     CollisionHeight=20.000000
}
