//=============================================================================
// MaidSoundSet.
//=============================================================================
class MaidSoundSet expands SharedHumanSoundSet;

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

	snd19=(Radius=1.0,NumSounds=1,Slot=SLOT_Misc,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'Voiceover.Maids.SMAI_')
	snd20=(Radius=1.0,NumSounds=1,Slot=SLOT_Misc,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'Voiceover.Maids.SMAI_')
*/

defaultproperties
{
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Maids.Smai_001',Sound1=Sound'Voiceover.Maids.Smai_002',Sound2=Sound'Voiceover.Maids.Smai_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Maids.Smai_011',Sound1=Sound'Voiceover.Maids.Smai_012',Sound2=Sound'Voiceover.Maids.Smai_013',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Maids.Smai_014',Sound1=Sound'Voiceover.Maids.Smai_015',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Maids.Smai_007',Sound1=Sound'Voiceover.Maids.Smai_008',Sound2=Sound'Voiceover.Maids.Smai_009',Sound3=Sound'Voiceover.Maids.Smai_010',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventRetreat=(Sound0=Sound'Voiceover.Maids.Smai_004',Sound1=Sound'Voiceover.Maids.Smai_005',Sound2=Sound'Voiceover.Maids.Smai_006',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Maids.Smai_016',Sound1=Sound'Voiceover.Maids.Smai_017',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
}
