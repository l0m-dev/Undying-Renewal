//=============================================================================
// JileSoundSet.
//=============================================================================
class JileSoundSet expands CreatureSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Bite;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Grow;
var(Sounds) CreatureSoundGroup	Mvmt;
var(Sounds) CreatureSoundGroup	Shoot;
var(Sounds) CreatureSoundGroup	Snap;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	VIdle;
var(Sounds) CreatureSoundGroup	Wild;
var(Sounds) CreatureSoundGroup	SPKill;

defaultproperties
{
     Bite=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Bite01',Sound1=Sound'CreatureSFX.RavenousPlant.C_Plant_Bite02',Sound2=Sound'CreatureSFX.RavenousPlant.C_Plant_Bite03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Damage01',Sound1=Sound'CreatureSFX.RavenousPlant.C_Plant_Damage02',Sound2=Sound'CreatureSFX.RavenousPlant.C_Plant_Damage03',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Die01',Sound1=Sound'CreatureSFX.RavenousPlant.C_Plant_Die02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Grow=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Grow01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Mvmt=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Mvmt01',Sound1=Sound'CreatureSFX.RavenousPlant.C_Plant_Mvmt02',Sound2=Sound'CreatureSFX.RavenousPlant.C_Plant_Mvmt03',Sound3=Sound'CreatureSFX.RavenousPlant.C_Plant_Mvmt04',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     Shoot=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Shoot01',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     Snap=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Snap01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Taunt=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Taunt01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     VIdle=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_VIdle01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Wild=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_Wild02',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     SpKill=(Sound0=Sound'CreatureSFX.RavenousPlant.C_Plant_SpKill01',NumSounds=1,Pitch=1,Volume=2.5,Radius=2)
}
