//=============================================================================
// SPShield.
//=============================================================================
class SPShield expands HeldProp;

//****************************************************************************
// Member vars.
//****************************************************************************
var() float					FullDrawScale;		//
var() float					GrowTime;			//
var() float					ShrinkTime;			//
var() float					Strength;			//
var() vector				Offset;				//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************
function BufferDamage( DamageInfo DInfo )
{
	Strength -= DInfo.Damage * DInfo.DamageMultiplier;
}

function Shrink()
{
	GotoState( 'Shrinking' );
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

auto state Growing
{
	simulated function Tick( float DeltaTime )
	{
		local vector	X, Y, Z;

		if ( pawn(Owner).Health <= 0 )
		{
			Destroy();
			return;
		}

		if ( Owner != none )
		{
			GetAxes( Owner.Rotation, X, Y, Z );
			SetLocation( Owner.Location + ( X * Offset.X ) + ( Y * Offset.Y ) + ( Z * Offset.Z ) );
			SetRotation( Owner.Rotation );
		}

		if ( DrawScale < FullDrawScale )
		{
			if ( GrowTime == 0.0 )
				DrawScale = FullDrawScale;
			else
				DrawScale = FMin( DrawScale + ( DeltaTime * FullDrawScale / GrowTime ), FullDrawScale );
		}
		else
			GotoState( 'Holding' );
	}

BEGIN:
	DrawScale = 0.01;

} // state Growing


state Holding
{
	simulated function Tick( float DeltaTime )
	{
		local vector	X, Y, Z;

		super.Tick( DeltaTime );

		if ( pawn(Owner).Health <= 0 )
		{
			Destroy();
			return;
		}

		if ( Owner != none )
		{
			GetAxes( Owner.Rotation, X, Y, Z );
			SetLocation( Owner.Location + ( X * Offset.X ) + ( Y * Offset.Y ) + ( Z * Offset.Z ) );
			SetRotation( Owner.Rotation );
		}

	}

} // state Holding


state Shrinking
{
	simulated function Tick( float DeltaTime )
	{
		local vector	X, Y, Z;

		if ( pawn(Owner).Health <= 0 )
		{
			Destroy();
			return;
		}

		if ( Owner != none )
		{
			GetAxes( Owner.Rotation, X, Y, Z );
			SetLocation( Owner.Location + ( X * Offset.X ) + ( Y * Offset.Y ) + ( Z * Offset.Z ) );
			SetRotation( Owner.Rotation );
		}

		if ( DrawScale > 0.05 )
		{
			if ( ShrinkTime == 0.0 )
				DrawScale = 0.05;
			else
				DrawScale = FMax( DrawScale - ( DeltaTime * FullDrawScale / ShrinkTime ), 0.05 );
		}
		else
			Destroy();
	}

	function Shrink()
	{
	}

} // state Shrinking


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     FullDrawScale=1.35
     GrowTime=1
     ShrinkTime=0.5
     Strength=80
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.Shield3rd_m'
}
