class Bubble1 expands Effects;

function ZoneChange(ZoneInfo NewZone)
{
    // End:0x1F
    if(!NewZone.bWaterZone)
    {
        Destroy();
        //UnresolvedNativeFunction_97(EffectSound1);
    }
    return;
}

function BeginPlay()
{
    super(Actor).BeginPlay();
    // End:0x95
    if(Level.NetMode != NM_DedicatedServer)
    {
        //UnresolvedNativeFunction_97(EffectSound2);
        LifeSpan = 3.0 + (float(4) * FRand());
        Buoyancy = (Mass + FRand()) + 0.10;
        // End:0x69
        if(FRand() < 0.30)
        {
            //Texture = texture'S_Bubble2';
        }
        // End:0x80
        else
        {
            // End:0x80
            if(FRand() < 0.30)
            {
                //Texture = texture'S_Bubble3';
            }
        }
        DrawScale += ((FRand() * DrawScale) / float(2));
    }
    return;
}

defaultproperties
{
    VBits=class'ScriptedPawn'
}