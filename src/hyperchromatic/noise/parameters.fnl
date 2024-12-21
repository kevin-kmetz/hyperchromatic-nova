;; hyperchromatic/noise/parameters.fnl

(local {:copy pl/copy-table} (require :pl/tablex))

;; Should return noise-parameters, with any values not provided
;; randomized.
(fn initialize [octaves persistence lacunarity seed]
  {: octaves
   : persistence
   : lacunarity
   : seed})

;; I forget what I was going for here...
(fn random-parameters! []
  {:octaves (math.random 1 8)
   :persistence (math.random)
   :lacunarity (math.random)
   :seed (math.random)})

(fn increment-lacunarity [differential palette]
  (let [new-palette (pl/copy-table palette)]
    (set new-palette.lacunarity (+ new-palette.lacunarity differential))
    new-palette))

(fn increment-persistence [differential palette]
  (let [new-palette (pl/copy-table palette)]
    (set new-palette.persistence (+ new-palette.persistence differential))
    new-palette))

{
  : initialize
  : random-parameters!
  : increment-lacunarity
  : increment-persistence
}
