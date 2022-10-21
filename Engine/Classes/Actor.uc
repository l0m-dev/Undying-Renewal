//=============================================================================
// Actor: The base class of all actors.
// This is a built-in Unreal class and it shouldn't be modified.damage

//=============================================================================
class Actor extends Object
	abstract
	native
	nativereplication;

// Imported data (during full rebuild).
//#exec Texture Import File=Textures\S_Actor.pcx Name=S_Actor Mips=On Flags=2
//#exec Texture Import File=Textures\Flag1.pcx Name=S_Flag Mips=On Flags=2
//#exec Texture Import File=Textures\generic_i.pcx Name=Generic_Inv Mips=On

// Flags for sound properties
const SOUND_LOCKED			= 0x0001;
const SOUND_NOPAUSE			= 0x0002;
const SOUND_AMBIENT			= 0x0004; // INTERNAL USE ONLY: DO NOT USE !!!!!!!!!!
const SOUND_BACKGROUND		= 0x0008;
const SOUND_VOICEOVER		= 0x0010;
const SOUND_NOSCRYEPITCH    = 0x0020;
const SOUND_NOSCRYEVOLUME	= 0x0040;
const SOUND_NOWATERPITCH    = 0x0080;
const SOUND_NOWATERVOLUME	= 0x0100;
const SOUND_SCRYEONLY		= 0x0200;
const SOUND_MUSICINTRO		= 0x0400;
const SOUND_NOFALLOFF		= 0x0800;
const SOUND_NOPANNING		= 0x1000;

/*
Common combinations
===================
No Scrye Pitch/Vol Changes				= 96
No UnderWater Pitch/Vol Changes			= 384
No Scrye/UnderWater Pitch Changes		= 160
No Scrye/UnderWater Pitch/Vol Changes	= 480
Shell Sounds							= 482
Voiceover								= 497 
*/

// Flags.
var(Advanced) const bool  bStatic;       // Does not move or change over time.
var(Advanced) savable bool        bHidden;       // Is hidden during gameplay.
var(Advanced) const bool  bNoDelete;     // Cannot be deleted during play.
var const bool            bDeleteMe;     // About to be deleted.
var transient const bool  bAssimilated;  // Actor dynamics are assimilated in world geometry.
var transient const bool  bTicked;       // Actor has been updated.
var transient bool		  bIsAMovingBrush;	// Flag is true if the actor is a moving brush.
var transient bool		  bIsRenderable;	// Flag is true if the actor can be rendered.
var transient bool        bLightChanged; // Recalculate this light's lighting now.
var bool                  bDynamicLight; // Temporarily treat this as a dynamic light.
var savable bool			bTimerLoop;		// Timer loops (else is one-shot).
var bool				  bSpawned;		 // Whether this actor was spawned in this level or not

// Other flags.
var(Advanced) bool        bCanTeleport;  // This actor can be teleported.
var(Advanced) bool		bOwnerNoSee;	 // Everything but the owner can see this actor.
var(Advanced) bool      bOnlyOwnerSee;   // Only owner can see this actor.
var Const     bool		bIsMover;		 // Is a mover.
var(Advanced) bool		bAlwaysRelevant; // Always relevant for network.
var Const	  bool		bAlwaysTick;     // Update even when players-only.
var(Advanced) bool        bHighDetail;	 // Only show up on high-detail.
var(Advanced) bool		  bStasis;		 // In StandAlone games, turn off if not in a recently rendered zone turned off if  bCanStasis  and physics = PHYS_None or PHYS_Rotating.
var(Advanced) bool		  bForceStasis;	 // Force stasis when not recently rendered, even if physics not none or rotating.
var const	  bool		  bIsPawn;		 // True only for pawns.
var(Advanced) const bool  bNetTemporary; // Tear-off simulation in network play.
var(Advanced) const bool  bNetOptional;  // Actor should only be replicated if bandwidth available.
var			  bool		  bReplicateInstigator;	// Replicate instigator to client (used by bNetTemporary projectiles).
var			  bool		  bTrailerSameRotation;	// If PHYS_Trailer and true, have same rotation as owner.
var			  bool		  bTrailerPrePivot;	// If PHYS_Trailer and true, offset from owner by PrePivot.
var			  bool		  bClientAnim;
var			  bool		  bSimFall;			// dumb proxy should simulate fall
var(Advanced) bool		bTimedTick;		 // If true, only update the tick if it has been longer than minticktime
var(Advanced) float		MinTickTime;	 // Number of seconds that should me waited before ticking this actor.
var			  float		TimeSinceTick;	 // Number of seconds since we were last ticked.
var(Advanced) int		Priority;		 // The priority this actor has to be ticked.

// Priority Parameters
// Actor's current physics mode.
var(Movement) savable const enum EPhysics
{
	PHYS_None,
	PHYS_Walking,
	PHYS_Falling,
	PHYS_Swimming,
	PHYS_Flying,
	PHYS_Rotating,
	PHYS_Projectile,
	PHYS_Rolling,
	PHYS_Interpolating,
	PHYS_MovingBrush,
	PHYS_Spider,
	PHYS_Trailer,
	PHYS_Attached
} Physics;

// Parameter to PlayAnim, describing how anim affects movement.
enum EMovement 
{ 
	MOVE_None,				// Do not apply anim movement to actor.
	MOVE_Velocity,			// As above, but scale anim rate by actor velocity.
	MOVE_Anim,				// Apply relative anim movement to actor.
	MOVE_AnimAbs			// Apply absolute world-space anim movement to actor.
};

// Parameter to PlayAnim, describing how anim affects movement.
enum ECombine
{ 
	COMBINE_Replace,		// Replace previous anims.
	COMBINE_Stack,			// Temporarily replace previous anims, until done.
	COMBINE_Modulate		// Modulate previous anim pose with this anim's deltas.
};

// Net variables.
enum ENetRole
{
	ROLE_None,              // No role at all.
	ROLE_DumbProxy,			// Dumb proxy of this actor.
	ROLE_SimulatedProxy,	// Locally simulated proxy of this actor.
	ROLE_AutonomousProxy,	// Locally autonomous proxy of this actor.
	ROLE_Authority,			// Authoritative control over the actor.
};
var ENetRole Role;
var(Networking) ENetRole RemoteRole;
var const transient int NetTag;

// Owner.
var const Actor   Owner;         // Owner actor.
var(Object) name InitialState;
var(Object) name Group;

// Execution and timer variables.
var savable float			TimerRate;		// Timer event, 0=no timer.
var savable const float		TimerCounter;	// Counts up until it reaches TimerRate.
var(Advanced) savable float		  LifeSpan;      // How old the object lives before dying, 0=forever.

// Animation variables.
var(Display) name         AnimSequence;  // Animation sequence we're playing.
										 // In DWI skeletal system, retained for compatibility;
										 // holds name of last sequence played or which just ended.

// Old Unreal anim variables. 
// These are gated in native code with #ifdef UNREAL_ANIM
/*
var bool				  bAnimFinished; // Unlooped animation sequence has finished.
var bool				  bAnimLoop;     // Whether animation is looping.
var bool				  bAnimNotify;   // Whether a notify is applied to the current sequence.
var bool				  bAnimByOwner;	 // Animation dictated by owner.

var(Display) float        AnimFrame;     // Current animation frame, 0.0 to 1.0.
var(Display) float        AnimRate;      // Animation rate in frames per second, 0=none, negative=velocity scaled.
var float                 TweenRate;     // Tween-into rate.
var Animation             SkelAnim;

// Animation control.
var          float        AnimLast;        // Last frame.
var          float        AnimMinRate;     // Minimum rate for velocity-scaled animation.
var			 float		  OldAnimRate;	   // Animation rate of previous animation (= AnimRate until animation completes).
var			 plane		  SimAnim;		   // replicated to simulated proxies.
*/

var(Display) float		  LODBias;		 // Adjust detail level selection. Multiplier, default 1.

