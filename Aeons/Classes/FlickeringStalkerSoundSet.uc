//=============================================================================
// FlickeringStalkerSoundSet.
//=============================================================================
class FlickeringStalkerSoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Atk;
var(Sounds) CreatureSoundGroup	Bite;
var(Sounds) CreatureSoundGroup	InvisoOff;
var(Sounds) CreatureSoundGroup	InvisoOn;
var(Sounds) CreatureSoundGroup	Mvmt;
var(Sounds) CreatureSoundGroup	TailHit;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	TurnFast;
var(Sounds) CreatureSoundGroup	TurnSlow;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	FleshSlice;
var(Sounds) CreatureSoundGroup	FleshStab;

defaultproperties
{
     Atk=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_Atk01',Sound1=Sound'CreatureSFX.FlickeringStalk.C_Flick_Atk02',NumSounds=2,Pitch=1,Volume=1.5,Radius=1)
     Bite=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_Bite01',Sound1=Sound'CreatureSFX.FlickeringStalk.C_Flick_Bite02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     InvisoOff=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_InvisoOff01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     InvisoOn=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_InvisoOn01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Mvmt=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_Mvmt01',Sound1=Sound'CreatureSFX.FlickeringStalk.C_Flick_Mvmt02',Sound2=Sound'CreatureSFX.FlickeringStalk.C_Flick_Mvmt03',NumSounds=3,Pitch=1,Volume=0.5,Radius=1)
     TailHit=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_TailHit01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Taunt=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_Taunt01',Sound1=Sound'CreatureSFX.FlickeringStalk.C_Flick_Taunt02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     TurnFast=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_TurnFast01',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     TurnSlow=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_TurnSlow01',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_VDamage01',Sound1=Sound'CreatureSFX.FlickeringStalk.C_Flick_VDamage02',NumSounds=2,slot=SLOT_Pain,Pitch=1,Volume=1.5,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.FlickeringStalk.C_Flick_VDeath01',Sound1=Sound'CreatureSFX.FlickeringStalk.C_Flick_VDeath02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=2)
     FleshSlice=(Sound0=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     FleshStab=(Sound0=Sound'Impacts.GoreSpecific.E_Imp_FleshStab02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
