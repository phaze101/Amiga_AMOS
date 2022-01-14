//=====================================================================================================================
// Metamorphosis
// By Prince / Phaze101
// 
// Using Kick Assembler
//=====================================================================================================================

// Data Memory Map
// Music				- $7000 (28672)
// Screen Structure		- $9200 (37376)
// TilesSet         	- $9400 (37888)
// Color Attributes 	- $9800 (38192)
// Map Date         	- $9900 (39168)
// Charset          	- $C000 (49152)
// Screen           	- $C800 (51200)
// Sprite Attributes	- $cc00 (52224)
// Sprites          	- $d000 (53248)

//=====================================================================================================================
// Constants
//=====================================================================================================================

.const SCREEN_RAM					= 	$C800			// Base Address Screen

.const StructSize					= End_ScreensLayoutMapTable - ScreensLayoutMapTable		// Structure Size

//=====================================================================================================================
// Setup Zero Page Variables
//=====================================================================================================================

#import "Includes/ZeroPageVariables.asm"

//=====================================================================================================================
// BASIC startup - SYS to Entry
//=====================================================================================================================

BasicUpstart2(Entry)

//=====================================================================================================================
// Game Code Starts Here
//=====================================================================================================================

Entry: 
	* = * "*** Code Start ***"

	jmp GameStart

//=====================================================================================================================
// Imports
//=====================================================================================================================

#import "Includes/MathsConversions.asm"
#import "Includes/MapLoader.asm" 
#import "Includes/DebugInfo.asm" 
#import "Includes/Joystick.asm" 
#import "Includes/ScreenRoutines.asm" 
#import "Includes/Keyboard.asm" 
#import "Includes/Player.asm" 

//=====================================================================================================================
// Game Code Starts Here
//=====================================================================================================================

GameStart: 
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
		lda #$07
		sta $d021
		lda #$0c		
		sta $d022
		lda #$09		
		sta $d023
		lda #$01
		sta $d024

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

		jsr InitKeyboard
		jsr InitScreen

//		ldx ScreenX
//		ldy ScreenY
//		jsr MapLoader.DrawMap

		lda ScreenNo
		jsr CalcScreen
		jsr DebugInfo
		jsr InitPlayer

	!Loop:
		jsr WaitRaster
//		jsr	PlayerJoyControl
//		jsr ViewAllScreen
		jsr DebugPanel
		jmp !Loop-

//=====================================================================================================================
// End of Code
//=====================================================================================================================

//=====================================================================================================================
// Game Data Sections
// Only the Character Set needs to be in Chipmem
//=====================================================================================================================

//---------------------------------------------------------------------------------------------------------------------
// Screen Layout Map Table Structure
// How the screens are all connected together
// Scr - Screen No
// Y - Y Position
// X - X Position
// T - Top screen connected to it
// B - Bottom screen connected to it
// L - Left Screen adjacent to it
// R - Right screen adjacent to it

//* = $6000 "Screen Table"								// How the screen are connected together
* = $9200 "Screen Table"								// How the screen are connected together

ScreensLayoutMapTable:
		//   Scr  Y   X   T   B   L   R   C1  C2  C3  C4
		.byte 01, 88, 00, 06, 00, 00, 02, 06, 12, 09, 11
