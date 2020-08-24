//=============================================================================
// LizbethSoundSet.
//=============================================================================
class LizbethSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	ClawWhsh;
var(Sounds) CreatureSoundGroup	RockPU;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	EventAttack;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	Scream;
var(Sounds) CreatureSoundGroup	Laugh;
var(Sounds) CreatureSoundGroup	SPKill;
var(Sounds) CreatureSoundGroup	VAttack;
var(Sounds) CreatureSoundGroup	VEffort;

defaultproperties
{
     ClawWhsh=(Sound0=Sound'CreatureSFX.Lizbeth.C_ClawWhsh01',Sound1=Sound'CreatureSFX.Lizbeth.C_ClawWhsh02',Sound2=Sound'CreatureSFX.Lizbeth.C_ClawWhsh03',NumSounds=3,Pitch=1,Volume=1.2,Radius=1.5)
     RockPU=(Sound0=Sound'CreatureSFX.Lizbeth.C_RockPU01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Lizbeth.Liz_013',Sound1=Sound'Voiceover.Lizbeth.Liz_014',Sound2=Sound'Voiceover.Lizbeth.Liz_015',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1.2,Radius=2)
     EventAttack=(Sound0=Sound'Voiceover.Lizbeth.Liz_017',Sound1=Sound'Voiceover.Lizbeth.Liz_018',Sound2=Sound'Voiceover.Lizbeth.Liz_019',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventTaunt=(Sound0=Sound'Voiceover.Lizbeth.Liz_020',Sound1=Sound'Voiceover.Lizbeth.Liz_021',Sound2=Sound'Voiceover.Lizbeth.Liz_022',Sound3=Sound'Voiceover.Lizbeth.Liz_023',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     Scream=(Sound0=Sound'CreatureSFX.Lizbeth.C_Lizbeth_Scream1',Sound1=Sound'CreatureSFX.Lizbeth.C_Lizbeth_Scream2',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Laugh=(Sound0=Sound'CreatureSFX.Lizbeth.C_Lizbeth_Laugh1',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     SpKill=(Sound0=Sound'CreatureSFX.Lizbeth.C_Lizbeth_SpKill01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=1)
     VAttack=(Sound0=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack1',Sound1=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack2',Sound2=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack3',Sound3=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack4',Sound4=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack5',Sound5=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack7',Sound6=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack8',Sound7=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VAttack9',NumSounds=8,Pitch=1,Volume=1,Radius=1)
     VEffort=(Sound0=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VEffort1',Sound1=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VEffort2',Sound2=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VEffort4',Sound3=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VEffort5',Sound4=Sound'CreatureSFX.Lizbeth.C_Lizbeth_VEffort6',NumSounds=5,Pitch=1,Volume=1,Radius=1)
}
