;; целая константа
(aclosure ac :attribute "opsem" :type "integer constant" :instance i
  :do i)

;; вещественная константа
(aclosure ac :attribute "opsem" :type "float constant" :instance i
  :do i)

;; строковая константа
(aclosure ac :attribute "opsem" :type "string constant" :instance i
  :do i)

;; байтовая константа
(aclosure ac :attribute "opsem" :type "bytes constant" :instance i
  :do i)

;; булева константа
(aclosure ac :attribute "opsem" :type "boolean constant" :instance i
  :do i)

;; None
(aclosure ac :attribute "opsem" :type "none constant"
  :do :none)

;; Ellipsis
(aclosure ac :attribute "opsem" :type "ellipsis constant"
  :do :ellipsis)

(aclosure ac
  :attribute "opsem"
  :type "tuple expression"
  :instance i
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "items" (aget i "items")
      :av "current" 0
      :av "bound" (length (aget i "items"))
      :av "accum" nil))

;; Стадия iterate: вычисление элементов
(aclosure ac
  :attribute "opsem"
  :type "tuple expression"
  :stage "iterate"
  :ap ac "items" items
  :ap ac "current" cur
  :ap ac "bound" n
  :ap ac "accum" acc
  :agent a
  :match
    (:v (< cur n) T
     :p (nth cur items) expr
     :do
       (update-push-aclosure ac
         :av "stage" "continue"
         :av "current" (+ cur 1)
         :av "accum" acc
         :av "items" items
         :av "bound" n)
       (clear-update-eval-aclosure ac
         :av "instance" expr
         :av "agent" a))
    :exit
      (aset a "value" (reverse acc))
      (next-aclosure ac)))

;; Стадия continue: добавление результата в аккумулятор
(aclosure ac
  :attribute "opsem"
  :type "tuple expression"
  :stage "continue"
  :value v
  :ap ac "current" cur
  :ap ac "accum" acc
  :ap ac "items" items
  :ap ac "bound" n
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "current" cur
      :av "bound" n
      :av "items" items
      :av "accum" (cons v acc))))

(aclosure ac
  :attribute "opsem"
  :type "list expression"
  :instance i
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "items" (aget i "items")
      :av "current" 0
      :av "bound" (length (aget i "items"))
      :av "accum" nil))

(aclosure ac
  :attribute "opsem"
  :type "list expression"
  :stage "iterate"
  :ap ac "items" items
  :ap ac "current" cur
  :ap ac "bound" n
  :ap ac "accum" acc
  :agent a
  :match
    (:v (< cur n) T
     :p (nth cur items) expr
     :do
       (update-push-aclosure ac
         :av "stage" "continue"
         :av "current" (+ cur 1)
         :av "accum" acc
         :av "items" items
         :av "bound" n)
       (clear-update-eval-aclosure ac
         :av "instance" expr
         :av "agent" a))
    :exit
      (aset a "value" (reverse acc))
      (next-aclosure ac)))

(aclosure ac
  :attribute "opsem"
  :type "list expression"
  :stage "continue"
  :value v
  :ap ac "current" cur
  :ap ac "accum" acc
  :ap ac "items" items
  :ap ac "bound" n
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "current" cur
      :av "bound" n
      :av "items" items
      :av "accum" (cons v acc))))

(aclosure ac
  :attribute "opsem"
  :type "set expression"
  :instance i
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "items" (aget i "items")
      :av "current" 0
      :av "bound" (length (aget i "items"))
      :av "accum" nil))

(aclosure ac
  :attribute "opsem"
  :type "set expression"
  :stage "iterate"
  :ap ac "items" items
  :ap ac "current" cur
  :ap ac "bound" n
  :ap ac "accum" acc
  :agent a
  :match
    (:v (< cur n) T
     :p (nth cur items) expr
     :do
       (update-push-aclosure ac
         :av "stage" "continue"
         :av "current" (+ cur 1)
         :av "accum" acc
         :av "items" items
         :av "bound" n)
       (clear-update-eval-aclosure ac
         :av "instance" expr
         :av "agent" a))
    :exit
      (aset a "value" acc)
      (next-aclosure ac)))

(aclosure ac
  :attribute "opsem"
  :type "set expression"
  :stage "continue"
  :value v
  :ap ac "current" cur
  :ap ac "accum" acc
  :ap ac "items" items
  :ap ac "bound" n
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "current" cur
      :av "bound" n
      :av "items" items
      :av "accum" (if (member v acc :test #'equal) acc (cons v acc)))))

(aclosure ac
  :attribute "opsem"
  :type "dict expression"
  :instance i
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "entries" (aget i "entries")
      :av "current" 0
      :av "bound" (length (aget i "entries"))
      :av "accum" nil))

;; Стадия iterate: вычисление ключа
(aclosure ac
  :attribute "opsem"
  :type "dict expression"
  :stage "iterate"
  :ap ac "entries" entries
  :ap ac "current" cur
  :ap ac "bound" n
  :ap ac "accum" dict
  :agent a
  :match
    (:v (< cur n) T
     :p (nth cur entries) entry
     :do
       (update-push-aclosure ac
         :av "stage" "after-key"
         :av "current" cur
         :av "entries" entries
         :av "bound" n
         :av "accum" dict
         :av "entry" entry)
       (clear-update-eval-aclosure ac
         :av "instance" (aget entry "key")
         :av "agent" a))
    :exit
      (aset a "value" dict)
      (next-aclosure ac)))

;; Стадия after-key: вычисление значения
(aclosure ac
  :attribute "opsem"
  :type "dict expression"
  :stage "after-key"
  :value key-val
  :ap ac "entry" entry
  :ap ac "current" cur
  :ap ac "entries" entries
  :ap ac "bound" n
  :ap ac "accum" dict
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "after-value"
      :av "current" cur
      :av "entries" entries
      :av "bound" n
      :av "accum" dict
      :av "key" key-val
      :av "entry" entry)
    (clear-update-eval-aclosure ac
      :av "instance" (aget entry "value")
      :av "agent" a)))

