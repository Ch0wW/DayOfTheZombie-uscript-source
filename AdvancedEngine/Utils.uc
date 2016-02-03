// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * Utils - A collection of handy utility functions, including:
 *
 *         - clamp methods for working with rotators
 *         - array sort
 *
 * Notes:
 *  The sort method uses "out" parameters for the arrays to get
 *  pass-by-reference semantics.  A "ref" parameter modifier could
 *  probably avoid some of the "out" overhead (see
 *  UObject::CallFunction).
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Nov 2003
 */
class Utils extends Object;

const MAX_PROPER = 32767.5;
const MAX_CLAMPED = 65535;
const MIN_PROPER = -32767.5;
const MIN_CLAMPED = -65535;

/**
 * Map a rotation value into its equivalent value in the range
 * [MIN_PROPER,MAX_PROPER].
 */
static function int clampProperComponent (float c){
    c = c % MAX_CLAMPED;
    if ( c > MAX_PROPER ) return -1 * ( MAX_CLAMPED - c );
    if ( c < MIN_PROPER ) return -1 * ( MIN_CLAMPED - c );
    return c;
}

/**
 * Change the component values of the rotator (in place) so that they all
 * lie in the range [MIN_PROPER,MAX_PROPER], but still represent the same
 * rotation.
 */
static function Rotator clampProper(Rotator r){
    r.Roll  = clampProperComponent(r.Roll);
    r.Pitch = clampProperComponent( r.Pitch );
    r.Yaw   = clampProperComponent( r.Yaw );
    return r;
}

/**
 * Sorts elements in non-descending order by c.  While this method is
 * algorithmically efficient O(n*log(n)), it is probably still
 * relatively heavy, so you won't want to use it in Tick().
 */
static function sort( out array<Object> Elements, Comparator c ) {
    local array<Object> tmp;
    tmp.length = elements.length;
    arraycopy( elements, 0, tmp, 0, tmp.length );
    mergeSort( elements, tmp, 0, elements.length, c );
    arraycopy( tmp, 0, elements, 0, elements.length );
}

/**
 * Ported from the standard Java implementation of mergeSort.
 */
private static function mergeSort( out array<Object> src,
                                   out array<Object> dest,
                                   int low, int high, Comparator c ) {
    local int length, i, j, p, q, mid;
    length = high - low;

    // Insertion sort on smallest arrays
    if (length < 7) {
        for ( i=low; i<high; i++) {
            for ( j=i; j>low && c.compare(dest[j-1], dest[j])>0; j-- ) {
                swap(dest, j, j-1);
            }
        }
        return;
    }

    // Recursively sort halves of dest into src
    mid = (low + high)/2;
    mergeSort(dest, src, low, mid, c);
    mergeSort(dest, src, mid, high, c);

    // If list is already sorted, just copy from src to dest.  This is an
    // optimization that results in faster sorts for nearly ordered lists.
    if ( c.compare(src[mid-1], src[mid]) <= 0 ) {
        arraycopy(src, low, dest, low, length);
        return;
    }

    // Merge sorted halves (now in src) into dest
    p = low; q = mid;
    for( i = low; i < high; i++ ) {
        if (q>=high || p<mid && c.compare(src[p], src[q]) <= 0) {
            dest[i] = src[p++];
        }
        else {
            dest[i] = src[q++];
        }
    }
}

/**
 * Swaps x[a] with x[b].
 */
private static function swap( out array<Object> x[], int a, int b ) {
    local Object t;
    t    = x[a];
    x[a] = x[b];
    x[b] = t;
}

/**
 * Copies an array from the specified source array, beginning at the
 * specified position, to the specified position of the destination
 * array.
 */
private static function arraycopy( out array<Object> src, int src_position,
                                   out array<Object> dst, int dst_position,
                                   int length ) {
    local int i, j;
    j = dst_position;
    for ( i = src_position; i < src_position + length; ++i ) {
        dst[j++] = src[i];
    }
}


/*****************************************************************
 * RndSound
 *****************************************************************
 */
static function sound RndSound(array<Sound> SndArray){
   return SndArray[FRand() * SndArray.length];
}

static function string GetLocalizedPackage(string objectname){
   return Left(objectname, InStr(objectname,"."));
}

static function string GetLocalizedSection(string objectname){
   return Right(objectname, (Len(objectname) - InStr(objectname,"."))-1);
}

defaultproperties
{
}
