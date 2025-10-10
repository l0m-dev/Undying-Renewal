//=============================================================================
// GlassHitDecal.
//=============================================================================
class GlassHitDecal expands AeonsDecal;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var() sound SpawnSound;

function PostBeginPlay()
{
	DrawScale = RandRange(0.1, 0.3);
	Super.PostBeginPlay();

	if ( SpawnSound != none )
		PlaySound(SpawnSound);
}

defaultproperties
{
     SpawnSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDeflect01'
     DecalTextures(0)=Texture'Aeons.HUD.ShieldCrack0'
     DecalTextures(1)=Texture'Aeons.HUD.ShieldCrack1'
     DecalTextures(2)=Texture'Aeons.HUD.ShieldCrack2'
     NumDecals=3
     DecalRange=16
     Style=STY_Translucent
}
