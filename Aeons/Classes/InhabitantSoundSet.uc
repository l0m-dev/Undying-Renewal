//=============================================================================
// InhabitantSoundSet.
//=============================================================================
class InhabitantSoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	AttackClaw;
var(Sounds) CreatureSoundGroup	Bite;
var(Sounds) CreatureSoundGroup	Death;
var(Sounds) CreatureSoundGroup	DeathStruggle;
var(Sounds) CreatureSoundGroup	MindShatter;
var(Sounds) CreatureSoundGroup	ShortVocal;
var(Sounds) CreatureSoundGroup	Sleep;
var(Sounds) CreatureSoundGroup	Stun;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	WingFlap;

defaultproperties
{
     AttackClaw=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_Attack01',Sound1=Sound'CreatureSFX.Inhabitant.C_Inhab_Attack02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Bite=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_Bite01',Sound1=Sound'CreatureSFX.Inhabitant.C_Inhab_Bite02',Sound2=Sound'CreatureSFX.Inhabitant.C_Inhab_Bite03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     Death=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_Death01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=2)
     DeathStruggle=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_DeathStruggle01',NumSounds=1,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=2)
     Mindshatter=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_MindShatter01',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     ShortVocal=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_ShortVocal01',Sound1=Sound'CreatureSFX.Inhabitant.C_Inhab_ShortVocal02',Sound2=Sound'CreatureSFX.Inhabitant.C_Inhab_ShortVocal03',Sound3=Sound'CreatureSFX.Inhabitant.C_Inhab_ShortVocal04',Sound4=Sound'CreatureSFX.Inhabitant.C_Inhab_ShortVocal05',NumSounds=5,Pitch=1,Volume=1,Radius=1)
     Sleep=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_Sleep01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Stun=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_Stun01',Sound1=Sound'CreatureSFX.Inhabitant.C_Inhab_Stun02',NumSounds=2,slot=SLOT_Pain,Pitch=1,Volume=1.5,Radius=1)
     Taunt=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_Taunt01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=2)
     WingFlap=(Sound0=Sound'CreatureSFX.Inhabitant.C_Inhab_WingFlap01',Sound1=Sound'CreatureSFX.Inhabitant.C_Inhab_WingFlap02',Sound2=Sound'CreatureSFX.Inhabitant.C_Inhab_WingFlap03',NumSounds=3,Pitch=1,Volume=0.5,Radius=1)
}
