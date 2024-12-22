;; hyperchromatic/init.fnl
;;
;; These are placeholder functions for now.

(local hpal (require :hyperchromatic/height_palette))

(fn initialize []
  nil)

(fn limit-frame-rate [state]
  nil)

(fn acquire-events [state]
  (love.event.pump)
  (update-state :system-events (love.event.poll)))

(fn process-events [state event-queue]
  (each event-name arg-1 arg-2 arg-3 arg-4 arg-5 arg-6 ))

(fn process-logic [state]
  nil)

(fn process-graphics [state]
  nil)

(fn render-to-screen! [state]
  nil)

(fn continue-or-quit! [state]
  (if state.exit-program
    state
    (loop! state)))

(fn finalize [state]
  nil)

(fn quit [state]
  nil)

(fn loop! [state]
  (-> state
      limit-frame-rate
      (process-events (aquire-events!))
      process-logic
      process-graphics
      render-to-screen!
      continue-or-quit!))

(fn run! []
  (-> initialize
      loop!
      finalize
      quit))

{
  : run!
}