;; Стадия after-value: добавление пары в словарь
(aclosure ac
  :attribute "opsem"
  :type "dict expression"
  :stage "after-value"
  :value val
  :ap ac "key" key
  :ap ac "current" cur
  :ap ac "entries" entries
  :ap ac "bound" n
  :ap ac "accum" dict
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "current" (+ cur 1)
      :av "entries" entries
      :av "bound" n
      :av "accum" (acons key val (remove key dict :key #'car :test #'equal)))))

(aclosure ac
  :attribute "op sem"
  :type "group expression"
  :instance i
  :agent a
  :do
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "expression")
      :av "agent" a))

(aclosure ac
    :attribute "opsem"
    :type "+1"
    :stage nil
    :instance i
    :agent a
    :do
    (update-push-aclosure ac :av "stage" "apply")
    (clear-update-eval-aclosure ac
        :av "instance" (aget i 1)
        :av "agent" a))

(aclosure ac
    :attribute "opsem"
    :type "+1"
    :stage "apply"
    :agent a
    :do
    (aset a "value" (aget a "value"))
    (next-aclosure ac))

(aclosure ac
    :attribute "opsem"
    :type "-1"
    :stage nil
    :instance i
    :agent a
    :do
    (update-push-aclosure ac :av "stage" "apply")
    (clear-update-eval-aclosure ac
        :av "instance" (aget i 1)
        :av "agent" a))

(aclosure ac
    :attribute "opsem"
    :type "-1"
    :stage "apply"
    :agent a
    :do
    (aset a "value" (- (aget a "value")))
    (next-aclosure ac))

(aclosure ac
    :attribute "opsem"
    :type "~1"
    :stage nil
    :instance i
    :agent a
    :do
    (update-push-aclosure ac :av "stage" "apply")
    (clear-update-eval-aclosure ac
        :av "instance" (aget i 1)
        :av "agent" a))

(aclosure ac
    :attribute "opsem"
    :type "~1"
    :stage "apply"
    :agent a
    :do
    (aset a "value" (lognot (aget a "value")))
    (next-aclosure ac))

(aclosure ac
    :attribute "opsem"
    :type "not 1"
    :stage nil
    :instance i
    :agent a
    :do
    (update-push-aclosure ac :av "stage" "apply")
    (clear-update-eval-aclosure ac
        :av "instance" (aget i "1")
        :av "agent" a))

(aclosure ac
    :attribute "opsem"
    :type "not 1"
    :stage "apply"
    :value 1
    :agent a
    :do
    (aset a "value" (if (null (aget a "value")) t nil))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1+2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1+2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1+2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (+ left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1-2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1-2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1-2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (- left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1*2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1*2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1*2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (* left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1/2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1/2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1/2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (/ left-val right-val))
  (next-aclosure ac)))

(aclosure ac
  :attribute "opsem"
  :type "1//2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1//2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1//2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (floor left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1%2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1%2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1%2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (mod left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1<<2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1<<2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1<<2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (ash left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1>>2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1>>2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1>>2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (ash left-val (- right-val)))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1&2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1&2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1&2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (logand left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1^2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1^2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1^2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (logxor left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1|2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1|2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1|2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (logior left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1==2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1==2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1==2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (equal left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1!=2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1!=2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1!=2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (not (equal left-val right-val)))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1<2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1<2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1<2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (< left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1<=2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1<=2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1<=2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (<= left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1>2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1>2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1>2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (> left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1>=2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1>=2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1>=2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (>= left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 is 2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1 is 2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1 is 2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (eq left-val right-val))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 is not 2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1 is not 2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1 is not 2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (not (eq left-val right-val)))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 in 2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1 in 2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1 in 2"
  :stage "apply"
  :agent a
  :value right-val   ; предполагается список
  :ap ac "left-val" left-val
  :do
  (aset a "value" (not (null (member left-val right-val :test #'equal))))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 not in 2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "right")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 1)
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1 not in 2"
  :stage "right"
  :instance i
  :agent a
  :value left-val
  :do
  (update-push-aclosure ac
     :av "stage" "apply"
     :av "left-val" left-val)
  (clear-update-eval-aclosure ac
     :av "instance" (aget i 2)
     :av "agent" a)

(aclosure ac
  :attribute "opsem"
  :type "1 not in 2"
  :stage "apply"
  :agent a
  :value right-val
  :ap ac "left-val" left-val
  :do
  (aset a "value" (null (member left-val right-val :test #'equal)))
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 and 2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "check-left")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i "1")
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1 and 2"
  :stage "check-left"
  :agent a
  :value left-val
  :do
  (if left-val
      (progn
        (update-push-aclosure ac
           :av "stage" "apply-and")
        (clear-update-eval-aclosure ac
           :av "instance" (aget i "2")
           :av "agent" a))
      (progn
        (aset a "value" left-val)
        (next-aclosure ac))))

(aclosure ac
  :attribute "opsem"
  :type "1 and 2"
  :stage "apply-and"
  :agent a
  :value right-val
  :do
  (aset a "value" right-val)
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 or 2"
  :stage nil
  :instance i
  :agent a
  :do
  (update-push-aclosure ac
     :av "stage" "check-left")
  (clear-update-eval-aclosure ac
     :av "instance" (aget i "1")
     :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "1 or 2"
  :stage "check-left"
  :agent a
  :value left-val
  :do
  (if left-val
      (progn
        (aset a "value" left-val)
        (next-aclosure ac))
      (progn
        (update-push-aclosure ac
           :av "stage" "apply-or")
        (clear-update-eval-aclosure ac
           :av "instance" (aget i "2")
           :av "agent" a))))

(aclosure ac
  :attribute "opsem"
  :type "1 or 2"
  :stage "apply-or"
  :agent a
  :value right-val
  :do
  (aset a "value" right-val)
  (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1.2"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "access"
      :av "attr-name" (aget i "2"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "1")
      :av "agent" a))

;; Стадия access: получение атрибута
(aclosure ac
  :attribute "opsem"
  :type "1.2"
  :stage "access"
  :value obj-val
  :ap ac "attr-name" attr-name
  :agent a
  :match
    (:p (aget obj-val attr-name) val
     :v val T
     :do
       (aset a "value" val)
       (next-aclosure ac))
    :exit (error ac "Attribute '~A' not found" attr-name)))

(aclosure ac
  :attribute "opsem"
  :type "1[2]"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "compute-index"
      :av "obj-expr" (aget i "1"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "2")
      :av "agent" a))

;; Стадия compute-index: вычисление индекса
(aclosure ac
  :attribute "opsem"
  :type "1[2]"
  :stage "compute-index"
  :value index-val
  :ap ac "obj-expr" obj-expr
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "access"
      :av "index" index-val)
    (clear-update-eval-aclosure ac
      :av "instance" obj-expr
      :av "agent" a))

;; Стадия access: доступ по индексу
(aclosure ac
  :attribute "opsem"
  :type "1[2]"
  :stage "access"
  :value obj-val
  :ap ac "index" index
  :agent a
  :match
    (:p (aget obj-val index) val
     :v val T
     :do
       (aset a "value" val)
       (next-aclosure ac))
    :exit (error ac "Index '~A' out of range" index)))

(aclosure ac
  :attribute "opsem"
  :type "1[l:u:s]"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "compute-lower"
      :av "obj-expr" (aget i "1")
      :av "upper-expr" (aget i "u")
      :av "step-expr" (aget i "s")))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "l")
      :av "agent" a))

;; Стадия compute-lower: вычисление нижней границы
(aclosure ac
  :attribute "opsem"
  :type "1[l:u:s]"
  :stage "compute-lower"
  :value lower-val
  :ap ac "obj-expr" obj-expr
  :ap ac "upper-expr" upper-expr
  :ap ac "step-expr" step-expr
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "compute-upper"
      :av "obj-expr" obj-expr
      :av "lower" lower-val
      :av "step-expr" step-expr)
    (if upper-expr
        (clear-update-eval-aclosure ac
          :av "instance" upper-expr
          :av "agent" a)
        (update-eval-aclosure ac
          :av "stage" "compute-upper"
          :av "obj-expr" obj-expr
          :av "lower" lower-val
          :av "upper" nil
          :av "step-expr" step-expr))))

