;***************************************************************************************
;IFM BZT CNC V2.1f
;***************************************************************************************

;***************************************************************************************

;***************************************************************************************
;DOKU
;***************************************************************************************
;Versionshistorie
;---------------- 
;V2.1f  : IFM BZT CNC V2.1f
;V2.1e	: WZ-Längenmessung - Nur positive Werkzeuglängen zulassen
;V2.1d	: Position nach Referenzfahrt neues Dialogfenster in WLMP (VF).
;V2.1c	: Bruchkontrolle - Dialog in WLMP aktiviert (VF).
;V2.1b	: Bruchkontrolle - Änderung für MDI oder Tool-Change Aufruf (VF).
;V2.1a	: Bruchkontrolle - Sensorzustand prüfen (VF).
;V2.1	: Z-Null und WZ-Längenmessung - Sensorzustand prüfen (VF).
;V2.0d	: In gosub 'zero_set_rotation' falls ein Job geladen wurde dieser gestartet
;	  und somit auch die Spindel was den Messtaster zerstört !
;		: Letzte Zeile geändert - hier darf kein STRG + G stehen !
;V2.0c: Funktionen für Eding WIFI Handrad implementiert 
;V2.0b: Werte der Werkzeugtabelle auf Null setzen 
;V2.0a: Z-Höhenausgleich 
;V2.0 : 3D Taster für X und Y Nullpunktermittlung 
;		Bruchkontrolle (Nicht aktiviert)
;		Spindelwarmlauf
;		Werkezugwechselbutton 
;V1.0e : Bei Wechslertyp 0 und 1 wird jetzt vor Z-Nullpunktermittlung nicht mehr geprüft ob Werkezug vermessen

;Verwendete Variablen
;   #3500 INIT
;   #3501 Merker ( Wurde Werkzeug bereits Vermessen? 1=JA)
;   #3502 Merker Wird nur für eine Berechnung benötigt
;   #3503 Merker Ja / Nein in Dialogabfragen
;   #3504 Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
;   #3505 Merker ob Längenmessung von Handrad 1=Handrad
;   #3510 Merker ob Werkzeugwechsel von GUI aufgerufen (1= von GUI aufgerufen)
;
; Parameter für Typ des Werkzeuglängensensors
;---------------------------------------------
;   #4400 Werkzeuglängensensor-Typ (0= Öffner, 1= Schliesser)
;
;   #4500 FREI
;
; Parameter für Werkzeuglängenmessung
;------------------------------------- 
;   #4501 Aktuelle Werkzeuglänge
;   #4502 Alte Werkzeuglänge
;   #4503 Maximale Werkzeuglänge                                (WZL-Vermessung)
;   #4504 Antastgeschwindigkeit zum Taster "suchen" (mm/min) 	(WZL-Vermessung)
;   #4505 Tastgeschwindigkeit zum Messen(mm/min)                (WZL-Vermessung)
;   #4506 ;Sicherheitshöhe als Maschinenkoordinate		(WZL-Vermessung)
;   #4507 ;Positionsangabe der X Achse 				(WZL-Vermessung)
;   #4508 ;Positionsangabe der Y Achse				(WZL-Vermessung)
;   #4509 Abstand Spindelnase zu Längensensor von Z0 aus     	(WZL-Vermessung)
;
; Parameter für Z-Nullpunkt Vermessung
;-------------------------------------- 
;   #4510 Tasterhöhe						(ZNP-Vermessung)
;   #4511 Freifahrhöhe						(ZNP-Vermessung)
;   #4512 Antastgeschwindigkeit zum Taster "suchen"		(ZNP-Vermessung)
;   #4513 Tastgeschwindigkeit zum Messen			(ZNP-Vermessung)
;-------------------------------------- 
;
;   #4514 Zwischenspeicher für X Pos
;   #4515 Zwischenspeicher für Y Pos
;   #4516 Zwischenspeicher für Z Pos
;   #4517 Merker (Es wurde kein Werkzeug ausgewählt)
;   #4518 Merker (Achse zurückfahren auf Z Vermessungspunkt)
;   #4519 Was tun nach Werkzeugvermessung: 0= vordefinierten Punkt anfahren 1= Werkstücknullpunkt fahren 2= Werkzeugwechselpos anfahren 3= Maschinennullpunkt anfahren 4= Stehen bleiben
;   #4524 Position X nach Längenmessung   
;   #4525 Position Y nach Längenmessung
;   #4526 Position Z nach Längenmessung
;   #4520 Werkzeugwechseltyp 0= Mache garnix 1 = Nur WPos Anfahren 2= WPos anfahren  + Vermessen 
;   #4521 (TYP 0) Werkzeugwechselpos  X 
;   #4522 (TYP 0) Werkzeugwechselpos  Y
;   #4523 (TYP 0) Werkzeugwechselpos  Z
;   #4524 Position X nach Längenmessung   
;   #4525 Position Y nach Längenmessung
;   #4526 Position Z nach Längenmessung
;   #4527 Abstand Taster zum Spindelkopf  bei Z0 G53 negativer Wert - UNBENUTZT
;   #4528 Erlaubte Toleranz Bruchkontrolle
;   #4529 Merker ob Automatische Bruchkontrolle eingeschaltet
;   #4530 Merker ob Kegelcheck eingeschaltet NICHT IN GEBRAUCH
;   #4531 Kegelhöhe über Sensor NICHT IN GEBRAUCH
;
; Parameter für Spindel-Warmlauf
;-------------------------------- 
;   #4532 Drehzahl Stufe 1 für Warmlauf Spindel
;   #4533 Laufzeit Stufe 1 für Warmlauf Spindel
;   #4534 Drehzahl Stufe 2 für Warmlauf Spindel
;   #4535 Laufzeit Stufe 2 für Warmlauf Spindel
;   #4536 Drehzahl Stufe 3 für Warmlauf Spindel
;   #4537 Laufzeit Stufe 3 für Warmlauf Spindel
;   #4538 Drehzahl Stufe 4 für Warmlauf Spindel
;   #4539 Laufzeit Stufe 4 für Warmlauf Spindel
;   #4540 bis #4549 Leer für mehr Stufen
;
; Parameter für 3D-finder
;------------------------- 
;   #4544 3D-finder Sensor-Typ (0= Öffner, 1= Schliesser)
;   #4545 3D-finder Taster-Länge (Werkzeuglänge)
;   #4546 3D-finder Kugelradius
;   #4547 3D-finder Radius-Offset
;
;   #4548 3D-finder Tgeschwindigkeit zum Taster-Anfahren (mm/min)
;   #4549 3D-finder Tastgeschwindigkeit zum Messen (mm/min)
;
; Parameter für Werkstück antasten (SOROTEC)
;--------------------------------------------
;   #4550 Nullpunktermittlung Merker Richtung
;   #4551 Nullpunktermittlung Versatz X+
;   #4552 Nullpunktermittlung Versatz X-
;   #4553 Nullpunktermittlung Versatz Y+
;   #4554 Nullpunktermittlung Versatz Y-
;
;   #4560 - 3D-finder Spindelversatz berücksichtigen (1= Ja, 0= Nein)
;   #4561 - 3D-finder Spindelversatz X
;   #4562 - 3D-finder Spindelversatz Y
;
;   #4563 - UNBENUTZT
;   #4564 - UNBENUTZT
;   #4565 - UNBENUTZT
;   #4566 - UNBENUTZT
;
;   #4600 Ab hier für Wechsler reserviert 
;
; Parameter für Position nach Referenzfahrt
;------------------------------------------
;   #4631 Position in X nach der Referenzfahrt
;   #4632 Position in Y nach der Referenzfahrt
;   #4633 Position in Z nach der Referenzfahrt
;
; SYSTEM VARIABLEN
;------------------
;   #5001 Aktuelle X Pos (Arbeitskoordinate)
;   #5002 Aktuelle Y Pos (Arbeitskoordinate)
;   #5003 Aktuelle Z Pos (Arbeitskoordinate)
;   #5004 Aktuelle A Pos (Arbeitskoordinate)
;   #5005 Aktuelle B Pos (Arbeitskoordinate)
;   #5006 Aktuelle C Pos (Arbeitskoordinate)
;   #5008 Aktuelle Werkzeugnummer
;   #5010 Aktuelle Werkzeuglänge
;   #5011 Neue Werkzeugnummer
;   #5015 Werkzeugwechsel-Vorgang (0= Wechsel nicht ausgeführt, 1= Wechsel wurde ausgeführt)
;   #5053 Sensor-Schaltpunkt Z Pos (Maschinenkoordinate), wenn Sensoreingang den Zustand ändert
;   #5061 Sensor-Schaltpunkt X Pos (Arbeitskoordinate)
;   #5062 Sensor-Schaltpunkt Y Pos (Arbeitskoordinate)
;   #5063 Sensor-Schaltpunkt Z Pos (Arbeitskoordinate)
;   #5064 Sensor-Schaltpunkt A Pos (Arbeitskoordinate)
;   #5065 Sensor-Schaltpunkt B Pos (Arbeitskoordinate)
;   #5066 Sensor-Schaltpunkt C Pos (Arbeitskoordinate)
;   #5067 Sensorimpuls:  1 = wenn Sensoreingang den Zustand ändert
;   #5068 Sensorzustand: 0 = geschlossen, 1 = geöffnet (wenn der Sensor als Öffner konfigfuriert ist)
;   #5071 Aktuelle X Pos (Maschinenkoordinate)
;   #5072 Aktuelle Y Pos (Maschinenkoordinate)
;   #5073 Aktuelle Z Pos (Maschinenkoordinate)
;   #5074 Aktuelle A Pos (Maschinenkoordinate)
;   #5075 Aktuelle B Pos (Maschinenkoordinate)
;   #5076 Aktuelle C Pos (Maschinenkoordinate)
;   #5113 Positives Limit Z (Maschinenkoordinate)
;   #5380 Abfrage ob Simulation Modus [0=Nein NormalModus,  1=Ja SimulationsModus]
;   #5397 Abfrage ob sich die Maschine im Render Modus befindet [0=Nein NormalModus,  1=Ja RenderModus]
;   #5398 DlgMsg Return-Value [1=OK,  -1=CANCEL]
;   #5399 Return-Value der Funktionen M55 und M56

