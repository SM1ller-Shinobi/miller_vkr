
(typedef "name" (uniont symbol string))
(typedef "identifier" (uniont "name"))
(typedef "function name" (uniont "identifier"))
(typedef "class name" (uniont "identifier"))
(typedef "parameter name" (uniont "identifier"))
(typedef "variable name" (uniont "identifier"))
(typedef "attribute name" (uniont "identifier"))
(typedef "import alias" (uniont "identifier"))


(typedef "constant" (uniont
    "integer constant"
    "float constant"
    "string constant"
    "bytes constant"
    "boolean constant"
    "none constant"
    "ellipsis constant"))

(typedef "integer constant"  int)
(typedef "float constant" real)
(typedef "string constant" string)
(typedef "bytes constant" string)
(typedef "boolean constant" bool)
(typedef "none constant")
(typedef "ellipsis constant")

(typedef "expression" (uniont
    "identifier" "constant"
    "tuple expression" "list expression" "set expression" "dict expression"
    "group expression"
    "1.2" "1[2]" "1[l:u:s]" "1(2)"
    "await"
    "+1" "-1" "~1"
    "1+2" "1-2" "1*2" "1/2" "1//2" "1%2"
    "1<<2" "1>>2"
    "1&2" "1^2" "1|2"
    "1==2" "1!=2" "1<2" "1<=2" "1>2" "1>=2" "1 is 2" "1 is not 2" "1 in 2" "1 not in 2"
    "1 and 2" "1 or 2" "not 1"
    "1 if 2 else 3" "lambda" "1:=2" "*1"
    "pow"
))

(mot "tuple expression"
    :at "items" (listt "expression"))
(mot "list expression"
    :at "items" (listt "expression"))
(mot "set expression"
    :at "items" (listt "expression"))
(mot "dict expression"
    :at "entries" (cot :amap "expression" "expression"))
(mot "dict expression"
    :at "entries" (listt "dict entry"))
(mot "dict entry"
    :at "key" "expression"
    :at "value" "expression")
(mot "group expression" :at "expression" "expression")

(mot "1.2" :at "1" "expression" :at "2" "identifier")   ; 1.2
(mot "1[2]" :at "1" "expression" :at "2" "expression")
(mot "1[l:u:s]" :at "1" "expression" :at "l" "expression" 
             :at "u" "expression" :at "s" "expression")
(mot "1(2)" :at "1" "expression" :at "2" (listt "arguments")) ; func(args)

(typedef "arguments" (uniont
    "pos argument"
    "kw argument"
    "star argument"
    "starstar argument"))

(mot "pos argument"     :at "value" "expression")
(mot "kw argument"      :at "name" "identifier" :at "value" "expression")
(mot "star argument"    :at "value" "expression")      # *expression
(mot "starstar argument" :at "value" "expression")     # **expression

(mot "+1"   :at 1 "expression")
(mot "-1"  :at 1 "expression")
(mot "~1"  :at 1 "expression") 
(mot "not 1" :at "1" "expression")

(mot "1+2"      :at 1 "expression" :at 2 "expression")
(mot "1-2"      :at 1 "expression" :at 2 "expression")
(mot "1*2"      :at 1 "expression" :at 2 "expression")
(mot "1/2"      :at 1 "expression" :at 2 "expression")
(mot "1//2"     :at 1 "expression" :at 2 "expression")
(mot "1%2"      :at 1 "expression" :at 2 "expression")

(mot "1<<2"   :at 1 "expression" :at 2 "expression")
(mot "1>>2"   :at 1 "expression" :at 2 "expression")

(mot "1&2" :at "1" "expression" :at "2" "expression")
(mot "1^2" :at "1" "expression" :at "2" "expression")
(mot "1|2"  :at "1" "expression" :at "2" "expression")

(mot "1 and 2"      :at "1" "expression" :at "2" "expression")
(mot "1 or 2"       :at "1" "expression" :at "2" "expression")

(mot "1==2"      :at 1 "expression" :at 2 "expression")
(mot "1!=2"   :at 1 "expression" :at 2 "expression")
(mot "1<2"      :at 1 "expression" :at 2 "expression")
(mot "1<=2"     :at 1 "expression" :at 2 "expression")
(mot "1>2"      :at 1 "expression" :at 2 "expression")
(mot "1>=2"     :at 1 "expression" :at 2 "expression")
(mot "1 is 2"      :at 1 "expression" :at 2 "expression")
(mot "1 is not 2"  :at 1 "expression" :at 2 "expression")
(mot "1 in 2 "      :at 1 "expression" :at 2 "expression")
(mot "1 not in 2"  :at 1 "expression" :at 2 "expression")

(mot "1 if 2 else 3"   :at "2" "expression" :at "1" "expression" :at "3" "expression")   # x if condition else y
(mot "lambda"    :at "params" "lambda params" :at "body" "expression")
(mot "1:=2" :at "1" "identifier" :at "2" "expression")               # name := expression
(mot "1**2"       :at "1" "expression" :at "2" "expression")                   # base ** exponent
(mot "*1" :at "1" "expression")                                     # *expression