;; Стадия compute-upper: вычисление верхней границы
(aclosure ac
  :attribute "opsem"
  :type "1[l:u:s]"
  :stage "compute-upper"
  :value upper-val
  :ap ac "obj-expr" obj-expr
  :ap ac "lower" lower
  :ap ac "step-expr" step-expr
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "compute-step"
      :av "obj-expr" obj-expr
      :av "lower" lower
      :av "upper" upper-val)
    (if step-expr
        (clear-update-eval-aclosure ac
          :av "instance" step-expr
          :av "agent" a)
        (update-eval-aclosure ac
          :av "stage" "compute-step"
          :av "obj-expr" obj-expr
          :av "lower" lower
          :av "upper" upper-val
          :av "step" nil))))

;; Стадия compute-step: вычисление шага
(aclosure ac
  :attribute "opsem"
  :type "1[l:u:s]"
  :stage "compute-step"
  :value step-val
  :ap ac "obj-expr" obj-expr
  :ap ac "lower" lower
  :ap ac "upper" upper
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "apply-slice"
      :av "lower" lower
      :av "upper" upper
      :av "step" (or step-val 1))
    (clear-update-eval-aclosure ac
      :av "instance" obj-expr
      :av "agent" a)))

;; Стадия apply-slice: применение среза
(aclosure ac
  :attribute "opsem"
  :type "1[l:u:s]"
  :stage "apply-slice"
  :value obj-val
  :ap ac "lower" lower
  :ap ac "upper" upper
  :ap ac "step" step
  :agent a
  :do
    (aset a "value" (subseq obj-val
                            (or lower 0)
                            (or upper (length obj-val))
                            step))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1(2)"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "eval-args"
      :av "2" (aget i "2")
      :av "current" 0
      :av "bound" (length (aget i "2"))
      :av "arg-values" nil)
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "1")
      :av "agent" a))

;; Стадия eval-args: вычисление аргументов
(aclosure ac
  :attribute "opsem"
  :type "1(2)"
  :stage "eval-args"
  :value func-val
  :ap ac "2" 2
  :ap ac "current" cur
  :ap ac "bound" n
  :ap ac "arg-values" arg-vals
  :agent a
  :match
    (:v (< cur n) T
     :p (nth cur 2) arg
     :do
       (update-push-aclosure ac
         :av "stage" "eval-args"
         :av "2" 2
         :av "current" (+ cur 1)
         :av "bound" n
         :av "arg-values" arg-vals
         :av "func" func-val)
       (clear-update-eval-aclosure ac
         :av "instance" (aget arg "value")
         :av "agent" a))
    :exit
      (update-push-aclosure ac
        :av "stage" "apply-func"
        :av "func" func-val
        :av "arg-values" (reverse arg-vals))
      (next-aclosure ac)))

