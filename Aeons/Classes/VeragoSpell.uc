//=============================================================================
// VeragoSpell.
//=============================================================================
class VeragoSpell expands Visible;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv


//****************************************************************************
// Member vars.
//****************************************************************************
var pawn					Target;				//
var	ScriptedFX 				Shaft;				//
var int 					NumKnots;			//
var vector 					Deltas[32];			//
var float 					DamageTimer;		//
var float					DamageAmount;		//
var float					TotalTime;			//
var Sound					AmbientLoop;		//
var bool					bDamaging;			//


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PostBeginPlay()
{
	super.PostBeginPlay();
	NumKnots = 32;
	DrawScale = 2;
	if ( RGC() )
		DamageTimer = 0.1;
}

function Destroyed()
{
	if ( Shaft != none)
		Shaft.Destroy();
	super.Destroyed();
}

function DamageInfo getDamageInfo( optional name DamageType )
{
	local DamageInfo DInfo;

	if ( DamageType == '' )
		DamageType = 'powerword';
	DInfo.Damage = DamageAmount;
	DInfo.DamageType = DamageType;
//	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = true;
	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1;
	DInfo.bBounceProjectile = false;
	return DInfo;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************
// Hovering, damaging pawns
auto state Hover
{
	function Tick ( float DeltaTime )
	{
		if ( bDamaging )
		{
			FindTarget();
			ApplyDamage( DeltaTime );
		}
	}

	function ApplyDamage( float DeltaTime )
	{
		local int	i;
		local int	hp;
		local pawn	PawnOwner;

		PawnOwner = pawn(Owner);

		TotalTime += DeltaTime;
		hp = TotalTime / DamageTimer;
		TotalTime -= ( DamageTimer * hp );

		if ( ( hp > 0 ) && ( Target != none ) )
			if ( Target.AcceptDamage( getDamageInfo() ) )
				Target.TakeDamage( PawnOwner, Target.Location, vect(0,0,0), getDamageInfo() );
	}

	function UpdateTarget()
	{
		if ( Target != none)
		{
			if ( Shaft != none)
				UpdateShaft( Shaft, Location, Target.Location );
			else
				Shaft = Strike( Location, Target.Location );
		}
		else if ( Shaft != none )
		{
			Shaft.Destroy();
			Shaft = none;
		}

	}

	function ScriptedFX Strike( vector Start, vector End )
	{
		local int			i;
		local vector		Loc;
		local float			Len;
		local ScriptedFX	sFX;

		// zero the deltas
		for ( i=0; i<32; i++ )
			deltas[i] = vect(0,0,0);

		sFX = Spawn( class'PWScriptedFX', self,, Start );
		sFX.SetLocation( Start );

		Len = VSize(end - start) / float(numKnots);

		for ( i=0; i<numKnots; i++ )
		{
			deltas[i] = VRand() * 8;
			Loc = ( Start + Normal(End - Start ) * ( Len * i ) ) + deltas[i];
			sFX.AddParticle( i, Loc );
		}
		return sFX;
	}

	// Update the shaft points
	function UpdateShaft( ScriptedFX Shaft, vector Start, vector End )
	{
		local int			i;
		local float			Len;
		local vector		Loc, LastPoint;

		Shaft.SetLocation( Start );

		Len = VSize(End - Start) / float(numKnots);

		LastPoint = Start;

		Shaft.GetParticleParams( 0, Shaft.Params );
		Shaft.Params.Position = LastPoint;
		Shaft.Params.Width = 4;
		Shaft.SetParticleParams( 0, Shaft.Params );

		for ( i=1; i<NumKnots; i++ )
		{
			Len = VSize(End - LastPoint) / (NumKnots - i);

			Deltas[i] = VRand() * 8;

			Loc = LastPoint + ( Normal(End - LastPoint) * Len );
			Loc += deltas[i];

			Shaft.GetParticleParams( i, Shaft.Params );
			Shaft.Params.Position = Loc;
			Shaft.Params.Width = 4 * ( 1 + ( i / float(NumKnots) ) );
			Shaft.SetParticleParams( i, Shaft.Params );
			LastPoint = Loc;
		}
	}

	function FindTarget()
	{
		local pawn	PawnOwner;
		local pawn	P;

		PawnOwner = Pawn(Owner);
		if ( ( PawnOwner != none ) &&
			 ( PawnOwner.Enemy != none ) &&
			 FastTrace( PawnOwner.Enemy.Location, Location ) )
		{
			Target = PawnOwner.Enemy;
		}
		else
		{
			Target = none;
			/*
			foreach AllActors( class'Pawn', P )
				if ( P.bIsPlayer )
				{
					Target = P;
					break;
				}
			*/
		}
		UpdateTarget();
	}

BEGIN:
	Sleep( 2.0 );
	bDamaging = true;
	AmbientSound = AmbientLoop;
}

defaultproperties
{
     DamageTimer=1
     DamageAmount=5
     AmbientLoop=Sound'Wpn_Spl_Inv.Spells.E_Spl_PwrSuck01'
     bHidden=True
     AmbientSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PwrSpawn01'
     SoundRadius=32
     SoundVolume=200
}
