//=============================================================================
// AmbroseSoundSet.
//=============================================================================
class AmbroseSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	AxeWhshGnt;
var(Sounds) CreatureSoundGroup	AxeHitGnt;
var(Sounds) CreatureSoundGroup	BSpin;
var(Sounds) CreatureSoundGroup	GrowA;
var(Sounds) CreatureSoundGroup	GrowB;
var(Sounds) CreatureSoundGroup	GrowC;
var(Sounds) CreatureSoundGroup	AxeWhsh;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VEffortA;
var(Sounds) CreatureSoundGroup	VEffortB;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAttack;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	Stone;
var(Sounds) CreatureSoundGroup	GrabA;
var(Sounds) CreatureSoundGroup	GrabB;
var(Sounds) CreatureSoundGroup	SPKill;
var(Sounds) CreatureSoundGroup	VTaunt;
var(Sounds) CreatureSoundGroup	GiantFS;
var(Sounds) CreatureSoundGroup	GiantFSLand;
var(Sounds) CreatureSoundGroup	GiantFSScuff;

defaultproperties
{
     AxeWhshGnt=(Sound0=Sound'CreatureSFX.Ambrose.C_AxeWhshGnt01',Sound1=Sound'CreatureSFX.Ambrose.C_AxeWhshGnt02',Sound2=Sound'CreatureSFX.Ambrose.C_AxeWhshGnt03',NumSounds=3,Pitch=1,Volume=1,Radius=1.5)
     AxeHitGnt=(Sound0=Sound'CreatureSFX.Ambrose.C_AxeHitGnt01',NumSounds=1,Pitch=1,Volume=1,Radius=1.5)
     bSpin=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_Bspin01',NumSounds=1,Pitch=1,Volume=1,Radius=1.5)
     GrowA=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_Grow1',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     GrowB=(Pitch=1,Volume=1,Radius=2)
     GrowC=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_Shrink1',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     AxeWhsh=(Sound0=Sound'CreatureSFX.Ambrose.C_AxeWhsh01',Sound1=Sound'CreatureSFX.Ambrose.C_AxeWhsh02',Sound2=Sound'CreatureSFX.Ambrose.C_AxeWhsh03',NumSounds=3,Pitch=1,Volume=1,Radius=1.5)
     VDamage=(Sound0=Sound'Voiceover.Ambrose.Amb_013',Sound1=Sound'Voiceover.Ambrose.Amb_014',Sound2=Sound'Voiceover.Ambrose.Amb_015',Sound3=Sound'CreatureSFX.Ambrose.C_Ambrose_Damage1',Sound4=Sound'CreatureSFX.Ambrose.C_Ambrose_Damage2',Sound5=Sound'CreatureSFX.Ambrose.C_Ambrose_Damage3',NumSounds=6,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1.5)
     VEffortA=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_VAttack1',Sound1=Sound'CreatureSFX.Ambrose.C_Ambrose_VAttack2',Sound2=Sound'CreatureSFX.Ambrose.C_Ambrose_VAttack3',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1.5)
     VEffortB=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_VBreath1',Sound1=Sound'CreatureSFX.Ambrose.C_Ambrose_VBreath2',Sound2=Sound'CreatureSFX.Ambrose.C_Ambrose_VBreath3',Sound3=Sound'CreatureSFX.Ambrose.C_Ambrose_VBreath4',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1.5)
     EventIdle=(Sound0=Sound'Voiceover.Ambrose.Amb_016',Sound1=Sound'Voiceover.Ambrose.Amb_017',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventAttack=(Sound0=Sound'Voiceover.Ambrose.Amb_019',Sound1=Sound'Voiceover.Ambrose.Amb_020',Sound2=Sound'Voiceover.Ambrose.Amb_021',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventTaunt=(Sound0=Sound'Voiceover.Ambrose.Amb_022',Sound1=Sound'Voiceover.Ambrose.Amb_023',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Stone=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_Stone1',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=2)
     GrabA=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_VShake1',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1.5)
     GrabB=(slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1.5)
     SpKill=(Sound0=Sound'CreatureSFX.Ambrose.C_Ambrose_SpKill01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=1)
     VTaunt=(Sound0=Sound'Voiceover.Ambrose.Amb_020',Sound1=Sound'Voiceover.Ambrose.Amb_021',Sound2=Sound'Voiceover.Ambrose.Amb_022',Sound3=Sound'Voiceover.Ambrose.Amb_023',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     GiantFSLand=(Sound0=Sound'Footsteps.Giant.C_GiantFS_Land',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     GiantFSScuff=(Sound0=Sound'Footsteps.Giant.C_GiantFS_Scuff',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
