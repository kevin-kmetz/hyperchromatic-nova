/*
 * hyperchromatic-nova/Source/hcnova/Util.hx
 */

package hcnova;

#if js
  import js.Browser;
#end

function randomFloat(lowerInclusive:Float, upperExclusive:Float) {
  final range = upperExclusive - lowerInclusive;

  return Math.random() * range + lowerInclusive;
}

function randomInt(lowerInclusive:Int, upperInclusive:Int):Int {
  final range = upperInclusive - lowerInclusive + 1;

  return Std.random(range) + lowerInclusive;
}

function println(text):Void {
  #if js
    Browser.console.log(text);
  #elseif sys
    Sys.println(text);
  #else
    trace(text);
  #end
}

// This is hacky, but I really don't want to have to import a third-party
// library just to make a float cleanly printable, and I don't see any
// included printf/sprintf-style functions in the Haxe documentation.
//
function truncateFloat(f:Float):Float {
  return Math.ffloor(f * 100.0) / 100.00;
}

