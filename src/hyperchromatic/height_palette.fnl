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

;; May the data structure and algorithm gods forgive me for the
;; blasphemy I'm about to port over/implement. This will be rectified later.
(fn random-array! [number-of-values]
  (let [random-array []]
    (var swap-performed? true)
    (for [i 1 number-of-values]
      (set (. random-array i) (math.random)))
    (while swap-performed?
      (set swap-performed? false)
      (for [i 1 (- number-of-values 1)]
        (set swap-performed? (or (swap-if! i (+ i 1) random-array #(> $1 $2))
                                 swap-performed?))))
    random-array))

(fn random-height-palette! [number-of-colors]
  (let [height-palette []
        random-heights (random-array! number-of-colors)]
    (for [i 1 number-of-colors]
      (set (. height-palette i) {:red (math.random)
                                 :green (math.random)
                                 :blue (math.random)
                                 :height (. random-heights i)}))
    height-palette))


(fn color-at-index [index palette]
  (. palette index))

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
  : random-array!
  : random-height-palette!
  : color-at-index
}
