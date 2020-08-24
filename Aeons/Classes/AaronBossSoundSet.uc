//=============================================================================
// AaronBossSoundSet.
//=============================================================================
class AaronBossSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	ChainMvmtA;
var(Sounds) CreatureSoundGroup	ChainMvmtB;
var(Sounds) CreatureSoundGroup	ChainMvmtC;
var(Sounds) CreatureSoundGroup	HookWhshA;
var(Sounds) CreatureSoundGroup	HookWhshB;
var(Sounds) CreatureSoundGroup	ChainWhipA;
var(Sounds) CreatureSoundGroup	ChainWhipB;
var(Sounds) CreatureSoundGroup	ChainPullA;
var(Sounds) CreatureSoundGroup	ChainThrowA;
var(Sounds) CreatureSoundGroup	VAttack;
var(Sounds) CreatureSoundGroup	VEffort;
var(Sounds) CreatureSoundGroup	StumpFS;
var(Sounds) CreatureSoundGroup	ForceBlast;
var(Sounds) CreatureSoundGroup	SpKill;
var(Sounds) CreatureSoundGroup	VTaunt;
var(Sounds) CreatureSoundGroup	ChainHitWood;
var(Sounds) CreatureSoundGroup	ChainHitStone;

defaultproperties
{
     ChainMvmtA=(Sound0=Sound'CreatureSFX.Aaron.C_ChainMvmt101',Sound1=Sound'CreatureSFX.Aaron.C_ChainMvmt102',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     ChainMvmtB=(Sound0=Sound'CreatureSFX.Aaron.C_ChainMvmt201',Sound1=Sound'CreatureSFX.Aaron.C_ChainMvmt202',Sound2=Sound'CreatureSFX.Aaron.C_ChainMvmt203',Sound3=Sound'CreatureSFX.Aaron.C_ChainMvmt204',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     ChainMvmtC=(Sound0=Sound'CreatureSFX.Aaron.C_ChainMvmt203',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     HookWhshA=(Sound0=Sound'CreatureSFX.Aaron.C_HookWhsh01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     HookWhshB=(Sound0=Sound'CreatureSFX.Aaron.C_HookWhsh02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ChainWhipA=(Sound0=Sound'CreatureSFX.Aaron.C_ChainWhip01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ChainWhipB=(Sound0=Sound'CreatureSFX.Aaron.C_ChainWhip02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ChainPullA=(Sound0=Sound'CreatureSFX.Aaron.C_ChainPull01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ChainThrowA=(Sound0=Sound'CreatureSFX.Aaron.C_ChainThrow01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VAttack=(Sound0=Sound'CreatureSFX.Aaron.C_Aaron_VAttack1',Sound1=Sound'CreatureSFX.Aaron.C_Aaron_VAttack2',Sound2=Sound'CreatureSFX.Aaron.C_Aaron_VAttack3',Sound3=Sound'CreatureSFX.Aaron.C_Aaron_VAttack4',Sound4=Sound'CreatureSFX.Aaron.C_Aaron_VAttack5',Sound5=Sound'CreatureSFX.Aaron.C_Aaron_VAttack6',NumSounds=6,Pitch=1,Volume=1,Radius=1.5)
     VEffort=(Sound0=Sound'CreatureSFX.Aaron.C_Aaron_VEffort1',Sound1=Sound'CreatureSFX.Aaron.C_Aaron_VEffort2',Sound2=Sound'CreatureSFX.Aaron.C_Aaron_VEffort3',Sound3=Sound'CreatureSFX.Aaron.C_Aaron_VEffort4',NumSounds=4,Pitch=1,Volume=1,Radius=1.5)
     StumpFS=(Sound0=Sound'CreatureSFX.Aaron.C_StumpFS01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     forceblast=(Sound0=Sound'LevelMechanics.Manor.E04_ForceBlast1',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     SpKill=(Sound0=Sound'CreatureSFX.Aaron.C_Aaron_SpKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VTaunt=(Sound0=Sound'Voiceover.Aaron.Aar_023',Sound1=Sound'Voiceover.Aaron.Aar_024',Sound2=Sound'Voiceover.Aaron.Aar_025',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     ChainHitWood=(Sound0=Sound'Impacts.SurfaceSpecific.E_Wpn_SpearHitRico01',Sound1=Sound'Impacts.SurfaceSpecific.E_Wpn_SpearHitRico02',Sound2=Sound'Impacts.SurfaceSpecific.E_Wpn_SpearHitRico03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     ChainHitStone=(Sound0=Sound'Impacts.SurfaceSpecific.E_Imp_Metal01',Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Metal02',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Metal03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
}
