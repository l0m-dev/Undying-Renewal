//=============================================================================
// FootSoundSet.
//=============================================================================
class FootSoundSet expands SoundContainer
	native;

// Footstep Matrix stuff
struct FootStepSoundProperties
{
	var() sound Sound1;
	var() sound Sound2;
	var() sound Sound3;
	var() sound Sound4;

	var() float	Pitch;
	var() float	PitchVar;
	var() float	Volume;
	var() float	VolumeVar;
};


struct FootSoundEntry
{
	var() FootStepSoundProperties	FootStep;
	var() SoundSet					Land;
	var() SoundSet					Scuff;
};

var() FootSoundEntry Default;
var() FootSoundEntry Glass;
var() FootSoundEntry Water;
var() FootSoundEntry Leaves;
var() FootSoundEntry Snow;
var() FootSoundEntry Grass;
var() FootSoundEntry Organic;
var() FootSoundEntry Carpet;
var() FootSoundEntry Earth;
var() FootSoundEntry Sand;
var() FootSoundEntry WoodHollow;
var() FootSoundEntry WoodSolid;
var() FootSoundEntry Stone;
var() FootSoundEntry Metal;
var() FootSoundEntry Extra1;
var() FootSoundEntry Extra2;
var() FootSoundEntry Extra3;
var() FootSoundEntry Extra4;
var() FootSoundEntry Extra5;
var() FootSoundEntry Extra6;

defaultproperties
{
}
