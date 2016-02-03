// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * WeatherEffect - 
 *
 * @version $Revision: #1 $
 * @author  Name (email@digitalextremes.com)
 * @date    Month 2003
 */
class WeatherEffect extends AdvancedActor
    placeable
    hidecategories(Actionable,Events,Sound,Movement,Collision,Lighting,LightColor,Karma,Force);

#exec Texture Import File=Textures\Weather.tga Name=WeatherIcon Mips=Off MASKED=1




//===========================================================================
// Editable properties
//===========================================================================
var() private class<Emitter> WeatherEffect;


//===========================================================================
// Implementation
//===========================================================================

/**
 */
function PreBeginPlay() {
    local WeatherEffect w;
    local int numWeatherEffects;

    super.PreBeginPlay();
    numWeatherEffects = 0;
    ForEach AllActors( Class, w ) {
        numWeatherEffects++;
                    if ( !(numWeatherEffects <= 1 ) ) {            Log( "(" $ self $ ") assertion violated: (numWeatherEffects <= 1 )", 'DEBUG' );           assert( numWeatherEffects <= 1  );        }//    ;
    }
}

/**
 * 
 */
function class<Emitter> GetWeatherEffectClass() {
    return WeatherEffect;
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bStatic=True
     bHidden=True
     bNoDelete=True
     Texture=Texture'AdvancedEngine.WeatherIcon'
}
