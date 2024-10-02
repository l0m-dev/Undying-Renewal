//=============================================================================
// TypingIndicator.
//=============================================================================
class TypingIndicator expands Visible;

function Tick(float DT)
{
    if (PlayerPawn(Owner) == None)
    {
        Destroy();
        return;
    }

    bHidden = !PlayerPawn(Owner).bIsTyping;
}

defaultproperties
{
     Style=STY_AlphaBlend
     Texture=WetTexture'fxB.FX.HoundPortalWet'
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     bCollideWorld=False
     bTimedTick=True
     MinTickTime=0.25
     RemoteRole=ROLE_SimulatedProxy
}
