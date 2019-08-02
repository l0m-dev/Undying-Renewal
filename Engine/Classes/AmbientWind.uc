//=============================================================================
// AmbientWind.
//=============================================================================
class AmbientWind expands Wind;

//
// Place anywhere in a level to get global, varying wind.
//

defaultproperties
{
     WindSpeed=128
     WindRadius=255
     WindFluctuation=255
     WindSource=LD_Ambient
     bPermeating=True
}
