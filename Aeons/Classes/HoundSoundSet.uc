//=============================================================================
// HoundSoundSet.
//=============================================================================
class HoundSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	Attack;
var(Sounds) CreatureSoundGroup	Bite;
var(Sounds) CreatureSoundGroup	Charge;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	DistHowl;
var(Sounds) CreatureSoundGroup	Idle;
var(Sounds) CreatureSoundGroup	Jump;
var(Sounds) CreatureSoundGroup	Roar;
var(Sounds) CreatureSoundGroup	Sniff;
var(Sounds) CreatureSoundGroup	SpecialKill;
var(Sounds) CreatureSoundGroup	Swipe;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	Spawn;
var(Sounds) CreatureSoundGroup	FootSweetener;

defaultproperties
{
     Attack=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Attack01',Sound1=Sound'CreatureSFX.Hound.C_Hound_Attack02',Sound2=Sound'CreatureSFX.Hound.C_Hound_Attack03',NumSounds=3,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Bite=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Bite01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Charge=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Charge01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     VDamage=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Damage01',Sound1=Sound'CreatureSFX.Hound.C_Hound_Damage02',NumSounds=2,slot=SLOT_Pain,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     VDeath=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Death01',Sound1=Sound'CreatureSFX.Hound.C_Hound_Death02',NumSounds=2,slot=SLOT_Talk,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     DistHowl=(Sound0=Sound'CreatureSFX.Hound.C_Hound_DistHowl01',Sound1=Sound'CreatureSFX.Hound.C_Hound_DistHowl02',NumSounds=2,slot=SLOT_Talk,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Idle=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Idle01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Jump=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Jump01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Roar=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Roar01',NumSounds=1,slot=SLOT_Talk,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Sniff=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Sniff01',Sound1=Sound'CreatureSFX.Hound.C_Hound_Sniff02',Sound2=Sound'CreatureSFX.Hound.C_Hound_Sniff03',NumSounds=3,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     SpecialKill=(Sound0=Sound'CreatureSFX.Hound.C_Hound_SpecialKill01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Swipe=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Swipe01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Taunt=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Taunt01',NumSounds=1,slot=SLOT_Talk,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     Spawn=(Sound0=Sound'CreatureSFX.Hound.C_Hound_Teleport01',NumSounds=1,slot=SLOT_Talk,Pitch=1,PitchVar=0.2,Volume=4,Radius=4)
     FootSweetener=(Sound0=Sound'CreatureSFX.SharedHuman.C_BFallSmall_Carpet01',NumSounds=1,slot=SLOT_Talk,Pitch=1,PitchVar=0.1,Volume=1,Radius=1)
     PatDeath=(PitchVar=0.2,Volume=4,Radius=4)
}
