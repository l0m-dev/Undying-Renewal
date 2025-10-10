//=============================================================================
// PhoenixExplosions.
//=============================================================================
class PhoenixExplosions expands Explosion
	abstract;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

defaultproperties
{
     DamageType=phx_concussive
}
