//=============================================================================
// BulletSpang.
//=============================================================================
class BulletSpang expands HitSpangs;

#exec MESH IMPORT MESH=Bullet_Spang_m SKELFILE=BulletSpang.ngf

simulated function Tick(float deltaTime)
{
	drawScale *= 0.75 + (FRand() * 0.2);
}

defaultproperties
{
     LifeSpan=1
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.Bullet_Spang_m'
     DrawScale=2
     bUnlit=True
}
