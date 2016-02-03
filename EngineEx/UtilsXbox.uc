// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * UtilsXboxLive
 *  This is a wrapper tothe xbox live functionality.
 */
class UtilsXbox extends Object
      native;

// Live Errors
native static final function int        Get_Last_Error   ();
native static final function            Set_Last_Error   (int error_code);

// Live account management
native static final function            Refresh_Accounts ();
native static final function int        Get_Num_Accounts ();
native static final function string     Get_Account_Name (int account_id);

native static final function            Select_Account   (int account_id);

native static final function string     Get_Current_Name    ();
native static final function string     Get_Current_ID      ();
native static final function string     Get_Current_Address ();

native static final function            Reaquire_Addr    ();    // Don't use

// Password
native static final function bool       Needs_Password   ();
native static final function bool       Check_Password   (int a, int b, int c, int d);

// Signing in and out
native static final function            Attempt_Silent_Sign_In   ();
native static final function            Attempt_Sign_In          ();
native static final function            Cancel_Sign_In           ();
native static final function bool       Sign_In_Pump             ();
native static final function bool       Is_Signed_In             ();
native static final function            Sign_Out                 ();

native static final function bool       Is_Auto_Need_Password    ();
native static final function bool       Is_Auto_Failed           ();

// Kicked by user with same name
native static final function bool       Is_Kicked                ();

// optional message
native static final function bool       Is_Optional_Message      ();


// Dashboard routines
native static final function            Do_Create_Account   ();
native static final function            Do_Management       ();
native static final function            Do_Auto_Update      ();
native static final function            Do_Troubleshooter   ();
native static final function            Do_Message_Check    ();
native static final function            Do_Dashboard        ();

// Setting status
native static final function            Set_Player_Offline      ();
native static final function            Set_Player_Online       ();
native static final function            Set_Player_Playing      ();
native static final function            Set_Player_Not_Playing  ();
native static final function            Set_Player_Joinable     ();
native static final function            Set_Player_Not_Joinable ();

native static final function bool       Is_Player_Online_Set    ();
native static final function bool       Is_Player_Playing_Set   ();
native static final function bool       Is_Player_Joinable_Set  ();

/*****************************************************************
 * Match making
 *****************************************************************
 */

// Match making
native static final function            Match_Refresh               ();
native static final function            Match_Refresh_Criteria      (int gt, int np);  // -1 is widcard
native static final function            Match_Cancel_Refresh        ();
native static final function bool       Match_Refresh_Pump          ();

native static final function int        Match_Get_Num_Sessions      ();

// Must select a match before using the "Get" functions below
native static final function            Match_Select                (int qm_id);
native static final function int        Match_Get_Selected          ();

native static final function string     Match_Get_HostAddress       ();
native static final function string     Match_Get_SessionName       ();
native static final function int        Match_Get_GameType          ();
native static final function int        Match_Get_TimeLimit         ();
native static final function int        Match_Get_ScoreLimit        ();
native static final function int        Match_Get_RegenerateAmmo    ();
native static final function int        Match_Get_MaxPlayers        ();
native static final function int        Match_Get_PrivateSlots      ();
native static final function int        Match_Get_Map_Index         ();

native static final function int        Match_Get_PublicOpen        ();
native static final function int        Match_Get_PrivateOpen       ();
native static final function int        Match_Get_PublicFilled      ();
native static final function int        Match_Get_PrivateFilled     ();

/*****************************************************************
 * Cross title match updating
 *****************************************************************
 */

native static final function bool       Is_Cross_Title_Invite       ();
native static final function string     Cross_Invited_Friend        ();
native static final function string     Cross_Friend                ();
native static final function            Cross_Refresh               ();
native static final function bool       Cross_Refresh_Pump          ();
native static final function            Cross_Cancel_Refresh        ();

/*****************************************************************
 * System Link
 *****************************************************************
 */

// Hosting services
native static final function            Syslink_Start_Host          (string gn);
native static final function            Syslink_Stop_Host           ();

// Client services
native static final function            Syslink_Refresh_Hosts       ();
native static final function int        Syslink_Get_Num_Hosts       ();

native static final function string     Syslink_Get_Host_Name_At    (int h_id);
native static final function            Syslink_Select_Host         (int h_id);

/*****************************************************************
 * Reboot manager
 *****************************************************************
 */

native static final function            Set_Save_Enable	            (bool save_en);
native static final function bool		Get_Save_Enable				();

