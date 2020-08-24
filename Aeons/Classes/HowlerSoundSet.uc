//=============================================================================
// HowlerSoundSet.
//=============================================================================
class HowlerSoundSet expands CreatureSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Breath;
var(Sounds) CreatureSoundGroup	ClawStab;
var(Sounds) CreatureSoundGroup	Eat;
var(Sounds) CreatureSoundGroup	Howl;
var(Sounds) CreatureSoundGroup	Jump;
var(Sounds) CreatureSoundGroup	Listen1;
var(Sounds) CreatureSoundGroup	Listen2;
var(Sounds) CreatureSoundGroup	Run;
var(Sounds) CreatureSoundGroup	SpclKill;
var(Sounds) CreatureSoundGroup	StunShake;
var(Sounds) CreatureSoundGroup	VAttack;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	VPreAtk;
var(Sounds) CreatureSoundGroup	Whoosh;

defaultproperties
{
     Breath=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Breath01',NumSounds=1,Pitch=1,Volume=0.4,Radius=1)
     ClawStab=(Sound0=Sound'CreatureSFX.Howler.C_Howl_ClawStab01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     eat=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Eat01',Sound1=Sound'CreatureSFX.Howler.C_Howl_Eat02',Sound2=Sound'CreatureSFX.Howler.C_Howl_Eat03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     howl=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Howl01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=5)
     Jump=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Jump01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Listen1=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Listen01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Listen2=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Listen02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     run=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Run01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     SpclKill=(Sound0=Sound'CreatureSFX.Howler.C_Howl_SpclKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     StunShake=(Sound0=Sound'CreatureSFX.Howler.C_Howl_StunShake01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VAttack=(Sound0=Sound'CreatureSFX.Howler.C_Howl_VAttack01',Sound1=Sound'CreatureSFX.Howler.C_Howl_VAttack02',Sound2=Sound'CreatureSFX.Howler.C_Howl_VAttack03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.Howler.C_Howl_VDamage01',Sound1=Sound'CreatureSFX.Howler.C_Howl_VDamage02',Sound2=Sound'CreatureSFX.Howler.C_Howl_VDamage03',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Howler.C_Howl_VDeath01',Sound1=Sound'CreatureSFX.Howler.C_Howl_VDeath02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     VPreAtk=(Sound0=Sound'CreatureSFX.Howler.C_Howl_PreAtk01',Sound1=Sound'CreatureSFX.Howler.C_Howl_PreAtk02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     Whoosh=(Sound0=Sound'CreatureSFX.Howler.C_Howl_Whoosh01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
