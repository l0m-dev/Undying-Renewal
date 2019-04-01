//=============================================================================
// FrozenMutator.
//=============================================================================
class FrozenMutator expands LightingMutator;

function MutateRenderParams(Actor A)
{
	if (!bResetToDefaults)
	{
		A.Lighting[0] = Lighting[0];
		A.Lighting[1] = Lighting[1];
		A.Opacity = Opacity;
	} else {
		A.Lighting[0] = A.default.Lighting[0];
		A.Lighting[1] = A.default.Lighting[1];
		A.Opacity = Opacity;
	}
	Destroy();
}

function Trigger(Actor Other, Pawn Instigator)
{
	local Actor A;
	
	if ( Event != 'none' )
	{
		ForEach AllActors(class 'actor', A, Event)
		{
			MutateRenderParams(A);
		}
	}
}

defaultproperties
{
     Opacity=0.5
     Lighting(0)=(Constant=(R=66,G=61,B=124),Diffuse=(R=142,G=192,B=206),SpecularHilite=(R=255,G=255,B=255),SpecularWidth=30,TextureMask=-1)
}
