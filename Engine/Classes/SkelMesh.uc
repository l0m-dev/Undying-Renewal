//=============================================================================
// SkelMesh
//=============================================================================

class SkelMesh expands Mesh
	native
	noexport;

var native private const pointer SkelProto;
var array<byte> Joints;
var array<byte> JointLocs;
var native private const pointer JointVerts_vtableptr;
var native private const pointer JointVerts_SavedAr;
var private native int JointVerts_SavedPos;
var array<byte> JointVerts;
var array<byte> Modifiers;
var SkelMesh ParentMesh;
var Place Origin;

/*
class ENGINE_API USkelMesh : public UMesh
{
	DECLARE_CLASS(USkelMesh,UMesh,0,Engine)

	DWI::SkelNode* SkelProto;
	TArray<FJointInfo> Joints;
	TArray<FJointLoc> JointLocs;
	TLazyArray<FJointVert> JointVerts;
	TArray<FModifierInfo> Modifiers;
	USkelMesh* ParentMesh;
	FPlace Origin;
}
*/

defaultproperties
{
}
