//=============================================================================
// WaterGlobe.
//=============================================================================
class WaterGlobe expands Fixtures;

#exec MESH IMPORT MESH=WaterGlobe_m SKELFILE=WaterGlobe.ngf 

var ParticleFX p;
var GlowSprite g;

function PostBeginPlay()
{
	super.PostBeginPlay();
	AttachEffects();
	LoopAnim('Idle');
}

function AttachEffects()
{
	p = Spawn(class 'Aeons.WaterGlobeParticleFX',,,JointPlace('Fire').pos,rotator(vect(0,0,1)));
	p.SetBase(self, 'Fire');

	g = Spawn(class 'Aeons.UnderWaterGlowSprite',,,JointPlace('Fire').pos);
	g.SetBase(self, 'Fire', 'Root');
}

defaultproperties
{
     bStatic=False
     DrawType=DT_Mesh
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.WaterGlobe_m'
     bUnlit=True
     bMRM=False
     CollisionRadius=24
     CollisionHeight=76
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
