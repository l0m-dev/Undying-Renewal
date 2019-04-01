//=============================================================================
// DecayedSaintSoundSet.
//=============================================================================
class DecayedSaintSoundSet expands SharedHumanSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Flesh;
var(Sounds) CreatureSoundGroup	Flesh3;
var(Sounds) CreatureSoundGroup	Heartbeat;
var(Sounds) CreatureSoundGroup	Impact;
var(Sounds) CreatureSoundGroup	Mvmt;
var(Sounds) CreatureSoundGroup	TauntH;
var(Sounds) CreatureSoundGroup	TauntS;
var(Sounds) CreatureSoundGroup	VAttack;
var(Sounds) CreatureSoundGroup	VChomp;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	VEffort;
var(Sounds) CreatureSoundGroup	VShake;
var(Sounds) CreatureSoundGroup	Whoosh;
var(Sounds) CreatureSoundGroup	SPKill;
var(Sounds) CreatureSoundGroup	Appear;

defaultproperties
{
     Flesh=(NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Flesh3=(NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Heartbeat=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_Heartbeat01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Impact=(Sound0=Sound'CreatureSFX.DecayedSaint.C_ImpBone01',Sound1=Sound'CreatureSFX.DecayedSaint.C_ImpBone02',Sound2=Sound'CreatureSFX.DecayedSaint.C_ImpBone03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     Mvmt=(Sound0=Sound'CreatureSFX.DecayedSaint.C_BoneMvmt01',Sound1=Sound'CreatureSFX.DecayedSaint.C_BoneMvmt02',Sound2=Sound'CreatureSFX.DecayedSaint.C_BoneMvmt03',Sound3=Sound'CreatureSFX.DecayedSaint.C_BoneMvmt04',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     TauntH=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_TauntH01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     TauntS=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_TauntS01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     VAttack=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_VAttack01',Sound1=Sound'CreatureSFX.DecayedSaint.C_DSaint_VAttack02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VChomp=(NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDamage01',Sound1=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDamage02',Sound2=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDamage03',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDeath01',Sound1=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDeath02',Sound2=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDeath03',Sound3=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDeath04',Sound4=Sound'CreatureSFX.DecayedSaint.C_DSaint_VDeath05',NumSounds=5,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     VEffort=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_VEffort01',Sound1=Sound'CreatureSFX.DecayedSaint.C_DSaint_VEffort02',Sound2=Sound'CreatureSFX.DecayedSaint.C_DSaint_VEffort03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     VShake=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_VShake01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     Whoosh=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_Whoosh01',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     SpKill=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_SpKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Appear=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_Appear1',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
