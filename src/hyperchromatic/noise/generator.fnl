;; hyperchromatic/noise/generator.fnl

;; Just a placeholder for now
(local love {:math {:noise (fn [a] 5)}})

(fn calc-octave [x y n-params total-noise current-frequency current-amplitude summed-amplitudes calced-octaves]
  (if (< calced-octaves (. n-params :octaves))
    (let [total-noise* (+ total-noise
                          (love.math.noise (* x (/ current-frequency 100))
                                           (* y (/ current-frequency 100) current-amplitude)))
          summed-amplitudes* (+ summed-amplitudes current-amplitude)
          current-amplitude* (* current-amplitude (. n-params :persistence))
          current-frequency* (* current-frequency (. n-params :lacunarity))]
      (calc-octave x y
                   n-params
                   total-noise*
                   current-frequency*
                   current-amplitude*
                   summed-amplitudes*
                   (- calced-octaves 1)))
    (/ total-noise summed-amplitudes)))

(fn noise-2d [x y n-params]
  (let [total-noise 0
        current-frequency 1
        current-amplitude 1
        summed-amplitudes 0
        calced-octaves 0]
    (calc-octave x
                 y
                 n-params
                 total-noise
                 current-frequency
                 current-amplitude
                 summed-amplitudes
                 calced-octaves)))

{
  : calc-octave
  : noise-2d
}
