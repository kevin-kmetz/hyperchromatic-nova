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

(fn random-color! [?height]
  {:red (math.random)
   :green (math.random)
   :blue (math.random)
   :height ?height})

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
      (set (. height-palette i) (random-color! (. random-heights i))))
    height-palette))

(fn randomize-colors! [height-palette]
  (let [new-palette []]
    (for [i 1 (length height-palette)]
      (set (. new-palette i) (random-color! (. height-palette i :height))))
    new-palette))


(fn color-at-index [index palette]
  (. palette index))

(fn height->color [height palette index]
  (let [index* (or index 1)]
    (if (> index* (length palette))
      (color-at-index 1 palette)
      (if (< height (. palette index* :height))
        (color-at-index index* palette)
        (height->color height palette (+ index* 1))))))

(fn color->height [color palette]
  nil)

(fn highest-below-one [index palette]
  (let [height (. palette index :height)]
    (if (< height 1)
        index
        (= height 1)
        0
        (below-one? (- index 1) palette))))

(fn lowest-above-one [palette]
  (let [p-length (length palette)
        highest-height (. palette p-length)]
    (if (not (> highest-height 1))
      nil
      (let [tmp 0] nil))))

(fn resequence-heights [palette]
  nil)

(fn increment-heights! [differential palette]
  (for [i 1 (length palette)]
    (let [current-color (. palette i)
          height (. current-color :height)
          new-height (+ height differential)]
      (set (. current-color :height) new-height)
      (when (> new-height 1.0)
        (set (. current-color :height) (- new-height 1.0)))))
  palette)

{
  : swap!
  : swap-if!
  : random-color!
  : random-array!
  : random-height-palette!
  : randomize-colors!
  : color-at-index
  : height->color
  : heighest-below-one
  : increment-heights!
}
