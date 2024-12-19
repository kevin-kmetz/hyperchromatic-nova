;; hyperchromatic/noise/parameters.fnl

;; Should return noise-parameters, with any values not provided
;; randomized.
(fn initialize-noise [octaves persistence lacunarity seed]
  { : octaves
    : persistence
    : lacunarity
    : seed})

;; I forget what I was going for here...
(fn random-noise! [x y noise-params]
  nil)
