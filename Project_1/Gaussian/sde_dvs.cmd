(define totalthickness	    10)
(define totalwidth          2)
  


;----------------------------------------------------------------------
; Structure definition
;----------------------------------------------------------------------;
(sdegeo:set-default-boolean "BAB");old replace new
 
(sdegeo:create-rectangle 
  (position 0.0  0.0  0.0)  (position totalwidth 0.5 0.0 ) "Silicon"  "nsub" )

(sdegeo:create-rectangle 
  (position 0.0 0.5  0.0)  (position totalwidth totalthickness 0.0 ) "Silicon"  "psub" )


;-----------electrode and contact------------
(sdegeo:define-contact-set "electrode1"   4  (color:rgb 1 0 0 ) "##" ) 
(sdegeo:define-2d-contact (find-edge-id (position 0.2  0.0 0.0)) "electrode1")

(sdegeo:define-contact-set "electrode2"   4  (color:rgb 1 0 0 ) "##" ) 
(sdegeo:define-2d-contact (find-edge-id (position 0.2  totalthickness 0.0)) "electrode2")


;------------profile------------ 
;-----------drift contact doping----------------  

(sdedr:define-refinement-window "win.drift"  "Rectangle" 
	(position 0.0 0.0 0.0)  (position totalwidth totalthickness 0.0)  
)

(define NAME "pA")
(sdedr:define-refinement-window (string-append "RW." NAME) 
	"Rectangle"  
	(position 0.0 0.5  0.0) 
	(position totalwidth totalthickness 0.0) 
)
(sdedr:define-constant-profile (string-append "DC." NAME)
	"BoronActiveConcentration" 
	8e15
)
(sdedr:define-constant-profile-placement (string-append "CPP." NAME)
	(string-append "DC." NAME) (string-append "RW." NAME)
	0
	"replace"
)

;DENIZ INSERT GAUSSIAN DOPING
(sdedr:define-gaussian-profile "nwell-doping-profile-gauss-hor"
"PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal"
2e18 "ValueAtDepth" 1e18 "Depth"
0.5 "Gauss" "Factor" 0.8) 
; Window Selection
(sdedr:define-refeval-window "window.nplusSi" "Line" (position 0 0 0) (position 2 0 0))
; Doping Placement
(sdedr:define-analytical-profile-placement "place.nplusSi" "nwell-doping-profile-gauss-hor"
"window.nplusSi" "Positive" "NoReplace")

;DENIZ COMMENT OUT
;(define NAME "nS")
;(sdedr:define-refinement-window (string-append "RW." NAME) 
;	"Rectangle"  
;	(position 0.0 0 0.0) 
;	(position totalwidth 0.5 0.0) 
;)
;(sdedr:define-constant-profile (string-append "DC." NAME)
;	"ArsenicActiveConcentration" 
;	 2e18
;)
;(sdedr:define-constant-profile-placement (string-append "CPP." NAME)
;	(string-append "DC." NAME) (string-append "RW." NAME)
;	0
;	"replace"
;)


;---------------------------------------------------------------------------
; Meshing
;---------------------------------------------------------------------------
; Global
(sdedr:define-refinement-window "win.global" "Rectangle"
                (position 0 0 0) (position totalwidth totalthickness 0))
(sdedr:define-refinement-size "RefDef.global" 0.5 0.5 0.1 0.1)
(sdedr:define-refinement-function "RefDef.global" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-function "RefDef.global" "MaxLenInt" "Silicon" "Oxide" 0.1 1.5 "Doubleside")
(sdedr:define-refinement-placement "Place.global" "RefDef.global" "win.global")

;anode region
;(sdedr:define-refinement-window "win.electrode1" "Rectangle"
;                (position 0 1 0) (position totalwidth totalthickness 0))
;(sdedr:define-refinement-size "RefDef.electrode1" 0.1 0.05 0.05 0.02)
;(sdedr:define-refinement-function "RefDef.electrode1" "DopingConcentration" "MaxTransDiff" 1)
;(sdedr:define-refinement-function "RefDef.electrode1" "MaxLenInt" "Silicon" "Oxide" 0.1 1.5 "Doubleside")
;(sdedr:define-refinement-placement "Place.electrode1" "RefDef.anode" "win.electrode1")

;cathode region
;(sdedr:define-refinement-window "win.electrode2" "Rectangle"
;                (position 0 0 0) (position totalwidth 1 0))
;(sdedr:define-refinement-size "RefDef.electrode2" 0.1 0.05 0.05 0.02)
;(sdedr:define-refinement-function "RefDef.electrode2" "DopingConcentration" "MaxTransDiff" 1)
;(sdedr:define-refinement-function "RefDef.electrode2" "MaxLenInt" "Silicon" "Oxide" 0.1 1.5 "Doubleside")
;(sdedr:define-refinement-placement "Place.electrode2" "RefDef.cathode" "win.electrode2")


;---------------------------------------------------------------------------
(sde:build-mesh "snmesh" "" "n@node@")
