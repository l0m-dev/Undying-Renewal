//=============================================================================
// MonkAbbottSoundSet.
//=============================================================================
class MonkAbbottSoundSet expands SharedHumanSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX
////#exec OBJ LOAD FILE=..\Sounds\Voiceover.uax PACKAGE=Voiceover

var(Sounds) CreatureSoundGroup	DropBook;
var(Sounds) CreatureSoundGroup	PageTurn;
var(Sounds) CreatureSoundGroup	MvmtHeavy;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	EventReload;
var(Sounds) CreatureSoundGroup	EventBurn;
var(Sounds) CreatureSoundGroup	EventPray;
/*
var(Sounds) CreatureSoundGroup	snd13;
var(Sounds) CreatureSoundGroup	snd14;
var(Sounds) CreatureSoundGroup	snd15;
var(Sounds) CreatureSoundGroup	snd16;
var(Sounds) CreatureSoundGroup	snd17;
var(Sounds) CreatureSoundGroup	snd18;
var(Sounds) CreatureSoundGroup	snd19;
var(Sounds) CreatureSoundGroup	snd20;
	snd13=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd14=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd15=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd16=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd17=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd18=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd19=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
	snd20=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.Monk.C_Monk_')
*/

defaultproperties
{
     DropBook=(Sound0=Sound'CreatureSFX.Monk.C_DropBook01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Pageturn=(Sound0=Sound'CreatureSFX.Monk.C_PageTurn01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     MvmtHeavy=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Monks.1mon_001',Sound1=Sound'Voiceover.Monks.1mon_002',Sound2=Sound'Voiceover.Monks.1mon_003',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Monks.1mon_013',Sound1=Sound'Voiceover.Monks.1mon_014',Sound2=Sound'Voiceover.Monks.1mon_015',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Monks.1mon_010',Sound1=Sound'Voiceover.Monks.1mon_011',Sound2=Sound'Voiceover.Monks.1mon_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Monks.1mon_007',Sound1=Sound'Voiceover.Monks.1mon_008',Sound2=Sound'Voiceover.Monks.1mon_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventRetreat=(Sound0=Sound'Voiceover.Monks.1mon_004',Sound1=Sound'Voiceover.Monks.1mon_005',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventTaunt=(Sound0=Sound'Voiceover.Monks.1mon_016',Sound1=Sound'Voiceover.Monks.1mon_017',Sound2=Sound'Voiceover.Monks.1mon_018',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventReload=(Sound0=Sound'Voiceover.Monks.1mon_019',Sound1=Sound'Voiceover.Monks.1mon_020',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Monks.1mon_021',Sound1=Sound'Voiceover.Monks.1mon_022',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventPray=(Sound0=Sound'Voiceover.Monks.1mon_023',Sound1=Sound'Voiceover.Monks.1mon_024',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
}
