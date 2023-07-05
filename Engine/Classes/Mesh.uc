//=============================================================================
// Mesh
//=============================================================================

class Mesh expands Primitive;

const MF_UNK			  = 0x00000001;
const MF_HAS_LOD_DISTANCE = 0x10000000;

var private native int Tris_vtableptr;
var private native int Tris_SavedAr;
var private native int Tris_SavedPos;
var array<byte> Tris;
var array<Texture> Textures;
var array<float> TextureLOD;

var private native int MRMMeshData;
var int NumVerts;
var int NumNormals;

var int Unk1;
var int Unk2;
var int Flags;

var private native int AnimData;

/*
struct UMesh : UPrimitive
{
    TLazyArray          			Tris; // FMeshTri
    TArray          				Textures; // UTexture*

	TArray		        			TextureLOD; // float

	// Counts.
	UMRMMeshData*					MRMMeshData;
	int								NumVerts;
	int								NumNormals;

	uint							Unk1;
	uint							Unk2;
	uint							Flags;

	UAnimData*                      AnimData;
};
*/

defaultproperties
{
}
