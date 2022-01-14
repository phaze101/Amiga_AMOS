//=====================================================================================================================
// Routines related to screen handling
//=====================================================================================================================

#importonce

//=====================================================================================================================
// Wait Raster
//=====================================================================================================================
WaitRaster: {
		lda $d012
		cmp	#226
		bne	WaitRaster
	f2:
		lda $d012
		cmp	#225
		bne	f2

	f3:
		lda $d012
		cmp	#224
		bne	f3

	f4:
		lda $d012
		cmp	#223
		bne	f4

	f5:
		lda $d012
		cmp	#222
		bne	f5

	f6:
		lda $d012
		cmp	#221
		bne	f6

	f7:
		lda $d012
		cmp	#220
		bne	f7

	f8:
		lda $d012
		cmp	#219
		bne	f8

	f9:
		lda $d012
		cmp	#218
		bne	f9

	// fa:
	// 	lda $d012
	// 	cmp	#217
	// 	bne	fa

	// fb:
	// 	lda $d012
	// 	cmp	#216
	// 	bne	fb

	// fc:
	// 	lda $d012
	// 	cmp	#215
	// 	bne	fc

	// fd:
	// 	lda $d012
	// 	cmp	#214
	// 	bne	fd

	// fe:
	// 	lda $d012
	// 	cmp	#213
	// 	bne	fe

	// ff:
	// 	lda $d012
	// 	cmp	#212
	// 	bne	ff
		rts
}

//=====================================================================================================================
// Clear Screen - Clears 1024 so it clears Sprites
//=====================================================================================================================

ClearScreen: {
		ldx #250
	!:
		lda #$0a
		sta SCREEN_RAM-1, x
		sta SCREEN_RAM + 250-1, x
		sta SCREEN_RAM + 500-1, x
		sta SCREEN_RAM + 750-1, x
		lda #$01
		sta $d800-1, x
		sta $d800 + 250-1, x
		sta $d800 + 500-1, x
		sta $d800 + 750-1, x
		dex
		bne !-
		rts
}

//=====================================================================================================================
// Read Current Screen Position
//=====================================================================================================================

InitScreen: {  
		lda	#<ScreensLayoutMapTable
		sta $fb
		lda	#>ScreensLayoutMapTable
		sta $fc

		ldy #$00
	LoopX:
		lda ($fb),y
		sta ScreenNo,y
		iny
		cpy #StructSize
		bne LoopX 
		rts
}

//=====================================================================================================================
// View all Screens
//=====================================================================================================================

ViewAllScreen: {
		lda #01				// Screen 00 is our start screen not screen 1
		sta result2_hi

	Loop:
		jsr CalcScreen

		jsr WaitForSpace

		inc result2_hi
		lda result2_hi
		cmp #46
		bne Loop

		rts

}

//=====================================================================================================================
// Calculate which screen should be displayed
// A = ScreenNumber
//=====================================================================================================================

CalcScreen: {
		// Based on screen Number where we need to move in the Screen Structure Table
		// Multiply the Screen Number that we need by 7 (size of scrtucture)

		sta Num1_lo
		dec Num1_lo					// Decrement the screen number by 1 since we start from screen 0 not from screen 1

		lda #StructSize
		sta Num2_lo
		jsr Mult8Bit_8Bit			// Stores 16 bit result in A(High byte) + X( Low Byte)
		stx $fd
		sta	$fe

		// Load the Table Screen Structure Pointers
		lda	#<ScreensLayoutMapTable
		sta $fb
		lda	#>ScreensLayoutMapTable
		sta $fc

		// Calculate Which Screen Structure We need
		clc
		lda $fd
		adc	$fb
		sta $fb						// Used Below

		lda $fe
		adc $fc
		sta $fc						// Used Below

		// Store the Table Structure values for the Current Screen in Zero Page
		// $FB and $FC Point to the Table Screen Structure  
		ldy #$00
	LoopX:
		lda ($fb),y
		sta ScreenNo,y
		iny
		cpy #StructSize
		bne LoopX 

		// Update the colours
		lda Col1
		sta $d021
		lda Col2		
		sta $d022
		lda Col3		
		sta $d023
		lda Col4
		sta $d024

		// Display the Screen From the Map
		ldx ScreenX
		ldy ScreenY
		jsr MapLoader.DrawMap

		// Display Debug Info
		jsr DebugInfo

		rts
}

//=====================================================================================================================
// Calculate which screen should be displayed
// A = ScreenNumber
// Save the Colours
//=====================================================================================================================

SaveScreenColours: {
		// Based on screen Number where we need to move in the Screen Structure Table
		// Multiply the Screen Number that we need by 7 (size of scrtucture)

		sta Num1_lo
		dec Num1_lo					// Decrement the screen number by 1 since we start from screen 0 not from screen 1

		lda #StructSize
		sta Num2_lo
		jsr Mult8Bit_8Bit			// Stores 16 bit result in A(High byte) + X( Low Byte)
		stx $fd
		sta	$fe

		// Load the Table Screen Structure Pointers
		lda	#<ScreensLayoutMapTable
		sta $fb
		lda	#>ScreensLayoutMapTable
		sta $fc

		// Calculate Which Screen Structure We need
		clc
		lda $fd
		adc	$fb
		sta $fb						// Used Below

		lda $fe
		adc $fc
		sta $fc						// Used Below

		// Store the Table Structure values for the Current Screen in Zero Page
		// $FB and $FC Point to the Table Screen Structure  
		ldy #$07					// Variable Col1 start at position 7
	LoopX:
		lda ScreenNo,y
		sta ($fb),y
		iny
		cpy #StructSize
		bne LoopX 

		rts
}