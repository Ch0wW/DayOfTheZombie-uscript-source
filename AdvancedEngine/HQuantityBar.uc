// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * VQuantityBar - a quantity bar, displayed vertically.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class HQuantityBar extends HudQuantity;

//===========================================================================
// Editable properties
//===========================================================================

var(HudQuantity) enum EAlignment {
    ALIGN_CENTER,
    ALIGN_LEFT
} HorizontalAlignment;

// desired height and width 
var(HudQuantity) const int SizeX;
var(HudQuantity) const int SizeY;
// max amount of this timer, so that scale is relative to largest size.
var(HudQuantity) float TimerMax;

//===========================================================================
// Internal data
//===========================================================================


//===========================================================================
// HudQuantity interface
//===========================================================================

/**
 * Call from your HUD code every frame...
 */
function drawQuantity( float amount, 
                       Canvas c, float scaleX, float scaleY ) {
    local int xpos, ypos, w, h;
    local float hscale;

    // precompute some useful values...
    hScale = (sizeX/MaxQuantity) * scaleX;
    w      = TimerMax * hScale;
    h      = sizeY * scaleY;
    switch( HorizontalAlignment ) {
    case ALIGN_CENTER:
        // figure out where left would be...
        xpos = (positionX * scaleX) - w/2;
        break;
    case ALIGN_LEFT:
    default:
        xpos = positionX * scaleX;
    }
    ypos = positionY * scaleY;        

    c.SetDrawColor( 255, 255, 255, 255 );
    // draw backdrop...
    if ( backdrop != None ) {
        c.setPos( xpos, ypos );
        c.DrawTileStretched( backdrop, w , h );
    }
    // draw bar...
    if ( bar != None ) {
        c.setPos( xpos, ypos );
        c.DrawTileStretched( bar, w - ((TimerMax - amount) * hScale), h );
    }
    // draw overlay...
    if ( overlay != None ) {
        c.setPos( xpos, ypos );
        c.DrawTileStretched( overlay, w , h );
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
