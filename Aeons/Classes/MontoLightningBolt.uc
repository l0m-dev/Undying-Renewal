//=============================================================================
// MontoLightningBolt.
//=============================================================================
class MontoLightningBolt expands LightningBolt;

simulated function PreBeginPlay()
{
	//log("Monto Lightning Bolt: PreBeginPlay()", 'Misc');
}

simulated function PostNetBeginPlay()
{
	if (Level.NetMode == NM_Client)
	{
		Strike(Start, End);
		GotoState('Holding');
	}
}

function Init( float Seconds, vector StartPoint, vector EndPoint )
{
	// log("Monto Lightning Bolt: Init()", 'Misc');
	// Duration = Seconds;
	Strike(startPoint, endPoint);
	GotoState('Holding');
}


simulated function updateShaft(float DeltaTime, vector Start, vector End, float Chaos, float Width)
{
	local int i, HitJoint, Flags, numPoints, hp, TotalAmplitude;
	local float scalar, RScale;
	local vector loc, HitLocation, HitNormal, X, Y, Z, LastPoint, ld, td, LastY, LastZ, WaterSurface;
	local Actor A;
	local Texture HitTexture;
	local DamageInfo Di;

	HitTexture = none;
	if ( shaft != none )
	{
		Trace(HitLocation,HitNormal,HitJoint, End, Start, false);
		
		if ( HitLocation != vect(0,0,0) )
			End = HitLocation;

		if ( IsWaterZone(end) )
		{
			bWaterStrike = true;
			WaterSurface = GetZoneChangeLoc(Start, End, 2);
			if ( WaterSurface != vect(0,0,0) )
			{
				End = WaterSurface;
			}
		} else {
			bWaterStrike = false;
		}
		
		len = VSize(end-start) / float(numKnots);
		HitTexture = TraceTexture(end + (Normal(end-start) * 2), start, Flags);

		// update Lights
		for (i=0; i<4; i++)
			if (lts[i] != None)
				lts[i].SetLocation(start + (end-start) * 0.25 * i);

		if ( len < MinPtDist )
		{
			len = MinPtDist;
			numPoints = VSize(end-start) / minPtDist;
		} else {
			numPoints = 32;
		}

		LastPoint = Start;

		Shaft.GetParticleParams(0,Shaft.Params);
		Shaft.Params.Position = LastPoint;
		Shaft.Params.Width = 2;
		Shaft.SetParticleParams(0, Shaft.Params);

		for (i=1; i<32; i++)
		{
			if ( i < numPoints )
			{
				RScale = float(i)/float(numpoints);

				Len = VSize(End - LastPoint) / (NumPoints-i);

				LastY = Normal( Y * 0.5 + LastY ) * RandRange(-2-(Chaos * 1.25), 2 + (Chaos * 1.25));
				LastZ = Normal( Z * 0.5 + LastZ ) * RandRange(-2-(Chaos * 1.25), 2 + (Chaos * 1.25));

				Deltas[i] = (Deltas[i] * 0.25) +  (LastY + LastZ);

				Loc = LastPoint + (Normal(end-LastPoint) * len);
				Loc += VRand() * RandRange(2.0,4.0);
				
				// log("Delats[i] = "$Deltas[i], 'Spell');

				// Loc = LastPoint + (Normal(end-LastPoint) * len);
				// Loc += deltas[i];

				Shaft.GetParticleParams(i,Shaft.Params);
				Shaft.Params.Position = Loc;
				Shaft.Params.Width = (width + 2) * (1+ (i/float(numPoints)));
				Shaft.SetParticleParams(i, Shaft.Params);
				LastPoint = Loc;
			} else {
				Shaft.GetParticleParams(i,Shaft.Params);
				Shaft.Params.Position = LastPoint;
				Shaft.Params.Width = 0;
				Shaft.SetParticleParams(i, Shaft.Params);
			}
		}

		LastStrike = end;
	} else {
		log("..................Lightning:UpdateShaft:No Shaft!");
	}
}

auto state null
{

	//Begin:
	//	log("Begin State Null", 'Misc');
}

simulated state Holding
{
	simulated function Tick(float DeltaTime)
	{
		lastRand = vRand();
		UpdateShaft(DeltaTime, start, end , 100, 4);
	}
	
	simulated function Timer()
	{
		gotoState('Release');
	}

	Begin:
		setTimer(1, false);
		timeDampening = 3.0;
		//log("Begin State Holding", 'Misc');
		
	End:
}

simulated state Release
{
	simulated function BeginState()
	{
		local int i;
		
		for (i=0; i<4; i++)
			if (lts[i] != None)
				lts[i].Destroy();
	}

	Begin:
		StopSound(sndID);
		Shaft.Destroy();

		if (MetalDecal != none)
		{
			MetalDecal.Destroy();
		}
		if (sFX != none)
		{
			sFX.Shutdown();
			sFX = none;
		}

		if (pFX != none)
		{
			pFX.Shutdown();
			pFX = none;
		}
		Destroy();
}

defaultproperties
{
     bCausesDamage=False
}
