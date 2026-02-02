/*
 * hyperchromatic-nova/Source/hcnova/Util.hx
 */

package hcnova;

function randomFloatFromRange(lowerBound:Float, upperBound:Float) {
  final range = upperBound - lowerBound;

  return Math.random() * range + lowerBound;
}

