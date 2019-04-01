//=============================================================================
// BethanySoundSet.
//=============================================================================
class BethanySoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	BloodDip;
var(Sounds) CreatureSoundGroup	BlastA;
var(Sounds) CreatureSoundGroup	BlastB;
var(Sounds) CreatureSoundGroup	RechargeLp;
var(Sounds) CreatureSoundGroup	SpecialKill;
var(Sounds) CreatureSoundGroup	SpellA;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventAttack;
var(Sounds) CreatureSoundGroup	EventTaunt;

defaultproperties
{
     blooddip=(Sound0=Sound'CreatureSFX.Bethany.C_Bethany_BloodDip01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     BlastA=(Sound0=Sound'CreatureSFX.Bethany.C_Bethany_BlastIntro01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     BlastB=(Sound0=Sound'LevelMechanics.Manor.E04_ForceBlast1',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     RechargeLp=(Sound0=Sound'CreatureSFX.Bethany.C_Bethany_RechargeLp01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     SpecialKill=(Sound0=Sound'CreatureSFX.Bethany.C_Bethany_SpecialKill01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     SpellA=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_SumGenUse01',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     VDamage=(Sound0=Sound'Voiceover.Bethany.Beth_007',Sound1=Sound'Voiceover.Bethany.Beth_008',Sound2=Sound'Voiceover.Bethany.Beth_009',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=10)
     VDeath=(Sound0=Sound'Voiceover.Bethany.Beth_010',Sound1=Sound'Voiceover.Bethany.Beth_011',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=10)
     EventAttack=(Sound0=Sound'Voiceover.Bethany.Beth_012',Sound1=Sound'Voiceover.Bethany.Beth_013',Sound2=Sound'Voiceover.Bethany.Beth_014',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=5)
     EventTaunt=(Sound0=Sound'Voiceover.Bethany.Beth_015',Sound1=Sound'Voiceover.Bethany.Beth_016',Sound2=Sound'Voiceover.Bethany.Beth_017',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=5)
}
