//=============================================================================
// DonkeySoundSet.
//=============================================================================
class DonkeySoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Chewing;
var(Sounds) CreatureSoundGroup	Graze;
var(Sounds) CreatureSoundGroup	Hoof;
var(Sounds) CreatureSoundGroup	BodyFall;

defaultproperties
{
     VDamage=(Sound0=Sound'CreatureSFX.Donkey.C_Donkey_Damage1',Sound1=Sound'CreatureSFX.Donkey.C_Donkey_Damage2',Sound2=Sound'CreatureSFX.Donkey.C_Donkey_Damage3',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Donkey.C_Donkey_Death1',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     Chewing=(Sound0=Sound'CreatureSFX.Donkey.C_Donkey_Chewing1',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     graze=(Sound0=Sound'CreatureSFX.Donkey.C_Donkey_Graze1',Sound1=Sound'CreatureSFX.Donkey.C_Donkey_Graze2',Sound2=Sound'CreatureSFX.Donkey.C_Donkey_Graze3',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     Hoof=(Sound0=Sound'CreatureSFX.Donkey.C_Hoof1',Sound1=Sound'CreatureSFX.Donkey.C_Hoof2',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     BodyFall=(Sound0=Sound'CreatureSFX.Sheep.C_Sheep_Bodyfall1',NumSounds=1,Pitch=1,Volume=1.5,Radius=1)
}
