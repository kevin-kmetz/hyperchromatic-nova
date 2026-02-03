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

