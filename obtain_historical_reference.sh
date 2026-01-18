# hyperchromatic-nova/obtain_historical_reference.sh
#
# Obtains one of the earlier implementations of HyperChromatic Nova that
# was never completed but was functional, written in Lua over Love2d. This
# first iteration was written/ported in June of 2024.
#
# Love2d will need to be installed to successfully execute this script.
# Visit "https://love2d.org" for installers and instructions.
# cURL is also presumed to be present for this script to successfully execute.
#
# Run this script from the "hyperchromatic-nova" (project root) directory
# with the following command, assuming a Linux or Mac environment:
#   sh obtain_historical_reference.sh
#
# Instructions (keys):
#   'c' => change colors
#   'p' => pause (or unpause if already paused)
#   'f' => change time direction to forward
#   'r' => change time direction to reverse (height wrap-around not implemented)
#   ',' => decrease speed of time
#   '.' => increase speed of time

mkdir -p historical-references/old-hyperchromatic-nova

curl -o historical-references/old-hyperchromatic-nova/main.lua \
     https://raw.githubusercontent.com/kevin-kmetz/hyperchromatic-nova/df9990e8c8a2fcad7622749aaa3bfeeb697292dd/main.lua

love historical-references/old-hyperchromatic-nova

