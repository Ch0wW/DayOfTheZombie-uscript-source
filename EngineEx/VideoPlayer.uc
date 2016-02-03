// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * UtilsBinkVideo
 *  This is an abstract wrapper to video functionality. Note:
 *  All scripts should use the parent functionality listed here
 *  and not the detail specific calls in child classes
 */
class VideoPlayer extends Object
 native;

var VideoNotification RegisteredObject;

/*****************************************************************
 * PlayVideo
 *****************************************************************
 */
public function PlayVideo(string v);

/*****************************************************************
 * ScaleVideo
 *****************************************************************
 */
public function ScaleVideo(float v);

/*****************************************************************
 * StopVideo
 *****************************************************************
 */
public function StopVideo();

/*****************************************************************
 * VideoIsPlaying
 *****************************************************************
 */
public function bool VideoIsPlaying();

/*****************************************************************
 * RegisterForNotification
 *****************************************************************
 */
public function RegisterForNotification(VideoNotification registrant){
    RegisteredObject = registrant;
}


function VideoComplete(bool completed){
    if (RegisteredObject != None){
        RegisteredObject.VideoComplete(completed);
    }
}

defaultproperties
{
}
