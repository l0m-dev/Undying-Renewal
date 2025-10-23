//=============================================================================
// ChunkyMaidSoundSet.
//=============================================================================
class ChunkyMaidSoundSet expands SharedHumanSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX
////#exec OBJ LOAD FILE=..\Sounds\Voiceover.uax PACKAGE=Voiceover

var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventBurn;
/*
var(Sounds) CreatureSoundGroup	snd19;
var(Sounds) CreatureSoundGroup	snd20;
	snd19=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'Voiceover.Maids.FMAI_')
	snd20=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'Voiceover.Maids.FMAI_')
*/

defaultproperties
{
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Maids.Fmai_001',Sound1=Sound'Voiceover.Maids.Fmai_002',Sound2=Sound'Voiceover.Maids.Fmai_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Maids.Fmai_010',Sound1=Sound'Voiceover.Maids.Fmai_011',Sound2=Sound'Voiceover.Maids.Fmai_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Maids.Fmai_013',Sound1=Sound'Voiceover.Maids.Fmai_014',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=0.75)
     EventAlert=(Sound0=Sound'Voiceover.Maids.Fmai_007',Sound1=Sound'Voiceover.Maids.Fmai_008',Sound2=Sound'Voiceover.Maids.Fmai_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventRetreat=(Sound0=Sound'Voiceover.Maids.Fmai_004',Sound1=Sound'Voiceover.Maids.Fmai_005',Sound2=Sound'Voiceover.Maids.Fmai_006',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Maids.Fmai_015',Sound1=Sound'Voiceover.Maids.Fmai_016',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
}
