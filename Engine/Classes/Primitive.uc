//=============================================================================
// Primitive
//=============================================================================

class Primitive expands Object;

struct Box
{
	var Vector Min;
	var Vector Max;
	var byte IsValid;
};

struct Sphere
{
	var float X;
	var float Y;
	var float Z;
	var float W;
};

var Box BoundingBox;
var Sphere BoundingSphere;

/*
FBox BoundingBox;
FSphere BoundingSphere;
*/

defaultproperties
{
}
