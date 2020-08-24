//=============================================================================
// RatSoundSet.
//=============================================================================
class RatSoundSet expands CreatureSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Bodyfall;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Footstep;
var(Sounds) CreatureSoundGroup	Group;
var(Sounds) CreatureSoundGroup	Hunt;

defaultproperties
{
     BodyFall=(Sound0=Sound'CreatureSFX.Rat.C_Rat_Bodyfall1',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Rat.C_Rat_Death1',Sound1=Sound'CreatureSFX.Rat.C_Rat_Death2',Sound2=Sound'CreatureSFX.Rat.C_Rat_Death3',Sound3=Sound'CreatureSFX.Rat.C_Rat_Death4',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     FootStep=(Sound0=Sound'CreatureSFX.Rat.C_Rat_Footstep1',Sound1=Sound'CreatureSFX.Rat.C_Rat_Footstep2',Sound2=Sound'CreatureSFX.Rat.C_Rat_Footstep3',Sound3=Sound'CreatureSFX.Rat.C_Rat_Footstep4',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     Group=(Sound0=Sound'CreatureSFX.Rat.C_Rat_Group1',Sound1=Sound'CreatureSFX.Rat.C_Rat_Group2',Sound2=Sound'CreatureSFX.Rat.C_Rat_Group3',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     hunt=(Sound0=Sound'CreatureSFX.Rat.C_Rat_Hunt1',Sound1=Sound'CreatureSFX.Rat.C_Rat_Hunt2',Sound2=Sound'CreatureSFX.Rat.C_Rat_Hunt3',NumSounds=3,Pitch=1,Volume=1,Radius=1)
}