//-----------------------------------------------------------------------------
// Structures.

struct SoundProps
{
	var() float Volume;
	var() float Pitch;
	var() float Radius;
	var() float PitchDelta;
	var() float VolumeDelta;
};

// Holds all the specific info related to damage
struct DamageInfo
{
	var float 	Damage;				// Damage Amount (Hitpoints)
	var int 	ManaCost;			// Damage Amount (Hitpoints)
	var name	DamageType;			// Damage Type
	var string	DamageString;		// Damage String - used to construc messages
	var bool	bMagical;			// Damage is magical
	var actor	Deliverer;			// Actor Delivering this damage
	var bool 	bBounceProjectile;	// A projectile delivering this damage needs to be destroyed
	var float	EffectStrength;		// Strength of the secondary effects of being damage
	var name	JointName;			// Name of the joint to apply damage to
	var vector	ImpactForce;		// direction and magnatude of the damage impact on the skeleton
	var float	DamageMultiplier;	// damage multiplier - for head shots.
	var float	DamageRadius;		// radius of area effect (explosive) damage.
	var vector	DamageLocation;		// location of area effect (explosive) damage.
};

// Identifies a unique convex volume in the world.
struct PointRegion
{
	var zoneinfo Zone;       // Zone.
	var int      iLeaf;      // Bsp leaf.
	var byte     ZoneNumber; // Zone number.
};

//-----------------------------------------------------------------------------
// Major actor properties.

// Scriptable.
var       const LevelInfo Level;         // Level this actor is on.
var transient const Level XLevel;        // Level object.
var(Events) savable name  Tag;			 // Actor's tag name.
var(Events) savable name  Event;         // The event this actor causes.
var Actor                 Target;        // Actor we're aiming at (other uses as well).
var Pawn          Instigator;    // Pawn responsible for damage.
var(Sound) sound          AmbientSound;  // Ambient sound effect.
var Inventory             Inventory;     // Inventory chain.
var const Actor           Base;          // Moving actor we're attached to.
var int					  BaseJoint;	 // Joint index of base actor. -1 if none.
var place                 BasePlace;	 // The base-relative placement of the actor, if attached.
var const PointRegion     Region;        // Region this actor is in.
var(Movement)	name	  AttachTag,	 // Which actor/joint to attach to.
						  AttachJointTag;
var() bool				  bSavable;		// Whether this actor should be saved in a save game.

// Internal.
var const byte            StandingCount; // Count of actors standing on this actor.
var const byte            MiscNumber;    // Internal use.
var const byte            LatentByte;    // Internal latent function use.
var const int             LatentInt;     // Internal latent function use.
var const float           LatentFloat;   // Internal latent function use.
var const actor           Touching[8];   // List of touching actors.
var const actor           Deleted;       // Next actor in just-deleted chain.

// Internal tags.
var const transient int CollisionTag, LightingTag, ExtraTag, SpecialTag;
var const transient color	IncidentLight;	// Color (and intensity) of light reaching this actors location.  
											// Only updated if actor drawn.

// The actor's position and rotation.
var(Movement) const savable vector Location;     // Actor's location; use Move to set.
var(Movement) const savable rotator Rotation;    // Rotation.
var       const savable vector    OldLocation;   // Actor's old location one tick ago.
var(Movement) savable vector      Velocity;      // Velocity.

var(Movement) savable rotator	  RotationRate;    // Change in rotation per second.
var(Movement) savable rotator     DesiredRotation; // Physics will rotate pawn to this if bRotateToDesired.



//Editing flags
var(Advanced) bool        bHiddenEd;     // Is hidden during editing.
var(Advanced) bool        bDirectional;  // Actor shows direction arrow during editing.
var const bool            bSelected;     // Selected in UnrealEd.
var const bool            bMemorized;    // Remembered in UnrealEd.
var const bool            bHighlighted;  // Highlighted in UnrealEd.
var bool                  bEdLocked;     // Locked in editor (no movement or rotation).
var(Advanced) bool        bEdShouldSnap; // Snap to grid in editor.
var transient bool        bEdSnap;       // Should snap to grid in UnrealEd.
var transient const bool  bTempEditor;   // Internal UnrealEd.

// What kind of gameplay scenarios to appear in.
var(Filter) bool          bDifficulty0;  // Appear in difficulty 0.
var(Filter) bool          bDifficulty1;  // Appear in difficulty 1.
var(Filter) bool          bDifficulty2;  // Appear in difficulty 2.
var(Filter) bool          bDifficulty3;  // Appear in difficulty 3.
var(Filter) bool          bSinglePlayer; // Appear in single player.
var(Filter) bool          bNet;          // Appear in regular network play.
var(Filter) bool          bNetSpecial;   // Appear in special network play mode.

// set to prevent re-initializing of actors spawned during level startup
var	bool				  bScriptInitialized;

// Editor support.
var Actor				  HitActor;		// Actor to return instead of this one, if hit.

//-----------------------------------------------------------------------------
// Display properties.

// Drawing effect.
var(Display) enum EDrawType
{
	DT_None,
	DT_Sprite,
	DT_Mesh,
	DT_Brush,
	DT_RopeSprite,
	DT_VerticalSprite,
	DT_Terraform,
	DT_SpriteAnimOnce,
	DT_Particles,
} DrawType;

// Style for rendering sprites, meshes.
var(Display) enum ERenderStyle
{
	STY_None,
	STY_Normal,
	STY_Masked,
	STY_Translucent,
	STY_Modulated,
	STY_AlphaBlend,
	STY_Highlight,
	STY_AlphaBlendZ,
} Style;

// Other display properties.
var(Display) texture    Sprite;			 // Sprite texture if DrawType=DT_Sprite.
var(Display) texture    Texture;		 // Misc texture.
var(Display) texture    Skin;            // Special skin or enviro map texture.
var(Display) mesh       Mesh;            // Mesh if DrawType=DT_Mesh.
var	transient animstate	AnimState;		 // Actor's current animation state, if any.
var transient int		ShadowDrawn;	 // Indicates whether this actors shadow has already been drawn.
var(Display) float		ShadowImportance;	// Indicates how important this actors shadow is (0 == not important).
var(Display) float		ShadowRange;	 // Indicates how far away from the object the shadow can be cast.
var transient int		CurrentMRMActorData; // 0 normally, 1 when rendering shadows.
var	transient mrmactordata MRMActorData[2]; // Actor's multi-resolution mesh state, if any.  
var transient float		BoundRenderRadius;	 // Rendering radius of the object. Calculated and adjusted on the fly.
var transient float		BoundRenderDistance; // Max distance the object can be viewed at. Calculated and adjusted on the fly.
											// Slot 0 is main state, 1 is alt. state.
var const export model  Brush;           // Brush if DrawType=DT_Brush.
var(Display) savable float      DrawScale;		 // Scaling factor, 1.0=normal size.
var	transient float		PrevDrawScale;	 // For tracking scaling changes.
var			 vector		PrePivot;		 // Offset from box center for drawing.
var(Display) float      ScaleGlow;		 // Multiplies lighting.
var(Display)  float     VisibilityRadius;// Actor is drawn if viewer is within its visibility
var(Display)  float     VisibilityHeight;// cylinder.  Zero=infinite visibility.
var(Display) byte       AmbientGlow;     // Ambient brightness, or 255=pulsing.
var(Display) byte       Fatness;         // Fatness (mesh distortion).
var(Display) float		SpriteProjForward;// Distance forward to draw sprite from actual location.
var(Display) float		Opacity;		 // Opacity - 0.0 = totally transparent, 1.0 = totally opaque.

