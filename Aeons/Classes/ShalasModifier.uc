//=============================================================================
// ShalasModifier.
//=============================================================================
class ShalasModifier expands PlayerModifier;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var bool 	bHUDEffect;
var float 	absorbManaPct;
var float 	Str;			// strength of HUD Effect
var vector 	Col;			// color of HUD effect
var vector  AdjLoc;
var AeonsPlayer Player;

//var int EffectSoundID;

//----------------------------------------------------------------------------

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	if (Owner != None && Owner.IsA('AeonsPlayer'))
		Player = AeonsPlayer(Owner);
	Col = vect(0.5,1,0.5) * 100;	// hud change color
	Str = 0.05;						// HUD change strength
	bHUDEffect = true;
}

state Activated
{

	function Timer()
	{
		if ( !AeonsPlayer(owner).useMana(1) )
			gotoState('Deactivated');
	}
	
	function AddParticles()
	{
		local int NumJoints, i;
		local name JointName;
		local Actor A;
		local place P;

		if ( Owner != none )
		{
			NumJoints = Owner.NumJoints();
			if ( NumJoints > 0 )
			{
				bActive = true;
				for (i=0; i<NumJoints; i++)
				{
					JointName = Owner.JointName(i);
					P = Owner.JointPlace(JointName);
					A = Spawn(class 'MandorlaParticleFX', Owner,, P.pos);
					A.SetBase(Owner,JointName, 'root');
				}
			}
		}
	}

	function BeginState()
	{
		SetBase(Owner);
		AmbientSound = EffectSound;
	}

	function EndState()
	{
		SetBase(None);
		AmbientSound = None;
		//Owner.PlaySound(EffectEndSound);
	}


	Begin:

		//EffectSoundID = Owner.PlaySound(EffectSound);

		if (Player != none)
			Player.bShalasActive = true;
		bActive = true;

		if ( bHUDEffect )
		{
			AddParticles();
			//PlayerPawn(Owner).ClientAdjustGlow( str, col );
			bHUDEffect = false;
		}

		if ( castingLevel == 0 ) {
			AbsorbManaPct = 0;
			setTimer( 1.0/25.0, true );
		} else if ( castingLevel == 1 ) {
			AbsorbManaPct = 0.25;
			setTimer( 1.0/25.0, true );
		} else if ( castingLevel == 2 ) {
			AbsorbManaPct = 0.25;
			setTimer( 1.0/20.0, true );
		} else if ( castingLevel == 3 ) {
			AbsorbManaPct = 0.5;
			setTimer( 1.0/20.0, true );
		} else if ( castingLevel == 4 ) {
			AbsorbManaPct = 0.5;
			setTimer( 1.0/15.0, true );
		} else if ( castingLevel == 5 ) {
			AbsorbManaPct = 0.75;
			setTimer( 1.0/10.0, true );
		} else {
			log("CastingLevel is invalid!!!");
			GotoState('Deactivated');	// bail out
		}

		AdjLoc = Pawn(Owner).location;
		AdjLoc.z -= 48;
		Pawn(Owner).bAcceptMagicDamage = false;
}

state Deactivated
{
	function RemoveParticles()
	{
		local Actor A;
		
		bActive = false;
		ForEach AllActors(class 'Actor', A)
			if ( A.Owner == Pawn(Owner) )
				if ( A.IsA('MandorlaParticleFX') )
					ParticleFX(A).Shutdown();
	}

	Begin:
		//Owner.StopSound(EffectSoundID);

		if (Player != none)
			Player.bShalasActive = true;

		bActive = false;
		RemoveParticles();
		if ( !bHUDEffect )
		{
			//PlayerPawn(Owner).ClientAdjustGlow( -str, -col );
			bHUDEffect = true;
		}
		PlayerPawn(Owner).bAcceptMagicDamage = true;
		GotoState('Idle');
}

auto state Idle
{
	Begin:
}

defaultproperties
{
     EffectSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShalaLoop01'
}
