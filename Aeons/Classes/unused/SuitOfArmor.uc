//=============================================================================
// SuitOfArmor.
//=============================================================================
class SuitOfArmor expands Ornaments;

#exec MESH IMPORT MESH=SuitOfArmor_m SKELFILE=SuitOfArmor.ngf

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.SuitOfArmor_m'
     CollisionRadius=32
     CollisionHeight=74
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