// Display.
var(Display)  bool      bUnlit;          // Lights don't affect actor.
var(Display)  bool      bNoSmooth;       // Don't smooth actor's texture.
var(Display)  bool      bParticles;      // Mesh is a particle system.
var(Display)  bool      bRandomFrame;    // Particles use a random texture from among the default texture and the multiskins textures
var(Display)  bool      bMeshEnviroMap;  // Environment-map the mesh.
var(Display)  bool      bMeshCurvy;      // Curvy mesh.
var(Display)  bool		bFilterByVolume; // Filter this sprite by its Visibility volume.
var(Display)  bool      bMRM;            // Allow MRM.
var(Display)  bool		bScryeOnly;	     // Only visible when Scrye is active
var(Display)  bool		bDrawBehindOwner;//	Always draw behind its owner.

// Not yet implemented.
var(Display) bool       bShadowCast;     // Casts shadows.

// Advanced.
var			  bool		bHurtEntry;	     // keep HurtRadius from being reentrant
var(Advanced) bool		bGameRelevant;	 // Always relevant for game
var			  bool		bCarriedItem;	 // being carried, and not responsible for displaying self, so don't replicated location and rotation
var			  bool		bForcePhysicsUpdate; // force a physics update for simulated pawns
var(Advanced) bool        bIsSecretGoal; // This actor counts in the "secret" total.
var(Advanced) bool        bIsKillGoal;   // This actor counts in the "death" toll.
var(Advanced) bool        bIsItemGoal;   // This actor counts in the "item" count.
var(Advanced) bool		  bCollideWhenPlacing; // This actor collides with the world when placing.
var(Advanced) bool		  bTravel;       // Actor is capable of travelling among servers.
var(Advanced) bool		  bMovable;      // Actor is capable of travelling among servers.

// Multiple skin support.
var(Display) lighting Lighting[2];		// Unique lighting materials for this actor.

//-----------------------------------------------------------------------------
// Sound.

// Ambient sound.
var(Sound) bool			bSoundPositional;	// whether or not the sounds appears to be coming from a specific location of if it is truly ambient
var(Sound) bool			bSoundLocked;		// This sound will not be overriden, when true, glxStartSample will use GLX_LOCKED
var(Sound) byte         SoundRadius;		// OuterRadius of ambient sound.  If InnerRadius specified, Falloff will be linear from Radius to RadiusInner
var(Sound) byte			SoundRadiusInner;	// InnerRadius of ambient sound.  Full Volume
var(Sound) savable byte         SoundVolume;		// Volume of amient sound.
var(Sound) savable byte         SoundPitch;			// Sound pitch shift, 64.0=none.
var(Sound) int			SoundFlags;			// Used to hold specialized flag values that will get detected internally

// Regular sounds.
var(Sound) float	TransientSoundVolume;
var(Sound) float	TransientSoundRadius;

var int	LastSoundID;	// since PlaySound called with SLOT_None changes the ID internally we have to store the new value in a variable or
						// change 4-5 functions to return an int or pass in an int reference or pointer.  For now, try the easy way out. 

// Impacts
var(Impact) enum EObjectType
{
	OT_Default,
	OT_Dynamite,
	OT_Molotov,
	OT_Bullet,
	OT_Ectoplasm,
	OT_Skull
} ImpactID;

enum EImpactType
{
	IT_FootStep, 
	IT_Land, 
	IT_Impact,
	IT_Scuff, 
	IT_Slide
};


enum ETextureType
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
};

var			int		LatentSoundId;		// Kyle, stay away!


// Sound slots for actors.
enum ESoundSlot
{
	SLOT_None,
	SLOT_Misc,
	SLOT_Pain,
	SLOT_Interact,
	SLOT_Ambient,
	SLOT_Talk,
	SLOT_Interface,
};

// Music transitions.
enum EMusicTransition
{
	MTRAN_None,
	MTRAN_Instant,
	MTRAN_Segue,
	MTRAN_Fade,
	MTRAN_FastFade,
	MTRAN_SlowFade,
};


// Actuator effects.
enum EActEffects
{
	ACTFX_FadeIn,
	ACTFX_FadeOut,
	ACTFX_StutterSlow,
	ACTFX_StutterNormal,
	ACTFX_StutterFast,
	ACTFX_OscillateSlow,
	ACTFX_OscillateNormal,
	ACTFX_OscillateFast,
	ACTFX_LightShake,
	ACTFX_NormalShake,
	ACTFX_HardShake,
	ACTFX_Quick,
	ACTFX_Manual
};


//-----------------------------------------------------------------------------
// Collision.

// Collision size.
var(Collision) savable const float CollisionRadius; // Radius of collision cyllinder.
var(Collision) savable const float CollisionHeight; // Half-height cyllinder.

// Collision flags.
var(Collision) savable const bool bCollideActors;   // Collides with other actors.
var(Collision) bool	      bCollideJoints;   // If bCollideActors, collides with joints, not collision cyl.
var(Collision) bool		  bCollideSkeleton;	// If bCollideSkeleton is true, collision checks resolve against skeleton, not 
											// collision cylinder.  Difference from bCollideJoints is that bCollideJoints only
											// has effect when set on the checking actor, bCollideSkeleton only has effect when
											// set on the checked actor.
var(Collision) bool       bCollideWorld;    // Collides with the world.
var(Collision) bool       bGroundMesh;		// If bCollideWorld also true, mesh and collision cylinder bottoms 
											// are synced, rather than centers. Should be true for most actors.
var(Collision) savable bool       bBlockActors;	    // Blocks other nonplayer actors.
var(Collision) savable bool       bBlockPlayers;    // Blocks other player actors.
var(Collision) bool       bProjTarget;      // Projectiles should potentially target this actor.

//-----------------------------------------------------------------------------
// Lighting.

// Light modulation.
var(Lighting) enum ELightType
{
	LT_None,
	LT_Steady,
	LT_Pulse,
	LT_Blink,
	LT_Flicker,
	LT_Strobe,
	LT_BackdropLight,
	LT_SubtlePulse,
	LT_TexturePaletteOnce,
	LT_TexturePaletteLoop
} LightType;

// Spatial light effect to use.
var(Lighting) enum ELightEffect
{
	LE_None,
	LE_TorchWaver,
	LE_FireWaver,
	LE_WateryShimmer,
	LE_Searchlight,
	LE_SlowWave,
	LE_FastWave,
	LE_CloudCast,
	LE_StaticSpot,
	LE_Shock,
	LE_Disco,
	LE_Warp,
	LE_Spotlight,
	LE_NonIncidence,
	LE_Shell,
	LE_OmniBumpMap,
	LE_Interference,
	LE_Cylinder,
	LE_Rotor,
	LE_Unused
} LightEffect;

// Lighting info.
var(LightColor) savable byte
	LightBrightness,
	LightHue,
	LightSaturation;

var(Lighting) byte
	LightRadius,						// Sqrt of world radius.
	LightRadiusInner,					// Fraction of outer radius.
	LightPeriod,
	LightPhase,
	LightCone,							// Angular distribution (max = spherical).
	LightConeInner,
	VolumeBrightness,
	VolumeRadius,
	VolumeFog;

// Lighting.
var(Lighting) bool	     bSpecialLit;	// Only affects special-lit surfaces.
var(Lighting) bool	     bActorShadows;	// Light casts actor shadows.
var(Lighting) bool	     bCorona;		// Light uses Skin as a corona.
var(Lighting) bool	     bLensFlare;	// Whether to use zone lens flare.
var(LightColor) bool	 bDarkLight;	// Whether lighting is subtractive.
var(Lighting) enum ELightSource
{
	LD_Point,							// Regular point light.
	LD_Plane,							// Parallel light.
	LD_Ambient							// All directions equally.
} LightSource;

//-----------------------------------------------------------------------------
// Physics.

// Options.
var(Movement) bool        bBounce;           // Bounces when hits ground fast.
var(Movement) bool		  bFixedRotationDir; // Fixed direction of rotation.
var(Movement) bool		  bRotateToDesired;  // Rotate to DesiredRotation.
var           savable bool        bInterpolating;    // Performing interpolating.
var			  const bool  bJustTeleported;   // Used by engine physics - not valid for scripts.

