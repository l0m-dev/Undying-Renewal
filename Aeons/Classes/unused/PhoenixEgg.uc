//=============================================================================
// PhoenixEgg.
//=============================================================================
class PhoenixEgg expands WeaponProjectile;

var vector SeekLocation;

function Tick(float DeltaTime)
{
	local float NewSpeed;
	local rotator r;

	if ( Pawn(Owner) == none )
	{
		Destroy();
		return;
	}

	r = rotation;

	r.Yaw += (3268 * DeltaTime);
	SetRotation(r);

	if (VSize(Pawn(Owner).Velocity) > Speed)
		NewSpeed = VSize(Pawn(Owner).Velocity);
	else
		NewSpeed = Speed;

	SeekLocation = Pawn(Owner).Location + vect(0,0,1) * Pawn(Owner).EyeHeight + Vector(Pawn(Owner).ViewRotation) * 24;
	Velocity = NewSpeed * (Normal(SeekLocation - Location));
	
	if ( !Pawn(Owner).Weapon.IsA('Phoenix') )
	{
		Destroy();
		return;
	} else {
		if ( Phoenix(Pawn(Owner).Weapon).GetStateName() == 'Idle' )
		{
			Destroy();
			return;
		}
	}
}

defaultproperties
{
     Speed=50
     Mesh=SkelMesh'Aeons.Meshes.PhoenixAmmo_m'
     DrawScale=0.333
     bCollideActors=False
}
