;; hyperchromatic/state/init.fnl

(local proto-state {:settings         {:screen-width   :UNITINIALIZED
                                       :screen-height  :UNINITIALIZED
                                       :max-fps        :UNINITIALIZED
                                       :retain-history :UNINITIALIZED}
                    :random           {:seed  :UNINITIALIZED
                                       :state :UNINITIALIZED}
                    :time             {:raw
                                       :theta}
                    :height-palette   :UNINITIALIZED
                    :noise-parameter  {:octaves     :UNINITIALIZED
                                       :lacunarity  :UNINITIALIZED
                                       :persistence :UNINITIALIZED}
                    :view             {:x-pos    :UNINITIALIZED
                                       :y-pos    :UNINITIALIZED
                                       :rotation :UNINITIALIZED
                                       :zoom     :UNINITIALIZED
                                       :scale    :UNINITIALIZED}
                    :initial-values   {:time      :UNINITIALIZED
                                       :h-palette :UNINITIALIZED
                                       :noise     :UNINITIALIZED
                                       :view      :UNINITIALIZED
                                       :post-proc :UNINITIALIZED
                                       :shader    :UNINITIALIZED
                                       :blender   :UNINITIALIZED
                                       :dynamics  :UNINITIALIZED}
                    :dynamics         {:time      :UNINITIALIZED
                                       :h-palette {:height   :UNINITIALIZED
                                                   :palette {:quantity :UNINITIALIZED
                                                             :color []}}
                                       :view      :UNINITIALIZED
                                       :noise     {:lacunarity  :UNINITIALIZED
                                                   :persistence :UNINITIALIZED
                                                   :ocatves     :UNINITIALIZED}
                                       :post-proc :UNINITIALIZED
                                       :shader    :UNINITIALIZED
                                       :blender   :UNINITIALIZED
                                       :dyn-types [:minimum
                                                   :maximum
                                                   :frequency
                                                   :offset
                                                   :velocity
                                                   :acceleration
                                                   :change-per-sec]}
                    :gen-restrictions {:h-palette :UNINITIALIZED
                                       :time      :UNINITIALIZED
                                       :noise     :UNINITIALIZED
                                       :view      :UNINITIALIZED
                                       :post-proc :UNINITIALIZED
                                       :shader    :UNINITIALIZED
                                       :blender   :UNINITIALIZED
                                       :dynamics  :UNINITIALIZED}
                    :event-queues     {:from-logic  :UNINITIALIZED
                                       :from-system :UNINITIALIZED}
                    :blenders         {:h-palette :UNINITIALIZED
                                       :noise     :UNINITIALIZED
                                       :view      :UNINITIALIZED
                                       :post-proc :UNINITIALIZED
                                       :shader    :UNINITIALIZED
                                       :blender   :UNINITIALIZED}
                    :rendering        {:render-queue    :UNINITIALIZED
                                       :post-processing :UNINITIALIZED
                                       :shaders         :UNINITIAlIZED}
                    :session-history  :UNINITIALIZED})

(fn new-state []
  proto-state)

(fn random-state! []
  nil)

{
  : new-state
  : random-state!
}
