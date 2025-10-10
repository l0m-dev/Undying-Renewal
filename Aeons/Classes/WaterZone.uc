class WaterZone expands ZoneInfo;

//#exec Texture Import File=WaterZoneInfo.pcx Name=WaterZoneInfo Mips=Off Flags=2
////#exec AUDIO IMPORT FILE="Sounds\Game\WaterSplash0.WAV" NAME="WaterSplash0" GROUP="Game"
////#exec AUDIO IMPORT FILE="Sounds\Game\WaterExit0.WAV" NAME="WaterExit0" GROUP="Game"

#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

defaultproperties
{
     EntrySound=Sound'CreatureSFX.SharedHuman.P_SlashIn01'
     ExitSound=Sound'CreatureSFX.SharedHuman.P_SplashOut01'
     bWaterZone=True
     ViewFlash=(X=-0.078,Y=-0.078,Z=-0.078)
     ViewFog=(X=0.1289,Y=0.1953,Z=0.17578)
     Texture=Texture'Aeons.WaterZoneInfo'
}
