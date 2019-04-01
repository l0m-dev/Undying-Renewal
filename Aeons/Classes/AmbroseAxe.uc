//=============================================================================
// ambroseaxe.
//=============================================================================
class ambroseaxe expands HeldProp;
#exec MESH IMPORT MESH=ambroseaxe_m SKELFILE=ambroseaxe.ngf

var(AICombat) float Health;

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	log( ".TakeDamage() called on AmbroseAxe joint " $ DInfo.JointName $ " damage = " $ DInfo.Damage $ ", type = " $ DInfo.DamageType $ ", Health = " $ Health $ "." );
	if( DInfo.JointName == 'axe_4' && DInfo.DamageType != 'fall' && DInfo.DamageType != 'hardfall' && DInfo.DamageType != 'drown' )
	{
		Health = Max( 5, Health - DInfo.Damage );
		if( (Ambrose(PawnOwner) != none) && (Health < 10) )
			Ambrose(PawnOwner).StoneHit();
	}
	DInfo.Damage = 0;
}

function Tick( float deltaTime )
{
	Health += 50.0 * deltaTime;
	if( Health > default.Health )
		Health = default.Health;
}

defaultproperties
{
     Health=25
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.ambroseaxe_m'
     CollisionRadius=10
     CollisionHeight=48
     bCollideActors=True
     bBlockActors=True
     bProjTarget=True
}
