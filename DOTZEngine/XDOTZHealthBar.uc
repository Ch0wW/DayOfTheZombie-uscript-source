// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZHealthBar - a regular health bar with an alternate overlay for when the
 *      player is infected.  Assumes the infected overlay is on the same
 *      material as the original.
 *
 * @version $Rev: 4521 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Aug 2004
 */
class XDOTZHealthBar extends VQuantityBar;

// settings
var(HudQuantity) const int InfectedOverlayOffsetU;
var(HudQuantity) const int InfectedOverlayOffsetV;

// internal
var bool bInfected;
var Material OrigOverlay;


/**
 * Call this when player's infection status changes.
 */
function SetInfected( bool isInfected ) {
    bInfected = isInfected;
}

/**
 * Handle the infected overlay... works on the assumption that both the normal
 * overlay and the infected overlay are subdivisions of the same material.
 */
function drawQuantity( float amount,
                       Canvas c, float scaleX, float scaleY ) {
    local int xpos, ypos, w, h;

    // fool parent-class into not drawing the overlay...
    if ( bInfected ) {
        origOverlay = overlay;
        overlay     = none;
    }
    super.drawQuantity( amount, c, scaleX, scaleY );

    // and replace with the infected overlay...
    if ( bInfected ) {
        overlay = origOverlay;
        if ( overlay != None ) {
            xpos = positionX * scaleX;
            ypos = positionY * scaleY;
            w    = layerWidth * scaleX;
            h    = layerHeight * scaleY;
            // draw overlay
            c.setPos( xpos, ypos );
            c.DrawTile( overlay, w , h,
                                 infectedOverlayOffsetU, infectedOverlayOffsetV,
                                 layerWidth, layerHeight );
        }
    }
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     InfectedOverlayOffsetU=192
     LayerHeight=182
     BackdropOffsetU=128
     BarOffsetU=64
     PositionX=120
     PositionY=700
     Backdrop=Texture'DOTZTInterface.HUD.HealthBars'
     Bar=Texture'DOTZTInterface.HUD.HealthBars'
     Overlay=Texture'DOTZTInterface.HUD.HealthBars'
}
