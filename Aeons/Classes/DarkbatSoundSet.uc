//=============================================================================
// DarkbatSoundSet.
//=============================================================================
class DarkbatSoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Alert;
var(Sounds) CreatureSoundGroup	Atk;
var(Sounds) CreatureSoundGroup	Dive;
var(Sounds) CreatureSoundGroup	Hunt;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Wake;
var(Sounds) CreatureSoundGroup	WingFlap;

defaultproperties
{
     Alert=(Sound0=Sound'CreatureSFX.Bat.C_Bat_Alert01',Sound1=Sound'CreatureSFX.Bat.C_Bat_Alert02',Sound2=Sound'CreatureSFX.Bat.C_Bat_Alert03',NumSounds=3,Pitch=1,Volume=1,Radius=2)
     Atk=(Sound0=Sound'CreatureSFX.Bat.C_Bat_Atk01',Sound1=Sound'CreatureSFX.Bat.C_Bat_Atk02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Dive=(Sound0=Sound'CreatureSFX.Bat.C_Bat_Dive01',Sound1=Sound'CreatureSFX.Bat.C_Bat_Dive02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     hunt=(Sound0=Sound'CreatureSFX.Bat.C_Bat_Hunt01',Sound1=Sound'CreatureSFX.Bat.C_Bat_Hunt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.Bat.C_Bat_VDamage01',Sound1=Sound'CreatureSFX.Bat.C_Bat_VDamage02',NumSounds=2,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Bat.C_Bat_VDeath01',Sound1=Sound'CreatureSFX.Bat.C_Bat_VDeath02',Sound2=Sound'CreatureSFX.Bat.C_Bat_VDeath03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Wake=(Sound0=Sound'CreatureSFX.Bat.C_Bat_Wake01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     WingFlap=(Sound0=Sound'CreatureSFX.Bat.C_Bat_WingFlap01',Sound1=Sound'CreatureSFX.Bat.C_Bat_WingFlap02',Sound2=Sound'CreatureSFX.Bat.C_Bat_WingFlap03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
}
