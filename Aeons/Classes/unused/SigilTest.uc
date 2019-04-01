//=============================================================================
// SigilTest.
//=============================================================================
class SigilTest expands Trigger;

#exec OBJ LOAD FILE=\Aeons\Textures\fxB2.utx PACKAGE=fxB2
#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var int Damage;
var float MomentumTransfer;
var int castingLevel;
var() sound Explodesound;
var vector loc;
var() class<Decal> Decal;
var Decal MyDecal;
var Boil Boils[6];

// delay between boil sounds
var float BoilSoundDelay;
// variable addition to BoilSoundDelay to add randomness
var float BoilSoundVar;
// current timer value updated in realtime, when 0, boil sound is played
var float BoilSoundTimer;
// var used just to hold a FRand() value
var float Percent;
// 3 sound for bubbling that are chosen at random
var sound BoilSounds[3];
var sound BoilPopsound;

//----------------------------------------------------------------------------
//	Replication
//----------------------------------------------------------------------------


//----------------------------------------------------------------------------

function PreBeginPlay()
{
	super.PreBeginPlay();
	Loc = Location;
	// Add maintenance to players mana modifier
	WardModifier(AeonsPlayer(Owner).WardMod).AddWard(4);

}

//----------------------------------------------------------------------------

// made Boils ClientSide only
simulated function GenBoil(int idx, float o)
{
	local vector x, y, z; 
	local vector v, v0, v1;
	local vector Loc;

	getAxes(Rotation, x, y, z);
	
	v0 = RandRange(-1.0, 1.0) * y;
	v1 = RandRange(-1.0, 1.0) * z;
	
	v = Normal(v0 + v1);
	
	Loc = Location + (v * RandRange(2.0, (12.0 * (castingLevel + 1))));

	Boils[idx] = Spawn(class 'Boil', self,,Loc, rotation);

	Boils[idx].Opacity = o;
}

//----------------------------------------------------------------------------

simulated function Destroyed()
{
	local int i;
	
	Log("SigilTest: Destroyed");

	if ( Owner != none )
		WardModifier(AeonsPlayer(Owner).WardMod).RemoveWard(4);

	for (i=0; i<6; i++)
		if (Boils[i] != none)
			Boils[i].Destroy();

	if ( MyDecal != None )
		MyDecal.Destroy();
}

//----------------------------------------------------------------------------

simulated function PostBeginPlay()
{
	// single player we don't get PostNetBeginPlay so we have to route Init here
	if ( Level.NetMode == NM_Standalone )
		Init();
}

//----------------------------------------------------------------------------

simulated function PostNetBeginPlay()
{ 
	// Multiplayer we need to wait till all variable are initialized 
	if ( Level.NetMode != NM_DedicatedServer )
		Init();
	else
		Assert(False); //does it really never get here on server ?
}

//----------------------------------------------------------------------------

simulated function Init()
{
	local int i, numBoils;
	local float opac;

	opac = 1.0;
	
	switch (CastingLevel)
	{
		case 0:
			numBoils = 1;
			break;
		case 1:
			numBoils = 2;
			break;
		case 2:
			numBoils = 3;
			break;
		case 3:
			numBoils = 4;
			break;

		case 4:
			numBoils = 5;
			Opac = 0.5;
			break;
		case 5:
			numBoils = 6;
			Opac = 0.5;
			break;
	}
	log("SigilTest: Init !!!!!!!!!!!!!!!!!!!!!!!!");
//	if ( Level.NetMode != NM_DedicatedServer )
//	{
		for (i=0; i<numBoils; i++)
			GenBoil(i, opac);

		if (Decal != none)
		{
			MyDecal = spawn(Decal,Self,,Location, Rotation);
			MyDecal.SetDrawScale(0.85);
			MyDecal.Opacity = opac;
		}
//	}
}

//----------------------------------------------------------------------------

function bool IsRelevant( actor Other )
{

	if ( Other.IsA('SpellProjectile') )
		return false;

	if ( Other.IsA('Skull_proj') || Other.IsA('Pawn') || Other.IsA('Projectile'))
		return true;
}

//----------------------------------------------------------------------------

