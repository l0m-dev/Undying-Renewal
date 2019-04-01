//=============================================================================
// FireFly.
//=============================================================================
class FireFly expands DefSpell;

// BURT - All exec imports were ripped since it is just an update

var 	FireFly_proj ff;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	ProjectileClass = class'FireFly_proj';
	ProjectileSpeed = class'FireFly_proj'.default.speed;
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector Start, X,Y,Z, SeekLoc;

	// if ( PlayerPawn(Owner) != None )
	//	PlayerPawn(Owner).ClientInstantFlash( -0.4, vect(500, 0, 650));

	Owner.PlaySound(FireSound);
	AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);

	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + 32 * X + FireOffset.Z * Z; 
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	TraceFire(0.0, SeekLoc);
	//ff = Spawn(class 'FireFly_proj',,,  (JointPlace('Mid_Base')).pos,AdjustedAim);
	ff = Spawn(class 'FireFly_proj',Pawn(Owner),,  Start,AdjustedAim);
//	ff.PlayerOwner = Pawn(Owner);
	ff.CastingLevel = localCastingLevel;
	ff.seekLoc = seekLoc;
}

state NormalFire
{

	Begin:
		// PlayerPawn(Owner).ClientMessage("FireFly:NormalFire:BeginState");
		ProjectileFire(ProjectileClass, ProjectileSpeed, false, true);
		FinishAnim();
		sleep(RefireRate);
		Finish();
}

defaultproperties
{
     HandAnim=FireFly
     manaCostPerLevel(0)=20
     manaCostPerLevel(1)=20
     manaCostPerLevel(2)=20
     manaCostPerLevel(3)=20
     manaCostPerLevel(4)=20
     ProjectileClass=Class'Aeons.FireFly_proj'
     RefireRate=2
     FireSound=Sound'Aeons.Spells.E_Spl_FireFlyGen01'
     ItemType=SPELL_Defensive
     InventoryGroup=27
     PickupMessage="FireFly"
     ItemName="FireFly"
     PlayerViewOffset=(Z=-40)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
