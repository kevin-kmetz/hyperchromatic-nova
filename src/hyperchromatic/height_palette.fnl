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
    (if (< height 1.0)
        index
        (= index 1)
        nil
        (highest-below-one (- index 1) palette))))

(fn lowest-above-one [palette]
  (let [p-length (length palette)
        highest-height (. palette p-length :height)]
    (if (not (> highest-height 1.0))
      nil
      (let [heighest<1 (highest-below-one p-length palette)]
        (if (= (type heighest<1) :nil)
            1
            (+ heighest<1 1))))))

(fn resequence-heights! [palette]
  "Accepts a palette whose height's have been incremented,
   and reorders them so that if those with heights > 1.0
   loop back around to the bottom of the palette.
   ~
   This is not meant to mutate an in-place palette - the returned
   palette should be treated as a distinct palette, but the old one
   should be considered mutated as well."
  (let [reordering-index (lowest-above-one palette)
        palette-length (length palette)
        resequenced-palette []]
    (if reordering-index
      (let [downward-offset (- reordering-index 1)
            upward-offset (- palette-length downward-offset)]
        (for [i reordering-index palette-length]
          (let [current-color (. palette i)
                current-height (. current-color :height)
                new-index (- i downward-offset)
                new-height (- current-height 1.0)]
            (set (. resequenced-palette new-index)
                 current-color)
            (set (. resequenced-palette new-index :height)
                 new-height)))
        (when (> reordering-index 1)
          (for [i 1 (- reordering-index 1)]
            (set (. resequenced-palette (+ i upward-offset))
                 (. palette i))))
        resequenced-palette)
      palette)))

(fn increment-heights! [differential palette]
  "Increments the heights for all colors in a palette, and then
   reorders them accordingly. The returned palette should be treated
   as distinct from the one passed in, and the old one passed in
   should be considered arbitrarily mutated."
  (for [i 1 (length palette)]
    (let [current-color (. palette i)
          height (. current-color :height)
          new-height (+ height differential)]
      (set (. current-color :height) new-height)))
  (resequence-heights! palette))

(local test-vals
  {:p1 [{:height 0.5} {:height 0.7} {:height 0.9} {:height 1.1} {:height 1.3} {:height 1.5} {:height 1.7}]
   :p2 [{:height 1.5} {:height 1.8} {:height 2.1} {:height 2.4}]
   :p3 [{:height 0.15} {:height 0.30} {:height 0.45} {:height 0.60}]
   :p4 [{:height 0.6}]
   :p5 [{:height 0.75} {:height 1.15}]})

{
  : swap!
  : swap-if!
  : random-color!
  : random-array!
  : random-height-palette!
  : randomize-colors!
  : color-at-index
  : height->color
  : highest-below-one
  : lowest-above-one
  : resequence-heights!
  : increment-heights!
  : test-vals
}
