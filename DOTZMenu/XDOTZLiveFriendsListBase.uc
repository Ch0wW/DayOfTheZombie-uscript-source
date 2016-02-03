// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveFriendsListBase extends XDOTZLivePage;

/* NOTE: KEEP THIS CLASS THE SAME AS XDOTZLiveFriendsListBaseIG */



// Notification icons
var Material icon_friend;
var Material icon_friend_sent;
var Material icon_friend_recv;
var Material icon_invite_recv;
var Material icon_invite_sent;

var Material icon_voice_muted;
var Material icon_no_voice;
var Material icon_voice_on;
var Material icon_voice_talking;

// state text
var localized string string_offline;
var localized string string_appears_offline;
var localized string string_online_playing;
var localized string string_online_playing_joinable;
var localized string string_online_not_in_game_session;
var localized string string_invite_received;
var localized string string_invite_sent;
var localized string string_request_received_by_you;
var localized string string_request_sent_by_you;

var localized string string_no_voice;
var localized string string_voice_on;
var localized string string_voice_off;
var localized string string_voice_through_tv;
var localized string string_voice_muted;


// Player status
enum FriendStatus {
    OFFLINE,
    APPEARS_OFFLINE,
    ONLINE_PLAYING,
    ONLINE_PLAYING_JOINABLE,
    ONLINE_NOT_IN_GAME_SESSION,
    INVITE_RECEIVED,           // To play a game
    INVITE_SENT,
    REQUEST_RECEIVED_BY_YOU,   // To join your friends list
    REQUEST_SENT_BY_YOU
};

enum VoiceStatus {
    VOICE_NONE,
    VOICE_TALKING,
    VOICE_ON,
    VOICE_OFF,
    VOICE_MUTED,
    VOICE_THROUGH_TV
};

/*****************************************************************
 * Items for the list
 *****************************************************************
 */

function VoiceStatus Get_Voice_Status_Friends () {
    // Update talking status
    if ( class'UtilsXbox'.static.VoiceChat_Mute_List_Is_Muted () )
        return VOICE_MUTED;

    if ( class'UtilsXbox'.static.Friends_Is_Voice_Enabled () ) {
        Log("Show Talking icon1");
        return VOICE_TALKING;
    } else {
        return VOICE_NONE;
    }
}

function FriendStatus Get_Friend_Status () {
    if ( class'UtilsXbox'.static.Friends_Is_Recv_Invitation() )
       return INVITE_RECEIVED;

    if ( class'UtilsXbox'.static.Friends_Is_Recv_Friend_Request() )
       return REQUEST_RECEIVED_BY_YOU;

    if ( class'UtilsXbox'.static.Friends_Is_Sent_Invitation() )
       return INVITE_SENT;

    if ( class'UtilsXbox'.static.Friends_Is_Sent_Friend_Request() )
       return REQUEST_SENT_BY_YOU;

    if ( class'UtilsXbox'.static.Friends_Is_Playing() &&
          class'UtilsXbox'.static.Friends_Is_Joinable() )
       return ONLINE_PLAYING_JOINABLE;

    if ( class'UtilsXbox'.static.Friends_Is_Playing() &&
         !class'UtilsXbox'.static.Friends_Is_Joinable() )
       return ONLINE_PLAYING;

    if ( class'UtilsXbox'.static.Friends_Is_Online() &&
         !class'UtilsXbox'.static.Friends_Is_Playing() )
       return ONLINE_NOT_IN_GAME_SESSION;

    if ( class'UtilsXbox'.static.Friends_Is_Offline() )
       return OFFLINE;
}