;; Стадия apply-func: применение функции
(aclosure ac
  :attribute "opsem"
  :type "1(2)"
  :stage "apply-func"
  :value arg-val
  :ap ac "func" func
  :ap ac "arg-values" arg-vals
  :agent a
  :env e
  :match
    (:v (null arg-val) T
     :do
       ;; Все аргументы вычислены, вызываем функцию
       (if (is-instance func "function value")
           (progn
             (update-push-aclosure ac
               :av "stage" "exiting function"
               :av "old-locals" (aget a "variable location"))
             (update-eval-aclosure ac
               :av "stage" "exec-body"
               :av "func" func
               :av "arg-values" arg-vals))
           (error ac "Not a callable object")))
    :do
      ;; Добавляем аргумент в список
      (update-eval-aclosure ac
        :av "stage" "eval-args"
        :av "2" (aget ac "2")
        :av "current" (aget ac "current")
        :av "bound" (aget ac "bound")
        :av "arg-values" (cons arg-val arg-vals)
        :av "func" func))))

;; Стадия exec-body: выполнение тела функции
(aclosure ac
  :attribute "opsem"
  :type "1(2)"
  :stage "exec-body"
  :ap ac "func" func
  :ap ac "arg-values" arg-vals
  :agent a
  :env e
  :do
    ;; Здесь должна быть логика связывания параметров с аргументами
    ;; и выполнения тела функции
    (clear-update-eval-aclosure ac
      :av "instance" (mo "block" :av "statements" (aget func "body"))
      :av "agent" a
      :av "attribute" "op sem::block")))

;; Стадия exiting function: восстановление контекста
(aclosure ac
  :attribute "opsem"
  :type "1(2)"
  :stage "exiting function"
  :ap ac "old-locals" old-locals
  :agent a
  :do
    (aset a "variable location" old-locals)
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1 if 2 else 3"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "check"
      :av "true-branch" (aget i "1")
      :av "false-branch" (aget i "3"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "2")
      :av "agent" a))

;; Стадия check: выбор ветки
(aclosure ac
  :attribute "opsem"
  :type "1 if 2 else 3"
  :stage "check"
  :value cond-val
  :ap ac "true-branch" true-branch
  :ap ac "false-branch" false-branch
  :agent a
  :match
    (:v cond-val T
     :do
       (clear-update-eval-aclosure ac
         :av "instance" true-branch
         :av "agent" a))
    :exit
      (clear-update-eval-aclosure ac
        :av "instance" false-branch
        :av "agent" a)))

(aclosure ac
  :attribute "opsem"
  :type "lambda"
  :instance i
  :agent a
  :env e
  :do
    (aset a "value"
      (mo "function value"
        :av "name" nil
        :av "params" (aget i "params")
        :av "body" (aget i "body")
        :av "closure-env" e
        :av "is-async" nil))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1:=2"
  :stage nil
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "assign"
      :av "target" (aget i "1"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "2")
      :av "agent" a))

;; Стадия assign: присваивание и возврат значения
(aclosure ac
  :attribute "opsem"
  :type "1:=2"
  :stage "assign"
  :value val
  :ap ac "target" target
  :agent a
  :do
    (clear-update-eval-aclosure ac
      :av "instance" target
      :av "agent" a
      :av "attribute" "op sem::assign"
      :av "value-to-assign" val)
    (aset a "value" val)
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "1**2"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "right"
      :av "base-expr" (aget i "1"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "1")
      :av "agent" a))

;; Стадия right: вычисление показателя степени
(aclosure ac
  :attribute "opsem"
  :type "1**2"
  :stage "right"
  :value base-val
  :ap ac "base-expr" base-expr
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "apply"
      :av "base-val" base-val)
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "2")
      :av "agent" a))

;; Стадия apply: применение операции
(aclosure ac
  :attribute "opsem"
  :type "1**2"
  :stage "apply"
  :value exp-val
  :ap ac "base-val" base-val
  :agent a
  :do
    (aset a "value" (expt base-val exp-val))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "*1"
  :stage nil
  :instance i
  :agent a
  :do
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "1")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "expression statement"
  :instance i
  :agent a
  :do
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "expression")
      :av "agent" a))

;; Множественное присваивание: a = b = c = value
;; Сначала вычисляем значение, потом применяем ко всем целям
(aclosure ac
  :attribute "op sem"
  :type "assign"
  :stage nil
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "assign-targets"
      :av "targets" (aget i "targets")
      :av "index" 0
      :av "bound" (length (aget i "targets")))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "value")
      :av "agent" a))

(aclosure ac
  :attribute "op sem"
  :type "assign"
  :stage "assign-targets"
  :value val
  :ap ac "targets" targets
  :ap ac "index" idx
  :ap ac "bound" n
  :agent a
  :match
    (:v (< idx n) T
     :p (nth idx targets) target
     :do
       (update-push-aclosure ac
         :av "stage" "assign-targets"
         :av "targets" targets
         :av "index" (+ idx 1)
         :av "bound" n
         :av "val" val)
       (clear-update-eval-aclosure ac
         :av "instance" target
         :av "agent" a
         :av "attribute" "op sem::assign"
         :av "value-to-assign" val))
    :exit
      (aset a "value" val)
      (next-aclosure ac))

(aclosure ac
  :attribute "op sem::assign"
  :type "identifier"
  :value val
  :ap ac "value-to-assign" v
  :agent a
  :do
    (match
      (:ap a (aseq "variable location" i) loc
       :do (aset loc "value" v))
      :do
        (let ((loc (mo "location" :av "value" v)))
          (aset a "variable location" i loc)))
    (next-aclosure ac))

(aclosure ac
  :attribute "op sem::assign"
  :type "attribute target"
  :value val
  :ap ac "value-to-assign" v
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "set-attr"
      :av "value-to-assign" v)
    (clear-update-eval-aclosure ac
      :av "instance" (aget val "obj")
      :av "agent" a))

