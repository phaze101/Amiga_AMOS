//=====================================================================================================================
// Variables in Page Zero
//=====================================================================================================================

* = $02 "Zero Page Constants" virtual

.zp {
	MultiplyNum1:
		.byte $00				// Multiplication Num1

	MultiplyNum2:
		.byte $00				// Multiplication Num2

	MultiplyNum1Hi:				
		.byte $00				// Multiplication Result in MultiplyNum1 (Lo), MultiplyNum1 (Hi) 

	MapLoaderTileLookup:
		.word $0000				// Contains address of our Tile where it is

	MapLoaderMapLookup:			// This is where our Map Tiles begin
		.word $0000

	MapLoaderColumn:			// The Column we are in from the Map 
		.byte $00

	MapLoaderRow:				// The Row we are in from the Map 
		.byte $00
	
	ScreenNo:					// Current Screen No
		.byte $00

	ScreenY:					// Current Screen Y
		.byte $00

	ScreenX:					// Current Screen X
		.byte $00

	ScreenTop:					// Screen on Top of Current
		.byte $00

	ScreenBelow:				// Screen Below Current
		.byte $00

	ScreenLeft:					// Screen to the left of Current
		.byte $00

	ScreenRight:				// Screen to the right of Current
		.byte $00

	Col1:						// Current Colour 1
		.byte $00

	Col2:						// Current Colour 2
		.byte $00

	Col3:						// Current Colour 3
		.byte $00

	Col4:						// Current Colour 4
		.byte $00

}

//=====================================================================================================================
// Div32 Div 16 convert Hex to Decimal Variables
//=====================================================================================================================

* = $40 "Div16Div32Convert" virtual

.zp {
	// 16 bit number 01 to be divided by 10 or 32 bit number combined with 02
	Num1_lo:
        .byte    $00
	Num1_hi:
        .byte    $00

	// 16 bit number 02 to be divided by 10 or 32 bit number combined with 01
	Num2_lo:
        .byte    $00
	Num2_hi:
        .byte    $00

	// 16 bit number result 01 or 32 bit number combined with 02
	result1_lo:
        .byte    $00
	result1_hi:
        .byte    $00

	// 16 bit number result 02 or 32 bit number combined with 01
	result2_lo:
        .byte    $00
	result2_hi:
        .byte    $00
}

