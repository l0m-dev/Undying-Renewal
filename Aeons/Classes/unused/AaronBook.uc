//=============================================================================
// AaronBook.
//=============================================================================
class AaronBook expands HeldProp;

#exec MESH IMPORT MESH=AaronBook_m SKELFILE=AaronBook.ngf

var() float					FadeTime;			//

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( ( LifeSpan > 0.0 ) && ( FadeTime > 0.0 ) )
		Opacity = FMax( 0.0, Opacity - ( DeltaTime / FadeTime ) );
}

defaultproperties
{
     FadeTime=0.75
     DroppedLifespan=5
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.AaronBook_m'
     CollisionRadius=16
     CollisionHeight=8
}