simulated native static final function int        Get_Reboot_Type                     ();
native static final function                      Set_Reboot_Type                     (int v);

// for configuring the system link host
native static final function            SysLink_Host_Set_Match_Name         (string v);

// for configuring the live host
native static final function            Live_Host_Set_Match_Name            (string v);
native static final function            Live_Host_Set_Map_Name              (string v);
native static final function            Live_Host_Set_Game_Type             (int v);
native static final function            Live_Host_Set_Score_Limit           (int v);
native static final function            Live_Host_Set_Time_Limit            (int v);
native static final function            Live_Host_Set_Max_Players           (int v);
native static final function            Live_Host_Set_Private_Slots         (int v);
native static final function            Live_Host_Set_Regenerate_Ammo       (int v);
native static final function            Live_Host_Set_Map_Index             (int v);

// Session updating
native static final function            Live_Host_Set_PublicFilled          (int v);
native static final function            Live_Host_Set_PublicOpen            (int v);
native static final function            Live_Host_Set_PrivateFilled         (int v);
native static final function            Live_Host_Set_PrivateOpen           (int v);
native static final function            Live_Host_Update_Session            ();

// for configuring the live client
native static final function            Live_Client_Set_Joining_Friend      (bool v);
native static final function            Live_Client_Set_Joining_Cross       (bool v);

// for single player
native static final function            SinglePlayer_Set_Map_Name           (string v);

/*****************************************************************
 * Network stuff
 *****************************************************************
 */

native static final function bool       Network_Is_Unplugged                ();


/*****************************************************************
 * Friends List
 *****************************************************************
 */

//native static final function            Friends_Begin_List                  ();
native static final function bool       Friends_Refresh_List                ();
//native static final function            Friends_End_List                    ();

native static final function int        Friends_Get_Num_Friends             ();
native static final function            Friends_Select                      (int f_id);
native static final function            Friends_Select_By_XUID              (string f_id);
native static final function int        Friends_Get_Selected                ();

native static final function string     Friends_Get_Gamer_Tag               ();
native static final function string     Friends_Get_ID                      ();
native static final function bool       Friends_Is_Online                   ();
native static final function bool       Friends_Is_Offline                  ();
native static final function bool       Friends_Is_Playing                  ();
native static final function string     Friends_Get_Game_Name               ();

// Have you sent an invitation to this friend
native static final function            Friends_Send_Invitation             ();
native static final function            Friends_Send_Invitation_With_Voice  ();
native static final function bool       Friends_Is_Sent_Invitation          ();
native static final function            Friends_Cancel_Invitation           ();
native static final function bool       Friends_Is_Rejected_Invitation      ();
native static final function bool       Friends_Is_Accepted_Invitation      ();

native static final function bool       Friends_Is_Invitation_For_Same_Title();
native static final function            Friends_Get_Friends_Session         ();

// Has the friend sent you an invitation
native static final function bool       Friends_Is_Any_Recv_Invitation      ();
native static final function bool       Friends_Is_Recv_Invitation          ();
native static final function            Friends_Accept_Invitation           ();
native static final function            Friends_Deny_Invitation             ();
native static final function            Friends_Remove_Inviter              ();

native static final function bool       Friends_Is_Joinable                 ();
native static final function            Friends_Join_Friend                 ();

// Friend Requests
// Have you sent a friend request
native static final function            Friends_Send_Friend_Request               (string f_id);
native static final function            Friends_Send_Friend_Request_With_Voice    (string f_id);
native static final function bool       Friends_Is_Sent_Friend_Request            ();
native static final function            Friends_Cancel_Friend_Request             ();
native static final function            Friends_Remove_Friend                     ();   //L2-5-10

// Has the person sent you a friend request
native static final function bool       Friends_Is_Any_Recv_Friend_Request  (); //L2-7-1
native static final function bool       Friends_Is_Recv_Friend_Request      ();
native static final function            Friends_Accept_Friend_Request       ();
native static final function            Friends_Deny_Friend_Request         ();
native static final function            Friends_Block_Friend_Request        (); //L2-5-7

native static final function bool       Friends_Is_Voice_Enabled            ();

native static final function            Friends_Send_Feedback               (string f_gt, string f_xuid, int fb);

/*****************************************************************
 * Voice
 *****************************************************************
 */

native static final function            VoiceChat_Select_Talker_By_XUID     (string f_xuid);
native static final function            VoiceChat_Select_Local_Talker       ();
native static final function            VoiceChat_Select_Talker             (int f_id);
native static final function int        VoiceChat_Get_Selected              ();

