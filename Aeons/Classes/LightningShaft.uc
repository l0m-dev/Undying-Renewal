//=============================================================================
// LightningShaft.
//=============================================================================
class LightningShaft expands Effects;

//#exec Texture Import Name=ltngIcon File=ltngIcon.pcx Group=Icons Mips=Off


// ===================================================================================
struct Pulse
{
	var float 	Index;			// Current index of the pulse
	var vector	Dir;			// Directional force of the pulse
	var float	Speed;			// Speed of the pulse - how long does it take to traverse the entire shaft length?
	var float 	Scale;			// Scale at the location of the pulse.
	var float	Width;
	var int		KnotsPerSec;	// number of knots this pulse moves down the shaft per second
	var bool	bInUse;
};

// User vars
var() bool		bTriggerMultiple; // trigger multiple times
var() bool		bMaintain;		// maintain the effect
var() int 		NumKnots;		// number of knots - this is number of segments + 1
var() name		EndStrikeEvent;	// Event to call when the strike is done.
var() name		StartStrikeEvent;
var() float		ShaftScale;		// initial scale of the shaft.
var() float		StrikeTime;		// how long to I take to strike?
var() float		Chaos;			// bigger value = more chaotic
var() float		scaleMinPct;	// minimum random scale multiplier
var() float		scaleMaxPct;	// maximum random scale multiplier
var() bool		bUsePath;		// uses path points to navigate a strike
var() float		HoldLen;		// length of time to hold the effect once strike() is called.
var() class<ScriptedFX> ParticleType;
// ===================================================================================
// Holding state info
var(LightningHoldState) bool 	bLockEnds;			// Lock the ends of the effect from moving
var(LightningHoldState) float 	PulseSpeedMin;		// Min speed of an energy pulse down the langth of the lightning shaft
var(LightningHoldState) float 	PulseSpeedMax;		// Max speed of an energy pulse down the langth of the lightning shaft
var(LightningHoldState) int 	PulsesPerSec;		// number of energy pulses per second
var(LightningHoldState) float 	PulseStrengthMin;	// Minimum pulse strangth
var(LightningHoldState) float 	PulseStrengthMax;	// Maximum pulse strangth
var(LightningHoldState) float 	PulseScaleMin;		// Minimum pulse strangth
var(LightningHoldState) float 	PulseScaleMax;		// Maximum pulse strangth
var(LightningHoldState) float 	PulseWidthMin;		// parametric width of the pulse
var(LightningHoldState) float 	PulseWidthMax;		// parametric width of the pulse

// ===================================================================================
// Internal vars
var int			lastKnot;		// index of the last active knot
var int			lastPoint;		// index of the last active NavPoint
var int			cPulse;			// current pulse index
var int			NumPulses;		// Number of active pulses I have going
var int			pulsePos[8];	// index into the knot array for each pulse - it's position within the array
var float 		moveDistance;	// distance to move a knot each update
var float		desiredScale;	// desired scale of the last knot
var float 		growRate;		// distance per sec the lightning should grow
var float		pInc;			// the parametric incrememnter
var float		numKnotsPerEvent;
var float		pDist;			// the parametric distance of a knots journey from being created to reaching its goal and spawning a new knot
var float		strikeLen;		// length of the strike
var float		timerRefresh;	// rate the timer updates the system
var float 		scales[256];	// array of scales for the knots
var float 		InitialScales[256]; // array of initial scales for the knots
var float 		HoldTimer;		// how long to stay in holding state
var float 		HoldStateTimer;
var vector 		Knots[256];		// array of positions for the knots
var vector 		initialKnots[256];	// array of Initially generated positions for the knots
var vector 		knotForces[256];// force vectors - one per knot
var vector		cDir;			// current direction the shaft is travelling
var vector		StrikeStart;	// start location of the strike
var vector		StrikeEnd;		// end location of the strike
var pulse 		pulses[8];		// up to 8 pulses allowed for a shaft

var ScriptedFX	shaft;	// Lightning shaft
var LightningNavigationPoint NavPoints[16];
var MasterLightningNavigationPoint MasterNavPoint;

// ===================================================================================
function PostBeginPlay()
{
	local vector start, end;

	start = vect(0,0,256);

	end.x = randRange(128,-128);
	end.y = randRange(128,-128);
	end.z = -512;

	super.PostBeginPlay();
}

function Trigger(Actor Other, Pawn Instigator)
{
	if( (shaft != none) && Level.bIsCutsceneLevel )
	{
		EndStrike();
	} else {
		if ( bUsePath )
		{
			GotoState('');
			PathedStrike();
		}
	}
}