End_ScreensLayoutMapTable:
		.byte 02, 88, 20, 07, 00, 01, 03, 06, 12, 09, 11
		.byte 03, 88, 40, 08, 00, 02, 04, 06, 12, 09, 11
		.byte 04, 88, 60, 09, 00, 03, 05, 06, 12, 09, 11
		.byte 05, 88, 80, 10, 00, 04, 00, 06, 12, 09, 11

		.byte 06, 77, 00, 11, 01, 00, 07, 06, 12, 09, 11
		.byte 07, 77, 20, 12, 02, 06, 08, 06, 12, 09, 11
		.byte 08, 77, 40, 13, 03, 07, 09, 06, 12, 09, 11
		.byte 09, 77, 60, 14, 04, 08, 10, 06, 12, 09, 11
		.byte 10, 77, 80, 15, 05, 09, 00, 06, 12, 09, 11

		.byte 11, 66, 00, 16, 06, 00, 12, 06, 12, 09, 11
		.byte 12, 66, 20, 17, 07, 11, 13, 06, 12, 09, 11
		.byte 13, 66, 40, 18, 08, 12, 14, 06, 12, 09, 11
		.byte 14, 66, 60, 19, 09, 13, 15, 06, 12, 09, 11
		.byte 15, 66, 80, 20, 10, 14, 00, 06, 12, 09, 11

		.byte 16, 55, 00, 21, 11, 00, 17, 06, 12, 09, 11
		.byte 17, 55, 20, 22, 12, 16, 18, 06, 12, 09, 11
		.byte 18, 55, 40, 23, 13, 17, 19, 06, 12, 09, 11
		.byte 19, 55, 60, 24, 14, 18, 20, 06, 12, 09, 11
		.byte 20, 55, 80, 25, 15, 19, 00, 06, 12, 09, 11

		.byte 21, 44, 00, 26, 16, 00, 22, 06, 12, 09, 11
		.byte 22, 44, 20, 27, 17, 21, 23, 06, 12, 09, 11
		.byte 23, 44, 40, 28, 18, 22, 24, 06, 12, 09, 11
		.byte 24, 44, 60, 29, 19, 23, 25, 06, 12, 09, 11
		.byte 25, 44, 80, 30, 20, 24, 00, 06, 12, 09, 11

		.byte 26, 33, 00, 31, 21, 00, 27, 06, 12, 09, 11
		.byte 27, 33, 20, 32, 22, 26, 28, 06, 12, 09, 11
		.byte 28, 33, 40, 33, 23, 27, 29, 06, 12, 09, 11
		.byte 29, 33, 60, 34, 24, 28, 30, 06, 12, 09, 11
		.byte 30, 33, 80, 35, 25, 29, 00, 06, 12, 09, 11

		.byte 31, 22, 00, 36, 26, 00, 32, 06, 12, 09, 11
		.byte 32, 22, 20, 37, 27, 31, 33, 06, 12, 09, 11
		.byte 33, 22, 40, 38, 28, 32, 34, 06, 12, 09, 11
		.byte 34, 22, 60, 39, 29, 33, 35, 06, 12, 09, 11
		.byte 35, 22, 80, 40, 30, 34, 00, 06, 12, 09, 11

		.byte 36, 11, 00, 41, 31, 00, 37, 06, 12, 09, 11
		.byte 37, 11, 20, 42, 32, 36, 38, 06, 12, 09, 11
		.byte 38, 11, 40, 43, 33, 37, 39, 06, 12, 09, 11
		.byte 39, 11, 60, 44, 34, 38, 40, 06, 12, 09, 11
		.byte 40, 11, 80, 45, 35, 39, 00, 06, 12, 09, 11

		.byte 41, 00, 00, 00, 36, 00, 42, 06, 12, 09, 11
		.byte 42, 00, 20, 00, 37, 41, 43, 06, 12, 09, 11
		.byte 43, 00, 40, 00, 38, 42, 44, 06, 12, 09, 11
		.byte 44, 00, 60, 00, 39, 43, 45, 06, 12, 09, 11
		.byte 45, 00, 80, 00, 40, 44, 00, 06, 12, 09, 11

//---------------------------------------------------------------------------------------------------------------------
// Tileset Set

*	=	$9400 "TileSet Data"

TileSet:
		.import binary "gfx/map33/tiles.bin" 				// 1024 Bytes ($0400)

//---------------------------------------------------------------------------------------------------------------------
// Character Set Attributes

*	=	$9800 "Colour Attributes"

CharAttributes:
		.import	binary "gfx/map33/charattribs.bin" 		// 256 Bytes ($100)

//---------------------------------------------------------------------------------------------------------------------
// Map Data

*	=	$9900 "Map Data"

MapData:
		.import binary "gfx/map33/map.bin" 				// 9900 Bytes ($26AC)

//---------------------------------------------------------------------------------------------------------------------
// Character Set - Chipmen starts at $C000
// Chipmen is Where VIC shares memory with CPU and all GFX are

* 	= 	$C000 "Character Set"

CharSet:
		.import	binary "gfx/map33/chars.bin"				// 2048 Bytes ($0800)

//---------------------------------------------------------------------------------------------------------------------
// Sprites attributes @ $cc00 - Chipmen starts at $C000
// Chipmen is Where VIC shares memory with CPU and all GFX are

* 	= 	$cc00 "Sprites Attributes"

SpritesAttributes:
		.import	binary "gfx/Sprites32/SpriteAttribs.bin"			// 128 Bytes ($80)

//---------------------------------------------------------------------------------------------------------------------
// Sprites @ $d000 - Chipmen starts at $C000
// Chipmen is Where VIC shares memory with CPU and all GFX are

* 	= 	$d000 "Sprites"

Sprites:
		.import	binary "gfx/Sprites32/Sprites.bin"				// 8192 Bytes ($2000)

//=====================================================================================================================
// End of Game Data
//=====================================================================================================================
