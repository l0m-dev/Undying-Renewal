//=============================================================================
// SPCrossbow.
//=============================================================================
class SPCrossbow expands SPWeapon;

//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     ProjClass=Class'Aeons.SPBoltProjectile'
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_Speargunfire01'
     bReloadable=True
     ReloadTime=3.5
     ReloadCount=1
     SpoolUpTime=0.1
     Accuracy=1
     AimAnim=Crossbow_Lift
     RecoilAnim=Attack_Crossbow
     FireSoundRadius=4000
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Crossbow_m'
}
