//=============================================================================
// ScarrowSoundSet.
//=============================================================================
class ScarrowSoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Appear;
var(Sounds) CreatureSoundGroup	AppearEnd;
var(Sounds) CreatureSoundGroup	AttackClaw;
var(Sounds) CreatureSoundGroup	AttackSpit;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Disappear;
var(Sounds) CreatureSoundGroup	Hunt;
var(Sounds) CreatureSoundGroup	Idle;
var(Sounds) CreatureSoundGroup	Slide;
var(Sounds) CreatureSoundGroup	Spit;
var(Sounds) CreatureSoundGroup	SpitHit;
var(Sounds) CreatureSoundGroup	Stun;
var(Sounds) CreatureSoundGroup	StunEnd;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	Whoosh;
var(Sounds) CreatureSoundGroup	SPKill;

defaultproperties
{
     Appear=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Appear01',NumSounds=1,Pitch=1,Volume=1.6,Radius=1)
     AppearEnd=(Sound0=Sound'CreatureSFX.Shades.C_Shade_AppearEnd01',NumSounds=1,Pitch=1,Volume=1.6,Radius=1)
     AttackClaw=(Sound0=Sound'CreatureSFX.Shades.C_Shade_AttackClaw01',Sound1=Sound'CreatureSFX.Shades.C_Shade_AttackClaw02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     AttackSpit=(Sound0=Sound'CreatureSFX.Shades.C_Shade_AttackSpit01',NumSounds=1,Pitch=1,Volume=1.5,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Damage01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Damage02',NumSounds=2,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Death01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Death02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     Disappear=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Disappear01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     hunt=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Hunt01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Hunt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Idle=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Idle01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Idle02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Slide=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Slide01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Slide02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Spit=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Spit01',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     SpitHit=(Sound0=Sound'CreatureSFX.Shades.C_Shade_SpitHit01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Stun=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Stun01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Stun02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     StunEnd=(Sound0=Sound'CreatureSFX.Shades.C_Shade_StunEnd01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Taunt=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Taunt01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=2)
     Whoosh=(Sound0=Sound'CreatureSFX.Shades.C_Shade_Whoosh01',Sound1=Sound'CreatureSFX.Shades.C_Shade_Whoosh02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     SpKill=(Sound0=Sound'CreatureSFX.Shades.C_Shade_SpecialKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