// Strike between two locations
function Strike(vector start, vector end)
{
	local PlayerPawn Player;
	local float StartDist;

	ForEach AllActors(class 'PlayerPawn', Player)
	{
		break;
	}

	StartDist = VSize(Player.Location - Start);

	StrikeStart = start;
	StrikeEnd = end;

	Clamp(numKnots,8,256);

	DesiredScale = shaftScale;					// initialize desiredScale

	TimerRefresh = strikeTime / numKnots;		// desired timer refresh rate
	NumKnotsPerEvent = 0.05 / timerRefresh; 	// how many knots should be created each timer() call

	MoveDistance = growRate / timerRefresh;		// move the last knot this distance each Timer()
	pInc = 1.0; //growRate / segmentLength;		// parametric incrementer

	SetTimer(0.05,true);						// set the timer to 20 fps

	cDir = Normal(end - start);
	StrikeLen = VSize(start - end);	// length of the strike from strikeStart to strikeEnd
	GrowRate =  strikeLen / numKnots;

	SetLocation(Player.Location + (Vector(Player.ViewRotation) * StartDist));
	Shaft = spawn(ParticleType,,,Location);
	
	LastKnot = 1;
	knots[0] = start;
	InitialKnots[0] = start;
	knots[1] = start;
	InitialKnots[1] = start;

	addKnot();
}

// Strike along a set of path points
function PathedStrike()
{
	local int numNavPoints;
	local name NextPoint;
	local vector lastLoc;
	local bool bEndOfNav;
	local LightningNavigationPoint iNav;

	forEach AllActors(class 'MasterLightningNavigationPoint', MasterNavPoint, Event)
	{
		break;
	}
	
	if (MasterNavPoint != none)
	{
		// found a master nac point
		
		// log(".........Lightning.........Found Master Point", 'Misc');
		
		NavPoints[0] = MasterNavPoint;
		NumNavPoints = 1;

		LastPoint = 0;
		
		StrikeLen = 0;
		NextPoint = MasterNavPoint.Event;
		LastLoc = MasterNavPoint.Location;

		while (!bEndOfNav)
		{
			bEndOfNav = true;
			forEach AllActors(class 'LightningNavigationPoint', iNav)
			{
				if (iNav.Tag == NextPoint)
				{
					NavPoints[numNavPoints] = iNav;
					StrikeLen += VSize(iNav.Location - LastLoc);
					LastLoc = iNav.Location;
					NextPoint = iNav.Event;
					NumNavPoints ++;
					bEndOfNav = false;
					// log(".........Lightning.........Found Point "$iNav.name, 'Misc');
					break;
				}
			}
		}

		Clamp(numKnots,8,256);
		DesiredScale = ShaftScale;					// initialize desiredScale
		TimerRefresh = StrikeTime / NumKnots;		// desired timer refresh rate
		NumKnotsPerEvent = 0.05 / TimerRefresh; 	// how many knots should be created each timer() call
		// log("desired Strike Timer   "$timerRefresh);
		// log("numKnotsPerEvent   "$numKnotsPerEvent);
	
		MoveDistance = GrowRate / TimerRefresh;		// move the last knot this distance each Timer()
	
		SetTimer(0.05,true);						// set the timer
	
		cDir = Normal(NavPoints[1].Location - NavPoints[0].Location);
		LastKnot = 1;
		// strikeLen = VSize(strikeStart - strikeEnd);	// length of the strike from strikeStart to strikeEnd
		GrowRate =  strikeLen / numKnots;
	
		SetLocation(MasterNavPoint.Location);
		Shaft = spawn(ParticleType,,,MasterNavPoint.Location);
	
		LastKnot = 1;
		Knots[0] = MasterNavPoint.Location;
		InitialKnots[0] = MasterNavPoint.Location;
		Knots[1] = MasterNavPoint.Location;
		InitialKnots[1] = MasterNavPoint.Location;

		AddKnot();
	}
}


// sets the new desired scale - the larger the pct value, the more deviation
// the scale will be from its last desired scale.  the pct is a percentage of
// the previous scale.  
function newScale(float pct)
{
	desiredScale = shaftScale * pct;
}

// sets the new direction - the larger the weight, the more randomized
// the direction will be from its last direction
function newDir(float weight)
{
	local vector seekDir;

	if (bUsePath)
	{
		if (NavPoints[LastPoint] != none)
		{
			if ( VSize(knots[lastKnot] - NavPoints[lastPoint].Location) < 128)
				LastPoint++;
			if ( NavPoints[LastPoint] != none )
			{
				seekDir = Normal(NavPoints[LastPoint].Location - knots[lastKnot]);
				cDir = Normal( (seekDir * (1 - weight)) + (VRand() * weight) + (cDir * randRange(0.1,0.5)));
			}
		}
	} else {
		seekDir = Normal(strikeEnd - knots[lastKnot]);
		if (fRand() > 0.9)
			cDir = Normal( seekDir + (VRand() * (weight * 2)) );
		else
			cDir = Normal( (seekDir * (1 - weight)) + (VRand() * weight) + (cDir * randRange(0.1,0.5)));
	}
}

