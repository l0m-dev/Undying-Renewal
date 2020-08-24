//----------------------------------------------------------------------------
// ParticleFX
//----------------------------------------------------------------------------
class ParticleFX expands Visible
	native;

//#exec Texture Import File=Textures\Particle.pcx Name=Particle MIPS=On Flags=2 
//#exec Texture Import File=Textures\ParticleSystem.pcx Name=S_Particle MIPS=On Flags=2

enum EParticlePrimitive
{
	PPRIM_Line,
	PPRIM_Billboard,
	PPRIM_Liquid,
	PPRIM_Shard,
	PPRIM_TriTube,
};

enum EDistributionType
{
	DIST_Random, 
	DIST_Uniform,
};

struct FloatParams
{
	var() float Base;
	var() float Max;
	var() float Rand;
};

struct ColorParams
{
	var() color  Base;
	var() color  Max;
	var() color  Rand;
};

struct ByteParams
{
	var() byte	Base;
	var() byte	Max;
	var() byte	Rand;
};

struct ParticleParams
{
	var vector	Position;		// Current Position in the world
	var vector	Velocity;		// Current Speed and Direction
		
	var float	Lifetime;		// Age at which to "die"
	
	var float	Alpha;			// Current Alpha value

	var color	Color;			// Current RGB color
	
	var float	Width;			// Horizontal dimension (local space)	
	var float	Length;			// or Height

	var float   DripTimer;      // Time to reach full scale when dripping
	
	var float	Elasticity;		// simulation of coefficent of restitution
	
	var float	SpinRate;		// current rotation rate
};

	var(PS_Emission) FloatParams		ParticlesPerSec;	
	var(PS_Emission) FloatParams		SourceWidth;
	var(PS_Emission) FloatParams		SourceHeight;
	var(PS_Emission) FloatParams		SourceDepth;

	var(PS_Emission) FloatParams		Period;
	var(PS_Emission) FloatParams		Decay;

	var(PS_Emission) FloatParams		AngularSpreadWidth;	
	var(PS_Emission) FloatParams		AngularSpreadHeight;
	var(PS_Emission) bool				bSteadyState;		// System does not evolve over time,
															// and does not need to be updated off-screen.
	var(PS_Emission) bool				bPrime;				// Prime the system on spawning.

	var(PS_Movement) FloatParams		Speed;
	var(PS_Movement) FloatParams		Lifetime;
	var(PS_Appearance) ColorParams		ColorStart;
	var(PS_Appearance) ColorParams		ColorEnd;
	var(PS_Appearance) FloatParams		AlphaStart;
	var(PS_Appearance) FloatParams		AlphaEnd;
	var(PS_Appearance) FloatParams		SizeWidth;
	var(PS_Appearance) FloatParams		SizeLength;
	var(PS_Appearance) FloatParams		SizeEndScale;
	var(PS_Appearance) FloatParams		SpinRate;
	var(PS_Appearance) FloatParams		DripTime;

	var(PS_Movement) bool			bUpdate;			// engine should update, otherwise script is controlling
	var(PS_Movement) bool			bVelocityRelative;	// acquire velocity of owner on emission
	var(PS_Movement) bool			bSystemRelative;	// particle locations are relative to system ( they move with respect to the system )
	var(PS_Appearance) float		Strength;

	var	  transient float			LOD;				// current runtime calculated LOD of system, usually ~= ScreenRatio * LODBias

	var(PS_Appearance) float		AlphaDelay;			// time to wait before beginning transition from StartAlpha to EndAlpha
	var(PS_Appearance) float		ColorDelay;			// time to wait before beginning transition from StartColor to EndColor
	var(PS_Appearance) float		SizeDelay;			// time to wait before beginning transition from SizeWidth/Length to EndScale factor of SizeWidth/SizeLength

	var(PS_Movement) float			Chaos;				// velocity to push particle by ( units / sec ) 
	var(PS_Movement) float			ChaosDelay;			// how often to perturb velocity vector ( seconds )

	var(PS_Movement) float			Elasticity;			// Magnitude of bounce, 0.0 = no collision at all,  0.01 = collide but stick, 1.0 = full bounce
	var(PS_Movement) vector 		Attraction;			// Attraction in 3 separate directions 
	
	var(PS_Movement) float			Damping;			// Damping magnitude
	var(PS_Emission) EDistributionType	Distribution;	// How do the particles get emitted
	
	var(PS_Movement) float			WindModifier;		// simulates mass / weight / density / ...  0.0 = no wind response
	var(PS_Movement) bool			bWindPerParticle;	// force computed for each particle location.
	var(PS_Movement) float			GravityModifier;	// simulates mass / weight / density / ...  0.0 = no gravity response, 1.0 = full gravity 
	var(PS_Movement) vector 		Gravity;			// external force for pre-canned effects	
	

	var(PS_Emission) int			ParticlesAlive;		// Number of particles for the system to keep alive.  If the system emits more than this, older particle will be killed	to make room
	var(PS_Emission) int			ParticlesMax;		// Finite number of particles that the system can emit before dying.

	//var() array<Texture> TextureSet;

	var(PS_Appearance) Texture		Textures[5];		// Random textures ( at start ) 
	
	var(PS_Appearance) Texture		ColorPalette;		// Use the palette of a texture as a color cycle

	// Render Style, Transparent, Translucent, Modulated...
//	var(PS_Appearance) ERenderStyle		RenderStyle;

	// Primitive Type
	var(PS_Appearance) EParticlePrimitive RenderPrimitive;
	
	var transient particlelist	ParticleList;		// Actor's list of active particles, if any.
    var float					EmitDelay;	 	    // time since we last emitted
	var vector					LastUpdateLocation; // where we were at the last time we were updated
	var vector					LastEmitLocation;	// where we last emitted particles
	var rotator					LastUpdateRotation;	// what was our rotation last time we updated ?
	var float					EmissionResidue;	// fractional particles left after emission attempt
	var(Advanced) float					Age;				// Age of the system
	var transient float			ElapsedTime;		// Time since last Update
	var bool					bShuttingDown;
	var transient plane			LightColor;			// Color of light used for this particle system.
	var int						CurrentPriorityTag;	// Render Priority for next particle emitted
	var bool					bShellOnly;			// flag for rendering in shell

native(431) final function int	NumParticles();
native(432) final function bool AddParticle(int Id, vector Loc);
native(433) final function bool GetParticleParams(int Id, ParticleParams Params);
native(434) final function bool SetParticleParams(int Id, ParticleParams Params);
native(435) final function bool RecomputeDeltas(int Id);

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     ParticlesPerSec=(Base=15)
     SourceWidth=(Base=10)
     SourceHeight=(Base=10)
     AngularSpreadWidth=(Base=5)
     AngularSpreadHeight=(Base=5)
     Speed=(Base=50)
     Lifetime=(Base=1)
     ColorStart=(Base=(R=255,G=128,B=64))
     ColorEnd=(Base=(R=255))
     AlphaStart=(Base=1)
     SizeWidth=(Base=8)
     SizeLength=(Base=8)
     SizeEndScale=(Base=1)
     bUpdate=True
     Textures(0)=Texture'Engine.Particle'
     RenderPrimitive=PPRIM_Billboard
     RemoteRole=ROLE_SimulatedProxy
     bDirectional=True
     DrawType=DT_Particles
     Style=STY_Translucent
     Texture=Texture'Engine.S_Particle'
     bUnlit=True
     CollisionRadius=100
     CollisionHeight=100
}
