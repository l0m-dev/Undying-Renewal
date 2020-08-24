//=============================================================================
// GuardianPhoenixSoundSet.
//=============================================================================
class GuardianPhoenixSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	Atk;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Wake;
var(Sounds) CreatureSoundGroup	WingFlap;

defaultproperties
{
     Atk=(Sound0=Sound'CreatureSFX.Phoenix.C_Phoenix_Attack01',Sound1=Sound'CreatureSFX.Phoenix.C_Phoenix_Attack02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.Phoenix.C_Phoenix_VDamage01',Sound1=Sound'CreatureSFX.Phoenix.C_Phoenix_VDamage02',NumSounds=2,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Phoenix.C_Phoenix_Death01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     WingFlap=(Sound0=Sound'CreatureSFX.Phoenix.C_Phoenix_WingFlap01',Sound1=Sound'CreatureSFX.Phoenix.C_Phoenix_WingFlap02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
}
