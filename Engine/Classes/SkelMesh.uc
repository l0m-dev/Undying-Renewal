//=============================================================================
// SkelMesh
//=============================================================================

class SkelMesh expands Mesh;

var private native int SkelProto;
var array<byte> Joints;
var array<byte> JointLocs;
var private native int JointVerts_vtableptr;
var private native int JointVerts_SavedAr;
var private native int JointVerts_SavedPos;
var array<byte> JointVerts;
var array<byte> PhysObj;
var SkelMesh ParentMesh;
var Place Origin;

/*
DWI::SkelNode* SkelProto;
TArray Joints;	    	 // DWIjoint 80 bytes each
TArray JointLocs;	     // jointloc, 36 bytes each
TLazyArray JointVerts;   // DWI::array<DWI::JointVert>, first 12 bytes are x,y,z
TArray PhysObj;          // cloth, hair, jiggle physics
USkelMesh* ParentMesh;
FPlace Origin;
*/

defaultproperties
{
}
