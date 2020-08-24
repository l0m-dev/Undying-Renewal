//=============================================================================
// MonkSoldierSoundSet.
//=============================================================================
class MonkSoldierSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	Figure8;
var(Sounds) CreatureSoundGroup	MvmtHeavy;
var(Sounds) CreatureSoundGroup	SpKill;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	EventReload;
var(Sounds) CreatureSoundGroup	EventBurn;
var(Sounds) CreatureSoundGroup	EventPray;
var(Sounds) CreatureSoundGroup	StaffSlam;

defaultproperties
{
     Figure8=(Sound0=Sound'CreatureSFX.Monk.C_Monk_Figure801',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     MvmtHeavy=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     SpKill=(Sound0=Sound'CreatureSFX.Monk.C_Monk_SpKill',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Monks.2mon_001',Sound1=Sound'Voiceover.Monks.2mon_002',Sound2=Sound'Voiceover.Monks.2mon_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Monks.2mon_013',Sound1=Sound'Voiceover.Monks.2mon_014',Sound2=Sound'Voiceover.Monks.2mon_015',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Monks.2mon_010',Sound1=Sound'Voiceover.Monks.2mon_011',Sound2=Sound'Voiceover.Monks.2mon_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Monks.2mon_007',Sound1=Sound'Voiceover.Monks.2mon_008',Sound2=Sound'Voiceover.Monks.2mon_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventRetreat=(Sound0=Sound'Voiceover.Monks.2mon_004',Sound1=Sound'Voiceover.Monks.2mon_005',Sound2=Sound'Voiceover.Monks.2mon_006',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventTaunt=(Sound0=Sound'Voiceover.Monks.2mon_016',Sound1=Sound'Voiceover.Monks.2mon_017',Sound2=Sound'Voiceover.Monks.2mon_018',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventReload=(Sound0=Sound'Voiceover.Monks.2mon_019',Sound1=Sound'Voiceover.Monks.2mon_020',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Monks.2mon_021',Sound1=Sound'Voiceover.Monks.2mon_022',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventPray=(Sound0=Sound'Voiceover.Monks.2mon_023',Sound1=Sound'Voiceover.Monks.2mon_024',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     StaffSlam=(Sound0=Sound'CreatureSFX.DecayedSaint.C_DSaint_StaffHit01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
