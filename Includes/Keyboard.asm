//=====================================================================================================================
// Scroll Through Screens
//=====================================================================================================================

	* = * "WASD Keyboard Start"

//=====================================================================================================================
// Keyboard Constants
//=====================================================================================================================

.const pra  =  $dc00				// CIA#1 (Port Register A)
.const prb  =  $dc01				// CIA#1 (Port Register B)

.const ddra =  $dc02				// CIA#1 (Data Direction Register A)
.const ddrb =  $dc03				// CIA#1 (Data Direction Register B)

//=====================================================================================================================
// Initialise the Keyboard
// Needs to be called before Game Loop
//=====================================================================================================================

InitKeyboard: {
		lda #%11111111				// CIA#1 Port A set to output 
		sta ddra             

		lda #%00000000  			// CIA#1 Port B set to inputt
		sta ddrb   
		rts
}

//=====================================================================================================================
// Wait for Space bar to be pressed
// Keyboard - A bit set to 1 means not pressed, a bit set to 0 means pressed
//=====================================================================================================================

WaitForSpace: {
        lda #%11111111
        sta $dc02
        lda #%00000000
        sta $dc03

        lda #$7f    					// %01111111 - only row 7 KB matrix
        sta $dc00

	// Key Pressed ?
	WaitLoop1:
        lda $dc01
        and #$10 						// mask %00010000 - Space
        bne WaitLoop1					// Loop if Key still not pressed - Bit is 1

	// Make sure key is released
	WaitLoop2:
        lda  $dc01
        and  #$10						// mask %00010000 - Space
        beq  WaitLoop2					// Loop if Key Still pressed - Bit is 0

        rts
}

//=====================================================================================================================
// Debug Panel
//=====================================================================================================================

DebugPanel:	{
		jsr	Keyboard_WASD			// Changes Screen
		jsr	Keyboard_1234			// changes Colour
		rts
}

//=====================================================================================================================
// Check for a single key presses
// Check for keyboard keys
//                                     W
//                                    ASD
//=====================================================================================================================

Keyboard_WASD: {             
	// Key A - Left Pressed
		lda #%11111101  			// $FE - Select row 2
		sta pra 
	check_a:
		lda prb         			// load column information
		and #%00000100  			// test 'a' key  
		beq go_left
	
	// Key D - Right Pressed
		lda #%11111011  			// select row 3
		sta pra 
	check_d:
		lda prb         			// load column information
		and #%00000100  			// test 'd' key 
		beq go_right

	// Key S - Down Pressed
		lda #%11111101  			// select row 2
		sta pra 
	check_s:
		lda prb         			// load column information
		and #%00100000  			// test 's' key  
		beq go_down

	// Key W - Up Pressed
		lda #%11111101  			// select row 2
		sta pra 
	check_w:
		lda prb         			// load column information
		and #%00000010  			// test 'w' key 
		beq go_up

		rts

	go_left:
		lda ScreenLeft
		bne DoCalcScreen
		rts

	go_right:
		lda ScreenRight
		bne DoCalcScreen
		rts

	go_up:
		lda ScreenTop
		bne DoCalcScreen
		rts

	go_down:
		lda ScreenBelow
		beq Exit

	DoCalcScreen:
		jsr CalcScreen

	Exit:
		rts
}

//=====================================================================================================================
// Check for a single key presses
// Check for keyboard keys 1234 + RB
//=====================================================================================================================

Keyboard_1234: {             
	// Key 1 - Down Pressed
		lda #%01111111  			// select row 8
		sta pra 
	check_1:
		lda prb         			// load column information
		and #%00000001  			// test '1' key  
		beq go_1

	// Key 2 - Down Pressed
		lda #%01111111  			// select row 8
		sta pra 
	check_2:
		lda prb         			// load column information
		and #%00001000  			// test '2' key  
		beq go_2

	// Key 3 - Down Pressed
		lda #%11111101  			// select row 2
		sta pra 
	check_3:
		lda prb         			// load column information
		and #%00000001  			// test '3' key  
		beq go_3

	// Key 4 - Down Pressed
		lda #%11111101  			// select row 2
		sta pra 
	check_4:
		lda prb         			// load column information
		and #%00001000  			// test '4' key  
		beq go_4

	// Key R - Down Pressed
		lda #%11111011  			// select row 3
		sta pra 
	check_r:
		lda prb         			// load column information
		and #%00000010  			// test 'r' key  
		beq go_r


	// Key B - Down Pressed
		lda #%11110111  			// select row 4
		sta pra 
	check_b:
		lda prb         			// load column information
		and #%00010000  			// test 'b' key  
		beq go_b


		rts

	go_1:
		inc Col1
		lda Col1
		and #$0f
		sta Col1
		jmp UpdateCols

	go_2:
		inc Col2
		lda Col2
		and #$0f
		sta Col2
		jmp UpdateCols

	go_3:
		inc Col3
		lda Col3
		and #$0f
		sta Col3
		jmp UpdateCols

	go_4:
		inc Col4
		lda Col4
		and #$0f
		sta Col4
		jmp UpdateCols

	go_r:
		jmp ResetCols

	go_b:
		jmp BWCols


}

//=====================================================================================================================
// Update Screen Colours
//=====================================================================================================================

UpdateCols: {             
		lda Col1
		sta $d021
		lda Col2		
		sta $d022
		lda Col3		
		sta $d023
		lda Col4
		sta $d024
		lda ScreenNo
		jsr SaveScreenColours
		jsr DebugInfo
		rts
}

//=====================================================================================================================
// Reset Screen Colours
//=====================================================================================================================

ResetCols: {             
		lda #$00
		sta $d020

		lda	#$06
		sta $d021
		sta Col1

		lda #$0c		
		sta $d022
		sta Col2

		lda #$09		
		sta $d023
		sta Col3

		lda #$00
		sta $d024
		sta Col4

		lda ScreenNo
		jsr SaveScreenColours
		jsr DebugInfo
		rts
}

//=====================================================================================================================
// Reset Screen Colours
//=====================================================================================================================

BWCols: {             
		lda #$00
		sta $d020

		lda #12
		sta $d021
		sta Col1

		lda #15		
		sta $d022
		sta Col2

		lda #11		
		sta $d023
		sta Col3

		lda #$00
		sta $d024
		sta Col4

		lda ScreenNo
		jsr SaveScreenColours
		jsr DebugInfo
		rts
}

