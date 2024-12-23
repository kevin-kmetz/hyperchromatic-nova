;; hyperchromatic/init.fnl
;;
;; These are placeholder functions for now.

(local fennel (require :fennel))
(local fennel/view (. (require :fennel) :view))
(fn pp [printable]
  (print (fennel/view printable) "\n"))

(local hyper-state (require :hyperchromatic/state))
(local hpal (require :hyperchromatic/height_palette))

;;(fn love.quit []
;;  (love.event.push "quit" 0)
;;  nil)

;;(fn love.event.quit []
;;  (love.event.push "quit" 0)
;;  nil)

(fn initialize []
  (let [new-state (hyper-state.new-state)]
    (pp new-state)
    new-state))

(fn limit-frame-rate [state]
  (love.timer.sleep 0.001)
  state)

(fn acquire-events! []
  (love.event.pump)
  love.event.poll)

(fn process-events [state event-queue]
  (each [name value (event-queue)]
    (if (= name "quit")
        (do
          (print "Now exiting...")
          (set state.quit-program true))))
  state)

(fn process-logic [state]
  state)

(fn process-graphics [state]
  state)

(fn render-to-screen! [state]
  (love.graphics.origin)
  (love.graphics.clear (love.graphics.getBackgroundColor))
  (love.graphics.present)
  state)

;; Since loop! and continue-or-quit! are mutually recursive,
;; this var is unfortunately needed.
(var loop! {})
(fn continue-or-quit! [state]
  (if state.quit-program
    state
    (loop! state)))

(fn finalize [state]
  state)

(fn quit [state]
  (print "Exit point.")
  state)

(set loop! (fn [state]
  (-> state
      limit-frame-rate
      (process-events (acquire-events!))
      process-logic
      process-graphics
      render-to-screen!
      continue-or-quit!)))

(fn run! []
  (-> (initialize)
      loop!
      finalize
      quit)
  nil)

{
  : run!
}
