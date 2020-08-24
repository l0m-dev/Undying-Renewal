//=============================================================================
// SPSkullStorm.
//=============================================================================
class SPSkullStorm expands SPWeapon;

//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     ProjClass=Class'Aeons.SPSkullStormProjectile'
     FireSound=Sound'Aeons.Spells.E_Spl_SkullScream01'
     bReloadable=True
     ReloadTime=4
     ReloadCount=1
     bIsMagical=True
     SpoolUpTime=0.4
     Accuracy=0.9
     AimAnim=Attack_Spell_Start
}