// Physics properties.
var(Movement) float       Mass;            // Mass of this actor.
var savable   float       PhysAlpha;       // Interpolating position, 0.0-1.0.
var savable   float       PhysRate;        // Interpolation rate per second.

//-----------------------------------------------------------------------------
// Networking.

// Network control.
var(Networking) float NetPriority; // Higher priorities means update it more frequently.
var(Networking) float NetUpdateFrequency; // How many seconds between net updates.

// Symmetric network flags, valid during replication only.
var const bool bNetInitial;       // Initial network update.
var const bool bNetOwner;         // Player owns this actor.
var const bool bNetRelevant;      // Actor is currently relevant. Only valid server side, only when replicating variables.
var const bool bNetSee;           // Player sees it in network play.
var const bool bNetHear;          // Player hears it in network play.
var const bool bNetFeel;          // Player collides with/feels it in network play.
var const bool bSimulatedPawn;	  // True if Pawn and simulated proxy.
var const bool bDemoRecording;	  // True we are currently demo recording
var const bool bClientDemoRecording;// True we are currently recording a client-side demo
var const bool bClientDemoNetFunc;// True if we're client-side demo recording and this call originated from the remote.

//Debug 
var bool bShowDebugInfo;

// Hit location information
var int LastJointHit;			// last joint hit by Trace

//-----------------------------------------------------------------------------
// Enums.

// Travelling from server to server.
enum ETravelType
{
	TRAVEL_Absolute,	// Absolute URL.
	TRAVEL_Partial,		// Partial (carry name, reset server).
	TRAVEL_Relative,	// Relative URL.
};

// Input system states.
enum EInputAction
{
	IST_None,    // Not performing special input processing.
	IST_Press,   // Handling a keypress or button press.
	IST_Hold,    // Handling holding a key or button.
	IST_Release, // Handling a key or button release.
	IST_Axis,    // Handling analog axis movement.
};

// Input keys.
enum EInputKey
{
/*00*/	IK_None			,IK_LeftMouse	,IK_RightMouse	,IK_Cancel		,
/*04*/	IK_MiddleMouse	,IK_Unknown05	,IK_Unknown06	,IK_Unknown07	,
/*08*/	IK_Backspace	,IK_Tab         ,IK_Unknown0A	,IK_Unknown0B	,
/*0C*/	IK_Unknown0C	,IK_Enter	    ,IK_Unknown0E	,IK_Unknown0F	,
/*10*/	IK_Shift		,IK_Ctrl	    ,IK_Alt			,IK_Pause       ,
/*14*/	IK_CapsLock		,IK_Unknown15	,IK_Unknown16	,IK_Unknown17	,
/*18*/	IK_Unknown18	,IK_Unknown19	,IK_Unknown1A	,IK_Escape		,
/*1C*/	IK_Unknown1C	,IK_Unknown1D	,IK_Unknown1E	,IK_Unknown1F	,
/*20*/	IK_Space		,IK_PageUp      ,IK_PageDown    ,IK_End         ,
/*24*/	IK_Home			,IK_Left        ,IK_Up          ,IK_Right       ,
/*28*/	IK_Down			,IK_Select      ,IK_Print       ,IK_Execute     ,
/*2C*/	IK_PrintScrn	,IK_Insert      ,IK_Delete      ,IK_Help		,
/*30*/	IK_0			,IK_1			,IK_2			,IK_3			,
/*34*/	IK_4			,IK_5			,IK_6			,IK_7			,
/*38*/	IK_8			,IK_9			,IK_Unknown3A	,IK_Unknown3B	,
/*3C*/	IK_Unknown3C	,IK_Unknown3D	,IK_Unknown3E	,IK_Unknown3F	,
/*40*/	IK_Unknown40	,IK_A			,IK_B			,IK_C			,
/*44*/	IK_D			,IK_E			,IK_F			,IK_G			,
/*48*/	IK_H			,IK_I			,IK_J			,IK_K			,
/*4C*/	IK_L			,IK_M			,IK_N			,IK_O			,
/*50*/	IK_P			,IK_Q			,IK_R			,IK_S			,
/*54*/	IK_T			,IK_U			,IK_V			,IK_W			,
/*58*/	IK_X			,IK_Y			,IK_Z			,IK_Unknown5B	,
/*5C*/	IK_Unknown5C	,IK_Unknown5D	,IK_Unknown5E	,IK_Unknown5F	,
/*60*/	IK_NumPad0		,IK_NumPad1     ,IK_NumPad2     ,IK_NumPad3     ,
/*64*/	IK_NumPad4		,IK_NumPad5     ,IK_NumPad6     ,IK_NumPad7     ,
/*68*/	IK_NumPad8		,IK_NumPad9     ,IK_GreyStar    ,IK_GreyPlus    ,
/*6C*/	IK_Separator	,IK_GreyMinus	,IK_NumPadPeriod,IK_GreySlash   ,
/*70*/	IK_F1			,IK_F2          ,IK_F3          ,IK_F4          ,
/*74*/	IK_F5			,IK_F6          ,IK_F7          ,IK_F8          ,
/*78*/	IK_F9           ,IK_F10         ,IK_F11         ,IK_F12         ,
/*7C*/	IK_F13			,IK_F14         ,IK_F15         ,IK_F16         ,
/*80*/	IK_F17			,IK_F18         ,IK_F19         ,IK_F20         ,
/*84*/	IK_F21			,IK_F22         ,IK_F23         ,IK_F24         ,
/*88*/	IK_Unknown88	,IK_Unknown89	,IK_Unknown8A	,IK_Unknown8B	,
/*8C*/	IK_Unknown8C	,IK_Unknown8D	,IK_Unknown8E	,IK_Unknown8F	,
/*90*/	IK_NumLock		,IK_ScrollLock  ,IK_Unknown92	,IK_Unknown93	,
/*94*/	IK_Unknown94	,IK_Unknown95	,IK_Unknown96	,IK_Unknown97	,
/*98*/	IK_Unknown98	,IK_Unknown99	,IK_Unknown9A	,IK_Unknown9B	,
/*9C*/	IK_Unknown9C	,IK_Unknown9D	,IK_Unknown9E	,IK_Unknown9F	,
/*A0*/	IK_LShift		,IK_RShift      ,IK_LControl    ,IK_RControl    ,
/*A4*/	IK_UnknownA4	,IK_UnknownA5	,IK_UnknownA6	,IK_UnknownA7	,
/*A8*/	IK_UnknownA8	,IK_UnknownA9	,IK_UnknownAA	,IK_UnknownAB	,
/*AC*/	IK_UnknownAC	,IK_UnknownAD	,IK_UnknownAE	,IK_UnknownAF	,
/*B0*/	IK_UnknownB0	,IK_UnknownB1	,IK_UnknownB2	,IK_UnknownB3	,
/*B4*/	IK_UnknownB4	,IK_UnknownB5	,IK_UnknownB6	,IK_UnknownB7	,
/*B8*/	IK_UnknownB8	,IK_UnknownB9	,IK_Semicolon	,IK_Equals		,
/*BC*/	IK_Comma		,IK_Minus		,IK_Period		,IK_Slash		,
/*C0*/	IK_Tilde		,IK_UnknownC1	,IK_UnknownC2	,IK_UnknownC3	,
/*C4*/	IK_UnknownC4	,IK_UnknownC5	,IK_UnknownC6	,IK_UnknownC7	,
/*C8*/	IK_Joy1	        ,IK_Joy2	    ,IK_Joy3	    ,IK_Joy4	    ,
/*CC*/	IK_Joy5	        ,IK_Joy6	    ,IK_Joy7	    ,IK_Joy8	    ,
/*D0*/	IK_Joy9	        ,IK_Joy10	    ,IK_Joy11	    ,IK_Joy12		,
/*D4*/	IK_Joy13		,IK_Joy14	    ,IK_Joy15	    ,IK_Joy16	    ,
/*D8*/	IK_UnknownD8	,IK_UnknownD9	,IK_UnknownDA	,IK_LeftBracket	,
/*DC*/	IK_Backslash	,IK_RightBracket,IK_SingleQuote	,IK_UnknownDF	,
/*E0*/  IK_JoyX			,IK_JoyY		,IK_JoyZ		,IK_JoyR		,
/*E4*/	IK_MouseX		,IK_MouseY		,IK_MouseZ		,IK_MouseW		,
/*E8*/	IK_JoyU			,IK_JoyV		,IK_UnknownEA	,IK_UnknownEB	,
/*EC*/	IK_MWheelUp		,IK_MWheelDown	,IK_Unknown10E,UK_Unknown10F  ,
/*F0*/	IK_JoyPovUp     ,IK_JoyPovDown	,IK_JoyPovLeft	,IK_JoyPovRight	,
/*F4*/	IK_UnknownF4	,IK_UnknownF5	,IK_Attn		,IK_CrSel		,
/*F8*/	IK_ExSel		,IK_ErEof		,IK_Play		,IK_Zoom		,
/*FC*/	IK_NoName		,IK_PA1			,IK_OEMClear
};

