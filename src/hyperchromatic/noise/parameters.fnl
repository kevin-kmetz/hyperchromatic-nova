;; hyperchromatic/noise/parameters.fnl

;; Should return noise-parameters, with any values not provided
;; randomized.
(fn initialize [octaves persistence lacunarity seed]
  { : octaves
    : persistence
    : lacunarity
    : seed})

;; I forget what I was going for here...
(fn random-parameters! [x y noise-params]
  nil)

(fn increment-lacunarity [differential palette]
  nil)

(fn increment-persistence [differential palette]
  nil)

{
  : initialize
  : random-parameters!
  : increment-lacunarity
  : increment-persistence
}
