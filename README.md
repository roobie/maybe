# maybe.janet
An implementation of the Maybe monad for Janet.

A Maybe type is useful when dealing with data that can be `nil` or not, and being more explicit about how values vs. non-values are handled.

It's a small module, so check the source code for the public API.

## Example

```janet
(defn complex-arithmetics
  [maybe-val]
  (maybe/map maybe-val
             (fn [n]
               (print "Running complex stuff")
               (* 2 (+ 3 (- 4 n))))))

(def v0 maybe/nothing)
(def v1 (maybe/just 1))

(-> v0 # Nothing, so the computation in the lambda in complex-arithmetics
       # will not run
    (complex-arithmetics)
    (match {:just result} (printf "v0 Result: %d" result)
           {:nothing _} (print "v0 There was no value")))

(-> v1 # Just, so arithmetic WILL run
    (complex-arithmetics)
    # Here, we use the alternative maybe/match instead of match
    (maybe/match :just (fn [result] (printf "v1 Result: %d" result))
                 :nothing (fn [] (print "v1 No result"))))
```