var(Display) class<RenderIterator> RenderIteratorClass;	// class to instantiate as the actor's RenderInterface
var transient RenderIterator RenderInterface;		// abstract iterator initialized in the Rendering engine

//-----------------------------------------------------------------------------
// natives.

// Execute a console command in the context of the current level and game engine.
native function string ConsoleCommand( string Command );


//------------------------------------------------------------------------------
// Saved Games

native(2002) final function bool SaveGameToMemoryCard( MemoryCard card );
native(2003) final function bool LoadGameFromMemoryCard( MemoryCard card );
native(2004) final function bool SaveGame( int slot );
native(2005) final function bool LoadGame( int slot );
native(2006) final function int GetSaveGameSize();
native(2032) final function string GetSaveGameList();

//-----------------------------------------------------------------------------
// Network replication.

replication
{
	// Relationships.
	unreliable if( Role==ROLE_Authority )
		Owner, Role, RemoteRole;
	unreliable if( bNetOwner && Role==ROLE_Authority )
		bNetOwner, Inventory;
	unreliable if( bReplicateInstigator && (RemoteRole>=ROLE_SimulatedProxy) && (Role==ROLE_Authority) )
		Instigator;

	// Ambient sound.
	unreliable if( (Role==ROLE_Authority) && (!bNetOwner || !bClientAnim) )
		AmbientSound;
	unreliable if( AmbientSound!=None && Role==ROLE_Authority  && (!bNetOwner || !bClientAnim) )
		SoundRadius, SoundVolume, SoundPitch;
	unreliable if( bDemoRecording )
		DemoPlaySound;

	// Collision.
	unreliable if( Role==ROLE_Authority )
		bCollideActors, bCollideJoints, bCollideWorld;
	unreliable if( (bCollideActors || bCollideWorld) && Role==ROLE_Authority )
		bProjTarget, bBlockActors, bBlockPlayers, CollisionRadius, CollisionHeight;

	// Location.
	unreliable if( !bCarriedItem && (bNetInitial || bSimulatedPawn || RemoteRole<ROLE_SimulatedProxy) && Role==ROLE_Authority )
		Location;
	unreliable if( !bCarriedItem && (DrawType==DT_Mesh || DrawType==DT_Brush || DrawType==DT_Particles) && (bNetInitial || bSimulatedPawn || RemoteRole<ROLE_SimulatedProxy) && Role==ROLE_Authority )
		Rotation;
	
	unreliable if( RemoteRole==ROLE_SimulatedProxy)
		Base, BaseJoint, BasePlace;

	// Velocity.
	unreliable if( bSimFall || ((RemoteRole==ROLE_SimulatedProxy && (bNetInitial || bSimulatedPawn)) || bIsMover) )
		Velocity;

	// Physics.
	unreliable if( bSimFall || (RemoteRole==ROLE_SimulatedProxy && bNetInitial && !bSimulatedPawn) )
		Physics, bBounce;
	unreliable if( RemoteRole==ROLE_SimulatedProxy && Physics==PHYS_Rotating && bNetInitial )
		bFixedRotationDir, bRotateToDesired, RotationRate, DesiredRotation;
		
	// Animation. 
	unreliable if( DrawType==DT_Mesh && ((RemoteRole<=ROLE_SimulatedProxy && (!bNetOwner || !bClientAnim)) || bDemoRecording) )
		AnimSequence;

	//reliable if( Role<ROLE_Authority )
	//	PlayAnim, LoopAnim;
	
	//unreliable if( DrawType==DT_Mesh && (RemoteRole<=ROLE_SimulatedProxy && (!bNetOwner || !bClientAnim)) )
	//	AnimSequence;
	
	
	
	// Rendering.
	unreliable if( Role==ROLE_Authority )
		bHidden, bOnlyOwnerSee;
	unreliable if( Role==ROLE_Authority )
		Texture, DrawScale, DrawType, Style, Opacity;
	unreliable if( DrawType==DT_Sprite && !bHidden && (!bOnlyOwnerSee || bNetOwner) && Role==ROLE_Authority)
		Sprite;
	unreliable if( DrawType==DT_Mesh && Role==ROLE_Authority )
		Mesh, PrePivot, bMeshEnviroMap, Skin, Fatness, AmbientGlow, ScaleGlow, bUnlit, bScryeOnly;
	unreliable if( DrawType==DT_Brush && Role==ROLE_Authority )
		Brush;

	// Lighting.
	unreliable if( Role==ROLE_Authority )
		LightType;
	unreliable if( LightType!=LT_None && Role==ROLE_Authority )
		LightEffect, LightBrightness, LightHue, LightSaturation, bDarkLight,
		LightRadius, LightRadiusInner, LightSource, 
		LightPeriod, LightPhase,
		VolumeBrightness, VolumeRadius,
		bSpecialLit;

	// Messages
	reliable if( Role<ROLE_Authority )
		BroadcastMessage, BroadcastLocalizedMessage;
}

//=============================================================================
// Actor error handling.

// Handle an error and kill this one actor.
native(233) final function Error( coerce string S );

//=============================================================================
// General functions.

// Latent functions.
native(256) final latent function Sleep( float Seconds );

// Collision.
native(262) final function SetCollision( optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers );
native(283) final function bool SetCollisionSize( float NewRadius, float NewHeight );

final function float DefaultCollisionHeight()
{
	return Default.CollisionHeight * DrawScale;
}
final function float DefaultCollisionRadius()
{
	return Default.CollisionRadius * DrawScale;
}

// Movement.
native(266) final function bool Move( vector Delta );
native(267) final function bool SetLocation( vector NewLocation );
native(299) final function bool SetRotation( rotator NewRotation );
native(3969) final function bool MoveSmooth( vector Delta );
native(3971) final function AutonomousPhysics(float DeltaSeconds);

// Appearance.
native(313) final function bool SetTexture( int Slot, texture NewTexture);
native(334) final function texture GetTexture( int Slot );
native(321) final function bool LoadTextureFromBMP(texture Tex, string PathToBMP);
native(322) final function ResetLightCache();

// Relations.
native(298) final function SetBase( actor NewBase, optional name BaseLoc, optional name SelfLoc );
native(272) final function SetOwner( actor NewOwner );

//=============================================================================
// Animation.

// Joint functions.
native(411) final function int NumJoints();
native(412) final function name JointName( int iJoint );
native(413) final function int JointIndex( name JointName );
native(414) final function place JointPlace( name JointName );
native(415) final function vector StaticJointDir( name BodyLoc, vector Dir );
native(416) final function int JointParent( int iJoint );

