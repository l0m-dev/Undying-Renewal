//=============================================================================
// ToggledTexture.
//=============================================================================
class ToggledTexture expands Info;

#exec TEXTURE IMPORT FILE=ToggleTexture.pcx GROUP=System Mips=Off

var() 	Texture 	BaseTexture;
var() 	Texture 	NewTexture;
var 	Texture 	Saved;
var 	bool		bBase;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	bBase = true;
	Saved = BaseTexture;
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
}

function StartLevel()
{
	if( bBase )
		BaseTexture.AnimCurrent = Saved;
	else
		BaseTexture.AnimCurrent = NewTexture;

	if( BaseTexture.AnimCurrent.AnimNext == None )
		BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;

	super.StartLevel();
}

defaultproperties
{
     Texture=Texture'Aeons.System.ToggleTexture'
}
