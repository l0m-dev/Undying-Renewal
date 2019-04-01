//=============================================================================
// LightningTreeBtm.
//=============================================================================
class LightningTreeBtm expands Decoration;
#exec MESH IMPORT MESH=LightningTreeBtm_m SKELFILE=LightningTreeBtm.ngf 

var Actor Top;
var savable bool bTopFallen;
var() float AnimRate;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Top = Spawn(class 'LightningTreeTop',self,,JointPlace('Pivot').pos, Rotation);
	Top.DrawScale = DrawScale;
	// Top.SetBase(self, 'Pivot', 'RootTop');
	// Top.SetBase(none);
}

event PostLoadGame()
{
	if( bTopFallen )
	{
		// log( "Trying to reset to saved state." );
		Top.PlayAnim('TreeFall',10.0,MOVE_Anim);
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	if ( Top != none )
	{
		if (!bTopFallen)
		{
			// PlayAnim( name Sequence, optional float Rate, optional EMovement move, optional ECombine combine, optional float TweenTime, optional name JointName, optional bool AboveJoint, optional bool OverrideTarget );
			Top.PlayAnim('TreeFall',AnimRate,MOVE_Anim);
			bTopFallen = true;
		}
	}
}

defaultproperties
{
     AnimRate=1
     bStatic=False
     bSavable=True
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.LightningTreeBtm_m'
}
