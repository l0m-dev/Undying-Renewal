//=============================================================================
// MonkSoldier.
//=============================================================================
class MonkSoldier expands HoodedMonk;

//#exec MESH IMPORT MESH=MonkSoldier_m SKELFILE=MonkSoldier.ngf INHERIT=HoodedMonk_m
//#exec MESH JOINTNAME Head=Hair Neck=Head


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     Mesh=SkelMesh'Aeons.Meshes.MonkSoldier_m'
}
