//=============================================================================
// SleedSoundSet.
//=============================================================================
class SleedSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	Bite;
var(Sounds) CreatureSoundGroup	Death1;
var(Sounds) CreatureSoundGroup	Death2;
var(Sounds) CreatureSoundGroup	Foot;
var(Sounds) CreatureSoundGroup	Shell;
var(Sounds) CreatureSoundGroup	Spawn;
var(Sounds) CreatureSoundGroup	SpKill;
var(Sounds) CreatureSoundGroup	Taunt1;
var(Sounds) CreatureSoundGroup	Taunt2;
var(Sounds) CreatureSoundGroup	VAttack1;
var(Sounds) CreatureSoundGroup	VAttack2;
var(Sounds) CreatureSoundGroup	VIdle1;
var(Sounds) CreatureSoundGroup	EventFearSpot;

defaultproperties
{
     Bite=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Bite01',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Bite02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Death1=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Death101',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Death102',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Death2=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Death201',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Death202',Sound2=Sound'CreatureSFX.Sleed.C_Sleed_Death204',Sound3=Sound'CreatureSFX.Sleed.C_Sleed_Death205',NumSounds=4,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Foot=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Foot01',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Foot02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Shell=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Shell01',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Shell02',Sound2=Sound'CreatureSFX.Sleed.C_Sleed_Shell03',Sound3=Sound'CreatureSFX.Sleed.C_Sleed_Shell04',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     Spawn=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Spawn01',Sound2=Sound'CreatureSFX.Sleed.C_Sleed_Spawn03',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     SpKill=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_SpKill01',NumSounds=1,Pitch=1,Volume=1.5,Radius=1)
     Taunt1=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Taunt101',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Taunt102',NumSounds=2,Pitch=1,Volume=1,Radius=2)
     Taunt2=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Taunt201',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     VAttack1=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_VAttack101',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_VAttack102',Sound2=Sound'CreatureSFX.Sleed.C_Sleed_VAttack103',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VAttack2=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_VAttack201',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VIdle1=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_VIdle101',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_VIdle102',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     EventFearSpot=(Sound0=Sound'CreatureSFX.Sleed.C_Sleed_Taunt101',Sound1=Sound'CreatureSFX.Sleed.C_Sleed_Taunt102',Sound2=Sound'CreatureSFX.Sleed.C_Sleed_Taunt201',NumSounds=3,Pitch=1,Volume=1,Radius=2)
}
