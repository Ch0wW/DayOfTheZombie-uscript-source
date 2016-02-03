// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * HudQuantity - base class for displaying a quantity of something on
 *               the HUD.  Assumes the AdvancedHud canvas scale and
 *               reference dimensions.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class HudQuantity extends Object
   hidecategories( Object );

//===========================================================================
// Editable properties
//===========================================================================

// position of top-left corner of the component on the reference canvas
var() const int PositionX;
var() const int PositionY;
// bottom-most layer
var() Material Backdrop;
// the material used to show the quantity
var() Material Bar;
// top-most layer
var() Material Overlay;
// largest amount that can be displayed (100% of capacity)
var() float MaxQuantity;


//===========================================================================
// HudQuantity interface
//===========================================================================

/**
 * Call from your HUD code every frame...
 */
function drawQuantity( float amount, 
                       Canvas c, float scaleX, float scaleY );


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     MaxQuantity=100.000000
}
