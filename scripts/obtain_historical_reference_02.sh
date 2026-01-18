# hyperchromatic-nova/obtain_historical_reference_02.sh
#
# Obtains and runs one of the programs that preceded and inspired HyperChromatic
# Nova. The program was completed to its desired state back in March of 2021,
# however unpolished it may be. It was written in plain Java, utilizing AWT.
#
# Java (the Java Runtime Environment) will need to be installed on the system
# for the program to run - it's likely that any version will do.
# cURL is also presumed to be present for this script to successfully execute.
#
# Run this script from the "hyperchromatic-nova" (project root) directory
# with the following command, assuming a Linux or Mac environment:
#   sh scripts/obtain_historical_reference_02.sh
#
# Instructions (keys):
#   'n' => Generate an entirely new image
#   'q' => randomize the colors or gradient (but not the quantity of colors)
#   'e' => randomize the colors, as well as their quantity
#   's' => randomize the seed (initial conditions, roughly)
#   'l' => randomize lacunarity (ratio of different levels of detail / frequency)
#   'p' => randomize persistence (roughness/smoothness level)
#   'o' => randomize quantity of octaves (level of detail)
#   'g' => toggle gradient mode on/off
#   'r' => reset gradient to default yellow and black gradient
#   'h' => toggle the help window open/closed (these instructions)
#   'z' => save current image to disk (see status bar for filename)

dir=$(basename "$PWD")
url="https://github.com/kevin-kmetz/chromatic-terrain/raw/refs/heads/main/ChromaticTerrain.jar"
savepath="historical-references/old-chromatic-terrain"
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
curl -L -o "$fullpath/ChromaticTerrain.jar" "$url"
java -jar "$fullpath/ChromaticTerrain.jar"

