//=============================================================================
// GiveSpellEffect.
//=============================================================================
class GiveSpellEffect expands Info;

//#exec TEXTURE IMPORT FILE=GiveSpellEffect.pcx GROUP=System Mips=Off

var Gerald Player;
var class<ParticleFX> ParticleSysClass;
var float EffectLen;

function FindPlayer()
{
	ForEach AllActors(class 'Gerald', Player)
	{
		break;
	}
}

function Trigger(Actor Oter, Pawn Instigator)
{
	local Actor A;

	FindPlayer();
	
	if ( Player != none )
	{
		if (ParticleSysClass != none)
		{
			A = Spawn(ParticleSysClass, Player,,Player.Location);
			A.Lifespan = EffectLen;
		} else {
			Destroy();
		}
	} else {
		Destroy();
	}
}

defaultproperties
{
     ParticleSysClass=Class'Aeons.GiveSpellParticleFX'
     EffectLen=3
}