native static final function bool       VoiceChat_Is_Talking                ();
native static final function bool       VoiceChat_Is_Banned                 ();
native static final function bool       VoiceChat_Is_Enabled                ();

native static final function bool       VoiceChat_Is_Voice_Thru_Speakers    ();
native static final function            VoiceChat_Set_Voice_Thru_Speakers   (bool v);

native static final function            VoiceChat_Set_Voice_Mask_None       ();
native static final function            VoiceChat_Set_Voice_Mask_Anonymous  ();

native static final function bool       VoiceChat_Is_Local_Enabled          ();
native static final function bool       VoiceChat_Is_Local_Banned           ();

native static final function            VoiceChat_Mute_List_Add             ();
native static final function            VoiceChat_Mute_List_Remove          ();
native static final function bool       VoiceChat_Mute_List_Is_Muted        ();

// Voice mail
native static final function            VoiceChat_Record_Voice_Mail         ();
native static final function            VoiceChat_Play_Voice_Mail           ();
native static final function float      VoiceChat_Get_Voice_Mail_Time       ();
native static final function            VoiceChat_Stop_Voice_Mail           ();
native static final function bool       VoiceChat_Is_Stopped                ();
native static final function            VoiceChat_Clear_Voice_Mail          ();

/*****************************************************************
 * Notifications
 *****************************************************************
 */

native static final function bool       Has_Friend_Request_Notification     ();
native static final function bool       Has_Game_Invite_Notification        ();
native static final function bool       Has_New_Game_Invite_Notification    ();

/*****************************************************************
 * Messaging
 *****************************************************************
 */

// Selecting messages
native static final function int        Messaging_Get_Num_Messages              ();
native static final function            Messaging_Select_Message                (int f_id);
native static final function int        Messaging_Get_Selected_Message          ();

// Find friend request message
native static final function int        Messaging_Find_Friend_Request_Message   (string f_xuid);
native static final function int        Messaging_Find_Game_Invite_Message      (string f_xuid);

// for voice attachments
native static final function bool       Messaging_Has_Voice_Attachment          ();
native static final function            Messaging_Download_Voice_Attachment     ();

native static final function string     Messaging_Get_Sender_Gamertag           ();
native static final function string     Messaging_Get_Sender_XUID               ();

/*****************************************************************
 * Controller
 *****************************************************************
 */

native static final function            Capture_Next_Controller                 ();
native static final function int        Get_Captured_Controller                 ();
native static final function            Set_Captured_Controller                 (int f_gp);
native static final function            Clear_Captured_Controller               ();
native static final function bool       Check_Captured_Controller               ();

native static final function            Rumble_Controller                       (float f_strength, float f_decay);
native static final function            Stop_Rumble                             ();

/*****************************************************************
 * Containers
 * These hold xbox data that needs to be signed. Like profiles and
 * save games...
 *****************************************************************
*/
// For creating containers
native static final function int Create_Container(string name, string iconsrc);
native static final function bool Delete_Container(int i);
native static final function bool Delete_Matching_Containers (string Key, string Value);

// For iterating containers
native static final function int	Get_Num_Containers();
native static final function bool Is_Valid_Container(int i);
native static final function int        Get_Demo_Mode ();

// Filtering functions
native static final function int	Get_Num_Filtered_Containers();
native static final function int	Filtered_To_Real_Index(int i);
native static final function Filter_Containers(string Key, string Value);
native static final function Filter_Containers_All();

// Accessing container data
native static final function string	Get_Container_Name(int i);
native static final function string	Get_Container_Path(int i);

// Meta data
native static final function string	Get_Container_Meta(int i, string Key);
native static final function Set_Container_Meta(int i, string Key, string Value);

// Opening and closing a container for reading and writing
native static final function bool Open_Container(int i, bool write);
native static final function bool      Close_Container();

native static final function int      Get_All_Containers_Size   (int max_size);

native static final function          Refresh_Memory_Unit		();
native static final function string   Get_Memory_Unit_Name		();

native static final function int      Get_Total_Blocks	      	();
native static final function int      Get_Total_Free_Blocks		();

native static final function          Dashboard_Free_Blocks		(int blocks);


/*****************************************************************
 * Checking for enough free space
 *****************************************************************
*/

native static final function bool Check_Free_Space (int i);

defaultproperties
{
}