(aclosure ac
  :attribute "op sem::assign"
  :type "attribute target"
  :stage "set-attr"
  :value obj-val
  :ap ac "value-to-assign" v
  :ap val "name" name
  :do
    (aset obj-val name v)
    (next-aclosure ac))


(aclosure ac
  :attribute "opsem"
  :type "augassign"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "compute-right"
      :av "target" (aget i "target")
      :av "op" (aget i "op"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "value")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "augassign"
  :stage "compute-right"
  :value right-val
  :ap ac "target" target
  :ap ac "op" op
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "apply-op"
      :av "right-val" right-val
      :av "op" op
      :av "target" target)
    (clear-update-eval-aclosure ac
      :av "instance" target
      :av "agent" a
      :av "attribute" "op sem::rvalue"))

(aclosure ac
  :attribute "opsem"
  :type "augassign"
  :stage "apply-op"
  :value left-val
  :ap ac "right-val" right-val
  :ap ac "op" op
  :ap ac "target" target
  :agent a
  :do
    (let ((result (case op
                    ("+=" (+ left-val right-val))
                    ("-=" (- left-val right-val))
                    ("*=" (* left-val right-val))
                    ("/=" (/ left-val right-val))
                    ("//=" (floor left-val right-val))
                    ("%=" (mod left-val right-val))
                    ("**=" (expt left-val right-val))
                    ("&=" (logand left-val right-val))
                    ("|=" (logior left-val right-val))
                    ("^=" (logxor left-val right-val))
                    ("<<=" (ash left-val right-val))
                    (">>=" (ash left-val (- right-val)))
                    ("@=" (call-matrix-mul left-val right-val))
                    (t (error ac "Unknown augassign op: ~A" op)))))
      (clear-update-eval-aclosure ac
        :av "instance" target
        :av "agent" a
        :av "attribute" "op sem::assign"
        :av "value-to-assign" result)))

(aclosure ac
  :attribute "opsem"
  :type "return"
  :instance i
  :agent a
  :env e
  :do
    (if (aget i "value")
        (progn
          (update-push-aclosure ac
            :av "stage" "store-return"
            :av "has-value" T)
          (clear-update-eval-aclosure ac
            :av "instance" (aget i "value")
            :av "agent" a))
        (progn
          (update-push-aclosure ac
            :av "stage" "propagate-return"
            :av "return-value" nil)
          (next-aclosure ac))))

(aclosure ac
  :attribute "opsem"
  :type "return"
  :stage "store-return"
  :value val
  :ap ac "has-value" has-val
  :do
    (update-eval-aclosure ac
      :av "stage" "propagate-return"
      :av "return-value" val))

(aclosure ac
  :attribute "opsem"
  :type "return"
  :stage "propagate-return"
  :ap ac "return-value" ret-val
  :agent a
  :env e
  :do
    (let ((ac1 (pop-aclosure ac)))
      (if (null ac1)
          (error ac "return outside function")
          (match
            (:ap ac1 "stage" st
             :do
               (cond
                 ((equal st "exiting function")
                  (update-push-aclosure ac
                    :av "stage" "returning-value"
                    :av "return-value" ret-val)
                  (eval-aclosure ac1))
                 ((or (equal st "exiting while")
                      (equal st "exiting for")
                      (equal st "exiting if")
                      (equal st "exiting try")
                      (equal st "exiting with"))
                  (push-aclosure ac)
                  (eval-aclosure ac1))
                 (t
                  (eval-aclosure ac)))))))))

(aclosure ac
  :attribute "opsem"
  :type "return"
  :stage "returning-value"
  :ap ac "return-value" ret-val
  :do
    ret-val)

(aclosure ac
  :attribute "opsem"
  :type "pass"
  :do
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "break"
  :agent a
  :env e
  :do
    (let ((ac1 (pop-aclosure ac)))
      (if (null ac1)
          (error ac "break outside loop")
          (match
            (:ap ac1 "stage" st
             :do
               (cond
                 ((or (equal st "exiting while")
                      (equal st "exiting for"))
                  )
                 ((equal st "exiting function")
                  (error ac "break inside function"))
                 ((or (equal st "exiting try")
                      (equal st "exiting with")
                      (equal st "exiting if"))
                  ;; Продолжаем поиск через блок
                  (push-aclosure ac)
                  (eval-aclosure ac1))
                 (t
                  (eval-aclosure ac)))))))))

(aclosure ac
  :attribute "opsem"
  :type "continue"
  :agent a
  :env e
  :do
    (let ((ac1 (peek-aclosure ac)))
      (if (null ac1)
          (error ac "continue outside loop")
          (match
            (:ap ac1 "stage" st
             :do
               (cond
                 ((equal st "exiting while")
                  (update-eval-aclosure ac1
                    :av "stage" "eval-condition"))
                 ((equal st "exiting for")
                  (update-eval-aclosure ac1
                    :av "stage" "next-iteration"))
                 ((or (equal st "exiting try")
                      (equal st "exiting with")
                      (equal st "exiting if"))
                  (pop-aclosure ac)
                  (eval-aclosure ac))
                 (t
                  (pop-aclosure ac)
                  (eval-aclosure ac)))))))))

(aclosure ac
  :attribute "opsem"
  :type "raise"
  :instance i
  :agent a
  :env e
  :do
    (if (aget i "exc")
        (progn
          (update-push-aclosure ac
            :av "stage" "after-exc"
            :av "cause-expr" (aget i "cause"))
          (clear-update-eval-aclosure ac
            :av "instance" (aget i "exc")
            :av "agent" a))
        (match
          (:ap e "current exception" cur-exc
           :do
             (update-eval-aclosure ac
               :av "stage" "raise"
               :av "exc" cur-exc
               :av "cause" nil))
          :exit (error ac "No active exception to reraise"))))

