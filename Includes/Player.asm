//=====================================================================================================================
// Routines related to Player Handling
//=====================================================================================================================

#importonce

//=====================================================================================================================
// Player constants
//=====================================================================================================================

.const PlayerSprAnim1		= 	((13*4096)-(3*16384))/64		// Sprite Pointer = Start address of Sprites - Bank Start Address / Sprite Size

//=====================================================================================================================
// Init Player
//=====================================================================================================================

InitPlayer: {
	// Set Player Sprite Pointer
		lda #PlayerSprAnim1
		sta SCREEN_RAM+(1024-8)

	// Set Sprite 0 colour
		lda #$00
		sta $d027

	// Turn Multi Colour On
		lda #%00000000
		sta $d01c

	// Set Sprite Multi colour 1
	//	lda #$0c
	//	sta $d025

	// Set Sprite Multi colour 2
	//	lda #$09
	//	sta $d026

	// Expand X and Y Sprite 0
	//	lda #%00000001
	//	sta $d01d
	//	sta $d017

	// Turn off X MSB for all Sprites
		lda #%00000000
		sta $d010

	// Set Sprite 0 X Postion
		lda #160+24-12-32
		sta $d000

	// Set Sprite 0 Y Postion
		lda #208-(2*8)			// 216 we position the player
		sta $d001

	// Turn Sprite 0 on
		lda #%00000001
		sta $d015

		rts
}