// Adds one knot to the knot array, sets a new direction
function addKnot()
{
	if ( lastKnot < (numKnots-1) )
	{
		knots[lastKnot+1] = knots[lastKnot];
		InitialKnots[lastKnot+1] = InitialKnots[lastKnot];

		newDir(chaos);
		newScale( randRange(scaleMinPct, scaleMaxPct) );
		pDist = 0;
		lastKnot++;
		shaft.AddParticle(lastKnot,knots[lastKnot]);
	} else {
		gotoState('Idle');
	}
}

// updates the particle system for rendering
function updateParticleSystem()
{
	local int i;

	for (i=0; i<=lastKnot; i++)
	{
		Shaft.GetParticleParams(i,Shaft.Params);
		Shaft.Params.Position = Knots[i];
		Shaft.Params.Width = scales[i];
		Shaft.SetParticleParams(i, Shaft.Params);
	}
}

function moveKnot()
{
	knots[lastKnot] += (cDir * growRate);
	InitialKnots[lastKnot] = knots[lastKnot];
	scales[lastKnot] = desiredScale;
	InitialScales[lastKnot] = scales[lastKnot];
}

function ShiftPoints(float amount)
{
	local int i;
	
	for (i=0; i<=lastKnot; i++)
	{
		Shaft.GetParticleParams(i,Shaft.Params);
		Shaft.Params.Position += VRand() * (FRand() * amount);
		Shaft.SetParticleParams(i, Shaft.Params);
	}
}

function Timer()
{
	local int i;

	for (i=0; i<numKnotsPerEvent; i++)
	{
		// log(".........Lightning.........Timer() "$i, 'Misc');
		moveKnot();
		updateParticleSystem();
		addKnot();
	}
}

// ==================================================================================
// Idle2 State
// ==================================================================================
state Idle2
{
	function Tick(float DeltaTime);
	function Timer();

	function Trigger(Actor Other, Pawn Instigator)
	{
		if ( bUsePath )
		{
			GotoState('');
			PathedStrike();
		}
	}


	Begin:
		// log("In Idle2 State", 'Misc');
}

// ==================================================================================
// Idle State
// ==================================================================================
state Idle
{
	function Timer();
	function Tick(float DeltaTime);


	function Trigger(Actor Other, Pawn Instigator)
	{
		if ( bUsePath )
		{
			GotoState('');
			PathedStrike();
		}
	}

	Begin:
		// log("In Idle State", 'Misc');
		if ( bMaintain )
			gotoState('Holding');
		setTimer(0,false);
		sleep(1);
		shaft.Destroy();
		if (!bTriggerMultiple)
			Destroy();
		else
			GotoState('');
}

