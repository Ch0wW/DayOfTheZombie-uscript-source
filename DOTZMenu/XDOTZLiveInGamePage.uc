// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//  XDOTZErrorPage - Base class for error pages
//-----------------------------------------------------------

class XDOTZLiveInGamePage extends XDOTZInGamePage;

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

// Done in player controller
/*function Periodic ()
{
    local bool network_unplugged;

    network_unplugged = class'UtilsXbox'.static.Network_Is_Unplugged();
    if (network_unplugged && Controller.TopPage() == self) {
        // Display loading screen
        Controller.OpenMenu("DOTZMenu.XDOTZSLNoNetworkCable");
    }
} */

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
}
