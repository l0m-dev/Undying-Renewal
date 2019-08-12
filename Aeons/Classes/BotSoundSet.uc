//=============================================================================
// BotSoundSet.
//=============================================================================
class BotSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	SwordWhsh;
var(Sounds) CreatureSoundGroup	SpKill;
var(Sounds) CreatureSoundGroup	SpKillTaunt;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	EventReload;
var(Sounds) CreatureSoundGroup	EventBurn;
var(Sounds) CreatureSoundGroup	GoreImpact;
var(Sounds) CreatureSoundGroup	WpnImpact;

var(Sounds) CreatureSoundGroup	ShieldUp;
var(Sounds) CreatureSoundGroup	ShieldDn;
var(Sounds) CreatureSoundGroup	ShieldHit;
var(Sounds) CreatureSoundGroup	VEffort;

defaultproperties
{
     SwordWhsh=(Sound0=Sound'CreatureSFX.Trsanti.C_SwordWhsh01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     SpKill=(Sound0=Sound'CreatureSFX.Trsanti.C_TrsantiG_SpKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     SpKillTaunt=(Sound0=Sound'Voiceover.Trsanti.1trs_016',Sound1=Sound'Voiceover.Trsanti.1trs_017',Sound2=Sound'Voiceover.Trsanti.1trs_018',Sound3=Sound'Voiceover.Trsanti.2trs_016',Sound4=Sound'Voiceover.Trsanti.2trs_017',Sound5=Sound'Voiceover.Trsanti.2trs_018',NumSounds=6,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Taunt=(Sound0=Sound'CreatureSFX.Trsanti.C_Trsanti_Taunt01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Trsanti.1trs_001',Sound1=Sound'Voiceover.Trsanti.1trs_002',Sound2=Sound'Voiceover.Trsanti.1trs_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Trsanti.1trs_013',Sound1=Sound'Voiceover.Trsanti.1trs_014',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Trsanti.1trs_007',Sound1=Sound'Voiceover.Trsanti.1trs_008',Sound2=Sound'Voiceover.Trsanti.1trs_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Trsanti.1trs_010',Sound1=Sound'Voiceover.Trsanti.1trs_011',Sound2=Sound'Voiceover.Trsanti.1trs_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventRetreat=(Sound0=Sound'Voiceover.Trsanti.1trs_004',Sound1=Sound'Voiceover.Trsanti.1trs_005',Sound2=Sound'Voiceover.Trsanti.1trs_006',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventTaunt=(Sound0=Sound'Voiceover.Trsanti.1trs_016',Sound1=Sound'Voiceover.Trsanti.1trs_017',Sound2=Sound'Voiceover.Trsanti.1trs_018',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventReload=(Sound0=Sound'Voiceover.Trsanti.1trs_019',Sound1=Sound'Voiceover.Trsanti.1trs_020',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventBurn=(Sound0=Sound'Voiceover.Trsanti.1trs_021',Sound1=Sound'Voiceover.Trsanti.1trs_022',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     GoreImpact=(Sound0=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet01',Sound1=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     WpnImpact=(Sound0=Sound'Impacts.WpnSplSpecific.E_Wpn_ShotHit01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     
	 ShieldUp=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldLaunch01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ShieldDn=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDestroy01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ShieldHit=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDeflect01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VEffort=(Sound0=Sound'CreatureSFX.Trsanti.C_Witch_VEffort1',Sound1=Sound'CreatureSFX.Trsanti.C_Witch_VEffort2',Sound2=Sound'CreatureSFX.Trsanti.C_Witch_VEffort3',Sound3=Sound'CreatureSFX.Trsanti.C_Witch_VEffort4',Sound4=Sound'CreatureSFX.Trsanti.C_Witch_VEffort5',Sound5=Sound'CreatureSFX.Trsanti.C_Witch_VEffort6',Sound6=Sound'CreatureSFX.Trsanti.C_Witch_VEffort7',Sound7=Sound'CreatureSFX.Trsanti.C_Witch_VEffort8',NumSounds=8,Pitch=1,Volume=1,Radius=1)
}
