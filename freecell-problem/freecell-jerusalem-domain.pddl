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

        ; A card has the status of moveable when it has been chosen for a move
        (MOVEABLE ?card)
        
        ;When a card is moveable, then the status is occupied
        ;Occupied avoids having multiple cards in moveable state.
        ;It forces the completion of a move (From moveable to a position) 
        (OCCUPIED)
        
        ;The origin of the moveable card is the bottom
        ;bottom identifies a column that is empty or it is going to be empty
        ;ORBOTT avoids having a move from empty column to empty column
        (ORBOTT)
        
        ;The origin of the moveable card is a freecell
        ;ORFREE avoids having a move from a freecell to a freecell
        (ORFREE)

        (CELLSPACE ?ncol - num)
        (COLSPACE ?ncol - num))


;It takes a card from a column with one element and puts it in the state of moveable
;It specifies the origin (bottom) and virtually removes the card from the column 
(:action FROM-BOTTOM-TO-MOVEABLE
  :parameters (?card - card ?ncol - num ?ncol_prev - num)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (BOTTOMCOL ?card) (COLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and (OCCUPIED) (ORBOTT) (MOVEABLE ?card)  (not (CLEAR ?card)) (not (BOTTOMCOL ?card)) (not (COLSPACE ?ncol_prev)) (COLSPACE ?ncol))
)

;It takes a card from a column with more than one element and puts it in the state of moveable
;Its origin is not relevant, then it is not specified, it virtually removes the card from the column. 
(:action FROM-STACK-TO-MOVEABLE
  :parameters (?card - card ?card_prev - card)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (ON ?card ?card_prev) )
  :effect
   (and (OCCUPIED) (not (CLEAR ?card)) (MOVEABLE ?card) (not (ON ?card ?card_prev)) (CLEAR ?card_prev))
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