//=============================================================================
// TriggeredTexture.
//=============================================================================
class TriggeredTexture expands Info;

//#exec TEXTURE IMPORT FILE=TriggeredTexture.pcx GROUP=System Mips=Off

var() Texture BaseTexture;
var() Texture TextureList[8];
var() int numTextures;
var 	Texture 	Original;
var int CurrentTexture;

var Texture AnimCurrent;
var Texture OldAnimCurrent;

replication
{
	reliable if( bNetInitial && Role==ROLE_Authority )
		BaseTexture;
	unreliable if( Role==ROLE_Authority )
		AnimCurrent;
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	Original = BaseTexture;
	BaseTexture.AnimCurrent = BaseTexture;

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

function PostLoadGame()
{
	if ( CurrentTexture != 0 )
	{
		BaseTexture.AnimCurrent = TextureList[currentTexture];		
	}
	else
	{
		BaseTexture.AnimCurrent = Original;
	}
	AnimCurrent = BaseTexture.AnimCurrent;
	OldAnimCurrent = AnimCurrent;
}

function Trigger(Actor Other, Pawn Instigator)
{
	if (CurrentTexture < numTextures)
	{
		BaseTexture.AnimCurrent = TextureList[currentTexture];
		AnimCurrent = BaseTexture.AnimCurrent;
		OldAnimCurrent = AnimCurrent;
	
		if ( BaseTexture.AnimCurrent.AnimNext == None )
			BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

		currentTexture ++;
	} else {
		Disable('Trigger');
	}
}

function StartLevel()
{
	local int i;
	
	i = CurrentTexture - 1;
	if( (i < numTextures) && (i >= 0) )
	{
		BaseTexture.AnimCurrent = TextureList[i];	
	}
	else if( i < 0 )
	{
		BaseTexture.AnimCurrent = Original;
	}
	AnimCurrent = BaseTexture.AnimCurrent;
	OldAnimCurrent = AnimCurrent;

	if( BaseTexture.AnimCurrent.AnimNext == none )
		BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

	super.StartLevel();
}

defaultproperties
{
     Texture=Texture'Aeons.System.TriggeredTexture'
     RemoteRole=ROLE_SimulatedProxy
     bAlwaysRelevant=True
     NetUpdateFrequency=2
}