(mot "for if clause"
    :at "targets" (listt "target")
    :at "iterator" "expression"
    :at "ifs" (listt "expression")
    :at "is async" bool)

(typedef "lambda params" (listt "identifier"))

(typedef "statement" (uniont "simple statement" "compound statement"))

(typedef "simple statement" (uniont
    "expression statement"
    "assign" "augassign"
    "return"
    "raise"
    "pass"
    "del"
    "assert"
    "break" "continue"
    "global" "nonlocal"
    "type alias"))

(typedef "compound statement" (uniont
    "if"
    "while"
    "for"
    "try" "with"
    "match" "function def" "class def"))

(mot "expression statement"
    :at "expression" "expression") 

(mot "assign"
    :at "targets" (listt "target")
    :at "value" "expression")                                      # a = b = c

(mot "augassign"
    :at "target" "target"
    :at "op" "augassign op"
    :at "value" "expression")

(typedef "augassign op" (enumt
    "+=" "-=" "*=" "@=" "/=" "%=" "&=" "|=" "^=" "<<=" ">>=" "**=" "//="))

(mot "return" :at "value" "expression")  
(mot "raise"
    :at "exc" "expression"
    :at "cause" "expression")   
(mot "pass")

(mot "del statement" 
    :at "targets" (listt "target"))

(mot "assert"
    :at "test" "expression"
    :at "msg" "expression")
(mot "break")
(mot "continue")
(mot "global"    :at "names" (listt "identifier"))
(mot "nonlocal"  :at "names" (listt "identifier"))

(mot "type alias"
    :at "name" "identifier"
    :at "type params" "type param list"
    :at "value" "expression")

(typedef "target" (uniont
    "identifier"
    "attribute target"
    "subscript target"
    "slice target"
    "star target"
    "list target"
    "tuple target"))

(mot "attribute target" :at "obj" "expression" :at "name" "identifier")
(mot "subscript target" :at "obj" "expression" :at "index" "expression")
(mot "slice target" 
    :at "obj" "expression" :at "lower" "expression" 
    :at "upper" "expression" :at "step" "expression")
(mot "star target" :at "target" "target")
(mot "list target" :at "elements" (listt "target"))
(mot "tuple target" :at "elements" (listt "target"))

(mot "if"
    :at "condition" "expression"
    :at "body" (listt "statement")
    :at "else" (listt "statement"))

(mot "while"
    :at "condition" "expression"
    :at "body" (listt "statement")
    :at "else" (listt "statement"))

(mot "for"
    :at "targets" (listt "target")
    :at "iterator" "expression"
    :at "body" (listt "statement")
    :at "else" (listt "statement")
    :at "is async" bool)

(mot "except handler"
    :at "type" "expression"
    :at "name" "identifier" nil
    :at "body" (listt "statement"))

(mot "with"
    :at "items" (listt "with item")
    :at "body" (listt "statement")
    :at "is async" bool)

(mot "with item"
    :at "context" "expression"
    :at "target" "target" nil)

(mot "match"
    :at "subject" "expression"
    :at "cases" (listt "match case"))

(mot "match case"
    :at "pattern" "pattern"
    :at "guard" "expression" nil
    :at "body" (listt "statement"))

(mot "function def"
    :at "name" "identifier"
    :at "params" "parameters"
    :at "return annotation" "expression"
    :at "body" (listt "statement")
    :at "decorators" (listt "expression")
    :at "is async" bool
    :at "type params" "type param list")

(mot "class def"
    :at "name" "identifier"
    :at "bases" (listt "expression")
    :at "keywords" (listt "kw argument")                               # для передачи мета-аргументов
    :at "body" (listt "statement")
    :at "decorators" (listt "expression")
    :at "type params" "type param list")

(mot "parameters"
    :at "posonly" (listt "parameter")                             # до /
    :at "args" (listt "parameter")                                ; обычные
    :at "star argument" "parameter"                            # *argument или *
    :at "kwonly" (listt "parameter")                              # после *
    :at "starstar argument" "parameter")                      # **kwarg

(mot "parameter"
    :at "name" "identifier"
    :at "annotation" "expression"
    :at "default" "expression"
    :at "is starred" bool                                         # для *argument
    :at "is starstar" bool)                                       # для **kwarg

(typedef "type param list" (listt "type param"))

(typedef "type param" (uniont
    "type var"
    "type var tuple"
    "type var dict"))

(mot "type var"
    :at "name" "identifier"
    :at "bound" "expression"
    :at "default" "expression")

(mot "type var tuple"
    :at "name" "identifier"
    :at "default" "expression")                                # *Ts

(mot "type var dict"
    :at "name" "identifier"
    :at "default" "expression")                                # **T

(mot "location"
  :at "value" "python value") 

(typedef "python value" (uniont
  "integer constant"
  "float constant"
  "python list"...))

(mot "python tuple"
  :at "items" (listt "python value"))

(mot "env"
  :at "agents" (listt "agent")
  :at "aclosures"
      (cot:amap "agent" (listt "aclosure"))
  :at "current exception"
      (uniont "exception value"))

(mot "agent"
  :at "variable location"
      (cot:amap "identifier" "location")
  :at "value" "python value")