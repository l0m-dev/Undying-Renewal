//=============================================================================
// SPFireballCannon.
//=============================================================================
class SPFireballCannon expands SPWeapon;

//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     ProjClass=Class'Aeons.FireballProjectile'
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCMiss01'
     bReloadable=True
     ReloadTime=4
     ReloadCount=1
     bIsMagical=True
     SpoolUpTime=1.6
     Accuracy=0.9
     AimAnim=Attack_Spell_Start
}
