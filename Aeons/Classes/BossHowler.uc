//=============================================================================
// BossHowler.
//=============================================================================
class BossHowler expands Howler;

// BURT - All exec imports were ripped since it is just an update

defaultproperties
{
     MeleeInfo(0)=(Damage=40)
     MeleeInfo(1)=(Damage=20)
     MeleeInfo(2)=(Damage=25)
     GroundSpeed=500
     AccelRate=2000
     HatedClass=Class'Aeons.Donkey'
     Health=140
     Mesh=SkelMesh'Aeons.Meshes.BossHowler_m'
     DrawScale=1.3
}