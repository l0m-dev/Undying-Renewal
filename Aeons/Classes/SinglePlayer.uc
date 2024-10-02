//=============================================================================
// SinglePlayer.
//=============================================================================
class SinglePlayer extends AeonsGameInfo;

var string StartMap;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	bClassicDeathmessages = True;
}

function Killed(pawn Killer,pawn Other,name DamageType)
{
    // don't show death messages
}   

function DiscardInventory(Pawn Other)
{
    if (Other.Weapon != None) {
        Other.Weapon.PickupViewScale*=0.7;
    }
    Super.DiscardInventory(Other);
}

function PlayTeleportEffect(actor Incoming,bool bOut,bool bSound)
{
}

defaultproperties
{
     bHumansOnly=True
     bClassicDeathMessages=True
}
