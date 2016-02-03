// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * HudRadar - a fancy radar/compass widget for your HUD.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Feb 2004
 */
class HudRadar extends Object;




//===========================================================================
// Editable properties
//===========================================================================

// maximum range in UU of the radar.
var() int MaxRange;

// information about the things that can be displayed on the radar
// note: must be ordered from most-specific to least in class
// hierarchy.
struct RadarContactType {
    var Class<Actor> type;
    var bool bHide;
    var int Priority; 
    //   var Name tag;
    //   var Name group;
};
var() Array<RadarContactType> radarContactTypes;

// how often to update the contacts (seconds)
const RADAR_UPDATE_INTERVAL = 0.1;

// size of the backdrop and overlay textures
var() int RadarMaterialSize;
// how far from the center of the texture can we draw icons (in texels)?
var() int RadarMaterialRadius;
var() Material Backdrop;
var() TexRotator Overlay;
// a subdivided texture, which correspond to the radar-contact types
// in row major order, numbered from 0.
var() Material Icons;
var() int IconMaterialSize;
var() int SubdivisionSize;
// another subdivided texture
var() Material LongRangeIcons;
var() int LRIconMaterialSize;
var() int LRSubdivisionSize;

// location on reference canvas of the top-left corner of the radar
var() int PositionX;
var() int PositionY;

//var() int LRindex;
var() int LRContactCount;

//===========================================================================
// Internal data
//===========================================================================

// actor the radar is centered around
var private Actor myFocalActor;
//
var private Actor myHelper;

// currently visible actors on the radar
struct RadarContact {
    var Vector locn; // location in worldspace of the actor
    var int    subX; // subdivision row
    var int    subY; // subdivision column
    var int Priority;
};
var private Array<RadarContact> radarContacts;
//
struct LRContactInfo {
    var Actor actor;
    var int   subX;
    var int   subY;
};
// 
var private Array<LRContactInfo> LRContacts;

// number of subdivision in a row of the Icons material
var private int subsAcross;
// subsize / 2
var private int halfSubSize;
// number of subdivisions in a row of the long-range icons material
var private int LRSubsAcross;
// LRSubdivisionSize / 2
var private int halfLRSubSize;
// radarMaterialSize / 2
var private int halfRadarSize;
// scale from world space into texture space on the radar
var private float radarScale;

const RADAR_TIMER = 59273;


//===========================================================================
// Radar interface
//===========================================================================

/**
 * Call this to start up the radar.
 *
 * @param focalActor - the actor that the radar is centered around
 * @param helper - an actor that will make the callbacks need to drive
 *                 this object.
 */
function init( Actor focalActor, optional Actor helper ) {
                if ( !(focalActor != None ) ) {            Log( "(" $ self $ ") assertion violated: (focalActor != None )", 'DEBUG' );           assert( focalActor != None  );        }//    ;
    if ( helper == None ) helper = focalActor;

    myFocalActor  = focalActor;
    myHelper      = helper;
    subsAcross    = iconMaterialSize / subdivisionSize;
    LRSubsAcross  = LRIconMaterialSize / LRSubdivisionSize;
    radarScale    = float(radarMaterialRadius) / maxRange;
    halfSubSize   = subDivisionSize / 2;
    halfLRSubSize = LRSubdivisionSize / 2;
    halfRadarSize = radarMaterialSize / 2;
    myHelper.SetMultiTimer( RADAR_TIMER, RADAR_UPDATE_INTERVAL, true );
    LRContacts.length = 20;
}

/**
 * Halts the radar updates.
 */
function stop() {
    myHelper.SetMultiTimer( RADAR_TIMER, 0, false );
    myHelper     = None;
    myFocalActor = None;
}

/**
 * Call this whenever a RADAR_TIMER multi-timer goes off.
 */
function updateRangedContacts() {
    local Actor a;
    local int end, i;
    local Pawn p;
    
    // re-populate the radar contact array.
    radarContacts.Length = 0;
    for ( i = 0; i < radarContactTypes.length; ++i ) 
    {
        if (radarContactTypes[i].bHide == true) continue;
        ForEach myFocalActor.RadiusActors( radarContactTypes[i].type,
                                           a, MaxRange )
        {
            if ( a != myFocalActor ) {
                // skip hidden stuff...
                if ( a.bHidden ) continue;
                // skip dead pawns...
                p = Pawn( a );
                if ( p != None && p.health <= 0 ) continue;
                // store the neccessary contact info...
                end = radarContacts.length;
                radarContacts.length = radarContacts.length + 1;
                radarContacts[end].locn = a.Location;
                radarContacts[end].subX = i % subsAcross;
                radarContacts[end].subY = i / subsAcross;
                radarContacts[end].Priority = radarContactTypes[i].Priority;
            }
        } // end foreach-loop
    } // end for-loop
}

/**
 */
function int GetIndexForPairing(int Subx, int SubY){
   local int i;
   local int LRindex;

   LRindex = 0;
   for ( i = 0; i < LRContactCount; i++ ) {
      if ( LRContacts[i].Subx == Subx && LRContacts[i].SubY == Suby){
         return LRindex;
      }
      LRindex++;
   }
   //new so return a new index
   return LRindex++;
}


/**
 * Track the specified actor using the icon at subX,Y.
 */
