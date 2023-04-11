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

        (CELLSPACE ?ncol - num)
        (COLSPACE ?ncol - num))



(:action FROM-BOTTOM-TO-FREE
  :parameters (?card - card ?ncol - num ?ncol_prev - num ?nfree - num ?nfree_prev - num)
  :precondition
   (and (CLEAR ?card) (BOTTOMCOL ?card) (COLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev) (CELLSPACE ?nfree) (SUCCESSOR ?nfree ?nfree_prev) )
  :effect
   (and (not (CLEAR ?card)) (not (BOTTOMCOL ?card)) (not (COLSPACE ?ncol_prev)) (COLSPACE ?ncol) (INCELL ?card) (not (CELLSPACE ?nfree)) (CELLSPACE ?nfree_prev))
)

(:action FROM-STACK-TO-STACK
  :parameters (?card - card ?card_to - card ?card_prev - card)
  :precondition
   (and (CLEAR ?card) (CLEAR ?card_to) (CANSTACK ?card ?card_to) (ON ?card ?card_prev))
  :effect
   (and  (CLEAR ?card_prev) (not (CLEAR ?card_to)) (not (ON ?card ?card_prev)) (ON ?card ?card_to))
)

(:action FROM-STACK-TO-BOTTOM
  :parameters (?card - card ?card_prev - card  ?nfree - num ?nfree_prev - num)
  :precondition
   (and (CLEAR ?card) (ON ?card ?card_prev) (COLSPACE ?nfree) (SUCCESSOR ?nfree ?nfree_prev) )
  :effect
   (and (not (ON ?card ?card_prev)) (not (COLSPACE ?nfree)) (COLSPACE ?nfree_prev) (CLEAR ?card_prev))
)

; (:action FROM-STACK-TO-FREE
;   :parameters (?card - card ?card_prev - card  ?nfree - num ?nfree_prev - num)
;   :precondition
;    (and (CLEAR ?card) (ON ?card ?card_prev) (CELLSPACE ?nfree) (SUCCESSOR ?nfree ?nfree_prev) )
;   :effect
;    (and (not (CLEAR ?card)) (not (ON ?card ?card_prev)) (INCELL ?card) (not (CELLSPACE ?nfree)) (CELLSPACE ?nfree_prev) (CLEAR ?card_prev))
; )

(:action FROM-STACK-TO-FREE
  :parameters (?card - card ?card_prev - card  ?nfree - num ?nfree_prev - num)
  :precondition
   (and (CLEAR ?card) (ON ?card ?card_prev) (CELLSPACE ?nfree) (SUCCESSOR ?nfree ?nfree_prev) )
  :effect
   (and (not (CLEAR ?card)) (not (ON ?card ?card_prev)) (INCELL ?card) (not (CELLSPACE ?nfree)) (CELLSPACE ?nfree_prev) (CLEAR ?card_prev))
)

(:action FROM-FREE-TO-BOTTOM
  :parameters (?card - card ?ncol - num ?ncol_prev - num ?nfree - num ?nfree_prev - num)
  :precondition
   (and (INCELL ?card) (COLSPACE ?ncol) (SUCCESSOR ?ncol ?ncol_prev) (CELLSPACE ?nfree_prev) (SUCCESSOR ?nfree ?nfree_prev) )
  :effect
   (and  (CLEAR ?card)  (BOTTOMCOL ?card) (not (COLSPACE ?ncol)) (COLSPACE ?ncol_prev) (not (INCELL ?card)) (not (CELLSPACE ?nfree_prev)) (CELLSPACE ?nfree))
)

(:action FROM-FREE-TO-STACK
  :parameters (?card - card ?card_prev - card ?nfree - num ?nfree_prev - num)
  :precondition
   (and (INCELL ?card)  (CELLSPACE ?nfree_prev) (SUCCESSOR ?nfree ?nfree_prev) (CLEAR ?card_prev) (CANSTACK ?card ?card_prev))
  :effect
   (and (not (CLEAR ?card_prev)) (CLEAR ?card) (not (INCELL ?card)) (not (CELLSPACE ?nfree_prev)) (CELLSPACE ?nfree) (ON ?card ?card_prev) )
)


; (:action FROM-STACK-TO-STACK-DOUBLE
;   :parameters (?card - card ?card_to - card ?card_prev - card ?card_home - card ?suit - suit ?val - num ?val_home - num)
;   :precondition
;    (and (CLEAR ?card) (CLEAR ?card_to) (CANSTACK ?card ?card_to) 
;    (ON ?card ?card_prev)  (VALUE ?card ?val) (VALUE ?card_home ?val_home) (SUIT ?card ?suit) (SUIT ?card_home ?suit) (SUCCESSOR ?val ?val_home)
;   (not (and (HOME ?card_home))))
;   :effect
;    (and  (CLEAR ?card_prev) (not (CLEAR ?card_to)) (not (ON ?card ?card_prev)) (ON ?card ?card_to))
; )

(:action FROM-BOTTOM-TO-STACK
  :parameters (?card - card ?card_to - card ?ncol - num ?ncol_prev - num)
  :precondition
   (and (CLEAR ?card) (CLEAR ?card_to) (CANSTACK ?card ?card_to) (BOTTOMCOL ?card) (COLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and  (not (CLEAR ?card_to)) (not (BOTTOMCOL ?card)) (ON ?card ?card_to) (not (COLSPACE ?ncol_prev)) (COLSPACE ?ncol))
)

(:action FROM-BOTTOM-TO-HOME
  :parameters (?card - card ?card_to - card ?suit - suit ?val - num ?val_to - num ?ncol - num ?ncol_prev - num)
  :precondition
   (and (CLEAR ?card) (BOTTOMCOL ?card) (HOME ?card_to) (SUIT ?card ?suit) (SUIT ?card_to ?suit) 
    (VALUE ?card ?val) (VALUE ?card_to ?val_to) (SUCCESSOR ?val ?val_to ) (COLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and  (not (HOME ?card_to)) (HOME ?card) (not (CLEAR ?card)) (not (BOTTOMCOL ?card)) 
   (not (COLSPACE ?ncol_prev)) (COLSPACE ?ncol))
)

(:action FROM-STACK-TO-HOME
  :parameters (?card - card ?card_to - card ?card_prev - card ?suit - suit ?val - num ?val_to - num)
  :precondition
   (and (CLEAR ?card) (HOME ?card_to) (ON ?card ?card_prev) (SUIT ?card ?suit) (SUIT ?card_to ?suit) 
    (VALUE ?card ?val) (VALUE ?card_to ?val_to) (SUCCESSOR ?val ?val_to ))
  :effect
   (and  (not (HOME ?card_to)) (HOME ?card) (not (CLEAR ?card)) (CLEAR ?card_prev) (not (ON ?card ?card_prev)))
)


; (:action FROM-FREE-TO-HOME
;   :parameters (?card - card ?card_to - card ?suit - suit ?val - num ?val_to - num ?ncol - num ?ncol_prev - num)
;   :precondition
;    (and (INCELL ?card) (HOME ?card_to) (SUIT ?card ?suit) (SUIT ?card_to ?suit) 
;     (VALUE ?card ?val) (VALUE ?card_to ?val_to) (SUCCESSOR ?val ?val_to ) (CELLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev))
;   :effect
;    (and  (not (HOME ?card_to)) (HOME ?card) (not (INCELL ?card)) 
;    (not (CELLSPACE ?ncol_prev)) (CELLSPACE ?ncol))
; )

)