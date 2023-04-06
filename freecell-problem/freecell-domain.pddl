;; freecell domain.

(define (domain freecell)
  (:requirements :strips :typing) 
  (:types card
          num
          suit
  )
  
  (:predicates 	(VALUE ?card - card ?val - num)

        (SUIT ?card - card ?st - suit)
        (SUCCESSOR ?n1 - num ?n2 - num)

        ; card relation predicates
        (CANSTACK ?card1 - card ?card2 - card)
        (ON ?card1 - card ?card2 - card)

        ;card status predicates
        (INCELL ?card - card)
        (CLEAR ?card - card)
        (HOME ?card - card)
        (BOTTOMCOL ?card - card)

        (CELLSPACE ?num - num)
        (COLSPACE ?num - num))
  
(:action TO-FREE-FROM-BOTTOM
  :parameters (?card - card ?num - num ?num_prev - num ?nspace - num ?nspace_prev - num)
  :precondition
   (and (CLEAR ?card) (BOTTOMCOL ?card) (COLSPACE ?num_prev) (SUCCESSOR ?num ?num_prev) (CELLSPACE ?nspace) (SUCCESSOR ?nspace ?nspace_prev) )
  :effect
   (and (not (CLEAR ?card)) (not (BOTTOMCOL ?card)) (not (COLSPACE ?num_prev)) (COLSPACE ?num) (INCELL ?card) (not (CELLSPACE ?nspace)) (CELLSPACE ?nspace_prev))
)

(:action TO-FREE-FROM-STACK
  :parameters (?card - card ?card_prev - card  ?nspace - num ?nspace_prev - num)
  :precondition
   (and (CLEAR ?card) (ON ?card ?card_prev) (CELLSPACE ?nspace) (SUCCESSOR ?nspace ?nspace_prev) )
  :effect
   (and (not (CLEAR ?card)) (not (ON ?card ?card_prev)) (INCELL ?card) (not (CELLSPACE ?nspace)) (CELLSPACE ?nspace_prev) (CLEAR ?card_prev))
)

(:action TO-BOTTOM-FROM-FREE
  :parameters (?card - card ?num - num ?num_prev - num ?nspace - num ?nspace_prev - num)
  :precondition
   (and (INCELL ?card) (COLSPACE ?num) (SUCCESSOR ?num ?num_prev) (CELLSPACE ?nspace_prev) (SUCCESSOR ?nspace ?nspace_prev) )
  :effect
   (and  (CLEAR ?card)  (BOTTOMCOL ?card) (not (COLSPACE ?num)) (COLSPACE ?num_prev) (not (INCELL ?card)) (not (CELLSPACE ?nspace_prev)) (CELLSPACE ?nspace))
)


)