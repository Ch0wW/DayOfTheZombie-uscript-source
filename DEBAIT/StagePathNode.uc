// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * StagePathNode - exists to provide compatibility with levels that
 *    were build before the StagePositions were taken off of the
 *    path-node network.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2003
 */
class StagePathNode extends StagePosition
   notplaceable;

#exec Texture Import File=Textures\BlueBall.tga Name=StageNodeIcon Mips=Off MASKED=1

defaultproperties
{
}
