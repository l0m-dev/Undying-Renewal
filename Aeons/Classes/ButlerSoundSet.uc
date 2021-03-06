//=============================================================================
// ButlerSoundSet.
//=============================================================================
class ButlerSoundSet expands SharedHumanSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX
//#exec OBJ LOAD FILE=\Aeons\Sounds\Voiceover.uax PACKAGE=Voiceover

var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventBurn;
var(Sounds) CreatureSoundGroup	EventScream;
/*
var(Sounds) CreatureSoundGroup	snd13;
var(Sounds) CreatureSoundGroup	snd14;
var(Sounds) CreatureSoundGroup	snd15;
var(Sounds) CreatureSoundGroup	snd16;
var(Sounds) CreatureSoundGroup	snd17;
var(Sounds) CreatureSoundGroup	snd18;
var(Sounds) CreatureSoundGroup	snd19;
var(Sounds) CreatureSoundGroup	snd20;
*/

/*
	snd13=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd14=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd15=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd16=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd17=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd18=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd19=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
	snd20=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Lizbeth.C_')
*/

defaultproperties
{
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Butlers.NMBUT_001',Sound1=Sound'Voiceover.Butlers.NMBUT_002',Sound2=Sound'Voiceover.Butlers.NMBUT_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Butlers.NMBUT_010',Sound1=Sound'Voiceover.Butlers.NMBUT_011',Sound2=Sound'Voiceover.Butlers.NMBUT_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Butlers.NMBUT_013',Sound1=Sound'Voiceover.Butlers.NMBUT_014',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Butlers.NMBUT_007',Sound1=Sound'Voiceover.Butlers.NMBUT_008',Sound2=Sound'Voiceover.Butlers.NMBUT_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventRetreat=(Sound0=Sound'Voiceover.Butlers.NMBUT_004',Sound1=Sound'Voiceover.Butlers.NMBUT_005',Sound2=Sound'Voiceover.Butlers.NMBUT_006',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Butlers.NMBUT_015',Sound1=Sound'Voiceover.Butlers.NMBUT_016',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventScream=(Sound0=Sound'Voiceover.Butlers.NMBUT_017',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
}
