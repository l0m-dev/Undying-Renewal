//=============================================================================
// LightningShaft2.
//=============================================================================
class LightningShaft2 expands Effects;

var float segmentLen;
var float len;
var PlayerPawn Player;
var int numKnots;
var vector end;
var vector p1, p2;
var float inc, inc2;
var vector deltas[32];

var LightningScriptedFX shaft;

function PreBeginPlay()
{
	super.PreBeginPlay();
	 forEach AllActors(class 'PlayerPawn', Player)
		break;
}

function PostBeginPlay()
{
	local vector v1, v2;
	
	v1.x = randRange(-512, 512);
	v1.y = randRange(-512, 512);
	v1.z = 512;

	v2.x = randRange(-512, 512);
	v2.y = randRange(-512, 512);
	v2.z = -512;
	
	super.PostBeginPlay();
	numKnots = 16;
	End = Player.EyeTraceLoc;
	// Player.eyeTrace(end);

	p1 = v1;
	p2 = v2;
	
	// strike(v1, v2);
	strike(Player.Location, end);
}

function Timer()
{
	shaft.Destroy();
	Destroy();
}

function Strike(vector Start, vector End)
{
	local int i;
	local vector loc;
	
	setLocation(start);
	shaft = spawn(class 'LightningScriptedFX',Player,,Player.Location);
	// shaft.setBase(Player);

	len = VSize(end-start) / float(numKnots);
	
	for (i=0; i<32; i++)
	{
		loc = start + Normal(end-start) * (len * i);
		deltas[i] = VRand() * 16;
		loc += deltas[i];
		shaft.AddParticle(i,loc);
	}

	shaft.bUpdate = true;
	// setTimer(0.3333, false);
}

function updateShaft(vector start, vector end)
{
	local int i;
	local vector loc;
	
	if (shaft != none)
	{
		for (i=0; i<32; i++)
		{
			deltas[i] += VRand();
			loc = start + Normal(end-start) * (len * i);
			loc += deltas[i];
			Shaft.GetParticleParams(i,Shaft.Params);
			Shaft.Params.Position = loc;
			Shaft.SetParticleParams(i, Shaft.Params);
		}
	}
}

function Tick(float DeltaTime)
{
	shaft.setLocation(Player.Location);
	shaft.setRotation(Player.ViewRotation);
}

defaultproperties
{
     bHidden=True
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Aeons.Icons.ltngIcon'
     bMovable=False
}
