//=============================================================================
// TriggeredTexture.
//=============================================================================
class TriggeredTexture expands Info;

//#exec TEXTURE IMPORT FILE=TriggeredTexture.pcx GROUP=System Mips=Off

var() Texture BaseTexture;
var() Texture TextureList[8];
var() int numTextures;
var 	Texture 	Original;
var savable int CurrentTexture;

function PreBeginPlay()
{
	super.PreBeginPlay();
	Original = BaseTexture;
	BaseTexture.AnimCurrent = BaseTexture;
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
}
function Trigger(Actor Other, Pawn Instigator)
{
	if (CurrentTexture < numTextures)
	{
		BaseTexture.AnimCurrent = TextureList[currentTexture];
	
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

	if( BaseTexture.AnimCurrent.AnimNext == none )
		BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

	super.StartLevel();
}

defaultproperties
{
     Texture=Texture'Aeons.System.TriggeredTexture'
}