// Animation functions.
native(259) final function bool PlayAnim( name Sequence, optional float Rate, optional EMovement move, optional ECombine combine, optional float TweenTime, optional name JointName, optional bool AboveJoint, optional bool OverrideTarget );
native(274) exec final function int PlayAnimSound( name Sequence, sound Voice, optional float Amplitude, optional ESoundSlot Slot, optional float Volume, optional bool bNoOverride, optional float Radius, optional float Pitch, optional int Flags );
native(260) exec final function bool LoopAnim( name Sequence, optional float Rate, optional EMovement move, optional ECombine combine, optional float TweenTime, optional name JointName, optional bool AboveJoint, optional bool OverrideTarget );
native(294) exec final function bool TweenAnim( name Sequence, optional float Time, optional bool bCheckNotifys );

final function ClearAnims()
{
	PlayAnim('');
}

native(282) final function bool IsAnimating();
native(292) final function bool IsAnimResting();
native(293) final function name GetAnimGroup( name Sequence );
native(261) final latent function FinishAnim();
native(263) final function bool HasAnim( name Sequence );
native(420) final function place AnimMoveRate();
native(422) exec final function ListAnims();
native(423) final function float GetNotifyTime( name Sequence, optional name NotifyFunction, optional float StartTime );
native(424) final function ApplyAnim();

// Animation notifications.
event AnimEnd();

// Skeletal targeting functions.
native(405) final function AddTargetPos( name BodyLoc, vector Pos, optional bool bPersistent, optional bool bIgnoreConstraints );
native(406) final function AddTargetRot( name BodyLoc, quat Rot, optional bool bPersistent, optional bool bIgnoreConstraints );
native(407) final function ClearTarget( name BodyLoc );
native(408) final function ClearTargets( );

final function LookAt( name JointName, vector Dir, optional bool bPersistent )
{
	// Apply a rotation bias to point the actor's facing direction at Dir, using actor Z as the primary rotation axis.
	AddTargetRot( JointName, RotateTo( 
		vect(1,0,0) << Rotation, 
		Dir, 
		vect(0,0,1) << Rotation
		), bPersistent );
}

// Skeletal dynamics.
native(426) final function AddDynamic ( name JointName, optional vector Loc, optional vector Impulse, optional float Duration );

// Other skeletal functions.

// Destroy the limb of a skeletal actor.
native(409) exec final function DestroyLimb( name BodyLoc );

// Remove the limb of a skeletal actor, creating new object from it.
native(410) exec final function actor DetachLimb( name BodyLoc, class<actor> SpawnClass );

// Applies some sort of modification to an actor.
native(421) exec final function ApplyMod( name JointName, class<modifier> Mod );

// Disable collision on a limb or limb tree.
native(417) exec final function SetLimbTangible( name Joint, bool tangible, optional bool all );


// Skeletal animation linkup.
// native final function LinkSkelAnim( Animation Anim );

//=========================================================================
// Physics.

// Physics control.
native(301) final latent function FinishInterpolation();
native(3970) final function SetPhysics( EPhysics newPhysics );

//=============================================================================
// Engine notification functions.

//
// Major notifications.
//
event Spawned();
event Destroyed();
event Expired();
event GainedChild( Actor Other );
event LostChild( Actor Other );
event Tick( float DeltaTime );
event Warped(vector OldLocation);

//
// Triggers.
//
event Trigger( Actor Other, Pawn EventInstigator );
event UnTrigger( Actor Other, Pawn EventInstigator );
event BeginEvent();
event EndEvent();

//
// Physics & world interaction.
//
event Timer();
event HitWall( vector HitNormal, actor HitWall, byte TextureID );
event Falling();
event Landed( vector HitNormal );
event ZoneChange( ZoneInfo NewZone );
event Touch( Actor Other );
event UnTouch( Actor Other );
event Bump( Actor Other );
event BaseChange();
event Attach( Actor Other );
event Detach( Actor Other );
event KillCredit( Actor Other );
event Actor SpecialHandling(Pawn Other);
event bool EncroachingOn( actor Other );
event EncroachedBy( actor Other );
event InterpolateEnd( actor Other );

// Shadow support
event Actor HeldPropRequest(int idx);

event FellOutOfWorld()
{
	SetPhysics(PHYS_None);
	Destroy();
}	

//
// Damage and kills.
//
event KilledBy( pawn EventInstigator );

// Take Damage
event TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo);

// Override this function elsewhere to disallow specific damage types
function bool AcceptDamage(DamageInfo DInfo)
{
	return true;
}

function ProjectileHit(Pawn Instigator, vector HitLocation, vector Momentum, projectile proj, DamageInfo DInfo)
{
	local vector HitNormal;

	// log("ProjectileHit: "$self);
	if ( AcceptDamage(DInfo) )
	{
		TakeDamage(Instigator, HitLocation, Momentum, DInfo);
		if ( !DInfo.bBounceProjectile )
			proj.Explode(HitLocation, HitNormal);
	}
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.DamageMultiplier = 1.0;
	return DInfo;	
}

//
// Trace a line and see what it collides with first.
// Takes this actor's collision properties into account.
// Returns first hit actor, Level if hit level, or None if hit nothing.
//
native(277) final function Actor Trace
(
	out vector      HitLocation,
	out vector      HitNormal,
	out int			HitJoint,
	vector          TraceEnd,
	optional vector TraceStart,
	optional bool   bTraceActors,
	optional bool   bIgnorePermeable,
	optional vector Extent
);

// returns true if did not hit world geometry
native(548) final function bool FastTrace
(
	vector          TraceEnd,
	optional vector TraceStart
);

native(285) final function Texture TraceTexture
(

	vector TraceEnd,
	vector TraceStart,
	out int Flags,
	optional bool bTraceDecals
	//P_GET_VECTOR_REF(ScrollDir);	
);

//
// Spawn an actor. Returns an actor of the specified class, not
// of class Actor (this is hardcoded in the compiler). Returns None
// if the actor could not be spawned (either the actor wouldn't fit in
// the specified location, or the actor list is full).
// Defaults to spawning at the spawner's location.
//
native(278) final function actor Spawn
(
	class<actor>      SpawnClass,
	optional actor	  SpawnOwner,
	optional name     SpawnTag,
	optional vector   SpawnLocation,
	optional rotator  SpawnRotation
);

//
// Destroy this actor. Returns true if destroyed, false if indestructable.
// Destruction is latent. It occurs at the end of the tick.
//
native(279) final function bool Destroy();

//=============================================================================
// Timing.

// Causes Timer() events every NewTimerRate seconds.
native(280) final function SetTimer( float NewTimerRate, bool bLoop );

//=============================================================================
// Sound functions.

// Play a sound effect.
native(264) final function int PlaySound
(
	sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch,
	optional int		Flags
);

// Stop a Sound given the Id
native(265) final function StopSound
(
	int Id
);

// play a sound effect, but don't propagate to a remote owner
// (he is playing the sound clientside
native simulated final function PlayOwnedSound
(
	sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch,
	optional int		Flags
);

native simulated event DemoPlaySound
(
	sound				Sound,
	optional ESoundSlot Slot,
	optional float		Volume,
	optional bool		bNoOverride,
	optional float		Radius,
	optional float		Pitch,
	optional int		Flags
);

// Get a sound duration.
native final function float GetSoundDuration( sound Sound );

native(402) final latent function FinishSound
(
	//rb maybe use a Sound pointer in addition / instead ?
	int Id
);

native(400) final function PlayImpactSound
( 
	int Slot, //fix slot should be the same no matter what ? 
	texture HitTexture, 
	byte ImpactType, 
	vector Location, 
	optional float Volume, 
	optional float Radius, 
	optional float Pitch 
);