function Tick(float DeltaTime)
{
	SetLocation(Loc);
}

//----------------------------------------------------------------------------

auto state FadeIn
{
	function Timer()
	{
		Opacity += 0.05;
		if ( Opacity >= 0.95 )
		{
			Opacity = 1.0;
			gotoState('Armed');
		}
	}
		
	function BeginState()
	{
		setTimer(0.1,true);
		log("Sigil:FadeIn State... begin", 'Misc');
	}
/*
	Begin:
		setTimer(0.1,true);
		log("Sigil:FadeIn State... begin", 'Misc');
*/
}

//----------------------------------------------------------------------------

state Armed
{
	function BeginState()
	{
		if ( CastingLevel == 4 )
			bScryeOnly = true;
		else
			LoopAnim('Idle');

		PlayAnim('Idle');
		setTimer(0.25,true);

		// set our delay for bubbling sounds
		BoilSoundTimer = BoilSoundDelay + FRand()*BoilSoundVar;

		// log("Sigil:Armed State... begin", 'Misc');
	}

	// there is another global Tick above, for now I'm copying the SetLoc and putting my sound code in here
	function Tick(float DeltaTime)
	{
		// from global tick
		SetLocation(Loc);

		BoilSoundTimer -= DeltaTime;

		if ( BoilSoundTimer <= 0 ) 
		{
			Percent = FRand();

			if (Percent < 0.33)
				PlaySound( BoilSounds[0], , 0.5, , 650 );
			else if (Percent < 0.66)
				PlaySound( BoilSounds[1], , 0.5, , 650 );
			else
				PlaySound( BoilSounds[2], , 0.5, , 650 );

			BoilSoundTimer = BoilSoundDelay + FRand()*BoilSoundVar;
		}
		
	}

	function Timer()
	{
		local int i;

		for (i=0;i<8;i++)
			if ( Touching[i] != None )
				Touch(Touching[i]);

		if ( (Pawn(Owner).health <= 0) || (Pawn(Owner).mana <= 2) )
			gotoState('BlowUp');
	}
	
	function Touch( actor Other )
	{
		// log("Sigil:Touch "$Other.name,'Misc');
		
		if( IsRelevant( Other ) )
		{
			if ( Other.IsA('Actor'))
			{
				gotoState('BlowUp');
			}
		}
	}

	function UnTouch( actor Other )
	{
		local actor A;
		
		// log("Sigil:Touch "$Other.name,'Misc');
		if( IsRelevant( Other ) )
		{
			if ( Other.IsA('Actor'))
			{
				gotoState('BlowUp');
			}
		}
	}

/*
	Begin:
		PlayAnim('Idle');
		setTimer(0.25,true);
		// log("Sigil:Armed State... begin", 'Misc');
*/
}

//----------------------------------------------------------------------------

state BlowUp
{

	Begin:
		switch (castingLevel)
		{
			case 0:
				spawn(class 'SigilExplosion0',Pawn(Owner),,Location);
				break;

			case 1:
				spawn(class 'SigilExplosion1',Pawn(Owner),,Location);
				break;

			case 2:
				spawn(class 'SigilExplosion2',Pawn(Owner),,Location);
				break;

			case 3:
				spawn(class 'SigilExplosion3',Pawn(Owner),,Location);
				break;

			case 4:
				spawn(class 'SigilExplosion4',Pawn(Owner),,Location);
				break;

			case 5:
				spawn(class 'SigilExplosion5',Pawn(Owner),,Location);
				break;
		}
		PlaySound(BoilPopSound);
		MyDecal.Destroy();
		Destroy();
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     Decal=Class'Aeons.CreepingRotDecal'
     BoilSoundDelay=2
     BoilSoundVar=2
     BoilSounds(0)=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPulse01'
     BoilSounds(1)=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPulse02'
     BoilSounds(2)=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPulse03'
     BoilPopsound=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBoilPop01'
     bHidden=False
     InitialState=None
     AmbientSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardLoop01'
     DrawType=DT_Mesh
     bMRM=False
     SoundRadius=24
     SoundVolume=24
     CollisionRadius=128
     CollisionHeight=128
     bProjTarget=True
}
