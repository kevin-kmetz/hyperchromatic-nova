;; hyperchromatic/height_palette.fnl

(fn stack-push [element stack-table]
  nil)

(fn stack-pop [stack-table]
  nil)

(fn swap! [index-one index-two array]
  (let [temp (. array index-two)]
    (set (. array index-two) (. array index-one))
    (set (. array index-one) temp)
    true))

(fn swap-if! [index-one index-two array predicate]
  (if (predicate (. array index-one) (. array index-two))
    (swap! index-one index-two array)
    false))

(fn get-random-array [number-of-values]
  (let [random-array []]
    (var swap-performed? true)
    (for [i 1 number-of-values]
      (set (. random-array i) (math.random)))
    (while swap-performed?
      (for [i 1 (- number-of-values 1)]
        (set swap-performed? (and (swap-if! i (+ i 1) random-array)
                                  swap-performed?))))
    random-array))

(fn random-height-palette! [number-of-colors]
  nil)


(fn color-at-index [index palette]
  [(. palette index :red)
   (. palette index :blue)
   (. palette index :green)])

(fn z [height index palette]
  (if (< height (. palette index))
    nil
    nil))

(fn height->color [height palette]
  (let [[red blue green] (color-at-index 1)]
    (each [index color (ipairs palette) &until nil]
      nil)
    nil))

(fn color->height [color palette]
  nil)

(fn increment-heights [differential palette]
  nil)

{
  : swap!
  : swap-if!
  : get-random-array
}