function Dust(vector HitLocation, vector HitNormal, Texture T, float StrengthMultiplier)
{
	local Actor A;
	local class<ParticleFX> ParticleClass;

	if (T == none)
		return;

	if ( T.EffectClass == none )
	{
		switch( T.ImpactID )
		{
			// no ParticleClass
			case TID_Carpet:	
			case TID_Glass:
			case TID_WoodHollow:
			case TID_WoodSolid:
			case TID_Stone:
			case TID_Metal:
			case TID_Default:
					break;
			
			case TID_Water:
				ParticleClass = class'Engine.GenWaterTextureHitFX';
				break;

			// Dirt FX
			case TID_Extra1:	// Bones
			case TID_Leaves:
			case TID_Grass:
			case TID_Earth:
				ParticleClass = class'Engine.GenDirtTextureHitFX';
				break;

			// SnowFX
			case TID_Snow:
				ParticleClass = class'Engine.GenSnowTextureHitFX';
				break;

			// Blood FX
			case TID_Organic:
				ParticleClass = class'Engine.GenBloodTextureHitFX';
				break;

			// Sand FX
			case TID_Sand:
				ParticleClass = class'Engine.GenSandTextureHitFX';
				break;
		}
		
		if (ParticleClass != none)
		{
			A = Spawn(ParticleClass,,,HitLocation, Rotator(HitNormal));
			if ( A.IsA('ParticleFX') ) 
			{
				ParticleFX(A).ColorStart.Base = T.MipZero;
				ParticleFX(A).Speed.Base = ParticleFX(A).default.Speed.Base * T.Dustiness * StrengthMultiplier;
				ParticleFX(A).Speed.Rand = ParticleFX(A).default.Speed.Rand * T.Dustiness * StrengthMultiplier;
				ParticleFX(A).ParticlesPerSec.Base = 1024;
			}
		}
	} else {
		A = Spawn(T.EffectClass,,,HitLocation, Rotator(HitNormal));
		if ( A.IsA('ParticleFX') ) 
		{
			ParticleFX(A).ColorStart.Base = T.MipZero;
			ParticleFX(A).Speed.Base = ParticleFX(A).default.Speed.Base * T.Dustiness * StrengthMultiplier;
			ParticleFX(A).Speed.Rand = ParticleFX(A).default.Speed.Rand * T.Dustiness * StrengthMultiplier;
			ParticleFX(A).ParticlesPerSec.Base = 1024;
		}
	}
}

// 
function int Dispel(optional bool bCheck)
{
	return -1;
}

//=============================================================================
// Actuator functions.

//
// Wrapper function for actuator support.
//
function int PlayActuator(PlayerPawn PPawn, int Effect, optional float Duration, optional float Intensity, optional int ActIndex)
{
	local int retVal;
	//log("Entering Play Actuator");

	if ( PPawn.bVibrateOn )
	{
		switch (Effect)
		{
			case EActEffects.ACTFX_FadeIn:
			case EActEffects.ACTFX_FadeOut:
			case EActEffects.ACTFX_StutterSlow:		
			case EActEffects.ACTFX_StutterNormal:
			case EActEffects.ACTFX_StutterFast:
			case EActEffects.ACTFX_OscillateSlow:
			case EActEffects.ACTFX_OscillateNormal:
			case EActEffects.ACTFX_OscillateFast:
			case EActEffects.ACTFX_LightShake:
			case EActEffects.ACTFX_NormalShake:
			case EActEffects.ACTFX_HardShake:
			case EActEffects.ACTFX_Quick:
				//log ("Entering Normal Effect");
				retVal = PPawn.ActivateActuator (0, Effect, 0.0f, Duration);
				break;

			case EActEffects.ACTFX_Manual:
				//log ("Entering Manual Effect");
				retVal = PPawn.ActivateActuator (ActIndex, Effect, Intensity, Duration);
				break;

			default:
				//log ("Entering Default Effect");
				retVal = PPawn.ActivateActuator (ActIndex, Effect, Intensity, Duration);
				break;
		}
	}
	else
	{
		Log("Vibrate called, but user disabled it!");
	}

	return retVal;
}


//=============================================================================
// AI functions.

//
// Inform other creatures that you've made a noise
// they might hear (they are sent a HearNoise message)
// Senders of MakeNoise should have an instigator if they are not pawns.
//
native(512) final function MakeNoise( float Loudness, optional float Radius );

//
// PlayerCanSeeMe returns true if some player has a line of sight to 
// actor's location.
//
native(532) final function bool PlayerCanSeeMe();

//=============================================================================
// Regular engine functions.

event ScryeBegin(PlayerPawn P);		// player has begun scrying
event ScryeEnd(PlayerPawn P);		// player has finished scrying

// Teleportation.
event bool PreTeleport( Teleporter InTeleporter );
event PostTeleport( Teleporter OutTeleporter );

// Level state.
event BeginPlay();

//========================================================================
// Misc. 
native(542) final function UnloadTexture( texture T );

//========================================================================
// Disk access.

// Find files.
native(539) final function string GetMapName( string NameEnding, string MapName, int Dir );
native(545) final function GetNextSkin( string Prefix, string CurrentSkin, int Dir, out string SkinName, out string SkinDesc );
native(547) final function string GetURLMap();
native final function string GetNextInt( string ClassName, int Num );
native final function GetNextIntDesc( string ClassName, int Num, out string Entry, out string Description );
native final function bool GetCacheEntry( int Num, out string GUID, out string Filename );
native final function bool MoveCacheEntry( string GUID, optional string NewFilename );  


//=============================================================================
// Iterator functions.

// Iterator functions for dealing with sets of actors.
native(304) final iterator function AllActors     ( class<actor> BaseClass, out actor Actor, optional name MatchTag );
native(305) final iterator function ChildActors   ( class<actor> BaseClass, out actor Actor );
native(306) final iterator function BasedActors   ( class<actor> BaseClass, out actor Actor );
native(307) final iterator function TouchingActors( class<actor> BaseClass, out actor Actor );
native(309) final iterator function TraceActors   ( class<actor> BaseClass, out actor Actor, out vector HitLoc, out vector HitNorm, out int HitJoint, vector End, optional vector Start, optional bool bTraceActors, optional bool bIgnorePermeable, optional vector Extent );
native(310) final iterator function RadiusActors  ( class<actor> BaseClass, out actor Actor, float Radius, optional vector Loc );
native(311) final iterator function VisibleActors ( class<actor> BaseClass, out actor Actor, optional float Radius, optional vector Loc );
native(312) final iterator function VisibleCollidingActors ( class<actor> BaseClass, out actor Actor, optional float Radius, optional vector Loc, optional bool bIgnoreHidden );

//=============================================================================
// Color operators
native(549) static final operator(20)  color -     ( color A, color B );
native(550) static final operator(16) color *     ( float A, color B );
native(551) static final operator(20) color +     ( color A, color B );
native(552) static final operator(16) color *     ( color A, float B );

//=============================================================================
// Scripted Actor functions.

// draw on canvas before flash and fog are applied (used for drawing weapons)
event RenderOverlays( canvas Canvas );

//
// Called immediately before gameplay begins.
//
event PreBeginPlay()
{
	// Handle autodestruction if desired.
	if( !bGameRelevant && (Level.NetMode != NM_Client) && !Level.Game.IsRelevant(Self) )
		Destroy();
}

//
// Broadcast a message to all players.
//
event BroadcastMessage( coerce string Msg, optional bool bBeep, optional name Type )
{
	local Pawn P;

	if (Type == '')
		Type = 'Event';

	if ( Level.Game.AllowsBroadcast(self, Len(Msg)) )
		for( P=Level.PawnList; P!=None; P=P.nextPawn )
			if( P.bIsPlayer || P.IsA('MessagingSpectator') )
			{
				if ( (Level.Game != None) && (Level.Game.MessageMutator != None) )
				{
					if ( Level.Game.MessageMutator.MutatorBroadcastMessage(Self, P, Msg, bBeep, Type) )
						P.ClientMessage( Msg, Type, bBeep );
				} else
					P.ClientMessage( Msg, Type, bBeep );
			}
}

