// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLivePage extends XDOTZPage;

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

// Done in player controller
/*function Periodic ()
{
    local bool network_unplugged;

    super.Periodic();

    network_unplugged = class'UtilsXbox'.static.Network_Is_Unplugged();
    if (network_unplugged && Controller.TopPage() == self) {
        // Display loading screen
        Controller.OpenMenu("DOTZMenu.XDOTZSLNoNetworkCable");
    }
} */

/*****************************************************************
 * default properties
 *****************************************************************
 */

defaultproperties
{
}
