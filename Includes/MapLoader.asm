//=====================================================================================================================
// Display a screen from the Map
//
// This routine is a general purpose routine hence tiles do not need to be in multiplication of 2
//
// Constraints
// Tiles can be max 6x6
// Width and Height cannot exceed 256
// The Data Constants should be Page bound ($100)
//=====================================================================================================================

#importonce

//=====================================================================================================================
// Info
// Requires the follwing zero page values
//
//	MultiplyNum1: 			.byte $00
//	MultiplyNum2: 			.byte $00
//	MultiplyNum1Hi: 		.byte $00
//	MapLoaderTileLookup: 	.word $0000
//	MapLoaderMapLookup: 	.word $0000
//	MapLoaderColumn: 		.byte $00
//	MapLoaderRow: 			.byte $00
//=====================================================================================================================

//=====================================================================================================================
// Map Data constants
// These DATA constants should be aligned to $100
//=====================================================================================================================

// Address pointers
.const MAP_DATA  = $9900
.const TILE_DATA = $9400
.const ATTR_DATA = $9800

// Tile Size Width and height in Characters
.const TILE_WIDTH  = 2
.const TILE_HEIGHT = 2

// Single Screen Size in Tiles - Width and Height
.const MAP_TILE_WIDTH  = 20				//Single screen size
.const MAP_TILE_HEIGHT = 11

// Full Map Width and Height
// The following 2 values cannot exceed 256
.const MAP_FULL_WIDTH  = 100 //Full map size 
.const MAP_FULL_HEIGHT = 99

//=====================================================================================================================
// Draws the screen from the Map Data based on the tileset created by the character set
// 
// The following routines are present
// 	MapLoader.DrawMap		- This needs to be Rewritten
// 	MapLoader.Multiply 		- This needs to be replaced
//=====================================================================================================================

