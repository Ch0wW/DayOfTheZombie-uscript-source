// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * VQuantityBar - a quantity bar, displayed vertically.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class VQuantityBar extends HudQuantity;

//===========================================================================
// Editable properties
//===========================================================================

// size of the visible part of the textures, in texels.
var(HudQuantity) const int LayerWidth;
var(HudQuantity) const int LayerHeight;
// top-right texel to start drawing from..
var(HudQuantity) const int BackdropOffsetU;
var(HudQuantity) const int BackdropOffsetV;
var(HudQuantity) const int OverlayOffsetU;
var(HudQuantity) const int OverlayOffsetV;
var(HudQuantity) const int BarOffsetU;
var(HudQuantity) const int BarOffsetV;


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
    local float debt;
    // precompute some useful values...
    xpos = positionX * scaleX;
    ypos = positionY * scaleY;
    w    = layerWidth * scaleX;
    h    = layerHeight * scaleY;
    c.SetDrawColor( 255, 255, 255, 255 );
    // draw backdrop...
    if ( backdrop != None ) {
        c.setPos( xpos, ypos );
        c.DrawTile( backdrop, w , h, 
                              backdropOffSetU, backdropOffSetV, 
                              layerWidth, layerHeight ); 
    }
    // draw bar
    if ( bar != None ) {
        // debt in texels...
        debt = (MaxQuantity - amount) * (layerHeight / MaxQuantity);
        c.setPos( xpos, (positionY + debt) * scaleY );
        c.DrawTile( bar, w, (layerHeight - debt) * scaleY, 
                         BarOffsetU, BarOffsetV + debt, 
                         layerWidth, layerHeight - debt ); 
    }
    if ( overlay != None ) {
        // draw overlay
        c.setPos( xpos, ypos );
        c.DrawTile( overlay, w , h, 
                             overlayOffsetU, overlayOffsetV, 
                             layerWidth, layerHeight ); 
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     LayerWidth=64
     LayerHeight=64
}
