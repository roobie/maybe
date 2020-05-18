
(import maybe)

(do
  (def m (maybe/just 1))
  (def v (match m
           {:just v} (+ v 1)
           {:nothing _} -1))
  (assert (= v 2)))

(do
  (def m (maybe/just 1))
  (def v (maybe/match m
                      :just (fn [v] (+ v 1))
                      :nothing 0))

  (assert (= v 2))
  )

(do
  (def m maybe/nothing)
  (def v (maybe/match m
                      :just (fn [v] (+ v 1))
                      :nothing 0))

  (assert (= v 0))
  )

(do
  (def v2 (->
           0
           (maybe/just)
           (maybe/map (fn [v] (+ v 1)))
           (maybe/map (fn [v] (+ v 1)))
           (maybe/map (fn [v] (+ v 1)))
           (maybe/unwrap!)))

  (assert (= v2 3))
  )

(do
  (def m (maybe/just 1))
  (assert (maybe/maybe? m))
  (assert (maybe/just? m))

  (assert (maybe/maybe? maybe/nothing))
  (assert (maybe/nothing? maybe/nothing))
  )

(do
  (def m (maybe/flat-map (maybe/just 1) (fn [v] (maybe/just (+ v 1)))))
  (assert (= 2 (maybe/unwrap! m)))
  )

# TODO assert-signals-error
## (maybe/unwrap! maybe/nothing)
