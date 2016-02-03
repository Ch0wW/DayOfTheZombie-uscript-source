// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SubtitleSequence extends Object;

struct SubtitleInfo{
   var() string Text;
   var() float DisplaySecs;
};

var() name EventName;
var() localized array<SubtitleInfo> Subtitle;
var string Package;
var string Section;
var string SubtitleTxt;
var() int NextSequenceNum;

function int GetNextSequenceNum(){
   return NextSequenceNum;
}

function int GetLength(){
   return Subtitle.length;
}

/*****************************************************************
 * GetText
 *****************************************************************
 */
function string GetText(int i){

  /* Rember you said you would put this stuff back when you were
    done development and ready to localize? Remember?*/


   Package = Left(string(Self), InStr(string(Self),"."));
   Section = Right(string(Self), (Len(string(Self)) - InStr(string(Self),"."))-1);
   SubtitleTxt = Localize(Section, "Subtitle", Package);

   if (i >= Subtitle.length){
      return "END_OF_SEQUENCE";
   }

   if (SubtitleTxt != ""){
      return ConvertStupidLocalizedArrayToUsefulText(SubtitleTxt, i);
   }

   return Subtitle[i].Text;

}


/*****************************************************************
 *
 *****************************************************************
 */
function string ConvertStupidLocalizedArrayToUsefulText(string LocalizedArray, int Index){
   local string subData;
   local int i;
   for (i=0;i<Subtitle.length;i++){
      SubData = Left(LocalizedArray, InStr(LocalizedArray, ")"));
      LocalizedArray = Right(LocalizedArray, (Len(LocalizedArray) - InStr(LocalizedArray, ")") - 1));
      SubData = Right(SubData, Len(SubData) - 2);
      if (i == index){
         return ConvertSubDataToText(SubData);
      }
   }
}

function string ConvertSubDataToText(string Subdata){
   local string subtext;
   if (InStr(subdata, "Text=") == -1){
      return "";
   }

   subtext = Right(Subdata, (Len(Subdata) - Len("Text=") -1));
   subtext = Left(Subtext, Instr(Subtext, ",DisplaySecs=")-1);
   return subtext;

}

/*****************************************************************
 * GetTime
 *****************************************************************
 */
function float GetTime(int i){
   if (i >= Subtitle.Length){
      return 0;
   }
   return Subtitle[i].DisplaySecs;
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     NextSequenceNum=-1
}
