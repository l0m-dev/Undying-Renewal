//=============================================================================
// StripTest. 
//=============================================================================
class StripTest expands ParticleFX;


var float theta;
var ParticleFX P;
var PlayerPawn Player;

var int hackflag;


var vector BaseLocation;

simulated function FindPlayer()
{
	local PlayerPawn PP; 
	
	foreach AllActors(class'PlayerPawn', PP)
		if(Viewport(PP.Player) != None)
			Player = PP;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	BaseLocation = Location;
	

	P = Spawn( class'Engine.ParticleFX', self,, Location );
	
	P.ParticlesPerSec.Base = 100;
	
	//P.Lifetime.Base = 0.5;
	P.Lifetime.Base = 2;

	
	P.AngularSpreadWidth.Base = 180;
	P.AngularSpreadHeight.Base = 180;
	
	//P.Speed.Base = 200;
	P.Speed.Base = 10;

	P.ColorStart.Base.R = 255;
	P.ColorStart.Base.G = 255;
	P.ColorStart.Base.B = 255;

	P.ColorEnd.Base.R = 0;
	P.ColorEnd.Base.G = 0;
	P.ColorEnd.Base.B = 255;

	P.SizeWidth.Base = 32;
	P.SizeLength.Base = 32;
	P.SizeEndScale.Base = 0.5;

		
}

function Tick(float DeltaTime)
{
	local vector temp;

	Super.Tick(DeltaTime);
	
	theta += DeltaTime*2;
	if ( theta > 6.27 ) 
		theta = 0;	
	
	temp.x = BaseLocation.x + 350 * cos(theta);
	temp.y = BaseLocation.y + 350 * sin(theta);
	temp.z = BaseLocation.z + 80  * cos(theta*2);
	
	SetLocation( temp );


	if ( Player != None ) 
	{
		if ( Player.ScryeTimer > 0.0 ) 
		{
			ColorStart.Base.R = 255;
			ColorStart.Base.G = 255;
			ColorStart.Base.B = 255;
		
			ColorEnd.Base.R = 255;
			ColorEnd.Base.G = 0;
			ColorEnd.Base.B = 0;
			
			LifeTime.Base = 2;
			
			GravityModifier = -0.2;
			
			hackflag = 2;
		}
		else
		{
			if ( hackflag == 2 )
			{
				hackflag = 0;
				ParticlesAlive = 1;
			}
			else 
				ParticlesAlive = 0;
				
			ColorStart.Base.R = 0;
			ColorStart.Base.G = 0;
			ColorStart.Base.B = 255;
		
			ColorEnd.Base.R = 255;
			ColorEnd.Base.G = 0;
			ColorEnd.Base.B = 0;
			
			LifeTime.Base = 1;

			GravityModifier = 0;
			
		}
	}
	else
	{
		FindPlayer();
	}

  
}

defaultproperties
{
     ParticlesPerSec=(Base=20)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=0)
     AngularSpreadHeight=(Base=0)
     Speed=(Base=0)
     SizeWidth=(Base=64)
     SizeLength=(Base=64)
     SizeEndScale=(Base=0)
     Distribution=DIST_Uniform
     Textures(0)=Texture'UWindow.WhiteTexture'
     RenderPrimitive=PPRIM_Line
     LODBias=10
}
