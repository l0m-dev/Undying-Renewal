//=============================================================================
// Mesh
//=============================================================================

class Mesh expands Primitive
	native
	noexport;

const MF_UNK			  = 0x00000001;
const MF_HAS_LOD_DISTANCE = 0x10000000;

var native private const pointer Tris_vtableptr;
var native private const pointer Tris_SavedAr;
var private native int Tris_SavedPos;
var array<byte> Tris;
var array<Texture> Textures;
var array<float> TextureLOD;

var native private const pointer MRMMeshData;
var int Verts;
var int Normals;

var byte Smoothing;
var int Unk2;
var int Flags;

var native private const pointer AnimData;

/*
class ENGINE_API UMesh : public UPrimitive
{
	DECLARE_ABSTRACT_CLASS(UMesh,UPrimitive,0,Engine)

	// Objects.
	TLazyArray<FMeshTri>			Tris;
	TArray<UTexture*>				Textures;
	TArray<FLOAT>					TextureLOD;

	// Counts.
	UMRMMeshData* MRMMeshData;
	INT Verts;
	INT Normals;

	BYTE Smoothing;
	DWORD Unk2;
	DWORD Flags;

	class UAnimData* AnimData;
}
*/

defaultproperties
{
}
