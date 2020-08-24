//=============================================================================
// ClientScriptedTexture.
//=============================================================================
class ScryeTexture expands Info;

//#exec TEXTURE IMPORT FILE=ScryeTexture.pcx GROUP=System Mips=Off Flags=2

var PlayerPawn Player;
var bool bWasScrying;

var() Texture BaseTexture;
var() Texture ScryeTexture;
var Texture Saved;

simulated function FindPlayer()
{
	local PlayerPawn P; 

	foreach AllActors(class'PlayerPawn', P)
		if(Viewport(P.Player) != None)
			Player = P;
}

simulated function Tick(float DeltaTime)
{
	if ( Player == None ) 
	{
		FindPlayer();
	}
	
	if ( Player != None )
	{
		if ((Player.ScryeTimer>(Player.ScryeFullTime/2))&&(!bWasScrying))
		{
			
			bWasScrying = true;

			Saved = BaseTexture.AnimCurrent;
			
			BaseTexture.AnimCurrent = ScryeTexture;
			
			if ( BaseTexture.AnimCurrent.AnimNext == None )
				BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;
						
		}
		else if ((Player.ScryeTimer<=(Player.ScryeRampTime/2))&&(bWasScrying))
		{
				
			bWasScrying = false;
		
			BaseTexture.AnimCurrent = Saved;

			if ( BaseTexture.AnimCurrent.AnimNext == None )
				BaseTexture.AnimCurrent.AnimNext = BaseTexture.AnimCurrent;
					
		}
	}

}

defaultproperties
{
     bNoDelete=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
     Texture=Texture'Aeons.System.ScryeTexture'
}
