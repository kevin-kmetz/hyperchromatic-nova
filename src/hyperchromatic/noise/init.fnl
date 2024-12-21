;; hyperchromatic/noise/init.fnl

(local {: initialize
        : random-parameters!
        : increment-lacunarity
        : increment-persistence} (require :hyperchromatic/noise/parameters))

(local {: calc-octave
        : noise-2d} (require :hyperchromatic/noise/generator))

{
  : initialize
  : random-parameters!
  : increment-lacunarity
  : increment-persistence
  : calc-octave
  : noise-2d
}
