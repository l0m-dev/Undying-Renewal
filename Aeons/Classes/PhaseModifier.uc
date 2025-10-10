//=============================================================================
// PhaseModifier.
//=============================================================================
class PhaseModifier expands PlayerModifier;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var float v;	// Velocity
var float vMin, vMax;
var byte vis;

var() sound FlickerSound;

var float dim1, dim2;
var float ChangeTimer;
var float phase_visible, phase_dim, phase_invisible;
var int SndID;

function PreBeginPlay()
{
	super.PreBeginPlay();
	dim1 = 0.25;
	dim2 = 0.35;
	ChangeTimer = 0.5;
}

state Deactivated
{
	function Timer()
	{
		if ( Owner.Opacity < 1.0 )
		{
			if ( FRand() < 0.05 )
				flicker(-0.5);
			Owner.Opacity += 0.1;
		} else {
			Pawn(Owner).Visibility = vis;
			gotoState('Idle');
		}
	}

	Begin:
		bActive = false;
		AeonsPlayer(Owner).bPhaseActive = false;
		SndID = Owner.PlaySound(DeactivateSound);
		setTimer(0.1,true);
		//FinishSound(SndID);
}

function clampOpacity()
{
	if ( Owner.opacity > 1.0 )
		Owner.Opacity = 1.0;
	else if ( Owner.opacity < 0.0 )
		Owner.Opacity = 0.0;
}

function Timer()
{
	gotoState('Deactivated');
}

state Activated
{

	Begin:
		bActive = true;
		AeonsPlayer(Owner).bPhaseActive = true;
		
		vMin = 16;
		vMax = 192;
		
		phase_visible = 0.95;

		vis = Pawn(Owner).default.Visibility;
		setTimer(30, false);
		Owner.PlaySound(ActivateSound);

		if ( castingLevel == 0 ) {
			gotoState('Amplitude1');
		} else if ( castingLevel == 1 ) {
			gotoState('Amplitude2');
		} else if ( castingLevel == 2 ) {
			gotoState('Amplitude3');
		} else if ( castingLevel == 3 ) {
			gotoState('Amplitude4');
		} else if ( castingLevel == 4 ) {
			gotoState('Amplitude5');
		} else if ( castingLevel == 5 ) {
			gotoState('Amplitude6');
		} else {
			log("Casting Level is invalid!!!");
			gotoState('Deactivated');	// bail out
		}
}

function Flicker(float value)
{
	log("Flicker");
	// PlaySound()
	Owner.PlaySound(FlickerSound);
	Owner.Opacity += value;
}

state Amplitude1
{
	function Tick( float DeltaTime )
	{
		local float offset;
		offset = DeltaTime / ChangeTimer;
		if ( (Pawn(Owner).bFire == 1) || (Pawn(Owner).bFireAttSpell == 1) || (Pawn(Owner).bFireDefSpell == 1) || (PlayerPawn(Owner).ScryeTimer > 0) )
		{
			if ( Owner.Opacity < phase_visible )
				Owner.Opacity += offset;
		} else {
			if ( FRand() < 0.005 )
				flicker(0.3);
	
			if ( Owner.Opacity > dim2 )
				Owner.Opacity -= offset;
			else if ( Owner.Opacity < dim1 )
				Owner.Opacity += offset;
		}
		clampOpacity();
		Pawn(Owner).Visibility = vis * Owner.Opacity;
	}

	Begin:
}

state Amplitude2
{
	function Tick( float DeltaTime )
	{
		local float offset;
		
		offset = DeltaTime / ChangeTimer;

		if ( (Pawn(Owner).bFire == 1) || (Pawn(Owner).bFireAttSpell == 1) || (Pawn(Owner).bFireDefSpell == 1) || (PlayerPawn(Owner).ScryeTimer > 0) )
		{
			if ( Owner.Opacity < phase_visible )
				Owner.Opacity += offset;
		} else {
			v = vSize(owner.velocity);		// get the velocity of the character
			// standing still
			if ( v < vMin ) {
				if ( Owner.Opacity > 0.0 )
					Owner.Opacity -= offset;
			} else {
				// moving
				if ( Owner.Opacity > dim2 )
					Owner.Opacity -= offset;
				else if ( Owner.Opacity < dim1 )
					Owner.Opacity += offset;
			}
		}
		clampOpacity();
		Pawn(Owner).Visibility = vis * Owner.Opacity;
	}

	Begin:
}

state Amplitude3
{

	function Tick(float deltaTime)
	{
		local float offset;
		
		offset = DeltaTime / ChangeTimer;

		if ( (Pawn(Owner).bFire == 1) || (Pawn(Owner).bFireAttSpell == 1) || (Pawn(Owner).bFireDefSpell == 1) || (PlayerPawn(Owner).ScryeTimer > 0) )
		{
			if ( Owner.Opacity < phase_visible )
				Owner.Opacity += offset;
		} else {
			v = vSize( owner.velocity );
			if ( v < vMax )
			{
				if ( Owner.Opacity > 0.0 )
					Owner.Opacity -= offset;
			} else {
				if ( Owner.Opacity < dim1 )
					Owner.Opacity += offset;
				else if ( Owner.Opacity > dim2 )
					Owner.Opacity -= offset;
			}
		}
		clampOpacity();
		Pawn(Owner).Visibility = vis * Owner.Opacity;
	}

	Begin:

}

state Amplitude4
{
	function Tick(float deltaTime)
	{
		local float offset;
		
		offset = DeltaTime / ChangeTimer;
		if ( (Pawn(Owner).bFire == 1) || (Pawn(Owner).bFireAttSpell == 1) || (Pawn(Owner).bFireDefSpell == 1) || (PlayerPawn(Owner).ScryeTimer > 0) )
		{
			if ( Owner.Opacity < dim2 )
				Owner.Opacity += offset;
			else if ( Owner.Opacity > dim2 )
				Owner.Opacity -= offset;
		} else {
			v = vSize( owner.velocity );
			if ( v < vMax )
			{
				if ( Owner.Opacity > 0.0 )
					Owner.Opacity -= offset;
			} else {
				if ( Owner.Opacity < dim1 )
					Owner.Opacity += offset;
				else if ( Owner.Opacity > dim2 )
					Owner.Opacity -= offset;
			}
		}
		clampOpacity();
		Pawn(Owner).Visibility = vis * Owner.Opacity;
	}

	Begin:

}

state Amplitude5
{
	function Tick(float deltaTime)
	{
		local float offset;
		
		offset = DeltaTime / ChangeTimer;
		if ( Owner.Opacity > 0.0 )
			Owner.Opacity -= offset;
		clampOpacity();
		Pawn(Owner).Visibility = vis * Owner.Opacity;
	}

	Begin:

}

state Amplitude6
{
	function Tick(float deltaTime)
	{
		local float offset;
		
		offset = DeltaTime / ChangeTimer;
		if ( Owner.Opacity > 0.0 )
			Owner.Opacity -= offset;
		clampOpacity();
		Pawn(Owner).Visibility = vis * Owner.Opacity;
	}

	Begin:

}

auto state Idle
{
	function Timer();
	
	Begin:
}

defaultproperties
{
     FlickerSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhaseFlicker01'
     DeactivateSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhaseEnd01'
     RemoteRole=ROLE_None
}
