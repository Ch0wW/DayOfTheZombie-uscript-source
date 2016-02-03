// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * UtilsBinkVideo
 *  This is a wrapper to the bink video functionality. Note:
 * Bink ONLY works with D3D, by using these you are making the decision
 * NOT to support other graphic rendererd (like OpenGL)
 */
//class BinkVideoPlayer extends VideoPlayer
class BinkVideoPlayer extends VideoPlayer
native;

//===========================================================================
// VideoManager Interface
//===========================================================================

/*****************************************************************
 * PlayVideo
 *****************************************************************
 */

function PlayVideo(string v){ Bink_Play(v); }

/*****************************************************************
 * ScaleVideo
 *****************************************************************
 */
function ScaleVideo(float v) { Bink_Scale(v); }

/*****************************************************************
 * StopVideo
 *****************************************************************
 */
function StopVideo(){ Bink_Stop(); }

/*****************************************************************
 * VideoIsPlaying
 *****************************************************************
 */
function bool VideoIsPlaying(){ return Bink_Is_Playing(); }


//===========================================================================
// Native implmentation of the video with Bink
//===========================================================================

/*****************************************************************
 * Bink_Play
 * Start a video using the bink player, v is the path to the video.
 * Starting a video with a different videoplayer stops any currently
 * executing videos, which gives notification to the initiating player
 * about the video completion... then the newly specified video is played
 *****************************************************************
 */
native final function            Bink_Play                           (string v);


/*****************************************************************
 * Bink_Scale
 * Set the scaling for the bink video. Default = 1.0
 *****************************************************************
 */
native final function            Bink_Scale                          (float v);

/*****************************************************************
 * Bink_Stop
 * Stop execution of any bink being played. This stops videos even
 * if they were create by another VideoPlayer instance.
 *****************************************************************
 */
native final function            Bink_Stop                           ();

/*****************************************************************
 * Bink_Is_Playing
 * returns true if there is a video being executed, false otherwise
 *****************************************************************
 */
native final function bool       Bink_Is_Playing                     ();

/*****************************************************************
 * Bink_Video_Complete
 * Called by the engine when a video is no longer being rendered. Completed
 * will have the value of true if the video ended normally, and false
 * if the video ended due to an interruption.
 *****************************************************************
 */
event Bink_Video_Complete(bool completed){
    VideoComplete(completed);
}

defaultproperties
{
}
