//=============================================================================
// GrandFatherClock.
//=============================================================================
class GrandFatherClock expands Furniture;
//#exec MESH IMPORT MESH=GrandFatherClock_m SKELFILE=GrandFatherClock.ngf 

simulated function StartLevel()
{
     if (LoopAnim('Idle',, MOVE_None))
     {
          // Idle anim lowers the mesh, raise it back up
          PrePivot.Z = 60.0;
     }
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.GrandFatherClock_m'
     CollisionRadius=24
     CollisionHeight=75
     bStatic=False
     bNoDelete=True
     bGroundMesh=True
     Physics=PHYS_None
     bClientAnim=True
     PrePivot=(Z=-25)
}