MapLoader: {
	.const TILE_DATA_LENGTH = TILE_WIDTH * TILE_HEIGHT

	// To know where in memory the table is create
	* = * "MapLoader Starts"

	TileToScreenOffsets:
		// In Maploader01 the characters that formed part of the tile where drawn next to each other
		// We do not want that
		// We want to draw these if we are at the top left hand corner of the screen at 
		// Row 0 - position 00 and position 01
		// Row 1 - position 40 and position 41 
		// hence we need the offset (or modulo) after we draw the first 2 in this case
		// the line below should produce in memory 0, 1, 40, 41
		.fill TILE_DATA_LENGTH, mod(i, TILE_WIDTH) + floor(i/TILE_WIDTH) * $28

	DrawMap: {
			//=====================================================================================
			// We pass the X and Y of where we want to start our screen in our Map
			// X = X Map Pos
			// Y = Y Map Pos 
			//=====================================================================================

			txa			// Pass the X Map position to the accumulator

			//=====================================================================================
			// Get Map data location
			//=====================================================================================
			sta MapLoaderMapLookup
//			lda #>MAP_DATA
			lda #>MapData
			sta MapLoaderMapLookup+1

			//=====================================================================================
			// Calculate the Y Offset
			// Basically if we are in Row 5
			// We multiply the 5 by the Tile Map Full Width
			//=====================================================================================
			sty MultiplyNum1		// Pass the Y Map Position 
			lda #MAP_FULL_WIDTH
			sta MultiplyNum2
			jsr Multiply
			// result in A and Y

			//=====================================================================================
			// Now we need to add the Y starting position and the X starting position
			// Now add to MapLoaderLookup
			//=====================================================================================
			clc
			adc MapLoaderMapLookup + 0
			sta MapLoaderMapLookup + 0
			tya 
			adc MapLoaderMapLookup + 1
			sta MapLoaderMapLookup + 1

			//=====================================================================================
			// Set screen and color target locations
			// Assuming we always start from Top Left position 0
			// Self Modify Code futher below where it
			// update Screen Address and Colour Ram address ($BEEF)
			//=====================================================================================
			lda #$00
			sta ScreenMod + 1
			sta ColorMod + 1
			lda #>SCREEN_RAM
			sta ScreenMod + 2
			lda #$d8
			sta ColorMod + 2

			//=====================================================================================
			// Init Row Position to 0
			// We start from top Left Hand Corder of the Screen
			// Set this position in MapLoaderColumn which is our starting Row
			//=====================================================================================
			lda #$00
			sta MapLoaderRow
		!RowLoop:

			//=====================================================================================
			// Init Coloum Position to 0
			// We start from top Left Hand Corder of the Screen
			// Set this position in MapLoaderColumn which is our starting Colomn
			//=====================================================================================
			lda #0
			sta MapLoaderColumn
			tay

			//=====================================================================================
			// Get the Tile Data - Which Tile we want to print the Screen
			//=====================================================================================
		!ColumnLoop:
			// ldy MapLoaderColumn	
			lda (MapLoaderMapLookup), y
			//Tile number in Acc			

			//=====================================================================================
			// Find Position in Tileset of the Tile we want to Draw
			//
			// Tile Number in A
			// We need: (TileNumber * TileDataLength) + TileData
			//lda #$47
			//
			// if you know that the tiles are going to be a power of 2 then
			// you can use ASL to do x2, x4, x8 etc etc
			// in our case since tileset is 2x2 we can do ASL ASL 
			// asl
			// asl
			//
			// We need = TileNumber(Num1) * TileDataLength(Num2) + TILE_DATA
			// Example  TileNumber (17) * TileDataLength (4) + TileData ($2900)
			//=====================================================================================
			sta MultiplyNum1
			lda #TILE_DATA_LENGTH
			sta MultiplyNum2

			jsr Multiply

			sta MapLoaderTileLookup + 0
			tya
			clc 
			adc #>TILE_DATA
			sta MapLoaderTileLookup + 1
			// MapLoaderTileLookup points to tile data


			//=====================================================================================
			// Prints the Tile to the Screen and also its colour
			//=====================================================================================
			ldy #$00
		!:
			// Print Char to screen
			// Notice we address self modifying code 
			lda (MapLoaderTileLookup), y
			ldx TileToScreenOffsets, y			
		ScreenMod:
			sta $BEEF, x

			// Set char Colour in Colour Ram
			// Notice we address self modifying code 
			tax
			lda ATTR_DATA, x
			ldx TileToScreenOffsets, y			
		ColorMod:
			sta $BEEF, x

			iny
			cpy #TILE_DATA_LENGTH
			bne !-
			// Tile is now drawn


			//=====================================================================================
			// Now increment screen and color locations
			//=====================================================================================
			clc
			lda ScreenMod + 1 //Lo byte
			adc #TILE_WIDTH
			sta ScreenMod + 1 //Lo byte
			bcc !+
			inc ScreenMod + 2
		!:
			clc
			lda ColorMod + 1 //Lo byte
			adc #TILE_WIDTH
			sta ColorMod + 1 //Lo byte
			bcc !+
			inc ColorMod + 2
		!:
			//=====================================================================================
			// Check if we are on new row
			// If not we are still on the same Row so we print the next Column Tile
			//=====================================================================================
			ldy MapLoaderColumn
			iny
			cpy #MAP_TILE_WIDTH
			beq !NextRow+
			sty MapLoaderColumn

			jmp !ColumnLoop-

			//=====================================================================================
			// We are in a New Row in the Map 
			// Increment the Row of our map 
			// Check if we have drawn all Rows for a screen
			//=====================================================================================
		!NextRow:
			ldy MapLoaderRow
			iny
			cpy #MAP_TILE_HEIGHT
			beq !RowsComplete+
			sty MapLoaderRow

			//=====================================================================================
			// Increase the map loader lookup to next row
			// Now Next Row is the Full Width of the TileMap
			// If each screen has 20 tiles as width
			// But our map data is 100 tiles width
			// That means that our next line in the Map Data is the Map Width 
			//=====================================================================================
			clc
			lda MapLoaderMapLookup + 0
			adc #MAP_FULL_WIDTH
			sta MapLoaderMapLookup + 0
			lda MapLoaderMapLookup + 1
			adc #0
			sta MapLoaderMapLookup + 1

			//=====================================================================================
			// Move screen pointer to next tile row
			//=====================================================================================
			.var screenAdvance = (40 - MAP_TILE_WIDTH * TILE_WIDTH) + (TILE_HEIGHT - 1) * 40
			lda ScreenMod + 1 //Lo byte
			adc #screenAdvance
			sta ScreenMod + 1 //Lo byte
			bcc !+
			inc ScreenMod + 2	
		!:
			//=====================================================================================
			// Move Colour Ram pointer to next tile row
			//=====================================================================================
			clc
			lda ColorMod + 1 //Lo byte
			adc #screenAdvance
			sta ColorMod + 1 //Lo byte
			bcc !+
			inc ColorMod + 2	
		!:
			jmp !RowLoop-

		!RowsComplete:
			rts
	}

	//=====================================================================================
	// Multiplys 8bit x 8bit (MultiplyNum1 * MultiplyNum2)
	// Returns result in A and Y
	// Stores 16 bit result in A(low byte) + Y(highByte)
	//=====================================================================================
	Multiply: {
			lda #$00
			tay
		 	sty MultiplyNum1Hi  // remove this line for 16*8=16bit multiply
			beq enterLoop

		doAdd:
			clc
			adc MultiplyNum1
			tax

			tya
			adc MultiplyNum1Hi
			tay
			txa

		loop:
			asl MultiplyNum1
			rol MultiplyNum1Hi
		enterLoop:  // accumulating multiply entry point (enter with .A=lo, .Y=hi)
			lsr MultiplyNum2
			bcs doAdd
			bne loop
			rts
	}
}