(aclosure ac
  :attribute "opsem"
  :type "raise"
  :stage "after-exc"
  :value exc-val
  :ap ac "cause-expr" cause-expr
  :agent a
  :env e
  :do
    (if (null cause-expr)
        (update-eval-aclosure ac
          :av "stage" "raise"
          :av "exc" exc-val
          :av "cause" nil)
        (progn
          (update-push-aclosure ac
            :av "stage" "raise"
            :av "exc" exc-val
            :av "cause" T)
          (clear-update-eval-aclosure ac
            :av "instance" cause-expr
            :av "agent" a))))

(aclosure ac
  :attribute "opsem"
  :type "raise"
  :stage "raise"
  :value cause-val
  :ap ac "exc" exc-val
  :ap ac "cause" cause-flag
  :env e
  :do
    (aset e "current exception"
      (if cause-flag
          (list exc-val cause-val)
          exc-val))
    (let ((ac1 (pop-aclosure ac)))
      (if (null ac1)
          (error ac "Unhandled exception: ~A" exc-val)
          (match
            (:ap ac1 "stage" st
             :do
               (cond
                 ((equal st "exiting try")
                  ;; try должен поймать исключение
                  (update-push-aclosure ac
                    :av "stage" "handle-exception"
                    :av "exception" exc-val)
                  (eval-aclosure ac1))
                 ((or (equal st "exiting with")
                      (equal st "exiting function"))
                  ;; Продолжаем поиск
                  (push-aclosure ac)
                  (eval-aclosure ac1))
                 (t
                  (eval-aclosure ac)))))))))

(aclosure ac
  :attribute "opsem"
  :type "assert"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "check-assert"
      :av "msg" (aget i "msg"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "test")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "assert"
  :stage "check-assert"
  :value test-val
  :agent a
  :env e
  :match
    (:v (null test-val) T
     :ap ac "msg" msg
     :do (aset e "current exception"
               (if msg
                   (list "AssertionError" msg)
                   "AssertionError"))
     :exit (error ac "Assertion failed"))
    :exit (next-aclosure ac)))

(aclosure ac
  :attribute "opsem"
  :type "del statement"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "del-targets"
      :av "targets" (aget i "targets")
      :av "index" 0
      :av "bound" (length (aget i "targets")))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "del statement"
  :stage "del-targets"
  :agent a
  :match
    (:ap ac "targets" targets
     :ap ac "index" idx
     :ap ac "bound" n
     :v (< idx n) T
     :p (nth idx targets) target
     :do
       (update-push-aclosure ac
         :av "stage" "del-targets"
         :av "targets" targets
         :av "index" (+ idx 1)
         :av "bound" n)
       (clear-update-eval-aclosure ac
         :av "instance" target
         :av "agent" a
         :av "attribute" "op sem::del"))
    :exit (next-aclosure ac)))

(aclosure ac
  :attribute "op sem::del"
  :type "identifier"
  :agent a
  :match
    (:ap a (aseq "variable location" i) loc
     :do (aset a "variable location"
               (remove i (aget a "variable location") :key #'car :test #'equal)))
    :exit (error ac "Name '~A' is not defined" i)))

(aclosure ac
  :attribute "opsem"
  :type "global"
  :instance i
  :agent a
  :match
    (:ap i "names" names
     :do (dolist (name names)
           (aset a "variable location"
                 (acons name (mo "location" :av "scope" "global")
                        (remove name (aget a "variable location") :key #'car :test #'equal)))))
    :do (next-aclosure ac)))

(aclosure ac
  :attribute "opsem"
  :type "nonlocal"
  :instance i
  :agent a
  :match
    (:ap i "names" names
     :do (dolist (name names)
           (aset a "variable location"
                 (acons name (mo "location" :av "scope" "nonlocal")
                        (remove name (aget a "variable location") :key #'car :test #'equal)))))
    :do (next-aclosure ac)))

(aclosure ac
  :attribute "opsem::block"
  :type "block"
  :stage nil
  :instance i
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "iterate"
      :av "statements" (aget i "statements")
      :av "current" 0
      :av "bound" (length (aget i "statements"))))

(aclosure ac
  :attribute "opsem::block"
  :type "block"
  :stage "iterate"
  :ap ac "statements" stmts
  :ap ac "current" cur
  :ap ac "bound" n
  :agent a
  :match
    (:v (< cur n) T
     :p (nth cur stmts) stmt
     :do
       (update-push-aclosure ac
         :av "stage" "iterate"
         :av "statements" stmts
         :av "current" (+ cur 1)
         :av "bound" n)
       (clear-update-eval-aclosure ac
         :av "instance" stmt
         :av "agent" a))
    :exit (next-aclosure ac)))

(aclosure ac
  :attribute "opsem"
  :type "if"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "check"
      :av "body" (aget i "body")
      :av "else" (aget i "else"))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "condition")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "if"
  :stage "check"
  :value cond
  :ap ac "body" body
  :ap ac "else" else
  :agent a
  :match
    (:v cond T
     :do
       (if (null body)
           (next-aclosure ac)
           (clear-update-eval-aclosure ac
             :av "instance" (mo "block" :av "statements" body)
             :av "agent" a
             :av "attribute" "op sem::block")))
    :exit
      (if (null else)
          (next-aclosure ac)
          (clear-update-eval-aclosure ac
            :av "instance" (mo "block" :av "statements" else)
            :av "agent" a
            :av "attribute" "op sem::block"))))

(aclosure ac
  :attribute "opsem"
  :type "while"
  :stage nil
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "exiting while")
    (update-eval-aclosure ac
      :av "stage" "eval-condition"
      :av "body" (aget i "body")
      :av "else" (aget i "else")))

(aclosure ac
  :attribute "opsem"
  :type "while"
  :stage "eval-condition"
  :instance i
  :ap ac "body" body
  :ap ac "else" else
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "check-condition"
      :av "body" body
      :av "else" else)
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "condition")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "while"
  :stage "check-condition"
  :value cond
  :ap ac "body" body
  :ap ac "else" else
  :agent a
  :match
    (:v cond T
     :do
       (update-push-aclosure ac
         :av "stage" "eval-condition"
         :av "body" body
         :av "else" else)
       (clear-update-eval-aclosure ac
         :av "instance" (mo "block" :av "statements" body)
         :av "agent" a
         :av "attribute" "op sem::block"))
    :exit
      (if (null else)
          (next-aclosure ac)
          (clear-update-eval-aclosure ac
            :av "instance" (mo "block" :av "statements" else)
            :av "agent" a
            :av "attribute" "op sem::block"))))

(aclosure ac
  :attribute "opsem"
  :type "while"
  :stage "exiting while"
  :do
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "for"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "exiting for")
    (update-eval-aclosure ac
      :av "stage" "eval-iterator"
      :av "targets" (aget i "targets")
      :av "body" (aget i "body")
      :av "else" (aget i "else")
      :av "is-async" (aget i "is-async")))

