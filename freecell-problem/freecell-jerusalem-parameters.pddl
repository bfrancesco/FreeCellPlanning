;; freecell domain.

(define (domain freecell)
  (:requirements :strips :typing) 
  (:types card
          num
          suit
          place
  )
  (:constants
    f - place 
    s - place 
    b - place 
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
        (MOVEABLE ?card - card)
        
        ;When a card is moveable, then the status is occupied
        ;Occupied avoids having multiple cards in moveable state.
        ;It forces the completion of a move (From moveable to a position) 
        (OCCUPIED)
        
        ;The origin of the moveable card is the bottom
        ;bottom identifies a column that is empty or it is going to be empty
        ;ORBOTT avoids having a move from empty column to empty column
        (ORIGIN ?origin - place)
        
        ;The origin of the moveable card is a freecell
        ;ORFREE avoids having a move from a freecell to a freecell
        (CELLSPACE ?ncol - num)
        (COLSPACE ?ncol - num))


;It takes a card from a column with one element and puts it in the state of moveable
;It specifies the origin (bottom) and virtually removes the card from the column  (increase colspace)
;It blocks the selection of other cards to be moveable using occupied
(:action FROM-BOTTOM-TO-MOVEABLE
  :parameters (?card - card ?ncol - num ?ncol_prev - num)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (BOTTOMCOL ?card) (COLSPACE ?ncol_prev) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and (OCCUPIED) (ORIGIN b) (MOVEABLE ?card)  (not (CLEAR ?card)) (not (BOTTOMCOL ?card)) (not (COLSPACE ?ncol_prev)) (COLSPACE ?ncol))
)

;It takes a card from a column with more than one element and puts it in the state of moveable
;Its origin is not relevant, then it is not specified, it virtually removes the card from the column. 
;It blocks the selection of other cards to be moveable using occupied
(:action FROM-STACK-TO-MOVEABLE
  :parameters (?card - card ?card_prev - card)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (ON ?card ?card_prev) )
  :effect
   (and (OCCUPIED) (ORIGIN s) (not (CLEAR ?card)) (MOVEABLE ?card) (not (ON ?card ?card_prev)) (CLEAR ?card_prev))
)

;It takes a card from a freecell and puts it in the state of moveable
;It specifies the origin (free) and virtually removes the card from the freecell (increase cellspace) 
;It blocks the selection of other cards to be moveable using occupied
(:action FROM-FREE-TO-MOVEABLE
  :parameters (?card - card ?nfree - num ?nfree_prev - num)
  :precondition
   (and (not (OCCUPIED)) (INCELL ?card)  (CELLSPACE ?nfree_prev) (SUCCESSOR ?nfree ?nfree_prev))
  :effect
   (and (OCCUPIED) (ORIGIN f) (MOVEABLE ?card) (not (INCELL ?card)) (not (CELLSPACE ?nfree_prev)) (CELLSPACE ?nfree))
)

;It takes the only moveable card and puts it into a freecell
;It can't happen if the moveable card was already in the freecell.
;It clears moveable, occupied and the origin and decreases the cellspace 
(:action FROM-MOVEABLE-TO-FREE
  :parameters (?card - card ?nfree - num ?nfree_prev - num ?origin - place)
  :precondition
   (and (MOVEABLE ?card) (ORIGIN ?origin) (not (ORIGIN f)) (CELLSPACE ?nfree) (SUCCESSOR ?nfree ?nfree_prev) )
  :effect
   (and (not (MOVEABLE ?card))  (not (ORIGIN ?origin)) (not (OCCUPIED)) (INCELL ?card) (not (CELLSPACE ?nfree)) (CELLSPACE ?nfree_prev) )
)

;It takes the only moveable card and puts it into an empty column
;It can't happen if the moveable card was already in a column with one element.
;It clears moveable, occupied and the origin and decreases the colspace 
(:action FROM-MOVEABLE-TO-BOTTOM
  :parameters (?card - card ?ncol - num ?ncol_prev - num ?origin -place)
  :precondition
   (and (MOVEABLE ?card)  (ORIGIN ?origin)  (not (ORIGIN b)) (COLSPACE ?ncol) (SUCCESSOR ?ncol ?ncol_prev))
  :effect
   (and (not (MOVEABLE ?card))  (not (ORIGIN ?origin)) (not (OCCUPIED)) (CLEAR ?card)  (BOTTOMCOL ?card) (not (COLSPACE ?ncol)) (COLSPACE ?ncol_prev))
)

;It takes the only moveable card and puts it into a column with more than one element.
;It clears moveable, occupied and eventually the origin and changes the state of the card that was on top
(:action FROM-MOVEABLE-TO-STACK
  :parameters (?card - card ?card_prev - card  ?origin - place)
  :precondition
   (and (MOVEABLE ?card) (ORIGIN ?origin) (not (ORIGIN s)) (CLEAR ?card_prev) (CANSTACK ?card ?card_prev))
  :effect
   (and (not (CLEAR ?card_prev))  (not (ORIGIN ?origin)) (CLEAR ?card) (not (MOVEABLE ?card)) (not (OCCUPIED)) (ON ?card ?card_prev) )
)

;It takes the only moveable card and puts it into home cell if the suit and value are correct .
;It clears moveable, occupied and eventually the origin, then it updates the state of the homecell
(:action FROM-MOVEABLE-TO-HOME
  :parameters (?card - card ?card_to - card ?suit - suit ?val - num ?val_to - num ?origin - place)
  :precondition
   (and (MOVEABLE ?card) (HOME ?card_to) (ORIGIN ?origin) (SUIT ?card ?suit) (SUIT ?card_to ?suit) 
    (VALUE ?card ?val) (VALUE ?card_to ?val_to) (SUCCESSOR ?val ?val_to ))
  :effect
   (and (not (MOVEABLE ?card)) (not (ORIGIN ?origin)) (not (OCCUPIED))  (not (HOME ?card_to)) (HOME ?card))
)

(:action FROM-STACK-TO-STACK
  :parameters (?card - card ?card_to - card ?card_prev - card)
  :precondition
   (and (not (OCCUPIED)) (CLEAR ?card) (CLEAR ?card_to) (CANSTACK ?card ?card_to) (ON ?card ?card_prev))
  :effect
   (and  (CLEAR ?card_prev) (not (CLEAR ?card_to)) (not (ON ?card ?card_prev)) (ON ?card ?card_to))
)

)