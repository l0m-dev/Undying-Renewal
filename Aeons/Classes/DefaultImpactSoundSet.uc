//=============================================================================
// DefaultImpactSoundSet.
//=============================================================================
class DefaultImpactSoundSet expands ImpactSoundSet;

#exec OBJ LOAD FILE=..\Sounds\FootSteps.uax PACKAGE=FootSteps
#exec OBJ LOAD FILE=..\Sounds\Impacts.uax PACKAGE=Impacts

defaultproperties
{
     Default=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Stone01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Stone02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Stone03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Glass=(Impact=(O_Volume=1.5,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Glass01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Glass02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Glass03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Water=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Water01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Water02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Water03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Leaves=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Leaves01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Leaves02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Leaves03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Snow=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Snow01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Snow02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Snow03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Grass=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Earth01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Earth02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Earth03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Organic=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Water01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Water02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Water03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Carpet=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Carpet01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Carpet02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Carpet03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Earth=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Earth01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Earth02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Earth03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Sand=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Snow01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Snow02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Snow03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     WoodHollow=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_WoodH01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_WoodH02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_WoodH03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     WoodSolid=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_WoodS01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_WoodS02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_WoodS03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Stone=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Stone01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Stone02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Stone03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
     Metal=(Impact=(O_Volume=1,O_Pitch=1,O_PitchVar=0.2,Sound1=Sound'Impacts.SurfaceSpecific.E_Imp_Metal01',Sound2=Sound'Impacts.SurfaceSpecific.E_Imp_Metal02',Sound3=Sound'Impacts.SurfaceSpecific.E_Imp_Metal03',T_Volume=1,T_Pitch=1,T_PitchVar=0.2))
}
