//=============================================================================
// VeragoSoundSet.
//=============================================================================
class VeragoSoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Chant;
var(Sounds) CreatureSoundGroup	SpKill;
var(Sounds) CreatureSoundGroup	Suicide;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	Tele;
var(Sounds) CreatureSoundGroup	Whisper;
var(Sounds) CreatureSoundGroup	Wind;
var(Sounds) CreatureSoundGroup	Teleport;

defaultproperties
{
     Chant=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Chant01',Sound1=Sound'CreatureSFX.Chanter.C_Chanter_Chant02',Sound2=Sound'CreatureSFX.Chanter.C_Chanter_Chant03',Sound3=Sound'CreatureSFX.Chanter.C_Chanter_Chant04',Sound4=Sound'CreatureSFX.Chanter.C_Chanter_Chant05',Sound5=Sound'CreatureSFX.Chanter.C_Chanter_Chant06',NumSounds=6,slot=SLOT_Talk,Pitch=0.85,Volume=1.2,Radius=1)
     SpKill=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_SpKill01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=1)
     Suicide=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Suicide01',NumSounds=1,Pitch=1,Volume=2,Radius=2)
     VDamage=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Take',NumSounds=1,slot=SLOT_Pain,Pitch=1,Volume=1.2,Radius=1.5)
     Tele=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Tele01',Sound1=Sound'CreatureSFX.Chanter.C_Chanter_Tele02',Sound2=Sound'CreatureSFX.Chanter.C_Chanter_Tele03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=2.5)
     Whisper=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Whisper01',Sound1=Sound'CreatureSFX.Chanter.C_Chanter_Whisper02',Sound2=Sound'CreatureSFX.Chanter.C_Chanter_Whisper03',NumSounds=3,Pitch=0.9,Volume=1,Radius=1)
     Wind=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Wind01',Sound1=Sound'CreatureSFX.Chanter.C_Chanter_Wind02',Sound2=Sound'CreatureSFX.Chanter.C_Chanter_Wind03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     Teleport=(Sound0=Sound'CreatureSFX.Chanter.C_Chanter_Transport1',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=1)
}
