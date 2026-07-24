//=============================================================================
// Spectator.
//=============================================================================
class Spectator extends PlayerPawn;

var bool bChaseCam;

function InitPlayerReplicationInfo()
{
	Super.InitPlayerReplicationInfo();
	PlayerReplicationInfo.bIsSpectator = true;
}

event FootZoneChange(ZoneInfo newFootZone)
{
}
	
event HeadZoneChange(ZoneInfo newHeadZone)
{
}

event PainTimer()
{
}

exec function Walk()
{	
}

exec function BehindView( Bool B )
{
	bBehindView = B;
	bChaseCam = bBehindView;
	if ( ViewTarget == None )
		bBehindView = false;
}

function ChangeTeam( int N )
{
	Level.Game.ChangeTeam(self, N);
}

exec function Taunt( name Sequence )
{
}

exec function CallForHelp()
{
}

exec function Fly()
{
	UnderWaterTime = -1;	
	SetCollision(false, false, false);
	bCollideWorld = true;
	GotoState('CheatFlying');

	ClientRestart();
}

function ServerChangeSkin( coerce string SkinName, coerce string FaceName, byte TeamNum )
{
}

function ClientReStart()
{
	//log("client restart");
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	BaseEyeHeight = Default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	
	GotoState('CheatFlying');
}

function PlayerTimeOut()
{
	local DamageInfo DInfo;

	if (Health > 0)
		Died(None, 'dropped', Location, DInfo);
}

// Send a message to all players.
exec function Say( string S )
{
	if ( Len(S) > 63 )
		S = Left(S,63);
	if ( !Level.Game.bMuteSpectators )
		BroadcastMessage( PlayerReplicationInfo.PlayerName$":"$S, true );
}

//=============================================================================
// functions.

exec function RestartLevel()
{
}

// This pawn was possessed by a player.
function Possess()
{
	bIsPlayer = true;
	EyeHeight = BaseEyeHeight;
	NetPriority = 2;
	Weapon = None;
	Inventory = None;
	Fly();
}

function PostBeginPlay()
{
	if (Level.LevelEnterText != "" )
		ClientMessage(Level.LevelEnterText);
	bIsPlayer = true;
	FlashScale = vect(1,1,1);
	if ( Level.NetMode != NM_Client )
		ScoringType = Level.Game.ScoreboardType;
}

//=============================================================================
// Inventory-related input notifications.

// The player wants to switch to weapon group numer I.
exec function SwitchWeapon (byte F )
{
}

exec function NextItem()
{
}

exec function PrevItem()
{
}

exec function Fire( optional float F )
{
	if (Role < ROLE_Authority)
		return;
	ViewPlayerNum(-1);
	bBehindView = bChaseCam;
	if ( ViewTarget == None )
		bBehindView = false;
}

//=================================================================================

function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
{
}

defaultproperties
{
     bChaseCam=True
     AirSpeed=400
     Visibility=0
     AttitudeToPlayer=ATTITUDE_Friendly
     MenuName="Spectator"
     bHidden=True
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
