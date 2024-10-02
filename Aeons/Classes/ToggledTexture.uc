//=============================================================================
// ToggledTexture.
//=============================================================================
class ToggledTexture expands Info;

//#exec TEXTURE IMPORT FILE=ToggleTexture.pcx GROUP=System Mips=Off

var() 	Texture 	BaseTexture;
var() 	Texture 	NewTexture;
var 	Texture 	Saved;
var 	bool		bBase;

var Texture AnimCurrent;
var Texture OldAnimCurrent;

replication
{
	unreliable if( Role==ROLE_Authority )
		AnimCurrent;
}

simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	bBase = true;
	Saved = BaseTexture;

	AnimCurrent = BaseTexture.AnimCurrent;
	OldAnimCurrent = AnimCurrent;

	if (Level.NetMode != NM_Client)
		Disable('Tick');
}

simulated function Tick(float DeltaTime)
{
	if (AnimCurrent != OldAnimCurrent)
	{
		BaseTexture.AnimCurrent = AnimCurrent;
		if ( BaseTexture.AnimCurrent.AnimNext == None )
			BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

		OldAnimCurrent = AnimCurrent;
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	if ( bBase )
	{
		BaseTexture.AnimCurrent = NewTexture;
	
		if ( BaseTexture.AnimCurrent.AnimNext == None )
			BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

		bBase = false;
	} else {
		BaseTexture.AnimCurrent = Saved;

		if ( BaseTexture.AnimCurrent.AnimNext == None )
			BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;
		bBase = true;
	}
	AnimCurrent = BaseTexture.AnimCurrent;
	OldAnimCurrent = AnimCurrent;
}

function StartLevel()
{
	if( bBase )
		BaseTexture.AnimCurrent = Saved;
	else
		BaseTexture.AnimCurrent = NewTexture;

	AnimCurrent = BaseTexture.AnimCurrent;
	OldAnimCurrent = AnimCurrent;

	if( BaseTexture.AnimCurrent.AnimNext == None )
		BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

	super.StartLevel();
}

defaultproperties
{
     Texture=Texture'Aeons.System.ToggleTexture'
     RemoteRole=ROLE_SimulatedProxy
     bAlwaysRelevant=True
     NetUpdateFrequency=2
     bNoDelete=True
}
