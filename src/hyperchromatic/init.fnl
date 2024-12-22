;; hyperchromatic/init.fnl
;;
;; These are placeholder functions for now.

(local hpal (require :hyperchromatic/height_palette))

(fn initialize []
  nil)

(fn limit-frame-rate [state]
  nil)

(fn acquire-events []
  nil)

(fn process-events [state event-queue]
  nil)

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
