//=============================================================================
// AeonsSinglePlayer.
//=============================================================================
class AeonsSinglePlayer expands AeonsPlayer
	abstract;

#exec OBJ LOAD FILE=..\Sounds\Impacts.uax PACKAGE=Impacts

function MakePlayerNoise(float Loudness, optional float Radius)
{
	if (Radius > 0)
		MakeNoise( Loudness * VolumeMultiplier, Radius );
	else
		MakeNoise( Loudness * VolumeMultiplier);
	
	if ( StealthMod != none )
	{
		if (StealthModifier(StealthMod).CurrentAudible < 1)
			StealthModifier(StealthMod).SpikeAudible(Loudness);
	}
}

defaultproperties
{
     WaterParticles=Class'Aeons.DrippingWetParticleFX'
     PI_StabSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshStab01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshStab02')
     PI_BiteSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshBite01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshBite02')
     PI_BluntSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshBlunt01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshBlunt02')
     PI_BulletSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet02')
     PI_RipSliceSound=(Sound_1=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice01',Sound_2=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice02')
     AnimSequence=Idle
     DrawType=DT_Mesh
     Style=STY_Normal
}