(aclosure ac
  :attribute "opsem"
  :type "for"
  :stage "eval-iterator"
  :ap ac "targets" targets
  :ap ac "body" body
  :ap ac "else" else
  :ap ac "is-async" is-async
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "create-iterator"
      :av "targets" targets
      :av "body" body
      :av "else" else
      :av "is-async" is-async)
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "iterator")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "for"
  :stage "create-iterator"
  :value iterator-obj
  :ap ac "targets" targets
  :ap ac "body" body
  :ap ac "else" else
  :ap ac "is-async" is-async
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "next-iteration"
      :av "iterator" iterator-obj
      :av "targets" targets
      :av "body" body
      :av "else" else
      :av "is-async" is-async))

(aclosure ac
  :attribute "opsem"
  :type "for"
  :stage "next-iteration"
  :ap ac "iterator" iterator-obj
  :ap ac "targets" targets
  :ap ac "body" body
  :ap ac "else" else
  :ap ac "is-async" is-async
  :agent a
  :env e
  :match
    (:p (call-iterator-next iterator-obj is-async) result
     :v (not (is-instance result "stop-iteration")) T
     :do
       (update-push-aclosure ac
         :av "stage" "next-iteration"
         :av "iterator" iterator-obj
         :av "targets" targets
         :av "body" body
         :av "else" else
         :av "is-async" is-async)
       (clear-update-eval-aclosure ac
         :av "instance" (mo "assign" :av "targets" targets :av "value" result)
         :av "agent" a
         :av "attribute" "op sem")
       :exit
         (update-push-aclosure ac
           :av "stage" "exec-body"
           :av "iterator" iterator-obj
           :av "else" else)
         (clear-update-eval-aclosure ac
           :av "instance" (mo "block" :av "statements" body)
           :av "agent" a
           :av "attribute" "op sem::block"))
    :exit
      (if (null else)
          (next-aclosure ac)
          (clear-update-eval-aclosure ac
            :av "instance" (mo "block" :av "statements" else)
            :av "agent" a
            :av "attribute" "op sem::block"))))

(aclosure ac
  :attribute "opsem"
  :type "for"
  :stage "exec-body"
  :ap ac "iterator" iterator-obj
  :ap ac "else" else
  :agent a
  :do
    (update-eval-aclosure ac
      :av "stage" "next-iteration"
      :av "iterator" iterator-obj
      :av "targets" nil
      :av "body" nil
      :av "else" else
      :av "is-async" nil))

(aclosure ac
  :attribute "opsem"
  :type "for"
  :stage "exiting for"
  :do
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "try"
  :instance i
  :agent a
  :env e
  :do
    (update-push-aclosure ac
      :av "stage" "exiting try"
      :av "handlers" (aget i "handlers")
      :av "else" (aget i "else")
      :av "finally" (aget i "finally"))
    (update-eval-aclosure ac
      :av "stage" "exec-body"
      :av "handlers" (aget i "handlers")
      :av "else" (aget i "else")
      :av "finally" (aget i "finally")))

(aclosure ac
  :attribute "opsem"
  :type "try"
  :stage "exec-body"
  :ap ac "handlers" handlers
  :ap ac "else" else
  :ap ac "finally" finally
  :agent a
  :do
    (clear-update-eval-aclosure ac
      :av "instance" (mo "block" :av "statements" (aget (aget ac "instance") "body"))
      :av "agent" a
      :av "attribute" "op sem::block"))

(aclosure ac
  :attribute "opsem"
  :type "try"
  :stage "exiting try"
  :ap ac "handlers" handlers
  :ap ac "else" else
  :ap ac "finally" finally
  :agent a
  :env e
  :match
    (:ap e "current exception" exc
     :v exc T
     :do
       (update-push-aclosure ac
         :av "stage" "handle-exception"
         :av "exception" exc
         :av "else" else
         :av "finally" finally)
       (clear-update-eval-aclosure ac
         :av "instance" (mo "block" :av "statements" handlers)
         :av "agent" a
         :av "attribute" "op sem::block"))
    :exit
      (if (null finally)
          (next-aclosure ac)
          (clear-update-eval-aclosure ac
            :av "instance" (mo "block" :av "statements" finally)
            :av "agent" a
            :av "attribute" "op sem::block"))))

(aclosure ac
  :attribute "opsem"
  :type "try"
  :stage "handle-exception"
  :ap ac "exception" exc
  :ap ac "else" else
  :ap ac "finally" finally
  :agent a
  :env e
  :do
    (aset e "current exception" nil)
    (if (null finally)
        (next-aclosure ac)
        (clear-update-eval-aclosure ac
          :av "instance" (mo "block" :av "statements" finally)
          :av "agent" a
          :av "attribute" "op sem::block")))

