
; > Dimensions <
(define tSub 10) ; um, thickness of the substrate

; > others <
(define node "@node@")

; ---------------------------------------------------------------------
; ### Creating The Structure ###
; ---------------------------------------------------------------------

(sdegeo:set-default-boolean "ABA") ; new will replace old

; > n type cSi layer <
(sdegeo:create-rectangle (position 0 0 0) (position 2 tSub 0) "Silicon" "Subs" )

; ---------------------------------------------------------------------
; ### Placing Contacts
; ---------------------------------------------------------------------
; > Electrode 1 < 
(sdegeo:define-contact-set "electrode1" 4  (color:rgb 1 0 0 ) "solid" )
(sdegeo:define-2d-contact (find-edge-id (position 0.2 0 0) ) "electrode1")

; > Electrode 2 < 
(sdegeo:define-contact-set "electrode2" 4  (color:rgb 0 1 0 ) "||" )
(sdegeo:define-2d-contact (find-edge-id (position 0.2 tSub 0) ) "electrode2")

; ---------------------------------------------------------------------
; ### Setting The Doping ###
; ---------------------------------------------------------------------

; > p region constant doping <
(sdedr:define-constant-profile "Const.Subs"  "BoronActiveConcentration" 8e15)
(sdedr:define-constant-profile-region "PlaceCD.Subs"  "Const.Subs" "Subs")

; > n+ region  <
(sdedr:define-constant-profile "doping.profile.nplusSi"  "PhosphorusActiveConcentration" 2e18)
(sdedr:define-refeval-window "window.nplusSi" "Rectangle"  (position 0 0 0.0)  (position 2 1 0.0) )
(sdedr:define-constant-profile-placement "place.nplusSi" "doping.profile.nplusSi" "window.nplusSi")

; ---------------------------------------------------------------------
; ### Refinement
; ---------------------------------------------------------------------
; on nSi
(sdedr:define-refeval-window "refw.ncSi" "Rectangle" (position 0 0 0) (position 2 tSub 0) )
(sdedr:define-multibox-size "refs.ncSi" 1 (/ tSub 5) 0 1 (/ tSub 20) 0 1 1.1 0)
(sdedr:define-multibox-placement "Place.ncSi" "refs.ncSi" "refw.ncSi")

; on top region
(sdedr:define-refeval-window "refw.nplus" "Rectangle" (position  0 0 0) (position  2 1 0))
(sdedr:define-multibox-size "refs.nplus" 1 (/ tSub 5) 0 1 (/ tSub 100) 0 1 1.2 0)
(sdedr:define-multibox-placement "Place.nplus" "refs.nplus" "refw.nplus")

(sde:build-mesh "snmesh" "" (string-append "n" node "_msh") )
