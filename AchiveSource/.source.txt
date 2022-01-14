//=====================================================================================================================
// Metamorphosis
// By Prince / Phaze101
// 
// Using Kick Assembler
//=====================================================================================================================

// Info:
// Screen           - $C800 (51200)
// Charset          - $C000 (49152)
// Color Attributes - $2800 (10240)
// TilesSet         - $2900 (10496)
// Map Date         - $3400 (13312)

//=====================================================================================================================
// Variables in Page Zero
//=====================================================================================================================

* = $02 "zero Page Constants" virtual

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

}

//=====================================================================================================================
// Constants
//=====================================================================================================================

.label SCREEN_RAM					= 	$C800			// Base Address Screen

.const ScreensLayoutMapStructLength	=	7				// ScreenLayoutMapTable Structure Length 

//=====================================================================================================================
// BASIC startup - SYS to Entry
//=====================================================================================================================

BasicUpstart2(Entry)

	// To know where Code Starts
	* = * "*** Code Starts ***"

//=====================================================================================================================
// Import maploader.asm
//=====================================================================================================================

#import "MapLoader.asm"

//=====================================================================================================================
// The main entry routine
//=====================================================================================================================

Entry: 
		//=============================================================================================================
		// Turn Interrupts off - Clear all interrtups
		//=============================================================================================================
		sei
		lda #$7f
		sta $dc0d		// 56333
		sta $dd0d		// 56589

		//=============================================================================================================
		// Switch Basic and Kernal off
		//=============================================================================================================
		lda #%00110101	// $35 - Bit 0-2 - RAM visible at $A000-$BFFF and $E000-$FFFF, I/O area visible at $D000-$DFFF
		sta $01
		cli

		//=============================================================================================================
		// Set VicII Bank to 3 - $C000 (49152)
		//=============================================================================================================
		lda $dd00
		and #%11111100
		sta $dd00

		//=============================================================================================================
		// Same Screen Ram $0800, Char Mem $0000
		// Remember that you need to add Vic2 bank value of $C000 to the above values
		//=============================================================================================================
		lda #%00100000
		sta $d018

		//=============================================================================================================
		// Set the Black Border
		//=============================================================================================================
		lda #$00
		sta $d020

		//=============================================================================================================
		// Set Background, Multi 1, Multi 2
		//=============================================================================================================
		lda #$00
		sta $d021
		lda #$0b		
		sta $d022
		lda #$09		
		sta $d023

		//=============================================================================================================
		// Setting Multi Colour Mode On
		//=============================================================================================================
		lda $d016
		ora #%00010000
		sta $d016

		jsr ClearScreen

		//=============================================================================================================
		// Pass X and Y starting position of Screen
		// Screen is part of multiple screens found in the Map
		// It also means that we can draw a screen starting at any position in the map
		//=============================================================================================================
//		ldx #20
//		ldy #99

		jsr InitScreen
		ldx ScreenX
		ldy ScreenY
		jsr MAPLOADER.DrawMap

	!Loop:
		jmp !Loop-

	* = * "*** Code End ***"

//=====================================================================================================================
// Clear Screen - Clears 1024 so it clears Sprites
//=====================================================================================================================

ClearScreen: {
		lda #$00
		ldx #250
	!:
		sta SCREEN_RAM-1, x
		sta SCREEN_RAM + 250-1, x
		sta SCREEN_RAM + 500-1, x
		sta SCREEN_RAM + 750-1, x
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
		cpy #ScreensLayoutMapStructLength
		bne LoopX 
		rts
}



//=====================================================================================================================
// Data Sections
// Only the Character Set needs to be in Chipmem
//=====================================================================================================================

* = $C000 "Character Set"
	.import binary "maps/Metamorphosis/chars.bin"		// Chars Redefined 

* = $2800 "Colour Attributes"
	.import binary "maps/Metamorphosis/cols.bin" 		// Colour Data

* = $2900 "TileSet Data"
	.import binary "maps/Metamorphosis/tiles.bin" 		// Tile Data

* = $3400 "Map Data"
MapData:
	.import binary "maps/Metamorphosis/map.bin" 		// Map Data

// How the screen are all connected together
// Screen No
// Y Position
// X Position
// Top screen connected to it
// Bottom screen connected to it
// Left Screen adjacent to it
// Right screen adjacent to it
* = $6000 "Screen Table"								// How the screen are connected together

ScreensLayoutMapTable:
	//   Scr  Y   X   T   B   L   R
//	.byte 1, 99, 20, 06, 00, 00, 02
	.byte 01, 88, 00, 06, 00, 00, 02
	.byte 02, 88, 20, 07, 00, 01, 03
	.byte 03, 88, 40, 08, 00, 02, 04
	.byte 04, 88, 60, 09, 00, 03, 05
	.byte 05, 88, 80, 10, 00, 04, 00

	.byte 06, 77, 00, 11, 01, 00, 07
	.byte 07, 77, 20, 12, 02, 06, 08
	.byte 08, 77, 40, 13, 03, 07, 09
	.byte 09, 77, 60, 14, 04, 08, 10
	.byte 10, 77, 80, 15, 05, 09, 00

	.byte 11, 66, 00, 16, 06, 00, 12
	.byte 12, 66, 20, 17, 07, 11, 13
	.byte 13, 66, 40, 18, 08, 12, 14
	.byte 14, 66, 60, 19, 09, 13, 15
	.byte 15, 66, 80, 20, 10, 14, 00

	.byte 16, 55, 00, 21, 11, 00, 17
	.byte 17, 55, 20, 22, 12, 16, 18
	.byte 18, 55, 40, 23, 13, 17, 19
	.byte 19, 55, 60, 24, 14, 18, 20
	.byte 20, 55, 80, 25, 15, 19, 00

	.byte 21, 44, 00, 26, 16, 00, 22
	.byte 22, 44, 20, 27, 17, 21, 23
	.byte 23, 44, 40, 28, 18, 22, 24
	.byte 24, 44, 60, 29, 19, 23, 25
	.byte 25, 44, 80, 30, 20, 24, 00

	.byte 26, 33, 00, 31, 21, 00, 27
	.byte 27, 33, 20, 32, 22, 26, 28
	.byte 28, 33, 40, 33, 23, 27, 29
	.byte 29, 33, 60, 34, 24, 28, 30
	.byte 30, 33, 80, 35, 25, 29, 00

	.byte 31, 22, 00, 36, 26, 00, 32
	.byte 32, 22, 20, 37, 27, 31, 33
	.byte 33, 22, 40, 38, 28, 32, 34
	.byte 34, 22, 60, 39, 29, 33, 35
	.byte 35, 22, 80, 40, 30, 34, 00

	.byte 36, 11, 00, 41, 31, 00, 37
	.byte 37, 11, 20, 42, 32, 36, 38
	.byte 38, 11, 40, 43, 33, 37, 39
	.byte 39, 11, 60, 44, 34, 38, 40
	.byte 40, 11, 80, 45, 35, 39, 00

	.byte 41, 00, 00, 00, 36, 00, 42
	.byte 42, 00, 20, 00, 37, 41, 43
	.byte 43, 00, 40, 00, 38, 42, 44
	.byte 44, 00, 60, 00, 39, 43, 45
	.byte 45, 00, 80, 00, 40, 44, 00
