# hyperchromatic-nova/obtain_historical_reference_03.sh
#
# Obtains and runs the program that served as the earliest precursor and
# inspiration for HyperChromatic Nova, originally written in January of 2019.
# The program was left in a partially implemented state after the author sated
# his curiosity on the matter at that time. It was written in plain Java,
# utilizing AWT.
#
# Java (the Java Runtime Environment) will need to be installed on the system
# for the program to run - Java 11 or higher should suffice.
# cURL is also presumed to be present for this script to successfully execute,
# as is unzip.
#
# Run this script from the "hyperchromatic-nova" (project root) directory
# with the following command, assuming a Linux or Mac environment:
#   sh scripts/obtain_historical_reference_03.sh
#
# Instructions (keys):
#   'n' => generates new terrain
#   'a' => pan the view left
#
# Do note that this old version saves a PNG image each time terrain is generated,
# and they may clutter up the directory the program is launched from. A simple
# "rm *.png" should clean them up.

dir=$(basename "$PWD")
url="https://github.com/kevin-kmetz/terrain-generator/archive/refs/heads/master.zip"
savepath="historical-references/old-terrain-generator"
pathprefix=""

if [ "$dir" = "hyperchromatic-nova" ]; then
  pathprefix="."
elif [ "$dir" = "scripts" ]; then
  pathprefix=".."
else
  pathprefix="."
fi

fullpath="$pathprefix/$savepath"

mkdir -p "$fullpath"
curl -L -o "$fullpath/old-terrain-generator.zip" "$url"
unzip -d "$fullpath" "$fullpath/old-terrain-generator.zip"
java "$fullpath/terrain-generator-master/TerrainGenerator/TerrainViewer.java"