//
// Broadcast a localized message to all players.
// Most message deal with 0 to 2 related PRIs.
// The LocalMessage class defines how the PRI's and optional actor are used.
//
event BroadcastLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	local Pawn P;

	for ( P=Level.PawnList; P != None; P=P.nextPawn )
		if ( P.bIsPlayer || P.IsA('MessagingSpectator') )
		{
			if ( (Level.Game != None) && (Level.Game.MessageMutator != None) )
			{
				if ( Level.Game.MessageMutator.MutatorBroadcastLocalizedMessage(Self, P, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject) )
					P.ReceiveLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
			} else
				P.ReceiveLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
		}
}

//
// Called immediately after gameplay begins.
//
event PostBeginPlay();

// This actor has just been loaded from a Save game
event PostLoadGame();

// Event that after PostBeginPlay AND PostLoadGame
event StartLevel();

event PlayerReady(PlayerPawn Player);

//
// Called after PostBeginPlay.
//
simulated event SetInitialState()
{
	bScriptInitialized = true;
	if( InitialState!='' )
		GotoState( InitialState );
	else
		GotoState( 'Auto' );
}

// called after PostBeginPlay on net client
simulated event PostNetBeginPlay();


//
// Hurt actors within the radius.
//
function HurtRadius( float DamageRadius, name DamageName, float Momentum, vector HitLocation, DamageInfo DInfo )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir, HurtLocation, jointDir;
	local float jointDist;
	local int i;
	local name closestJointName;
	local float SourceDamage;
	
	SourceDamage = DInfo.Damage;

	if( bHurtEntry )
		return;

	if( DInfo.DamageRadius == 0.0 )
		DInfo.DamageRadius = DamageRadius;

	if( DInfo.DamageLocation == vect(0,0,0) )
		DInfo.DamageLocation = HitLocation;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( Victims != self )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;

			if( Victims.bCollideSkeleton )
			{
				HurtLocation = HitLocation;
				damageScale = 1.0;
			}
			else
			{
				HurtLocation = Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir;
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			}

			DInfo.Damage = SourceDamage * damageScale;
			Victims.TakeDamage (
				Instigator,
				HurtLocation,
				(damageScale * Momentum * dir),
				DInfo
			);
		} 
	}
	bHurtEntry = false;
}

//
// Called when carried onto a new level, before AcceptInventory.
//
event TravelPreAccept();

//
// Called when carried into a new level, after AcceptInventory.
//
event TravelPostAccept();

//
// Called when a scripted texture needs rendering
//
event RenderTexture(ScriptedTexture Tex);

//
// Called by PlayerPawn when this actor becomes its ViewTarget.
//
function BecomeViewTarget();

//
// Returns the string representation of the name of an object without the package
// prefixes.
//
function String GetItemName( string FullName )
{
	local int pos;

	pos = InStr(FullName, ".");
	While ( pos != -1 )
	{
		FullName = Right(FullName, Len(FullName) - pos - 1);
		pos = InStr(FullName, ".");
	}

	return FullName;
}

//
// Returns the human readable string representation of an object.
//

function String GetHumanName()
{
	return GetItemName(string(class));
}

// Set the display properties of an actor.  By setting them through this function, it allows
// the actor to modify other components (such as a Pawn's weapon) or to adjust the result
// based on other factors (such as a Pawn's other inventory wanting to affect the result)
function SetDisplayProperties(ERenderStyle NewStyle, texture NewTexture, bool bLighting, bool bEnviroMap )
{
	Style = NewStyle;
	texture = NewTexture;
	bUnlit = bLighting;
	bMeshEnviromap = bEnviromap;
}

function SetDefaultDisplayProperties()
{
	Style = Default.Style;
	texture = Default.Texture;
	bUnlit = Default.bUnlit;
	bMeshEnviromap = Default.bMeshEnviromap;
}

//=============================================================================
// Multiskin support
static function SetMultiSkin( playerpawn SkinActor, string SkinName, string FaceName, byte TeamNum )
{
}


// ========================================================================================
// takes an incoming vector and a normal vector and returns the normalized reflected vector
// 
// dir = incoming direction i.e. a light or projectile direction
// N = surface Normal.
// 
// Note! the first arg, dir, needs to be pointing away from the surface
// you are reflecting off - this is particularly true with projectile velocity
// vectors - just pass in the negative normalized velocity vector
function vector reflect(vector dir, vector N)
{
	return Normal(( 2 * (dir dot N) * N) - dir);
}

// Debug.
function String GetDebugInfo()
{
	return "";
}

function String GetDebugInfo2()
{
	return "";
}

function String GetDebugInfo3()
{
	return "";
}

//----------------------------------------------------------------------------

simulated function LogActor( string message )
{
	Log( self.class.name $ "  " $ message );
}

//----------------------------------------------------------------------------

simulated function LogActorState( string message )
{
	Log( self.class.name $ ": State=" $ GetStateName() $ ": " $ message );
}

//----------------------------------------------------------------------------

simulated function LogTime( string message )
{
	Log( "(" $ Level.Hour $ ":" $ Level.Minute $ ":" $ Level.Second $ "." $ Level.MilliSecond $ ")" @ message );
}

//----------------------------------------------------------------------------

simulated function LogTimeActor( string message )
{
	Log( "(" $ Level.Hour $ ":" $ Level.Minute $ ":" $ Level.Second $ "." $ Level.MilliSecond $ ")" @ class.name @ message );
}

//----------------------------------------------------------------------------

simulated function LogTimeActorState( string message )
{
	Log( "(" $ Level.Hour $ ":" $ Level.Minute $ ":" $ Level.Second $ "." $ Level.MilliSecond $ ")" @	class.name $ ": State=" $ GetStateName() $ ": " $ message );
}

function Color ParseColor(string S)
{
	local Color C;

	if(Left(S, 1) == "#")
		S = Mid(S, 1);

	C.R = 16 * GetHexDigit(Mid(S, 0, 1)) + GetHexDigit(Mid(S, 1, 1));
	C.G = 16 * GetHexDigit(Mid(S, 2, 1)) + GetHexDigit(Mid(S, 3, 1));
	C.B = 16 * GetHexDigit(Mid(S, 4, 1)) + GetHexDigit(Mid(S, 5, 1));

	return C;
}

function int GetHexDigit(string D)
{
	switch(caps(D))
	{
	case "0": return 0;
	case "1": return 1;
	case "2": return 2;
	case "3": return 3;
	case "4": return 4;
	case "5": return 5; 
	case "6": return 6; 
	case "7": return 7; 
	case "8": return 8; 
	case "9": return 9; 
	case "A": return 10; 
	case "B": return 11; 
	case "C": return 12; 
	case "D": return 13; 
	case "E": return 14; 
	case "F": return 15; 
	}

	return 0;
}

//////////////////////////////////////////////////////////////////////////////
//	Default Properties
//////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     bSpawned=True
     Role=ROLE_Authority
     RemoteRole=ROLE_DumbProxy
     LODBias=1
     bDifficulty0=True
     bDifficulty1=True
     bDifficulty2=True
     bDifficulty3=True
     bSinglePlayer=True
     bNet=True
     bNetSpecial=True
     DrawType=DT_Sprite
     Style=STY_Normal
     Texture=Texture'Engine.S_Actor'
     ShadowRange=1024
     DrawScale=1
     ScaleGlow=1
     Fatness=128
     SpriteProjForward=32
     Opacity=1
     bMRM=True
     bMovable=True
     Lighting(0)=(Diffuse=(R=255,G=255,B=255))
     Lighting(1)=(Diffuse=(R=255,G=255,B=255))
     bSoundPositional=True
     SoundRadius=30
     SoundVolume=128
     SoundPitch=64
     TransientSoundVolume=1
     CollisionRadius=22
     CollisionHeight=22
     bGroundMesh=True
     bJustTeleported=True
     Mass=100
     NetPriority=1
     NetUpdateFrequency=100
}
