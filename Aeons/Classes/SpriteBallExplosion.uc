//=============================================================================
// SpriteBallExplosion.
//=============================================================================
class SpriteBallExplosion expands AnimSpriteEffect;

var int ExpCount;

function MakeSound()
{
	PlaySound(EffectSound1,,7.0);
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_Client )
		MakeSound();
	Texture = SpriteAnim[int(FRand()*5)];	
	if (Level.NetMode==NM_Standalone) 
		SetTimer(0.05+FRand()*0.04,False);
	Super.PostBeginPlay();		
}

simulated Function Timer()
{

	local vector TempVect;


	ExpCount++;
	if (FRand()<0.4)
	{
		TempVect.X = (FRand()-0.5)*80.0;
		TempVect.Y = (FRand()-0.5)*80.0;
		TempVect.Z = (FRand()-0.5)*80.0;				
		Spawn(class'SpriteBallChild',Self, '', Location+TempVect);
	}
	
	if (FRand()<0.3)
	{
		TempVect.X = (FRand()-0.5)*60.0;
		TempVect.Y = (FRand()-0.5)*60.0;
		TempVect.Z = (FRand()-0.5)*60.0;		

	}
	
	if (ExpCount<4) SetTimer(0.05+FRand()*0.05,False);
	
}

defaultproperties
{
     NumFrames=8
     Pause=0.05
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.7
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     DrawScale=3.5
     LightType=LT_TexturePaletteOnce
     LightBrightness=192
     LightHue=27
     LightSaturation=71
     LightRadius=16
     bCorona=False
     LightSource=LD_Ambient
}
