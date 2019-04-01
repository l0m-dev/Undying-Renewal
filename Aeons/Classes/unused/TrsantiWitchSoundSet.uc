//=============================================================================
// TrsantiWitchSoundSet.
//=============================================================================
class TrsantiWitchSoundSet expands SharedHumanSoundSet;


var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	EventBurn;
var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	WitchMvmt;
var(Sounds) CreatureSoundGroup	WitchKiss;
var(Sounds) CreatureSoundGroup	DaggerDraw;
var(Sounds) CreatureSoundGroup	DaggerWhsh;
var(Sounds) CreatureSoundGroup	ShieldUp;
var(Sounds) CreatureSoundGroup	ShieldDn;
var(Sounds) CreatureSoundGroup	ShieldHit;
var(Sounds) CreatureSoundGroup	VEffort;

defaultproperties
{
     VDamage=(Sound0=Sound'Voiceover.Trsanti.1ftrs_001',Sound1=Sound'Voiceover.Trsanti.1ftrs_002',Sound2=Sound'Voiceover.Trsanti.1ftrs_003',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Trsanti.1ftrs_011',Sound1=Sound'Voiceover.Trsanti.1ftrs_012',Sound2=Sound'Voiceover.Trsanti.1ftrs_013',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Trsanti.1ftrs_009',Sound1=Sound'Voiceover.Trsanti.1ftrs_010',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Trsanti.1ftrs_007',Sound1=Sound'Voiceover.Trsanti.1ftrs_008',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     EventRetreat=(Sound0=Sound'Voiceover.Trsanti.1ftrs_004',Sound1=Sound'Voiceover.Trsanti.1ftrs_005',Sound2=Sound'Voiceover.Trsanti.1ftrs_006',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     EventTaunt=(Sound0=Sound'Voiceover.Trsanti.1ftrs_014',Sound1=Sound'Voiceover.Trsanti.1ftrs_015',Sound2=Sound'Voiceover.Trsanti.1ftrs_016',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Trsanti.1ftrs_017',Sound1=Sound'Voiceover.Trsanti.1ftrs_018',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     WitchMvmt=(Sound0=Sound'CreatureSFX.Trsanti.C_WitchMvmt01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     WitchKiss=(Sound0=Sound'CreatureSFX.Trsanti.C_WitchKiss01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     DaggerDraw=(Sound0=Sound'CreatureSFX.Trsanti.C_DaggerDraw01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     DaggerWhsh=(Sound0=Sound'CreatureSFX.Trsanti.C_DaggerWhsh01',Sound1=Sound'CreatureSFX.Trsanti.C_DaggerWhsh02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     ShieldUp=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldLaunch01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ShieldDn=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDestroy01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ShieldHit=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDeflect01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VEffort=(Sound0=Sound'CreatureSFX.Trsanti.C_Witch_VEffort1',Sound1=Sound'CreatureSFX.Trsanti.C_Witch_VEffort2',Sound2=Sound'CreatureSFX.Trsanti.C_Witch_VEffort3',Sound3=Sound'CreatureSFX.Trsanti.C_Witch_VEffort4',Sound4=Sound'CreatureSFX.Trsanti.C_Witch_VEffort5',Sound5=Sound'CreatureSFX.Trsanti.C_Witch_VEffort6',Sound6=Sound'CreatureSFX.Trsanti.C_Witch_VEffort7',Sound7=Sound'CreatureSFX.Trsanti.C_Witch_VEffort8',NumSounds=8,Pitch=1,Volume=1,Radius=1)
}
