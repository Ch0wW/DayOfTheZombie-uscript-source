// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XBoxPlayerInput extends PlayerInput;

var() config bool   bInvertVLook;

//horizontal look movement
var() float         XAccelScale;
var() float         XThreshold;
var	float	 	     LastABaseX;
var() config float  XLookRateMax;
var float           XAccelRate;

//vertical look movement
var() float         YAccelScale;
var() float         YThreshold;
var	float			  LastaLookup;
var() config float  YLookRateMax;
var float           YAccelRate;

var bool            bFirstTime;

struct ParamsTable {
    //horizontal look movement
    var float   XAccelScale;
    var float   XThreshold;
    var float   XLookRateMax;
    var float   XAccelRate;

    //vertical look movement
    var float   YAccelScale;
    var float   YThreshold;
    var float   YLookRateMax;
    var float   YAccelRate;
};

var Array<ParamsTable> Params;

/*****************************************************************
 * InvertLook
 *****************************************************************
 */
function bool InvertVLook(bool bIsChecked){
    bInvertVLook = bIsChecked;
    return bInvertVLook;
}


/*****************************************************************
 * SetSensitivity
 *****************************************************************
 */
function SetControllerSensitivity(float sensitivity){
    Sensitivity = int(sensitivity);

    Log ("Sensitivity set" $ Sensitivity);

    XAccelScale = Params[Sensitivity].XAccelScale;
    XThreshold = Params[Sensitivity].XThreshold;
    XLookRateMax = Params[Sensitivity].XLookRateMax;
    XAccelRate = Params[Sensitivity].XAccelRate;

    YAccelScale = Params[Sensitivity].YAccelScale;
    YThreshold = Params[Sensitivity].YThreshold;
    YLookRateMax = Params[Sensitivity].YLookRateMax;
    YAccelRate = Params[Sensitivity].YAccelRate;
}


/*****************************************************************
 * SameDirection
 *****************************************************************
 */
function bool SameDirection(float currentDir, float LastDir){
   if( CurrentDir <= 0 && LastDir > 0) {
      return false;
	} else if( CurrentDir >= 0 && LastDir < 0) {
      return false;
   } else if ( CurrentDir == 0) {
      return false;
   }
   return true;
}


/*****************************************************************
 * PlayerInput
 *****************************************************************
 */
function PlayerInput( float DeltaTime )
{
    local float FOVScale, MouseScale;

    // CARROT: Need to set this once this object is created
    if (bFirstTime) {
        SetControllerSensitivity(Sensitivity);
        bFirstTime = false;
    }

	// Ignore input if we're playing back a client-side demo.
	if( Outer.bDemoOwner && !Outer.default.bDemoOwner ){ return; }

	// Check for Double click move
	// flag transitions
	bEdgeForward = (bWasForward ^^ (aBaseY > 0));
	bEdgeBack = (bWasBack ^^ (aBaseY < 0));
	bEdgeLeft = (bWasLeft ^^ (aStrafe < 0));
	bEdgeRight = (bWasRight ^^ (aStrafe > 0));
	bWasForward = (aBaseY > 0);
	bWasBack = (aBaseY < 0);
	bWasLeft = (aStrafe < 0);
	bWasRight = (aStrafe > 0);

	// Smooth and amplify mouse movement
	FOVScale = DesiredFOV * 0.01111; // 0.01111 = 1/90
	MouseScale = MouseSensitivity * FOVScale;
	aMouseX = SmoothMouse(aMouseX*MouseScale, DeltaTime,bXAxis,0);
	aMouseY = SmoothMouse(aMouseY*MouseScale, DeltaTime,bYAxis,1);
	aMouseX = AccelerateMouse(aMouseX);
	aMouseY = AccelerateMouse(aMouseY);


   if ((aLookUp > YThreshold || aLookup < -YThreshold) &&
       SameDirection(aLookUp, LastaLookup)==true){
      YAccelScale *= YAccelRate;
   } else {
      YAccelScale = default.YAccelScale;
   }
	LastaLookUp = aLookUp;

	// adjust keyboard and joystick movements
   if (bInvertVLook){
   	aLookUp = aLookUp * FOVScale * -1  * YAccelScale; //@@@
   } else {
      aLookUp = aLookUp * FOVScale * YAccelScale; //@@@
   }

   if (aLookup > YLookRateMax) { aLookup = YLookRateMax; }
   if (aLookup < -YLookRateMax) { aLookup = -YLookRateMax; }


   //HORIZONTAL LOOK MOVEMENT
   //@@@ try to accelerate the x axis like Pariah did
   if ((aBasex > XThreshold || aBaseX < -XThreshold) &&
       SameDirection(aBaseX, LastABaseX)==true){
      XAccelScale *= XAccelRate;
   } else {
      XAccelScale = default.XAccelScale;
   }
	LastABaseX = aBaseX;
	if( bStrafe!=0 ){
		aStrafe += aBaseX * 7.5 + aMouseX;
	} else {// forward
		aTurn  += aBaseX * FOVScale * XAccelScale + aMouseX;
   }
   if (aTurn > XLookRateMax) { aTurn = XLookRateMax; }
   if (aTurn < -XLookRateMax) { aTurn = -XLookRateMax; }
	aBaseX = 0;


	// Remap mouse y-axis movement.
	if( (bStrafe == 0) && (bAlwaysMouseLook || (bLook!=0)) )	{
		// Look up/down.
		if ( bInvertMouse )
			aLookUp -= aMouseY;
		else
			aLookUp += aMouseY;
	}else { // Move forward/backward.
		aForward += aMouseY;
   }

	if ( bSnapLevel != 0 )	{
		bCenterView = true;
		bKeyboardLook = false;
	} else if (aLookUp != 0) {
		bCenterView = false;
		bKeyboardLook = true;
	} else if ( bSnapToLevel && !bAlwaysMouseLook ){
		bCenterView = true;
		bKeyboardLook = false;
	}

	// Remap other y-axis movement.
	if ( bFreeLook != 0 ){
		bKeyboardLook = true;
		aLookUp += 0.5 * aBaseY * FOVScale;
	}else {
		aForward += aBaseY;
   }
	aBaseY = 0;
	HandleWalking();
}

defaultproperties
{
     XAccelScale=0.130000
     XThreshold=700.000000
     XLookRateMax=1200.000000
     XAccelRate=1.200000
     YAccelScale=0.100000
     YThreshold=620.000000
     YLookRateMax=1000.000000
     YAccelRate=1.100000
     bFirstTime=True
     Params(0)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=800.000000,XAccelRate=1.080000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.050000)
     Params(1)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=900.000000,XAccelRate=1.100000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.060000)
     Params(2)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1000.000000,XAccelRate=1.130000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.070000)
     Params(3)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1100.000000,XAccelRate=1.160000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.100000)
     Params(4)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1200.000000,XAccelRate=1.200000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.100000)
     Params(5)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1300.000000,XAccelRate=1.300000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.100000)
     Params(6)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1400.000000,XAccelRate=1.400000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.110000)
     Params(7)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1500.000000,XAccelRate=1.500000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.120000)
     Params(8)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1600.000000,XAccelRate=1.600000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.130000)
     Params(9)=(XAccelScale=0.130000,XThreshold=700.000000,XLookRateMax=1700.000000,XAccelRate=1.700000,YAccelScale=0.100000,YThreshold=620.000000,YLookRateMax=1000.000000,YAccelRate=1.140000)
}
