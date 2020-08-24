//=============================================================================
// ScriptedPawnTeam.
//=============================================================================
class ScriptedPawnTeam expands actor;

var(AICombat) float	Aggressiveness;
var	float			Strength;
var float			CurrentStrength;
var float			MemberContribution;
var	ScriptedPawn	Leader;
var bool			bIsInitialized;

function Init()
{
	if( !bIsInitialized )
	{
		Strength = 1.0;
		CurrentStrength = Strength;
		MemberContribution = 1.0;
		Leader = none;
		bIsInitialized = true;
	}
}

function SendMessage( ScriptedPawn.ETeamMessage Message, ScriptedPawn Sender, actor ExtraData )
{
	local ScriptedPawn sPawn;

	sPawn = Leader;
	while ( sPawn != none )
	{
		if ( sPawn != Sender )
			sPawn.TeamAIMessage( Sender, Message, ExtraData );
		sPawn = sPawn.NextTeamMember;
	}
}

function Tick( float DeltaTime )
{
	local ScriptedPawn sPawn;

	CurrentStrength = Strength;
	sPawn = Leader;

	while( sPawn != none )
	{
		if( sPawn.IsRetreating() )
			CurrentStrength -= MemberContribution;
		sPawn = sPawn.NextTeamMember;
	}	
}

function bool ShouldCharge( ScriptedPawn Teammate, ScriptedPawn Charging, actor Enemy )
{
	local pawn		EnemyPawn;
	local vector	vTeammateToEnemy;
	local vector	vChargingToEnemy;
	local float		dTeammateToEnemy;
	local float		dChargingToEnemy;
	local float		avgAggressiveness;
	local float		randomAdvanceFactor;

	EnemyPawn = pawn(Enemy);
	if( EnemyPawn != none )
	{
		avgAggressiveness = Teammate.Aggression();
		vTeammateToEnemy = Enemy.Location - Teammate.Location;
		vChargingToEnemy = Enemy.Location - Charging.Location;
		dTeammateToEnemy = vTeammateToEnemy dot vTeammateToEnemy;
		dChargingToEnemy = vChargingToEnemy dot vChargingToEnemy;

		// If the player is reloading, make team member more likely to charge.
		if( (PlayerPawn(Enemy) != none) && (PlayerPawn(Enemy).bReloading) )
			avgAggressiveness *= 2.0;

		// If the enemy is looking at member, make that member less likely to charge.
		if( Teammate.EnemyFOVAngle() > 0.966 )	// ~15 degrees -- values are Cos(Angle)
			avgAggressiveness *= 0.5;

		if( (avgAggressiveness * dTeammateToEnemy) < dChargingToEnemy )
		{
			return false;
		}
		else if( avgAggressiveness < Teammate.RelativeStrength( EnemyPawn ) )
		{
			return false;
		}
		randomAdvanceFactor = (3.0 - avgAggressiveness);
		randomAdvanceFactor *= randomAdvanceFactor;
		if( (randomAdvanceFactor * FRand()) > (dTeammateToEnemy / dChargingToEnemy) )
		{
			return false;
		}
	}
	return true;
}

function bool ShouldSupport( ScriptedPawn Teammate, ScriptedPawn Charging, actor Enemy )
{
	return true;
}

function float Aggression()
{
	return CurrentStrength * Aggressiveness;
}

function bool IsMember( ScriptedPawn member )
{
	local ScriptedPawn sPawn;

	sPawn = Leader;
	while( (sPawn != none) && (sPawn != member) )
	{
		sPawn = sPawn.NextTeamMember;
	}

	return sPawn == member;
}

function MemberKilled( pawn killed )
{
	local ScriptedPawn		sPawn;
	local ScriptedPawn		pPawn;

	if( ScriptedPawn(killed) != none )
	{
		// nominate a new leader.
		if( ScriptedPawn(killed) == Leader )
		{
			sPawn = Leader.NextTeamMember;
			if ( sPawn != none )
			{
				// pass the baton
				sPawn.bIsTeamLeader = true;
				Leader = sPawn;
				Leader.TeamNewLeader( killed );
			}
		}
		// Remove killed pawn from linked list.
		else if( Leader != none )
		{
			sPawn = Leader.NextTeamMember;
			pPawn = Leader;

			while( sPawn != none )
			{
				if( sPawn == ScriptedPawn(killed) )
				{
					pPawn.NextTeamMember = sPawn.NextTeamMember;
				}
				else
				{
					pPawn = sPawn;
				}
				sPawn = sPawn.NextTeamMember;
			}
		}
	}
	Strength = max( 0.0, Strength - MemberContribution );
}

// add a ScriptedPawn to the team (only team leader can do this)
function RegisterMember( ScriptedPawn aPawn )
{
	if ( aPawn.bIsTeamLeader )
	{
		Leader = aPawn;
		Leader.NextTeamMember = none;
	}
	else
	{
		aPawn.NextTeamMember = Leader.NextTeamMember;
		Leader.NextTeamMember = aPawn;
		MemberContribution = MemberContribution / (MemberContribution + 1);
	}
}

function LogTeam()
{
	local ScriptedPawn	sPawn;

	sPawn = Leader;
	sPawn.DebugLogMessage( "Team leader is " $ sPawn.name );

	sPawn = sPawn.NextTeamMember;
	while ( sPawn != none )
	{
		sPawn.DebugLogMessage( "Team member: " $ sPawn.name );
		sPawn = sPawn.NextTeamMember;
	}
	Leader.DebugLogMessage( "" );
}

defaultproperties
{
     Aggressiveness=0.5
     bHidden=True
}
