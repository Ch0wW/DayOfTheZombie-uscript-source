// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZBrowser_PlayersList
 * -lists game servers received from Master Server
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    May 2005
 */
class DOTZBrowser_PlayersList extends GUIMultiColumnList;




var DOTZBrowser_ServerListPageBase MyPage;
var DOTZBrowser_ServersList  MyServersList;
var int listitem;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    OnDrawItem  = MyOnDrawItem;
    OnKeyEvent  = InternalOnKeyEvent;
    Super.Initcomponent(MyController, MyOwner);
}

function MyOnDrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected)
{
    local float CellLeft, CellWidth;

    GetCellLeftWidth( 0, CellLeft, CellWidth );
    Style.DrawText( Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, MyServersList.Servers[listitem].PlayerInfo[i].PlayerName );

    GetCellLeftWidth( 1, CellLeft, CellWidth );
    Style.DrawText( Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, string(MyServersList.Servers[listitem].PlayerInfo[i].Score) );

    if( MyServersList.Servers[listitem].PlayerInfo[i].StatsID != 0 )
    {
        GetCellLeftWidth( 2, CellLeft, CellWidth );
        Style.DrawText( Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, string(MyServersList.Servers[listitem].PlayerInfo[i].StatsID) );
    }

    GetCellLeftWidth( 3, CellLeft, CellWidth );
    Style.DrawText( Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, string(MyServersList.Servers[listitem].PlayerInfo[i].Ping) );
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    if( Super.InternalOnKeyEvent(Key, State, delta) )
        return true;

    if( State==1 )
    {
        switch(Key)
        {
        case 0x0D: //IK_Enter
            MyServersList.Connect(false);
            return true;
            break;
        case 0x74: //IK_F5
            //MyPage.RefreshList();
            return true;
            break;
        }
    }
    return false;
}

defaultproperties
{
     ColumnHeadings(0)="Player Name"
     ColumnHeadings(1)="Score"
     ColumnHeadings(2)="Stats ID"
     ColumnHeadings(3)="Ping"
     InitColumnPerc(0)=0.170000
     InitColumnPerc(1)=0.110000
     InitColumnPerc(2)=0.110000
     InitColumnPerc(3)=0.110000
     StyleName="BBListButton"
}
