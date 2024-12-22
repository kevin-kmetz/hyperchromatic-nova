;; hyperchromatic/init.fnl

(local hpal (require :hyperchromatic/height_palette))

(fn love.load []
  (math.randomseed (os.time)))

(fn process-input [state]
  nil)

(fn process-events [state]
  nil)

(fn love.update [delta]
  nil)

(fn love.keypressed [key]
  nil)

(fn love.draw []
  (love.graphics.setColor 0.1 0.2 (/ (math.random) 2) 1.0)
  (love.graphics.rectangle :fill 100 100 600 600))

(fn process-graphics [state]
  nil)

;; Uses tail call optimization to loop. Exit should occur
;; after process-input if triggered.
;;
;; !! DO NOT RUN - CAUSES MEMORY LEAK RIGHT NOW!
;;    Results from not clearing screen but continuously drawing rectangles.
;;
;;(fn love.run [state]
;;  (-> state
;;      process-input
;;      love.update
;;      love.draw
;;      love.run))
