//=============================================================================
// TrsantiLtSoundSet.
//=============================================================================
class TrsantiLtSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	DaggerWhsh;
var(Sounds) CreatureSoundGroup	DaggerDraw;
var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	EventReload;
var(Sounds) CreatureSoundGroup	EventBurn;
var(Sounds) CreatureSoundGroup	SpKill;
var(Sounds) CreatureSoundGroup	SpKillTaunt;
var(Sounds) CreatureSoundGroup	Reload1;
var(Sounds) CreatureSoundGroup	Reload2;
var(Sounds) CreatureSoundGroup	Reload3;
var(Sounds) CreatureSoundGroup	DrawShotgun;
var(Sounds) CreatureSoundGroup	GoreImpact;
var(Sounds) CreatureSoundGroup	WpnImpact;

defaultproperties
{
     DaggerWhsh=(Sound0=Sound'CreatureSFX.Trsanti.C_DaggerWhsh01',Sound1=Sound'CreatureSFX.Trsanti.C_DaggerWhsh02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     DaggerDraw=(Sound0=Sound'CreatureSFX.Trsanti.C_DaggerDraw01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Trsanti.1trs_001',Sound1=Sound'Voiceover.Trsanti.1trs_002',Sound2=Sound'Voiceover.Trsanti.1trs_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Trsanti.2trs_013',Sound1=Sound'Voiceover.Trsanti.2trs_014',Sound2=Sound'Voiceover.Trsanti.2trs_015',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Trsanti.2trs_007',Sound1=Sound'Voiceover.Trsanti.2trs_008',Sound2=Sound'Voiceover.Trsanti.2trs_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventIdle=(Sound0=Sound'Voiceover.Trsanti.2trs_010',Sound1=Sound'Voiceover.Trsanti.2trs_011',Sound2=Sound'Voiceover.Trsanti.2trs_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventRetreat=(Sound0=Sound'Voiceover.Trsanti.2trs_004',Sound1=Sound'Voiceover.Trsanti.2trs_005',Sound2=Sound'Voiceover.Trsanti.2trs_006',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventTaunt=(Sound0=Sound'Voiceover.Trsanti.2trs_016',Sound1=Sound'Voiceover.Trsanti.2trs_017',Sound2=Sound'Voiceover.Trsanti.2trs_018',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventReload=(Sound0=Sound'Voiceover.Trsanti.2trs_019',Sound1=Sound'Voiceover.Trsanti.2trs_020',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventBurn=(Sound0=Sound'Voiceover.Trsanti.2trs_022',Sound1=Sound'Voiceover.Trsanti.2trs_022',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpKill=(Sound0=Sound'CreatureSFX.Trsanti.C_TrsantiLt_SpKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     SpKillTaunt=(Sound0=Sound'Voiceover.Trsanti.1trs_016',Sound1=Sound'Voiceover.Trsanti.1trs_017',Sound2=Sound'Voiceover.Trsanti.1trs_018',Sound3=Sound'Voiceover.Trsanti.2trs_016',Sound4=Sound'Voiceover.Trsanti.2trs_017',Sound5=Sound'Voiceover.Trsanti.2trs_018',NumSounds=6,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Reload1=(Sound0=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotOpen01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Reload2=(Sound0=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotLoadReg03',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Reload3=(Sound0=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotClose01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     DrawShotgun=(Sound0=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotPU1',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     GoreImpact=(Sound0=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice01',Sound1=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     WpnImpact=(Sound0=Sound'Impacts.WpnSplSpecific.E_Wpn_DaggerHit01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