function setLongRangeContact( Actor a, int subX, int subY ) {
    local int index;
    //                // Log( self @ "LR set" @ a  )    ;

    index = GetIndexForPairing(SubX, SubY);
    if ( a == None ) {
        LRContacts[index].actor = None;
    }
    else {
        LRContactCount++;
        LRContacts[index].actor = a;
        LRContacts[index].subX  = subX;
        LRContacts[index].subY  = subY;
    }
 }

/**
 */
function clearLRContacts() {
    local int i;
    for ( i = 0; i < LRContacts.length; ++i ) {
        LRContacts[i].actor = none;
    }
    LRContactCount = 0;
}

/**
 * Call from DrawToHud().
 */
function drawRadar( Canvas c, float scaleX, float scaleY) {
    local int i, posX, posY, matSzX, matSzY, iconSzX, iconSzY;
    local int centerX, centerY, LRIconSzX, LRIconSzY;
    local float distance;
    local vector v, relativePosn;
    local rotator r;

    // precompute some useful numbers...
    posX    = positionX * scaleX;
    posY    = positionY * scaleY;
    matSzX  = radarMaterialSize * scaleX;
    matSzY  = radarMaterialSize * scaleY;
    iconSzX = subdivisionSize * scaleX;
    iconSzY = subdivisionSize * scaleY;
    LRiconSzX = LRsubdivisionSize * scaleX;
    LRiconSzY = LRsubdivisionSize * scaleY;
    centerX = (positionX + halfRadarSize) * scaleX;
    centerY = (positionY + halfRadarSize) * scaleY;

    // lay down the backdrop
    c.SetPos( posX, posY );
    c.DrawTile( backdrop, matSzX, matSzY, 
                0, 0, radarMaterialSize, radarMaterialSize );

    // draw low priority ranged contacts
    for ( i = 0; i < radarContacts.Length; ++i ) {
        v = myFocalActor.location - radarContacts[i].locn;
        distance = Vsize( v );
        r= myFocalActor.rotation;
        r.Pitch = 0;
        r.Roll = 0;
        // depending on how often you update the contacts, some may
        // have moved beyond the range of the radar.
        if ( distance > MaxRange || radarcontacts[i].Priority != 0) continue;
        relativePosn 
            = radarScale * distance 
           * Vector( rotator(v) - (r - Rot(0,16384,0)) );
        C.SetPos( centerX + (relativePosn.X - halfSubSize ) * scaleX, 
                  centerY + (relativePosn.Y - halfSubSize ) * scaleY ); 
        C.DrawTile( icons, iconSzX, iconSzY,
                    radarContacts[i].subX * subDivisionSize,
                    radarContacts[i].subY * subDivisionSize,
                    subDivisionSize, subDivisionSize );
    } // end for-loop


    // draw unranged contacts
    for ( i = 0; i < LRcontacts.length; ++i ) {

       //re de-added
       //if ( LRContacts[i].actor == None || LRContacts[i].actor.bHidden ) {
        if ( LRContacts[i].actor == None ) {
            continue;
        }
        v = myFocalActor.location - LRContacts[i].actor.location;
        distance = fmin( Vsize(v), MaxRange );
        r= myFocalActor.rotation;
        r.Pitch = 0;
        r.Roll = 0;
        relativePosn 
            = radarScale * distance 
           * Vector( rotator(v) - (r  -Rot(0,16384,0)) );
        C.SetPos( centerX + (relativePosn.X - halfLRSubSize ) * scaleX, 
                  centerY + (relativePosn.Y - halfLRSubSize ) * scaleY ); 
        C.DrawTile( longRangeIcons, LRiconSzX, LRiconSzY,
                    LRContacts[i].subX * LRsubdivisionSize,
                    LRContacts[i].subY * LRsubdivisionSize,
                    LRsubdivisionSize, LRsubdivisionSize );        
    }

    // draw high priority ranged contacts
    for ( i = 0; i < radarContacts.Length; ++i ) {
        v = myFocalActor.location - radarContacts[i].locn;
        distance = Vsize( v );
        r= myFocalActor.rotation;
        r.Pitch = 0;
        r.Roll = 0;
        // depending on how often you update the contacts, some may
        // have moved beyond the range of the radar.
        if ( distance > MaxRange || radarcontacts[i].Priority != 1) continue;
        relativePosn 
            = radarScale * distance 
           * Vector( rotator(v) - (r - Rot(0,16384,0)) );
        C.SetPos( centerX + (relativePosn.X - halfSubSize ) * scaleX, 
                  centerY + (relativePosn.Y - halfSubSize ) * scaleY ); 
        C.DrawTile( icons, iconSzX, iconSzY,
                    radarContacts[i].subX * subDivisionSize,
                    radarContacts[i].subY * subDivisionSize,
                    subDivisionSize, subDivisionSize );
    } // end for-loop


    // draw the overlay on top...
    c.SetPos( posX, posY );
    overlay.rotation.yaw = myFocalActor.rotation.yaw + 16384;
    c.DrawTile( overlay, matSzX, matSzY, 0, 0, 
                radarMaterialSize, radarMaterialSize );                
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     MaxRange=3000
     RadarMaterialSize=256
     RadarMaterialRadius=100
     IconMaterialSize=64
     SubdivisionSize=16
     LRIconMaterialSize=64
     LRSubdivisionSize=32
     PositionX=16
     PositionY=16
}
