//=============================================================================
// ArcaneWhorlFX.
//=============================================================================
class ArcaneWhorlFX expands ScriptedFX;

var name JointNames[64];
var int NumJoints;
var AeonsPlayer Player;

function PreBeginPlay()
{
	local int i;
	local name JointName;
	local float p;

	if (Owner == none)
	{
		log("Arcane Whorls FX shutting Down because I have no Owner", 'Misc');
		bShuttingDown = true;
		return;
	}

	setLocation(Owner.Location);
	setBase(Owner);
	NumJoints = Owner.NumJoints();
	
	if (NumJoints > 0)
	{
		// Iterate the joints
		for (i=0; i<NumJoints; i++)
		{
			JointNames[i] = Owner.JointName(i);
			AddParticle(i, Owner.JointPlace(JointNames[i]).pos);
		}
	}
	
	Enable('Tick');
	bUpdate = true;
}

function SetPlayer(AeonsPlayer P)
{
	Player = P;
}

function RenderOverlays(Canvas Canvas)
{
	local int i;

	log("ArcaneWhorlsFX - RenderOverlays", 'Misc');
	if ( Player != none )
	{
		if ( !bShuttingDown )
		{
			if ( Owner == none)
			{
				bShuttingDown = true;
				return;
			} else {
			
				SetLocation(Owner.Location);

				if ( NumJoints > 0 )
					for (i=0; i<NumJoints; i++)
						if ( FRand() < 0.15 )
						 AddParticle(i, Owner.JointPlace(JointNames[i]).pos);
			}
		}
	}
}

defaultproperties
{
     AngularSpreadWidth=(Rand=180)
     AngularSpreadHeight=(Rand=180)
     Speed=(Rand=20)
     Lifetime=(Rand=0.25)
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     AlphaStart=(Rand=0.5)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=4)
     SizeLength=(Base=4)
     SizeEndScale=(Rand=2)
     Gravity=(Z=500)
     Textures(0)=Texture'Aeons.Particles.PotFire09'
     RenderPrimitive=PPRIM_Billboard
}
