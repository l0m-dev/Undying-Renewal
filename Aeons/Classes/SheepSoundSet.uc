//=============================================================================
// SheepSoundSet.
//=============================================================================
class SheepSoundSet expands CreatureSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	BodyFall;
var(Sounds) CreatureSoundGroup	Graze;
var(Sounds) CreatureSoundGroup	Chewing;
var(Sounds) CreatureSoundGroup	Hoof;

defaultproperties
{
     VDamage=(Sound0=Sound'CreatureSFX.Sheep.C_Sheep_Damage1',Sound1=Sound'CreatureSFX.Sheep.C_Sheep_Damage2',NumSounds=2,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Sheep.C_Sheep_Death1',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     BodyFall=(Sound0=Sound'CreatureSFX.Sheep.C_Sheep_Bodyfall1',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     graze=(Sound0=Sound'CreatureSFX.Sheep.C_Sheep_Graze1',Sound1=Sound'CreatureSFX.Sheep.C_Sheep_Graze2',Sound2=Sound'CreatureSFX.Sheep.C_Sheep_Graze3',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     Chewing=(Sound0=Sound'CreatureSFX.Sheep.C_Sheep_Chewing1',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Hoof=(Sound0=Sound'CreatureSFX.Donkey.C_Hoof1',Sound1=Sound'CreatureSFX.Donkey.C_Hoof2',NumSounds=2,Pitch=1,Volume=1,Radius=1)
}