;***************************************************************************************
IF [#3500 == 0] then ; INIT
	#3500 = 1
	IF [#4504 == 0] THEN  	
		#4504 =50	;Antastgeschwindigkeit zum Taster "suchen" (mm/min)
	ENDIF
	IF [#4505 == 0] THEN  	
		   #4505 =10  	;Tastgeschwindigkeit zum Messen(mm/min)  
	ENDIF
	IF [#4511 == 0] THEN  	
	   	#4511 =10	;Freifahrhöhe		
	ENDIF
	IF [#4512 == 0] THEN  	
		#4512 = 50  	;Antastgeschwindigkeit zum Taster "suchen"
	ENDIF  
	IF [#4513 == 0] THEN  	
		#4513 =20  	;Tastgeschwindigkeit zum Messen
	ENDIF
ENDIF
;***************************************************************************************

;---------------------------------------------------------------------------------------
  Sub user_1 ; Z-Nullpunktermittlung
; ;---------------------------------------------------------------------------------------
; ; #185  - TEMP-Variable (Sensor Fehler-Zustand)


; 	IF [[#3501 == 1] or [#4520 < 2]]then	; Wurde Werkzeug bereits Vermessen? 1=JA oder ist längensensor inaktiv geschaltet

; 		;--------------------------------------------------
; 		; Sensorzustand prüfen
; 		;--------------------------------------------------
; 		 IF [#4400 == 0]				; Wenn Öffner (#4400 = 0)
; 		     #185 = 1					;     Fehler-Zustand (1= offen)
; 		 ELSE						; Wenn Schliesser (#4400 = 1)
; 		     #185 = 0					;     Fehler-Zustand (0= geschlossen)
; 		 ENDIF

; 		 IF [#5068 == #185]					; Sensorzustand prüfen
; 			dlgmsg "Werkzeugsensor nicht angeschlossen"
; 			IF [#5398 == 1]					; OK-Taste
; 			    IF [#5068 == #185]				; Sensor immer noch nicht angeschlossen
; 				errmsg "Z-Nullpunktermittlung abgebrochen -> Sensor Error"
; 			    ENDIF
; 			ELSE
; 			    errmsg "Z-Nullpunktermittlung abgebrochen -> Sensor Error"
; 			ENDIF	
; 		 ENDIF
; 		;--------------------------------------------------


; 		#4518 = 0 						; Merker Achse zurückfahren auf Z Vermessungspunkt) Sicherheitshalber rücksetzen
; 		IF [#3505 == 0] 					; Merker ob Längenmessung von Handrad 1=Handrad
; 			DlgMsg "Z-Nullpunkt ermitteln" 
; 		ENDIF	
; 		#3505 = 0						; Merker ob Längenmessung von Handrad 1=Handrad
; 		IF [[#5398 == 1] AND [#5397 == 0]]			; OK Taste gedrückt und RenderModus AUS !!
; 			M5						; Spindel ausschalten
; 			msg "Taster wird angefahren"	
; 			G38.2 G91 z-50 F[#4512] 			; Schnelles anfahren auf Taster bis Schaltsignaländerung
; 			IF [#5067 == 1]					; Wenn Sensor gefunden wurde
; 			    G38.2 G91 z20 F[#4513]			; Langsam von Taster runterfahren zur exakten Z-Ermittlung
; 			    G90
; 	 		    IF [#5067 == 1]				; Wenn Sensor gefunden wurde              
; 				G0 Z#5063				; Schaltpunkt anfahren	
; 				G92 Z[#4510] 				; Z-Nullpunkt übernehmen

; 				G0 Z[#4510 + 5] 			; Taster 5mm Freifahren
; 				msg"Z-Nullpunktermittlung fertig"
; 			    ELSE
; 				G90 
; 				errmsg "FEHLER: Sensor hat nicht geschaltet"
; 			    ENDIF

; 			ELSE	;CANCEL

; 			    G90 
; 			    DlgMsg "WARNUNG: Kein Sensor gefunden! Erneut Versuchen?" 
; 			    IF [#5398 == 1] ;OK   				
; 				GoSub user_1
; 			    ELSE
; 				errmsg "Messung wurde abgebrochen!"
; 			    ENDIF
; 			ENDIF
; 		ENDIF   	
; 	ELSE
; 		#3505 = 0					; Merker ob Längenmessung von Handrad 1=Handrad
; 		DlgMsg "WARNUNG - Werkzeug zuerst Vermessen" 
; 		IF [#5398 == 1] 	;OK
; 	   		#4514 = #5071				; Zwischenspeicher für X Pos
; 			#4515 = #5072				; Zwischenspeicher für Y Pos
; 			#4516 = #5073				; Zwischenspeicher für Z Pos
; 			#4518 = 1				; Merker setzen das zurückpositioniert wird
; 			GoSub user_2
; 		ENDIF
; 	ENDIF
 Endsub

;***************************************************************************************
Sub user_2 ; Werkzeuglängenmessung
;---------------------------------------------------------------------------------------
; #185  - TEMP-Variable (Sensor Fehler-Zustand)
; #4509 - Abstand Taster zum Spindelkopf  bei Z0 (G53)(negativer Wert)
;


  #5016 = [#5008]	; Aktuelle Werkzeugnummer
  IF [#5017 == 0]
	#5017 = [#4503]	; Maximale Werkzeuglänge
  ElSE
	#5017 = #[5400 + #5016] ; von gespeicherte Tabelle
  ENDIF
  #5019 = [#4507]	; Werkzeuglängensensorposition X-Achse
  #5020 = [#4508]	; Werkzeuglängensensorposition Y-Achse
  #5021 = 0 		; Gemessene Werkzeuglänge wird hier eingetragen

   ;-VF-----------------------------------------------
   ; Für 3D-Taster keine Längenmessung
   ;--------------------------------------------------
    IF [#5008 > 97]			; Werkzeuge 98 und 99 sind 3D-Taster - keine Längenmessung
	msg "Werkzeug ist 3D-Taster -> Längenmessung nicht ausgeführt"
	M30				; Programmende
    ENDIF
   ;--------------------------------------------------

   ;--------------------------------------------------
   ; Sensorzustand prüfen
   ;--------------------------------------------------
    IF [#4400 == 0]				; Wenn Öffner (#4400 = 0)
	#185 = 1				;     Fehler-Zustand (1= offen)
    ELSE					; Wenn Schliesser (#4400 = 1)
	#185 = 0				;     Fehler-Zustand (0= geschlossen)
    ENDIF

    IF [#5068 == #185]					; Sensorzustand prüfen
	dlgmsg "Werkzeugsensor nicht angeschlossen"
	IF [#5398 == 1]					; OK-Taste
	    IF [#5068 == #185]				; Sensor immer noch nicht angeschlossen
		errmsg "Werkzeuglängenmessung abgebrochen -> Sensor Error"
	    ENDIF
	ELSE
	    errmsg "Werkzeuglängenmessung abgebrochen -> Sensor Error"
	ENDIF	
    ENDIF
   ;--------------------------------------------------

    msg "Werkzeug wird vermessen"
    dlgmsg "Soll Werkzeug Vermessen werden" "Werkzeuglänge ca:" 5017

    IF [[#5398 == 1] AND [#5397 == 0]]		; OK Taste wurde gedrückt und RenderModus ist AUS !!

	IF [[#5017] <= 0] THEN					; Testen ob Werkzeuglänge negativ
	    DlgMsg "!!! WARNUNG: Werkzeuglänge muss positiv sein !!!" "Werkzeuglänge ca:" 5017
	    ; IF [#5398 == 1] ;OK
	    ;	GoSub user_2
	    ; ELSE
	    ;	GoSub user_2
	    ; ENDIF
	ENDIF

	IF [[#4509 + #5017 + 10] > [#4506]] THEN		; Testen ob errechneter Wert höher wie sicherheitshöhe ist
	    DlgMsg "!!! WARNUNG: Werkzeug zu lang !!!" "Werkzeuglänge ca:" 5017
	    ; IF [#5398 == 1] ;OK
	    ;	GoSub user_2
	    ; ELSE
	    ;	GoSub user_2
	    ; ENDIF
	ENDIF

	IF [ [#5017 <= 0] OR [[#4509 + #5017 + 10] > [#4506]] ]	;#VF# Immer noch falsche Eingabe
	    errmsg "Werkzeuglängenmessung Abgebrochen"
	ENDIF


	M5 M9
	G53 G0 z[#4506]						; Z Sicherheitshöhe anfahren [Maschinenkoordinate] 
       	G53 G0 x[#5019] y[#5020]				; Werkzeuglängensensor Position anfahren

	;--------------------------------
	; Eilgeschwindigkeit zum Sensor 
	;--------------------------------
	 G53 G0 z[#4509 + #5017 + 10]				; Abstand Z zum Sensor in G0 anfahren - Spindelkopfabstand + max.Werkzeuglänge + 10
	;--------------------------------

	G53 G38.2 Z[#4509] F[#4504]				; Z mit Antastgeschwindigkeit #4504 an den Sensor fahren

	IF [#5067 == 1]						; Wenn Sensor gefunden wurde
	    G91 G38.2 Z20 F[#4505]				; Z mit Messgeschwindigkeit #4505 vom Sensor wegfahren bis Taster erneut schaltet
	    G90							; Modus für absolute Koordinaten

	    IF [#5067 == 1]					; Wenn Sensor gefunden wurde, wird Tastpunkt in #5053 gespeichert

		G00 g53 z#4506					; Z Sicherheitshöhe anfahren [Maschinenkoordinate]

		;***********Bei Direktvermessung Tabelle auf 0 schreiben
		#[5400 + #5016] = [#5053 - #4509]			;Berechnete Werkzeuglänge in Tabelle speichern
		#[5500 + #5016] = 0 ;#5018				;Werkzeugdurchmesser in Tabelle speichern
		;***********Bei Direktvermessung Tabelle auf 0 schreiben Ende

		#5021 = [#5053 - #4509]				; Berechnung Werkzeuglänge = Tastpunkt  - chuck height
		msg "Werkzeuglänge = " #5021

		IF [#3501 == 1] 				; Wurde Werkzeug bereits Vermessen? 1=JA
		    #4502 = [#4501]				; Alte Werkzeuglänge speichern
		    #4501 = [#5021]				; Aktuelle Werkzeuglänge speichern = Ermittelte Werkzeuglänge
		    #3502 = [#4501 - #4502]			; Werkzeuglängenunterschied ausrechnen

		    G43 H#5016				; Werkzeuglängenkorrektur aktivieren
			;G92 Z[#5003 - #3502]		 	; Z-Nullpunkt verschieben

		    ;Werkzeuglaenge und Werkzeugdurchmesser in Tabelle speichern
		    ;#[5400 + #5016] = [#5053 - #4509]			;Berechnete Werkzeuglänge in Tabelle speichern
		    ;#[5500 + #5016] = #5018				;Werkzeugdurchmesser in Tabelle speichern
		    ;msg "Gemessene Werkzeuglaenge="#[5400 + #5016]" gespeichert in Werkzeugnr. "#5016
		ELSE
		    #4501 = [#5021]				; Aktuelle Werkzeuglänge eintragen
            	ENDIF

		IF [#4518 == 1] then				; Merker: Zurückfahren auf Z Vermessungspunkt (1=JA, 0=NEIN)
		    G0 G53 Z#4506				; Z Sicherheitshöhe anfahren [Maschinenkoordinate]
		    G0 G53 X#4514 Y#4515			; Repositionieren
		    #4518 = 0					; Merker: Zurückfahren auf Vermessungspunkt (1=JA, 0=NEIN)
		    #3501 = 1					; Merker: Wurde Werkzeug bereits Vermessen? (1=JA, 0=NEIN)
		ELSE
		    IF [#4519 == 0] then			; ### 0 ### Was tun nach Werkzeugvermessung: 0= vordefinierten Punkt anfahren
			G0 G53 Z#4506				; Z Sicherheitshöhe anfahren [Maschinenkoordinate]
			G0 G53 X#4524 Y#4525			; Vordefinierten Punkt anfahren 
		    ENDIF

		    IF [#4519 == 1] then			; ### 1 ### Was tun nach Werkzeugvermessung: 1= Werkstücknullpunkt fahren 
			G0 G53 Z#4506				; Z Sicherheitshöhe anfahren [Maschinenkoordinate]
			G0 X0 Y0				; Werkstücknullpunkt anfahren
		    ENDIF

		    IF [#4519 == 2] then			; ### 2 ### Was tun nach Werkzeugvermessung: 2= Manuelle Werkzeugwechselpos anfahren
			G0 G53 Z#4523				; Werkzeugwechselpos Z anfahren
			G0 G53 X#4521 Y#4522			; Werkzeugwechselpos XY anfahren
		    ENDIF

		    IF [#4519 == 3] then			; ### 3 ### Was tun nach Werkzeugvermessung: 3= Maschinennullpunkt anfahren
			G0 G53 Z#4506				; Z Sicherheitshöhe anfahren [Maschinenkoordinate]
			G0 G53 X0 Y0				; Maschinennullpunkt anfahren
		    ENDIF

		    ; IF [#4519 == 4] then			; ### 4 ### Was tun nach Werkzeugvermessung: 4= Stehen bleiben
		    ; ENDIF
					
		ENDIF

		#4518 = 0					; Merker: Zurückfahren auf Vermessungspunkt (1=JA, 0=NEIN)
           	#3501 = 1					; Merker: Wurde Werkzeug bereits Vermessen? (1=JA, 0=NEIN)
	    ELSE
		errmsg "FEHLER: Kein Sensor gefunden - RESET BETäTIGEN"
	    ENDIF

	ELSE
	    errmsg "FEHLER: Kein Sensor gefunden - Messung abgebrochen"
	ENDIF
    ENDIF

Endsub

;***************************************************************************************
Sub user_3 ; Bruchkontrolle des Fräsers
;---------------------------------------------------------------------------------------
; #185  - TEMP-Variable (Sensor Fehler-Zustand)
; #4509 - Abstand Taster zum Spindelkopf  bei Z0 (G53)(negativer Wert)
; #5021 - Gemessene Werkzeuglänge aus der vorherigen Messung
;


    ; #4529 = 0
   ; IF [#4529 == 1]			 					; #4529 Merker ob Automatische Bruchkontrolle eingeschaltet

	IF [#3501 == 1]								; Merker (Wurde Werkzeug bereits Vermessen? 1=JA)

		;--------------------------------------------------
		; Sensorzustand prüfen
		;--------------------------------------------------
		 IF [#4400 == 0]				; Wenn Öffner (#4400 = 0)
		     #185 = 1					;     Fehler-Zustand (1= offen)
		 ELSE						; Wenn Schliesser (#4400 = 1)
		     #185 = 0					;     Fehler-Zustand (0= geschlossen)
		 ENDIF

		 IF [#5068 == #185]					; Sensorzustand prüfen
			dlgmsg "Werkzeugsensor nicht angeschlossen"
			IF [#5398 == 1]					; OK-Taste
			    IF [#5068 == #185]				; Sensor immer noch nicht angeschlossen
				#3504 = 0				; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
				errmsg "Z-Nullpunktermittlung abgebrochen -> Sensor Error"
			    ENDIF
			ELSE
			    #3504 = 0					; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
			    errmsg "Z-Nullpunktermittlung abgebrochen -> Sensor Error"
			ENDIF	
		 ENDIF
		;--------------------------------------------------

		msg "Bruchkontrolle"
		M5 M9
		G53 G0 z[#4506]							; Sicherheitshöhe 
		G53 G0 y[#5020]  						; XYChange Vorsict Sonderfall    
		G53 G0 x[#5019]							; XYChange Vorsict Sonderfall
		G53 G0 z[#4509 + #5017 + 10]

		G53 G38.2 Z[#4509] F[#4504] 
		IF [#5067 == 1]							; Wenn Sensor gefunden wurde
			G91 G38.2 Z20 F[#4505] 
			G90
			IF [#5067 == 1]						; Wenn Sensor gefunden wurde, wird Tastpunkt in #5053 gespeichert
				#4501 = [#5053 - #4509]				; Berechnung aktuelle Werkzeuglänge = Tastpunkt  - chuck height
				G00 G53 z#4506
				IF [[[#5021 + #4528] > [#4501]]  and [[#5021 - #4528] < [#4501]]]
					msg "Okay"
					msg " Massabweichung:" [#5021 - #4501]	
					
				ELSE
					#3504 = 0				; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
					G53 G0 Z[#4523]				; Sicherheitshöhe
					G53 G0 X[#4521] 			; Manuelle Werkzeugwechselpos X XYchange
					G53 G0 Y[#4522]				; Manuelle Werkzeugwechselpos Y XYchange
					Dlgmsg "Werkzeug Verschlissen, fortführen?" " Massabweichung:" 4501	
					IF [#5398 == 1] ;OK
						Dlgmsg "WARNUNG: Auftrag wird fortgeführt"	
					ELSE
						#3504 = 0			; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
						errmsg "Werkzeug Verschlissen, abbruch"
					ENDIF
				ENDIF

				IF [#3504 == 0]					; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
					IF [#4519 == 0] then			; Was tun nach Werkzeugvermessung 0= vordefinierten Punkt anfahren
						G0 G53 Z#4506				; Sicher Z 
						G0 G53 X#4524 				; Vordefinierten Punkt anfahren XYchange
						G0 G53 Y#4525				; Vordefinierten Punkt anfahren XYchange
					ENDIF
			
					IF [#4519 == 1] then			; Was tun nach Werkzeugvermessung 1= Werkstücknullpunkt fahren 
						G0 G53 Z#4506				; Sicher Z 
						G0 X0 					; Werkstücknullpunkt anfahren anfahren XYchange
						G0 Y0 					; Werkstücknullpunkt anfahren anfahren XYchange
					ENDIF
					
					IF [#4519 == 2] then			; Was tun nach Werkzeugvermessung 2= Werkzeugwechselpos anfahren
						G0 G53 Z#4523				; Werkzeugwechselpunkt anfahren
						G0 G53 X#4521 				; Werkzeugwechselpunkt anfahren XYchange
						G0 G53 Y#4522				; Werkzeugwechselpunkt anfahren XYchange
					ENDIF

					IF [#4519 == 3] then			; Was tun nach Werkzeugvermessung 3= Maschinennullpunkt anfahren
						G0 G53 Z#4506				; Sicher Z 
						G53 X0 					; Maschinennullpunkt anfahren XYchange
						G53 Y0 					; Maschinennullpunkt anfahren XYchange
					ENDIF

					IF [#4519 == 4] then			; Was tun nach Werkzeugvermessung 4= Stehen bleiben		
					ENDIF
				ENDIF					

			ELSE
				#3504 = 0					; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
				errmsg "FEHLER: Kein Sensor gefunden"
			ENDIF
		ELSE
			#3504 = 0						; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
			errmsg "FEHLER: Kein Sensor gefunden"
		ENDIF

	ELSE
	   DlgMsg "Werkzeug wurde noch nicht Vermessen"
	ENDIF
	#3504 = 0								; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik

   ; ELSE
   ;	DlgMsg "Bruchkontrolle nicht aktiviert"
   ; ENDIF

Endsub

;***************************************************************************************
Sub user_4  ; Spindel Warmlauf 
;---------------------------------------------------------------------------------------
;   #4532 Drehzahl Stufe 1 für Warmlauf Spindel
;   #4533 Laufzeit Stufe 1 für Warmlauf Spindel
;   #4534 Drehzahl Stufe 2 für Warmlauf Spindel
;   #4535 Laufzeit Stufe 2 für Warmlauf Spindel
;   #4536 Drehzahl Stufe 3 für Warmlauf Spindel
;   #4537 Laufzeit Stufe 3 für Warmlauf Spindel
;   #4538 Drehzahl Stufe 4 für Warmlauf Spindel
;   #4539 Laufzeit Stufe 4 für Warmlauf Spindel

	DlgMsg "Spindelwarmlauf Starten?"
	IF [#5398 == 1]	 ;OK
		G53 G00 Z0
		M03 S#4532
		G04 P#4533	
		M03 S#4534
		G04 P#4535	
		M03 S#4536
		G04 P#4537	
		M03 S#4538
		G04 P#4539	
		M05
	ENDIF
Endsub

;***************************************************************************************
Sub user_5  ; Werkzeug wechseln
;---------------------------------------------------------------------------------------

    Dlgmsg "Welches Werkzeug soll eingewechselt werden" " Neue Werkzeugnr.:" 5011
    IF [#5398 == 1] ;OK
	IF [#5011 > 99] THEN
	    Dlgmsg "Werkzeugnr Ungültig: Bitte Werkzeugnummer 1..99 Auswählen"
	    #5011 = #5008				; Neue Werkzeugnummer zurück setzen wie es war
	ELSE
	    #3510 = 1					; Merker ob Werkzeugwechsel von GUI aufgerufen (1= von GUI aufgerufen)
	    gosub change_tool

	    #3510 = 0					; Merker ob Werkzeugwechsel von GUI aufgerufen zurück setzen
	ENDIF
    ENDIF

Endsub

;***************************************************************************************
 Sub user_6  ; Werkzeugmanipulation
; ;---------------------------------------------------------------------------------------
;     #5011 = [#5008]
;     Dlgmsg "!!! Werkzeugmanipulation !!!" "Alte Werkzeugnr" 5008" Neue Werkzeugnr" 5011
;     IF [#5011 > 99] THEN
; 	Dlgmsg "Werkzeugnr Ungültig: Bitte Werkzeugnummer 1..99 Auswählen"
; 	#5011 = #5008					; Neue Werkzeugnummer zurück setzen wie es war
; 	M30
;     ELSE
; 	#5015 = 1					; Wurde werkzeug erfolgreich gewechselt 1=Ja
; 	IF [[#5011] > 0] THEN
; 	    M6 T[#5011]
; 	    ;G43
; 	ELSE
; 	    M6 T[#5011]
; 	ENDIF

;     ENDIF

 Endsub

;***************************************************************************************
Sub user_7
;---------------------------------------------------------------------------------------
   	msg "sub user_7"
	DlgMsg "Keine Funktion hinterlegt"
Endsub

;***************************************************************************************
Sub user_8
;---------------------------------------------------------------------------------------
;   #4550 Nullpunktermittlung Merker Richtung
;   #4551 Nullpunktermittlung Versatz X+
;   #4552 Nullpunktermittlung Versatz X-
;   #4553 Nullpunktermittlung Versatz Y+
;   #4554 Nullpunktermittlung Versatz Y-
Dlgmsg "Nullpunkt ermitteln 1 = X+ / 2 = X- / 3 = Y+  / 4 = Y-" "Richtung:" 4550 
IF [#4550 == 0]
ENDIF

;---- X-Plus-----------------------------------------------------------------------------------
IF [#4550 == 1]
	G91 G38.2 x20 F[#4504]
	G90
	IF [#5067 == 1]					; Wenn Sensor gefunden wurde
	    G91 G38.2 x-10 F[#4505]
		G90
		IF [#5067 == 1]				; Wenn Sensor gefunden wurde
			G92 X#4551
			G91 G00 x-1 
			G90
		ENDIF
	ELSE
		DlgMsg "FEHLER: Kein Sensor gefunden - Messung abgebrochen"
	ENDIF 
	#4550 = 0
ENDIF
;---- X-Minus-----------------------------------------------------------------------------------
IF [#4550 == 2]
	G91 G38.2 x-20 F[#4504]
	G90
	IF [#5067 == 1]					; Wenn Sensor gefunden wurde
	    G91 G38.2 x10 F[#4505]
		G90
		IF [#5067 == 1]				; Wenn Sensor gefunden wurde
			G92 X#4552
			G91 G00 x1 
			G90
		ENDIF
	ELSE
		DlgMsg "FEHLER: Kein Sensor gefunden - Messung abgebrochen"
	ENDIF 
	#4550 = 0
ENDIF
;---- Y-Plus-----------------------------------------------------------------------------------
IF [#4550 == 3]
	G91 G38.2 y20 F[#4504]
	G90
	IF [#5067 == 1]					; Wenn Sensor gefunden wurde
	    G91 G38.2 y-10 F[#4505]
		G90
		IF [#5067 == 1]				; Wenn Sensor gefunden wurde
			G92 y#4553
			G91 G00 y-1 
			G90
		ENDIF
	ELSE
		DlgMsg "FEHLER: Kein Sensor gefunden - Messung abgebrochen"
	ENDIF 
	#4550 = 0
ENDIF 
;---- Y-Minus-----------------------------------------------------------------------------------
IF [#4550 == 4]
	G91 G38.2 y-20 F[#4504]
	G90
	IF [#5067 == 1]					; Wenn Sensor gefunden wurde
	    G91 G38.2 y10 F[#4505]
		G90
		IF [#5067 == 1]				; Wenn Sensor gefunden wurde
			G92 y#4554
			G91 G00 y1 
			G90
		ENDIF
	ELSE
		DlgMsg "FEHLER: Kein Sensor gefunden - Messung abgebrochen"
	ENDIF 
	#4550 = 0
ENDIF
ENDSUB

;***************************************************************************************
Sub user_9
;---------------------------------------------------------------------------------------
   	msg "sub user_9"
	DlgMsg "Keine Funktion hinterlegt"
Endsub

;***************************************************************************************
Sub user_10
;---------------------------------------------------------------------------------------
  	DlgMsg "Soll Maschinennullpunkt angefahren werden?"
	if [#5398 == 1] ;OK
	   	G53 G0 Z0
	    	G53 X0 Y0
	ENDIF
Endsub

;***************************************************************************************
Sub home_z ;Homing per axis
;---------------------------------------------------------------------------------------
    msg "Referenziere Achse Z"
    M80
    g4p0.2
    home z
Endsub
;***************************************************************************************
Sub home_x
    msg "Referenziere Achse  X"
    M80
    g4p0.2
    home x
    ;homeTandem X
Endsub
;***************************************************************************************
Sub home_y
    msg "Referenziere Achse  Y"
    M80
    g4p0.2
    home y
    ;homeTandem Y
Endsub
;***************************************************************************************
Sub home_a
    msg "Referenziere  Achse A"
    M80
    g4p0.2
    home a
Endsub
;***************************************************************************************
Sub home_b
    msg "Referenziere  Achse  B"
    M80
    g4p0.2
    home b
Endsub
;***************************************************************************************
Sub home_c
    msg "Referenziere  Achse  C"
    M80
    g4p0.2
    home c
Endsub
;***************************************************************************************
;Home all axes
sub home_all
    gosub home_z
    gosub home_y
    gosub home_x
    gosub home_a
    gosub home_b
    gosub home_c

   ; G53 G01 X0 Y0 Z0 F1000; Achse X, Y und Z auf 0 Fahren    
    G53 G01 Z#4633 F2000			; Achse Z auf Sicherheitshoehe fahren
    G53 G01 X#4631 Y#4632 F2000			; Achse X und Y auf Sicherheitsposition fahren

    msg"Referenzierung fertig"	
    ;homeIsEstop on ;diese Zeile Einkommentieren wenn Refschalter = Endschalter  

    #3501 = 0					; INIT - Werkzeug noch nicht Vermessen
    #3504 = 0					; INIT - Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik

    m30
endsub

;***************************************************************************************
Sub zero_set_rotation
;---------------------------------------------------------------------------------------
    msg "Ersten Punkt antasten und mit STRG + G fortfahren"
	m0
	#5020 = #5071 ;x1
	#5021 = #5072 ;y1
    msg "Zweiten Punkt antasten und mit STRG + G fortfahren"
	m0
	#5022 = #5071 ;x2
	#5023 = #5072 ;y2
	#5024 = ATAN[#5023 - #5021]/[#5022 - #5020]
	if [#5024 > 45]
       #5024 = [#5024 - 90] ;Punkte in Y Achse
	endif
	g68 R#5024
	msg "Koordinatensystem mit G68 R"#5024" gedreht"
	msg "*** Bitte Messtaster entfernen!!! ***"
Endsub

;***************************************************************************************
sub change_tool
;---------------------------------------------------------------------------------------

    #5015 = 0						; Merker: Werkzeugwechsel noch nicht ausgeführt
    M5 M9						; Spindel AUS, Kühlung AUS

    IF [#5397 == 0]					; Render Modus AUS (0= Aus)

	;---------------------------------------------------------------------------------------
	; 0 = Wechsel ignorieren
	;---------------------------------------------------------------------------------------
	IF [[#4520] == 0] 			; Werkzeugwechslertyp  0= Wechsel ignorieren 1 = Nur WPos Anfahren 2= WPos anfahren  + Vermessen 
		#5015 = 1				; Wurde werkzeug erfolgreich gewechselt 1=Ja
	ENDIF

	;---------------------------------------------------------------------------------------
	; 1 = Nur WPos Anfahren
	;---------------------------------------------------------------------------------------
	IF [[#4520] == 1] 			; Werkzeugwechslertyp  0= Mache garnix 1 = Nur WPos Anfahren 2= WPos anfahren  + Vermessen 
		#3503 = 1				; Werkzeugnummer bereits eingelegt  1=Ja
		IF [[#5011] == [#5008]] THEN
			Dlgmsg "Werkzeug bereits eingelegt. Trotzdem wechseln?"
			IF [#5398 == 1] ;OK
				#3503 = 1
			ELSE
				#3503 = 0
			ENDIF
		ENDIF

		IF [#3503 == 1] THEN
			G53 G0 Z[#4523]			; Sicherheitshöhe
			G53 G0 X[#4521] Y[#4522]	; Werkzeugwechselpos X Y

			Dlgmsg "Bitte Werkzeug einwechseln" "Alte Werkzeugnr.:" 5008" Neue Werkzeugnr.:" 5011
			if [#5398 == 1] ;OK
				IF [#5011 > 99] THEN
					Dlgmsg "Werkzeugnr Ungültig: Bitte Werkzeugnummer 1..99 Auswählen"
					IF [#5398 == 1] ;OK
						gosub change_tool
					ELSE
						errmsg "Werkzeugwechsel abgebrochen"
					ENDIF
					
				ELSE
					#5015 = 1		; Werkzeugwechsel ausgeführt 1=Ja
				ENDIF
			ELSE
				errmsg "Werkzeugwechsel abgebrochen"
			ENDIF
	
		ENDIF
	ENDIF

	;---------------------------------------------------------------------------------------
	; 2= WPos anfahren  + Vermessen 
	;---------------------------------------------------------------------------------------
	IF [[#4520] == 2] 				; Werkzeugwechslertyp  0= Mache garnix 1 = Nur WPos Anfahren 2= WPos anfahren  + Vermessen 
		#3503 = 1					; Werkzeugnummer bereits eingelegt  1=Ja
		IF [[#5011] == [#5008]] THEN
			Dlgmsg "Werkzeug bereits eingelegt. Trotzdem wechseln?"
			IF [#5398 == 1] ;OK
				#3503 = 1
			ELSE
				#3503 = 0
			ENDIF
		ENDIF

		IF [#3503 == 1] THEN

			IF [[#5008 > 0] AND [#4529 == 1]]	; Aktuelle Werkzeugnummer grösser 0 und Bruchkontrolle aktiviert
				#3504 = 1			; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
				GOSUB user_3			; Bruchkontrolle aufrufen
				#3504 = 0			; Merker ob Bruchkontrolle von Automatik aufgerufen wurde 1=Automatik
			ELSE
				msg "Bruchkontrolle nicht ausgeführt"
			ENDIF

			G53 G0 Z[#4523]				; Sicherheitshöhe
			G53 G0 X[#4521] Y[#4522]		; Werkzeugwechselpos X Y

			Dlgmsg "Bitte Werkzeug einwechseln" "Alte Werkzeugnr.:" 5008 " Neue Werkzeugnr.:" 5011
			IF [#5398 == 1] ;OK
				IF [#5011 > 99]
					Dlgmsg "Werkzeugnr Ungültig: Bitte Werkzeugnummer 1..99 Auswählen" " Neue Werkzeugnr.:" 5011
					IF [#5398 == 1] ;OK
				 	    IF [#5011 > 99]
						errmsg "Werkzeugnr Ungültig -> Werkzeugwechsel abgebrochen"
					    ENDIF
					ELSE
					    errmsg "Werkzeugwechsel abgebrochen"
					ENDIF
				ENDIF

				#5015 = 1			; Werkzeugwechsel ausgeführt 1=Ja
			ELSE
			   	errmsg "Werkzeugwechsel abgebrochen" 
			ENDIF

		ENDIF
	ENDIF
	;---------------------------------------------------------------------------------------

	IF [[#5015] == 1] THEN   
		msg "Werkzeugnr.: " #5008" mit Werkzeugnr.: " #5011 " gewechselt"

	        M6 T[#5011]				; Neue Werkzeugnummer setzen

		IF [#4520 == 2] 			; Werkzeugwechslertyp  0= Mache garnix 1 = Nur WPos Anfahren 2= WPos anfahren  + Vermessen 
		    gosub user_2			; Werkzeuglängenmessung aufrufen  [ACHTUNG - Muss unbedingt nach M6 T.. gemacht werden]
		ENDIF

		#5015 = 0				; Werkzeugwechsel ausgeführt 1=Ja
	ENDIF
	;G01

    ENDIF						; Render Modus

endsub

;***************************************************************************************
sub config
;---------------------------------------------------------------------------------------
GoSub wzwp
GoSub znpp
GoSub wlmp
GoSub NL3D
GoSub SPWL
endsub

;***************************************************************************************
sub WZWP
;---------------------------------------------------------------------------------------
;0= Mache garnix 1 = Nur WPos Anfahren 2= WPos anfahren  + Vermessen
Dlgmsg "Bitte Werkzeugwechslertyp eingeben" "TYP" 4520  
if [#5398 == 1] ;OK
	IF [#4520 > 0 ] THEN
		Dlgmsg "Bitte Werkzeugwechselposition eingeben" "Position X-Achse" 4521 "Position Y-Achse" 4522 "Position Z-Achse" 4523
		
	ENDIF

ENDIF
endsub
;***************************************************************************************
sub ZNPP
;---------------------------------------------------------------------------------------
	Dlgmsg "Bitte Z-Nullpunktsensordaten eingeben" "TYP 0=Öffner, 1=schliesser" 4400 "Höhe Sensor" 4510 "Anfahrvorschub:" 4512 "Tastvorschub:" 4513
endsub

;***************************************************************************************
sub WLMP
;---------------------------------------------------------------------------------------
	Dlgmsg "Position nach Referenzfahrt" "Position nach Referenz X:" 4631 "Position nach Referenz Y:" 4632 "Position nach Referenz Z:" 4633
	Dlgmsg "Bitte Werkzeuglängensensordaten eingeben" "Position X-Achse" 4507 "Position Y-Achse" 4508 "Sicherheitshöhe Z" 4506 "SP. ohne Werkzeug" 4509 "Max. Werkzeuglänge" 4503 "Anfahrvorschub:" 4504 "Tastvorschub:" 4505
	Dlgmsg "Daten Bruchkontrolle" "Bruchkontrolle aktivieren?" 4529 "Verschleisstoleranz +/- in mm:" 4528  
	Dlgmsg "Position nach Messung anfahren" "Funktion:" 4519 "Position X-Achse" 4524 "Position Y-Achse" 4525 

;#4519 Was tun nach Werkzeugvermessung: 
;0= vordefinierten Punkt anfahren
;1= Werkstücknullpunkt fahren 
;2= Werkzeugwechselpos anfahren
;3= Maschinennullpunkt anfahren
;4= Stehen bleiben
;#4524 Position X nach Längenmessung   
;#4525 Position Y nach Längenmessung
;#4526 Position Z nach Längenmessung
endsub
;***************************************************************************************
sub NL3D
;---------------------------------------------------------------------------------------
;   #4551 Nullpunktermittlung Versatz X+
;   #4552 Nullpunktermittlung Versatz X-
;   #4553 Nullpunktermittlung Versatz Y+
;   #4554 Nullpunktermittlung Versatz Y-
	Dlgmsg "Versatz 3D Taster.." "in Richtung X+" 4551 "in Richtung X-" 4552 "in Richtung Y+" 4553 "in Richtung Y-" 4554 
ENDSUB

;***************************************************************************************
sub SPWL
;---------------------------------------------------------------------------------------
;   #4532 Drehzahl Stufe 1 für Warmlauf Spindel
;   #4533 Laufzeit Stufe 1 für Warmlauf Spindel
;   #4534 Drehzahl Stufe 2 für Warmlauf Spindel
;   #4535 Laufzeit Stufe 2 für Warmlauf Spindel
;   #4536 Drehzahl Stufe 3 für Warmlauf Spindel
;   #4537 Laufzeit Stufe 3 für Warmlauf Spindel
;   #4538 Drehzahl Stufe 4 für Warmlauf Spindel
;   #4539 Laufzeit Stufe 4 für Warmlauf Spindel
	Dlgmsg "Spindelwarmlaufparameter" "Drehzahl Stufe 1" 4532 "Laufzeit (sek.) Stufe 1" 4533 "Drehzahl Stufe 2" 4534 "Laufzeit(sek.) Stufe 2" 4535 "Drehzahl Stufe 3" 4536 "Laufzeit (sek.) Stufe 3" 4537 "Drehzahl Stufe 4" 4538 "Laufzeit(sek.) Stufe 4" 4539
ENDSUB


;***************************************************************************************
sub zhcmgrid
;***************************************************************************************
;probe scanning routine for eneven surface milling
;scanning starts at x=0, y=0

  if [#4100 == 0]
   #4100 = 10  ;nx
   #4101 = 5   ;ny
   #4102 = 40  ;max z 
   #4103 = 10  ;min z 
   #4104 = 1.0 ;step size
   #4105 = 100 ;probing feed
  endif    

  #110 = 0    ;Actual nx
  #111 = 0    ;Actual ny
  #112 = 0    ;Missed measurements counter
  #113 = 0    ;Number of points added

  ;Dialog
  dlgmsg "gridMeas" "nx" 4100 "ny" 4101 "maxZ" 4102 "minZ" 4103 "gridSize" 4104 "Feed" 4105 
    
  if [#5398 == 1] ; user pressed OK
    ;Move to startpoint
    g0 z[#4102];to upper Z
    g0 x0 y0 ;to start point
        
    ;ZHCINIT gridSize nx ny
    ZHCINIT [#4104] [#4100] [#4101] 
    
    #111 = 0    ;Actual ny value
    while [#111 < #4101]
      #110 = 0
      while [#110 < #4100]
        ;Go up, goto xy, measure
        g0 z[#4102];to upper Z
        g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
        g38.2 F[#4105] z[#4103];probe down until touch
                
        ;Add point to internal table if probe has touched
        if [#5067 == 1]
          ZHCADDPOINT
          msg "nx="[#110 +1]" ny="[#111+1]" added"
          #113 = [#113+1]
        else
          ;ZHCADDPOINT
          msg "nx="[#110 +1]" ny="[#111+1]" not added"
          #112 = [#112+1]
        endif

        #110 = [#110 + 1] ;next nx
      endwhile
      #111 = [#111 + 1] ;next ny
    endwhile
        
    g0 z[#4102];to upper Z
    ;Save measured table
    ZHCS zHeightCompTable.txt
    msg "Done, "#113" points added, "#112" not added" 
        
  else
    ;user pressed cancel in dialog
    msg "Operation canceled"
  endif
endsub

;***************************************************************************************
; Handradfunktionen
;---------------------------------------------------------------------------------------
;***************************************************************************************
 SUB xhc_probe_z ;Z-Nullpunktermittlung
;---------------------------------------------------------------------------------------
	#3505 = 1					; Merker ob Längenmessung von Handrad 1=Handrad
	gosub user_1 ;Z-Nullpunktermittlung
ENDSUB

;***************************************************************************************
SUB xhc_macro_1
;---------------------------------------------------------------------------------------
	msg"Keine Funktion für Macro 1 Hinterlegt"
ENDSUB

;***************************************************************************************
SUB xhc_macro_2
;---------------------------------------------------------------------------------------
	gosub user_2 ;Werkzeugvermessung
ENDSUB
;***************************************************************************************
SUB xhc_macro_3
;---------------------------------------------------------------------------------------
	msg"Keine Funktion für Macro 3 Hinterlegt"
ENDSUB
;***************************************************************************************
SUB xhc_macro_6
;---------------------------------------------------------------------------------------
	msg"Keine Funktion für Macro 6 Hinterlegt"
ENDSUB
;***************************************************************************************
SUB xhc_macro_7
;---------------------------------------------------------------------------------------
	msg"Keine Funktion für Macro 7 Hinterlegt"
ENDSUB
;***************************************************************************************
sub zhcmgrid ; Oberflaeche abtasten
          ;probe scanning routine for eneven surface milling
;---------------------------------------------------------------------------------------

;scanning starts at x=0, y=0

  if [#4100 == 0]
   #4100 = 10  ;nx
   #4101 = 5   ;ny
   #4102 = 40  ;max z 
   #4103 = 10  ;min z 
   #4104 = 1.0 ;step size
   #4105 = 100 ;probing feed
  endif    

  #110 = 0    ;Actual nx
  #111 = 0    ;Actual ny
  #112 = 0    ;Missed measurements counter
  #113 = 0    ;Number of points added
  #114 = 1    ;0: odd x row, 1: even xrow

  ;Dialog
  dlgmsg "gridMeas" "nx" 4100 "ny" 4101 "maxZ" 4102 "minZ" 4103 "gridSize" 4104 "Feed" 4105 
    
  if [#5398 == 1] ; user pressed OK
    ;Move to startpoint
    g0 z[#4102];to upper Z
    g0 x0 y0 ;to start point
        
    ;ZHCINIT gridSize nx ny
    ZHCINIT [#4104] [#4100] [#4101] 
    
    #111 = 0    ;Actual ny value
    while [#111 < #4101]
        if [#114 == 1]
          ;even x row, go from 0 to nx
          #110 = 0 ;start nx
          while [#110 < #4100]
            ;Go up, goto xy, measure
            g0 z[#4102];to upper Z
            g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
            g38.2 F[#4105] z[#4103];probe down until touch
                    
            ;Add point to internal table if probe has touched
            if [#5067 == 1]
              ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" added"
              #113 = [#113+1]
            else
              ;ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" not added"
              #112 = [#112+1]
            endif

            #110 = [#110 + 1] ;next nx
          endwhile
          #114=0
        else
          ;odd x row, go from nx to 0
          #110 = [#4100 - 1] ;start nx
          while [#110 > -1]
            ;Go up, goto xy, measure
            g0 z[#4102];to upper Z
            g0 x[#110 * #4104] y[#111 * #4104] ;to new scan point
            g38.2 F[#4105] z[#4103];probe down until touch
                    
            ;Add point to internal table if probe has touched
            if [#5067 == 1]
              ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" added"
              #113 = [#113+1]
            else
              ;ZHCADDPOINT
              msg "nx="[#110 +1]" ny="[#111+1]" not added"
              #112 = [#112+1]
            endif

            #110 = [#110 - 1] ;next nx
          endwhile
          #114=1
        endif
	  
      #111 = [#111 + 1] ;next ny
    endwhile
        
    g0 z[#4102];to upper Z
    ;Save measured table
    ZHCS zHeightCompTable.txt
    msg "Done, "#113" points added, "#112" not added" 
        
  else
    ;user pressed cancel in dialog
    msg "Operation canceled"
  endif
endsub