// ==================================================================================
// Holding State
// ==================================================================================
state Holding
{
	// ====================================
	// setup
	function BeginState()
	{
		HoldstateTimer = 0;
	
	}

	// ====================================
	// creates a pulse and sends it off
	function GeneratePulse()
	{
		local int i;
		local pulse p;
		
		if (NumPulses < 8)
		{
			for (i=0; i<8;i++)
			{
				if ( !pulses[i].bInUse )
				{
					p.Dir = VRand() * ( RandRange(PulseStrengthMin, PulseStrengthMax) );
					p.Dir.z = 0;
					p.Index = 0;
					p.Speed = randRange(PulseSpeedMin, PulseSpeedMax);
					p.Scale = randRange(PulseScaleMin, PulseScaleMax);
					p.KnotsPerSec = float(numKnots-1) / p.Speed;
					p.Width = randRange(PulseWidthMin, PulseWidthMax) * numKnots;
					p.bInUse = true;
					pulses[i] = p;
					NumPulses ++;
				
/*
					log("-----------------------------------");
					log("GeneratePulse: Dir = "$p.dir);
					log("GeneratePulse: Speed = "$p.Speed);
					log("GeneratePulse: Scale = "$p.Scale);
					log("GeneratePulse: KnotsPerSec = "$p.KnotsPerSec);
					log("-----------------------------------");
					log("NumPulses: "$numPulses);
*/
					break;
				}
			}
		}
	}

	// ====================================
	// Timer
	function Timer()
	{
		GeneratePulse();
	}

	// remove the indexed pulse from the array up pulses and update necessary stuff
	function removePulse(int Index)
	{
		local pulse p;
		
		Pulses[Index] = p;
		NumPulses --;
	}

	// moves the pulses down the array of knots
	function movePulses(float dt)
	{
		// dt is deltaTime, passed from Tick() - this is the length of time in the frame I am working with
		local int i;
		local float moveKnots;
		
		for (i=0; i<numPulses; i++)
		{
			if ( pulses[i].bInUse )
			{
				// how many knots down the shaft do I move this frame?
	
				moveKnots = dt * float(pulses[i].KnotsPerSec);
				moveKnots = FClamp(moveKnots, 0, numKnots);
	
				// update the pulse struct
				pulses[i].Index += moveKnots;
	
				// past the end
				if (pulses[i].Index > numKnots)
					RemovePulse(i);
			}
		}
	}

	function UpdateKnotMods()
	{
		local int i, j;
		local pulse p;
		local int start, end;
		local float str;
		
		for(i=0; i<numKnots; i++)
		{
			Scales[i] = InitialScales[i];
			KnotForces[i] = vect(0,0,0);
		}

		for(i=0; i<numPulses; i++)
		{
			p = pulses[i];
			if ( p.bInUse )
			{
				start = int(p.index - (p.width / 2));
				end = int(p.index + (p.width / 2));
				
				start = Clamp(start, 0, numKnots);
				end = Clamp(end, 0, numKnots);
				
				for (j=start; j<end+1; j++)
				{
					// strength of this effect at the knot
					str = getStrength(p.index, p.width, j);
					
					if ( bLockEnds )
					{
						if (j < (numKnots * 0.15))
							str = 0;

						if (j > (numKnots * 0.85))
							str = 0;

						/*
						if (j < (numKnots * 0.5))
						{
							if ( j < (numKnots * 0.25) )
								str *= ((j/numKnots) * 4);
						
						} else {
							if ( j > (numKnots * 0.75) )
								str *= ( abs(j - (NumKnots*0.5)) / numKnots) * 4;
						}
						*/
					}
					
					Scales[j] += p.Scale * str;
					KnotForces[j] += p.Dir * str;
				}
			}

		}
	}

	function float getStrength(float c, float w, float x)
	{
		local float	pi;
		local float h, d;

		pi = 3.1415926535897932384626433832795;

		return ( square(cos (((x-c) * pi) / w )) );
	}

	function updateKnotArray()
	{
		local int i;

		for(i=0; i<NumKnots; i++)
		{
			// knots[i] = InitialKnots[i] + (VRand() * randRange(PulseStrengthMin, PulseStrengthMax));
			knots[i] = InitialKnots[i] + KnotForces[i];
			// scales[i] = InitialScales[i] + (RandRange(-2.0,2.0));

			Shaft.GetParticleParams(i,Shaft.Params);
			Shaft.Params.Position = knots[i];
			Shaft.Params.Width = Scales[i];
			Shaft.SetParticleParams(i, Shaft.Params);
		}
	}

	// ====================================
	// updater of everything
	function Tick(float deltaTime)
	{
		if (HoldStateTimer > HoldLen)
		{ 
			EndStrike();
		} else {
			HoldStateTimer += DeltaTime;
			movePulses(deltaTime);
			updateKnotMods();
			updateKnotArray();
		}
	}
	
	Begin:
		setTimer(1/float(pulsesPerSec), true);
		// log("Lightning in Holding state",'Misc');
} // Holding State

simulated function EndStrike()
{
	local Actor A;
	
	if (EndStrikeEvent != 'none')
	{
		ForEach AllActors (class 'Actor', A, EndStrikeEvent)
			A.Trigger(self, none);
	}

	Shaft.Destroy();
	
	if ( bTriggerMultiple )
		GotoState('Idle2');
	else
		Destroy();
}

simulated function StrikeStrike()
{
	local Actor A;
	
	if (StartStrikeEvent != 'none')
	{
		ForEach AllActors (class 'Actor', A, StartStrikeEvent)
			A.Trigger(self, none);
	}
}

defaultproperties
{
     bMaintain=True
     NumKnots=16
     ShaftScale=4
     StrikeTime=0.1
     Chaos=0.25
     scaleMinPct=0.5
     scaleMaxPct=2
     HoldLen=10
     ParticleType=Class'Aeons.LightningFX'
     PulseSpeedMin=1
     PulseSpeedMax=0.2
     PulsesPerSec=4
     PulseStrengthMin=8
     PulseStrengthMax=32
     PulseScaleMin=2
     PulseScaleMax=16
     PulseWidthMin=0.1
     PulseWidthMax=0.5
     growRate=64
     StrikeEnd=(Z=-2300)
     bHidden=True
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Aeons.Icons.ltngIcon'
     bMovable=False
}