function string Get_Status_String () {
    local string voice_part;
    local string playing_game;

//    local VoiceStatus voice_status;
    local FriendStatus friend_status;

    voice_part = "";
    // Figure out voice part
/*
    voice_status = Get_Voice_Status_Friends();
    switch (voice_status) {
        case VOICE_NONE:        voice_part = string_no_voice;          break;
        case VOICE_ON:          voice_part = string_voice_on;          break;
        case VOICE_OFF:         voice_part = string_voice_off;         break;
        case VOICE_THROUGH_TV:  voice_part = string_voice_through_tv;  break;
        case VOICE_MUTED:       voice_part = string_voice_muted;       break;
    };
  */
    // Get the game title that friend is playing
    playing_game = class'UtilsXbox'.static.Friends_Get_Game_Name();
    //playing_game = "WWWWWWWWWWWWWWWW";
    if (Len(playing_game) > 15){
      playing_game = Left(playing_game, 15) $ "...";
    }


    // Figure out friend status part
    friend_status = Get_Friend_Status();
    switch (friend_status) {
        case OFFLINE:
             return string_offline;

        case APPEARS_OFFLINE:
             return string_appears_offline;

        case ONLINE_PLAYING:
             return string_online_playing $ " " $ playing_game $ " " $ voice_part;

        case ONLINE_PLAYING_JOINABLE:
             return string_online_playing_joinable $ " " $ playing_game $ " " $ voice_part;

        case ONLINE_NOT_IN_GAME_SESSION:
             return string_online_not_in_game_session $ " " $ playing_game $ " " $ voice_part;

        case INVITE_RECEIVED:
             return string_invite_received $ " " $ playing_game $ " " $ voice_part;

        case INVITE_SENT:
             return string_invite_sent $ " " $ voice_part;

        case REQUEST_RECEIVED_BY_YOU:
             return string_request_received_by_you;

        case REQUEST_SENT_BY_YOU:
             return string_request_sent_by_you;
    };

}

function Material Get_Friend_Status_Material () {
    local FriendStatus friend_status;

    // Figure out friend status part
    if (class'UtilsXbox'.static.Friends_Get_Selected() >= 0) {
        friend_status = Get_Friend_Status();

        switch (friend_status) {
            case OFFLINE:                        return None;
            case APPEARS_OFFLINE:                return None;
            case ONLINE_PLAYING:                 return icon_friend;
            case ONLINE_PLAYING_JOINABLE:        return icon_friend;
            case ONLINE_NOT_IN_GAME_SESSION:     return icon_friend;
            case INVITE_RECEIVED:                return icon_invite_recv;
            case INVITE_SENT:                    return icon_invite_sent;
            case REQUEST_RECEIVED_BY_YOU:        return icon_friend_recv;
            case REQUEST_SENT_BY_YOU:            return icon_friend_sent;
        };
    } else {
        return none;
    }
}

function Material Get_Voice_Status_Material_Friends () {
    local VoiceStatus voice_status;

    // Figure out voice part
    voice_status = Get_Voice_Status_Friends();
    switch (voice_status) {
        case VOICE_NONE:        return None;
        case VOICE_TALKING:     return icon_voice_on;
        case VOICE_MUTED:       return icon_voice_muted;
     };

}

/*****************************************************************
 * DefaultProperties
 *****************************************************************
 */

defaultproperties
{
     icon_friend=Texture'DOTZTInterface.XBoxIcons.Friend'
     icon_friend_sent=Texture'DOTZTInterface.XBoxIcons.FriendInvite'
     icon_friend_recv=Texture'DOTZTInterface.XBoxIcons.FriendRequest'
     icon_invite_recv=Texture'DOTZTInterface.XBoxIcons.Invite'
     icon_invite_sent=Texture'DOTZTInterface.XBoxIcons.SentInvite'
     icon_voice_muted=Texture'DOTZTInterface.XBoxIcons.VoiceMuted'
     icon_no_voice=Texture'DOTZTInterface.XBoxIcons.NoVoice'
     icon_voice_on=Texture'DOTZTInterface.XBoxIcons.VoiceOnB'
     icon_voice_talking=Texture'DOTZTInterface.XBoxIcons.VoiceOn'
     string_offline="Offline"
     string_appears_offline="Offline"
     string_online_playing="Playing"
     string_online_playing_joinable="Available in"
     string_online_not_in_game_session="Online in"
     string_invite_received="Wants to play"
     string_invite_sent="Invited to play"
     string_request_received_by_you="Wants to be your Friend"
     string_request_sent_by_you="You asked to be Friend"
     string_voice_on="Voice: On"
     string_voice_off="Voice: Off"
     string_voice_through_tv="Voice through TV"
     string_voice_muted="Voice: Off"
}
