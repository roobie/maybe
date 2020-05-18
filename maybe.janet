# Maybe is a sum type as described here https://wiki.haskell.org/Maybe that can
# be used to box values and make it more explicit with handling values vs.
# non-values

# Internal symbol to be able to tell whether a struct is a maybe or not.
(def- type-name (string "maybe" (gensym)))
(defn- to-fn
  "Coerce any type to a function"
  [x]
  (case (type x)
    :function x
    (fn [&] x)))

# Section: types
(defn just
  [v]
  {:__type type-name
   :just v})

(def nothing
  {:__type type-name
   :nothing false})

(defn auto
  "Automatically determine whether to create a Just or Nothing. If `x` is nil,
  then Nothing, otherwise Just x."
  [x]
  (if (nil? x)
    nothing
    (just x)))

# Section: predicates
(defn maybe?
  [m]
  (= type-name (get m :__type)))

(defn nothing?
  [m]
  (and (maybe? m) (= m nothing)))

(defn just?
  [m]
  (and (maybe? m) (get m :just false)))

# Section: utility
(defn map
  "The `map` function allows for treating Maybe's the same regardless of whether
  they contain a value or not. If the Maybe contains a value, the lambda will be
  called, and the resulting value will be wrapped in a Maybe, whereas if the
  Maybe is empty, nothing happens."
  [m f]
  (if (just? m)
    (auto (f (in m :just)))
    nothing))

(defn flat-map
  "The `flat-map` function is like `map` with the only difference that it does
  not wrap the result from the lambda in a Maybe, so this can be used when the
  lambda already returns a Maybe."
  [m f]
  (if (just? m)
    (f (in m :just))
    nothing))

(defn match
  "Matches the Maybe with either the :just or the :nothing function based on the
  state of the Maybe. One can use the built-in match in a somewhat similar
  manner."
  [m
   &keys {:just just-f
          :nothing nothing-f}]
  (if (just? m)
    (just-f (in m :just))
    ((to-fn nothing-f))))


(defn unwrap!
  "Extracts value from the supplied Maybe. If it's Nothing, an error will be
  signalled (hence the bang! in the name)."
  [m]
  (unless (just? m)
    (error "this 'maybe' does not have a value."))
  (in m :just))
