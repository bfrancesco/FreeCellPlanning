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
        (MOVEABLE ?card)
        ;A CARD WAS ALREADY IN THE STATE OF MOVEABLE
        (OCCUPIED)
        ;THE ORIGIN IS THE BOTTOM, IT DOESN'T HAVE SENSE TO GO BOTTOM-BOTTOM
        (ORBOTT)
        ;THE ORIGIN IS FREE, IT DOESN'T HAVE SENSE TO GO FREE-FREE
        (ORFREE)

        (CELLSPACE ?ncol - num)
        (COLSPACE ?ncol - num))



(:action FROM-BOTTOM-TO-MOVEABLE
  :parameters (?card - card ?ncol - num ?ncol_prev - num)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (BOTTOMCOL ?card) (COLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and (OCCUPIED) (ORBOTT) (MOVEABLE ?card)  (not (CLEAR ?card)) (not (BOTTOMCOL ?card)) (not (COLSPACE ?ncol_prev)) (COLSPACE ?ncol) )
)

(:action FROM-STACK-TO-MOVEABLE
  :parameters (?card - card ?card_prev - card)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (ON ?card ?card_prev) )
  :effect
   (and (OCCUPIED) (MOVEABLE ?card) (not (ON ?card ?card_prev)) (CLEAR ?card_prev))
)

(:action FROM-FREE-TO-MOVEABLE
  :parameters (?card - card ?nfree - num ?nfree_prev - num)
  :precondition
   (and (not (OCCUPIED)) (INCELL ?card)  (CELLSPACE ?nfree_prev) (SUCCESSOR ?nfree ?nfree_prev))
  :effect
   (and (OCCUPIED) (ORFREE) (MOVEABLE ?card) (not (INCELL ?card)) (not (CELLSPACE ?nfree_prev)) (CELLSPACE ?nfree))
)

(:action FROM-MOVEABLE-TO-FREE
  :parameters (?card - card ?nfree - num ?nfree_prev - num)
  :precondition
   (and (MOVEABLE ?card) (not (ORFREE)) (CELLSPACE ?nfree) (SUCCESSOR ?nfree ?nfree_prev) )
  :effect
   (and (not (MOVEABLE ?card)) (not (ORFREE)) (not (OCCUPIED)) (INCELL ?card) (not (CELLSPACE ?nfree)) (CELLSPACE ?nfree_prev) )
)

(:action FROM-MOVEABLE-TO-BOTTOM
  :parameters (?card - card ?ncol - num ?ncol_prev - num)
  :precondition
   (and (MOVEABLE ?card) (not (ORBOTT)) (COLSPACE ?ncol) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and (not (MOVEABLE ?card)) (not (ORBOTT)) (not (OCCUPIED)) (CLEAR ?card)  (BOTTOMCOL ?card) (not (COLSPACE ?ncol)) (COLSPACE ?ncol_prev))
)

(:action FROM-MOVEABLE-TO-STACK
  :parameters (?card - card ?card_prev - card)
  :precondition
   (and (MOVEABLE ?card) (CLEAR ?card_prev) (CANSTACK ?card ?card_prev))
  :effect
   (and (not (CLEAR ?card_prev)) (not (ORBOTT)) (not (ORFREE)) (CLEAR ?card) (not (MOVEABLE ?card)) (not (OCCUPIED)) (ON ?card ?card_prev) )
)

(:action FROM-MOVEABLE-TO-HOME
  :parameters (?card - card ?card_to - card ?suit - suit ?val - num ?val_to - num)
  :precondition
   (and (MOVEABLE ?card) (HOME ?card_to) (SUIT ?card ?suit) (SUIT ?card_to ?suit) 
    (VALUE ?card ?val) (VALUE ?card_to ?val_to) (SUCCESSOR ?val ?val_to ))
  :effect
   (and (not (MOVEABLE ?card)) (not (ORBOTT)) (not (ORFREE)) (not (OCCUPIED))  (not (HOME ?card_to)) (HOME ?card))
)

)