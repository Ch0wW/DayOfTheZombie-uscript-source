// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// TeamLogonClient.
//=============================================================================
class UPreviewMapListClient extends UPreviewSkinnedDialogClientWindow;


#exec Texture Import File=Textures\UTechLogo.pcx Name=iUTechLogo Group=Menu Flags=2 
#exec Texture Import File=Textures\MapListSkin.pcx Name=iMapListSkin Group=Menu Mips=Off
#exec Texture Import File=Textures\MapListBk.pcx Name=iMapListBk Group=Menu Flags=2
#exec AUDIO IMPORT FILE=Sounds\Click.wav Name=mnuClick

var UWindowLabelControl WindowTitle;	// The title of the menu
var UWindowListBox MyMaps;
var int GoCount;
	

function Created()
{
	local PlayerController PC;

	Super.Created();

	PC = GetPlayerOwner();
	

	WindowTitle = UWindowLabelControl(CreateControl(class'UWindowLabelControl',110,3,290,20));
	WindowTitle.Font = 1;
	WindowTitle.Text = "Select Map to Preview...";
	WindowTitle.Align = TA_Center;
	WindowTitle.TextColor = class'canvas'.static.MakeColor(0,0,0);

	MyMaps = UWindowListBox(CreateControl(class'UwindowListBox',35,120, WinWidth-70, WinHeight-120));
	MyMaps.ItemHeight = 25;
	MyMaps.Font=2;
	MyMaps.Align=TA_Center;
	MyMaps.TextColor=class'canvas'.static.MakeColor(255,255,255);
	MyMaps.SelectionBkgColor=class'canvas'.static.MakeColor(0,0,0);
	MyMaps.SelectionColor=class'canvas'.static.MakeColor(255,255,0);
//	MyMaps.bNoSelectionBox = true;
	MyMaps.VertSB.HideWindow();
	MyMaps.Register(Self);
	
	MyMaps.AddItem("AW-Junkyard");
	MyMaps.AddItem("CTF-Coyote");
	MyMaps.AddItem("CTF-Grotto");
	MyMaps.AddItem("CTF-Nightfall");
	MyMaps.AddItem("SC_Citytest");
	MyMaps.AddItem("UW-BlackForest1");
	MyMaps.AddItem("CP_CogTest3");
	MyMaps.AddItem("CP_UnderGeist");
	MyMaps.AddItem("CP_UWCog");
	MyMaps.AddItem("CTF-Ravine");
	MyMaps.AddItem("CTF-Echolon");
	
}

function BeforePaint(Canvas C, float X, float Y)
{
	WinLeft = (C.ClipX/2)-(WinWidth/2);
//	WinTop  = (C.ClipY/2)-(WinHeight/2);
	WinTop  = 0;
	
	if (MyMaps.SelectedItem==None)
		MyMaps.SetSelectedItem(UWindowListBoxItem(MyMaps.Items.Next));
	
	Super.BeforePaint(c,x,y);
}

function Paint(Canvas C, float X, float Y)
{
	local int S;
	local Color H;
	local float xl,yl;
	local string st;

		
	H = C.DrawColor;
	S = C.Style;

	C.Style =1;
	C.SetPos((WinWidth/2)-172,25);
	C.DrawTile( texture 'iUTechLogo',343,82,0,0,343,82);
	
	C.SetPos(0,0);
	
	C.Style = 4;
	C.DrawTile( texture 'iMapListBk',WinWidth,WinHeight,0,0,512,512);
	C.Style = S;
	C.DrawColor = H;

	C.SetPos(0,0);

	Super.Paint(C,X,Y);	
	
	if (GoCount>0)
	{
		MyMaps.HideWindow();
		GoCount++;

		C.Font = Root.Fonts[F_LargeBold];
		C.SetDrawColor(255,255,0);
		
		st = "Loading...";
		C.StrLen(st,xl,yl);
		xl = (C.ClipX/2)-(xl/2); 
		
		C.SetPos(xl,120);
		C.DrawTextClipped(st);
		
		st = MyMaps.SelectedItem.Caption;
		C.SetDrawColor(255,0,255);

		C.StrLen(st,xl,yl);
		C.SetPos((WinWidth/2)-(xl/2),120+5+yl);
		C.DrawTextClipped(st);

		if (GoCount==10)
		{
			Root.ConsoleCommand("LAUNCHXBOXMAP "$MyMaps.SelectedItem.Caption);
		}
		
	}

}

function Notify(UwindowDialogControl C, byte E)
{
	if ( (c==MyMaps) && (E==DE_Change) )
	{
		GoCount=1;
	}
}

defaultproperties
{
     DrawStyle=3
     Skin=Texture'UPreview.Menu.iMapListSkin'
     WinWidth=512.000000
     WinHeight=480.000000
     bLeaveOnscreen=True
}
