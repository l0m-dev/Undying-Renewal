//=============================================================================
// HandmaidenSoundSet.
//=============================================================================
class HandmaidenSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Idle;
var(Sounds) CreatureSoundGroup	SKillCycle;
var(Sounds) CreatureSoundGroup	SKillEnd;
var(Sounds) CreatureSoundGroup	SKillStart;
var(Sounds) CreatureSoundGroup	TauntCycle;
var(Sounds) CreatureSoundGroup	TauntEnd;
var(Sounds) CreatureSoundGroup	TauntStart;
var(Sounds) CreatureSoundGroup	CastLightning;
var(Sounds) CreatureSoundGroup	CastShalas;

defaultproperties
{
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=5)
     VDamage=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_Damage01',Sound1=Sound'CreatureSFX.Handmaiden.C_HandMdn_Damage02',Sound2=Sound'CreatureSFX.Handmaiden.C_HandMdn_Damage03',Sound3=Sound'CreatureSFX.Handmaiden.C_HandMdn_Damage04',NumSounds=4,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=5)
     VDeath=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_Death01',Sound1=Sound'CreatureSFX.Handmaiden.C_HandMdn_Death02',Sound2=Sound'CreatureSFX.Handmaiden.C_HandMdn_Death03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=5)
     Idle=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_Idle01',Sound1=Sound'CreatureSFX.Handmaiden.C_HandMdn_Idle02',Sound2=Sound'CreatureSFX.Handmaiden.C_HandMdn_Idle03',NumSounds=3,Pitch=1,Volume=0.6,Radius=5)
     SKillCycle=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_SKillCycle01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     SKillEnd=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_SKillEnd01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     SKillStart=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_SKillStart01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     TauntCycle=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_TauntCycle01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     TauntEnd=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_TauntEnd01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     TauntStart=(Sound0=Sound'CreatureSFX.Handmaiden.C_HandMdn_TauntStart01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     CastLightning=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_LightningStart01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     CastShalas=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShalaLaunch01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     PatDeath=(Radius=5)
}