(aclosure ac
  :attribute "opsem"
  :type "with"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "exiting with"
      :av "items" (aget i "items")
      :av "body" (aget i "body")
      :av "index" 0
      :av "bound" (length (aget i "items"))
      :av "contexts" nil)
    (update-eval-aclosure ac
      :av "stage" "enter-context"
      :av "items" (aget i "items")
      :av "body" (aget i "body")
      :av "index" 0
      :av "bound" (length (aget i "items"))
      :av "contexts" nil))

(aclosure ac
  :attribute "opsem"
  :type "with"
  :stage "enter-context"
  :ap ac "items" items
  :ap ac "body" body
  :ap ac "index" idx
  :ap ac "bound" n
  :ap ac "contexts" contexts
  :agent a
  :match
    (:v (< idx n) T
     :p (nth idx items) item
     :do
       (update-push-aclosure ac
         :av "stage" "enter-context"
         :av "items" items
         :av "body" body
         :av "index" (+ idx 1)
         :av "bound" n
         :av "contexts" contexts)
       (clear-update-eval-aclosure ac
         :av "instance" (aget item "context")
         :av "agent" a))
    :exit
      (update-eval-aclosure ac
        :av "stage" "exec-body"
        :av "body" body
        :av "contexts" contexts)))

(aclosure ac
  :attribute "opsem"
  :type "with"
  :stage "exec-body"
  :ap ac "body" body
  :ap ac "contexts" contexts
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "exiting with"
      :av "contexts" contexts)
    (clear-update-eval-aclosure ac
      :av "instance" (mo "block" :av "statements" body)
      :av "agent" a
      :av "attribute" "op sem::block"))

(aclosure ac
  :attribute "opsem"
  :type "with"
  :stage "exiting with"
  :ap ac "contexts" contexts
  :agent a
  :do
    (dolist (ctx contexts)
      (call-exit-context ctx))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "match"
  :instance i
  :agent a
  :do
    (update-push-aclosure ac
      :av "stage" "match-cases"
      :av "subject" nil
      :av "cases" (aget i "cases")
      :av "index" 0
      :av "bound" (length (aget i "cases")))
    (clear-update-eval-aclosure ac
      :av "instance" (aget i "subject")
      :av "agent" a))

(aclosure ac
  :attribute "opsem"
  :type "match"
  :stage "match-cases"
  :value subject-val
  :ap ac "subject" subject
  :ap ac "cases" cases
  :ap ac "index" idx
  :ap ac "bound" n
  :agent a
  :match
    (:v (null subject) T
     :do
       (update-eval-aclosure ac
         :av "stage" "match-cases"
         :av "subject" subject-val
         :av "cases" cases
         :av "index" idx
         :av "bound" n))
    :v (< idx n) T
    :p (nth idx cases) case
    :do
      (update-push-aclosure ac
        :av "stage" "match-cases"
        :av "subject" subject-val
        :av "cases" cases
        :av "index" (+ idx 1)
        :av "bound" n)
      (clear-update-eval-aclosure ac
        :av "instance" (aget case "pattern")
        :av "agent" a
        :av "attribute" "op sem::match"
        :av "subject" subject-val
        :av "guard" (aget case "guard")
        :av "body" (aget case "body")))
    :exit (next-aclosure ac))

(aclosure ac
  :attribute "opsem::match"
  :type "pattern"
  :value match-result
  :ap ac "subject" subject
  :ap ac "guard" guard
  :ap ac "body" body
  :agent a
  :match
    (:v match-result T
     :do
       (if guard
           (progn
             (update-push-aclosure ac
               :av "stage" "check-guard"
               :av "body" body)
             (clear-update-eval-aclosure ac
               :av "instance" guard
               :av "agent" a))
           (clear-update-eval-aclosure ac
             :av "instance" (mo "block" :av "statements" body)
             :av "agent" a
             :av "attribute" "op sem::block"))))

(aclosure ac
  :attribute "opsem::match"
  :type "pattern"
  :stage "check-guard"
  :value guard-val
  :ap ac "body" body
  :agent a
  :match
    (:v guard-val T
     :do
       (clear-update-eval-aclosure ac
         :av "instance" (mo "block" :av "statements" body)
         :av "agent" a
         :av "attribute" "op sem::block"))
    :exit (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "function def"
  :instance i
  :agent a
  :do
    (aset a "value"
      (mo "function value"
        :av "name" (aget i "name")
        :av "params" (aget i "params")
        :av "body" (aget i "body")
        :av "decorators" (aget i "decorators")
        :av "is-async" (aget i "is-async")
        :av "closure-env" (aget ac "env")))
    (next-aclosure ac))

(aclosure ac
  :attribute "opsem"
  :type "class def"
  :instance i
  :agent a
  :env e
  :do
    (update-push-aclosure ac
      :av "stage" "create-class"
      :av "name" (aget i "name")
      :av "bases" (aget i "bases")
      :av "keywords" (aget i "keywords")
      :av "body" (aget i "body"))
    (clear-update-eval-aclosure ac
      :av "instance" (mo "block" :av "statements" (aget i "body"))
      :av "agent" a
      :av "attribute" "op sem::block")))

(aclosure ac
  :attribute "opsem"
  :type "class def"
  :stage "create-class"
  :ap ac "name" name
  :ap ac "bases" bases
  :ap ac "keywords" keywords
  :ap ac "body" body
  :agent a
  :env e
  :do
    (aset a "value"
      (mo "class value"
        :av "name" name
        :av "bases" bases
        :av "keywords" keywords
        :av "body-namespace" (aget a "value")))
    (next-aclosure ac))