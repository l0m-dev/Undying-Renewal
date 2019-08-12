//=============================================================================
// SPEctoplasm.
//=============================================================================
class SPEctoplasm expands SPWeapon;

//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     ProjClass=Class'Aeons.SPEctoplasmProjectile'
     FireSound=Sound'Aeons.Spells.E_Spl_EctoSpawn01'
     bReloadable=False
     ReloadTime=0.333333
     ReloadCount=1
     bIsMagical=True
     SpoolUpTime=0.4
     Accuracy=0.9
     AimAnim=Attack_Spell_Start
}
