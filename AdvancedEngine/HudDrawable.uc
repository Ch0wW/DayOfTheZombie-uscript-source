// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * HudDrawable - implemented by objects that can be drawn to the HUD.
 *    To actually get drawn, the object must register(self) with the
 *    AdvancedHud, found in GetLocalPlayerController().myHUD.  If the
 *    object no longer needs to be drawn, call unregister(self).
 *
 * Might be nice to make provisions for 2D animation through this
 * interface...
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class HudDrawable extends Object
   interface
   abstract;

/**
 * Draw yourself to the canvas.  Scale is relative to a 1280x1024
 * canvas.  This function is called every frame, so be quick about
 * it.
 */
function drawToHUD( Canvas c, float scaleX, float scaleY );

/**
 * Analogous to drawHUD, but used for debugging info (e.g. for LDs)
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY );

defaultproperties
{
}
