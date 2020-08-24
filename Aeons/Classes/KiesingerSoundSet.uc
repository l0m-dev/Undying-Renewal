//=============================================================================
// KiesingerSoundSet.
//=============================================================================
class KiesingerSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	EventTaunt;
var(Sounds) CreatureSoundGroup	EventAttack;
var(Sounds) CreatureSoundGroup	EventFall;
var(Sounds) CreatureSoundGroup	ForceBlast;
var(Sounds) CreatureSoundGroup	LightBuild;
var(Sounds) CreatureSoundGroup	Suck;
var(Sounds) CreatureSoundGroup	Laugh;
var(Sounds) CreatureSoundGroup	ShieldUp;
var(Sounds) CreatureSoundGroup	ShieldDn;
var(Sounds) CreatureSoundGroup	ShieldHit;
var(Sounds) CreatureSoundGroup	PLaunch;

defaultproperties
{
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'Voiceover.Kiesinger.Kie_013',Sound1=Sound'Voiceover.Kiesinger.Kie_014',Sound2=Sound'Voiceover.Kiesinger.Kie_015',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=5)
     EventTaunt=(Sound0=Sound'Voiceover.Kiesinger.Kie_016',Sound1=Sound'Voiceover.Kiesinger.Kie_017',Sound2=Sound'Voiceover.Kiesinger.Kie_018',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=5)
     EventAttack=(Sound0=Sound'Voiceover.Kiesinger.Kie_019',Sound1=Sound'Voiceover.Kiesinger.Kie_020',Sound2=Sound'Voiceover.Kiesinger.Kie_021',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=5)
     EventFall=(Sound0=Sound'Voiceover.Kiesinger.Kie_025',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=2,Radius=10)
     forceblast=(Sound0=Sound'LevelMechanics.Manor.E04_ForceBlast1',NumSounds=1,Pitch=1,Volume=1,Radius=2)
     LightBuild=(Sound0=Sound'CreatureSFX.Kiesinger.C_Kies_LightBuild01',NumSounds=1,Pitch=1,Volume=1.5,Radius=3)
     Suck=(Sound0=Sound'CreatureSFX.Kiesinger.C_Kies_Suck1',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     Laugh=(Sound0=Sound'CreatureSFX.Kiesinger.C_Kies_Laugh1',NumSounds=1,Pitch=1,Volume=1,Radius=5)
     ShieldUp=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldLaunch01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ShieldDn=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDestroy01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     ShieldHit=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDeflect01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     PLaunch=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixLaunch01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
