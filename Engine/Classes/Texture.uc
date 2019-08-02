//=============================================================================
// Texture: An Unreal texture map.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Texture extends Bitmap
	safereplace
	native
	noexport;


// Subtextures.
var(Texture) texture BumpMap;		// Bump map to illuminate this texture with.
var(Texture) texture DetailTexture;	// Detail texture to apply.
var(Texture) texture MacroTexture;	// Macrotexture to apply, not currently used.

// Surface properties.
var(Surface) lighting Lighting;		// Lighting properties.
var(Texture) float DrawScale;       // Scaling relative to parent.
var(Texture) float Friction;		// Surface friction coefficient, 1.0=none, 0.95=some.
var(Texture) float Climb;			// For ladders and climbing objects.
var(Texture) float MipMult;         // Mipmap multiplier.
var(Texture) float Dustiness;		// How dusty is this surface - used as a strength parameter for the effects created
var(Texture) float JumpMultiplier;	// how does the player jump off of this surface?
var(Texture) float Elasticity;		// how elastic is the surface - used for collision and ricochet behavior.
var(Texture) float Flammability;	// how flammable is the surface?
var(Texture) class<Actor> EffectClass; // what effect class do I create when something hits me?

// Sounds.
var() sound FootstepSound;		// Footstep sound.
var() sound HitSound;			// Sound when the texture is hit with a projectile.


// Impacts
var(Impact) enum ETextureType
{
	TID_Default, 
	TID_Glass,
	TID_Water,
	TID_Leaves,
	TID_Snow,
	TID_Grass,
	TID_Organic,
	TID_Carpet,
	TID_Earth,
	TID_Sand,
	TID_WoodHollow,
	TID_WoodSolid,
	TID_Stone,
	TID_Metal,
	TID_Extra1, 
	TID_Extra2,
	TID_Extra3,
	TID_Extra4,
	TID_Extra5,
	TID_Extra6
} ImpactID;

// Inserted here for packing.
var(Texture) byte   SkipPS2Mips;		// Number of mip levels to skip for the PS2.

//var(Impact) byte	ImpactID; 
var(Impact) sound	ImpactSound[3];		// Possible Impact sounds for this Texture
var(Impact) float	ImpactVolume;
var(Impact) float	ImpactVolumeVar;
var(Impact) float	ImpactPitch;
var(Impact) float	ImpactPitchVar; 

// Surface flags. !!out of date
var          bool bInvisible;
var(Surface) editconst bool bMasked;
var(Surface) bool bTransparent;
var          bool bNotSolid;
var(Surface) bool bEnvironment;
var          bool bSemisolid;
var(Surface) bool bModulate;
var(Surface) bool bFakeBackdrop;
var(Surface) bool bTwoSided;
var(Surface) bool bAutoUPan;
var(Surface) bool bAutoVPan;
var(Surface) bool bNoSmooth;
var(Surface) bool bBigWavy;
var(Surface) bool bSmallWavy;
var(Surface) bool bWaterWavy;
var          bool bLowShadowDetail;
var          bool bNoMerge;
var(Surface) bool bCloudWavy;
var          bool bDirtyShadows;
var          bool bHighLedge;
var          bool bSpecialLit;
var          bool bGouraud;
var(Surface) bool bUnlit;
var          bool bHighShadowDetail;
var          bool bPortal;
var          const bool bMirrored, bX2, bX3;
var          const bool bX4, bX5, bX6, bX7;

// Texture flags.
var(Surface) bool  bPermeable;		// Make the surface permeable to weapons.
var(Quality) private  bool bHighColorQuality;   // High color quality hint.
var(Quality) private  bool bHighTextureQuality; // High color quality hint.
var private           bool bRealtime;           // Texture changes in realtime.
var private           bool bParametric;         // Texture data need not be stored.
var private transient bool bRealtimeChanged;    // Changed since last render.
var private           bool bHasComp;			// Whether a compressed version exists.


// Level of detail set.
var(Quality) enum ELODSet
{
	LODSET_None,   // No level of detail mipmap tossing.
	LODSET_World,  // World level-of-detail set.
	LODSET_Skin,   // Skin level-of-detail set.
} LODSet;

// Animation.
var(Animation) texture AnimNext;
var transient  texture AnimCurrent;
var(Animation) byte    PrimeCount;
var transient  byte    PrimeCurrent;
var(Animation) float   MinFrameRate, MaxFrameRate;
var transient  float   Accumulator;

// Mipmaps.
var private native const array<int> Mips, CompMips;
var const ETextureFormat CompFormat;

defaultproperties
{
     Lighting=(Diffuse=(R=255,G=255,B=255))
     DrawScale=1
     Friction=1
     MipMult=1
     Dustiness=1
     JumpMultiplier=1
     Elasticity=1
     Flammability=1
     LODSet=LODSET_World
}
