//=====================================================================================================================
// Convert and Display 16 and 32 Bit Hex Numbers in Decimal
// By Phaze101
//
// Include Variables in Main.s or you Main Program whatever that is called
//=====================================================================================================================

//=====================================================================================================================
// Code Below to be Remarks to be accessed via Basic
// All these comments can be removed
//=====================================================================================================================

//*       =       $C000

//=====================================================================================================================
// Main
//=====================================================================================================================

//Init16BitNo
//        lda #$FF
//        sta Num1_hi
//        lda #$00
//        sta Num1_lo
//
//Dispaly16bit
//        jsr Display16Bit
//        
//Init32BitNo
//        lda #$FF
//        sta Num1_hi
//        lda #$00
//        sta Num1_lo
//        lda #$FF
//        sta Num2_hi
//        lda #$FF
//        sta Num2_lo
//
//Dispaly32bit
//        jsr Display32Bit
//
//        rts

#importonce

//=====================================================================================================================
// Variables - Div32 Div 16 convert Hex to Decimal Variables
//=====================================================================================================================
//
//* = $40 "Div16Div32Convert" virtual
//
//.zp {
//	// 16 bit number 01 to be divided by 10 or 32 bit number combined with 02
//	Num1_lo:
//        .byte    $00
//	Num1_hi:
//        .byte    $00
//
//	// 16 bit number 02 to be divided by 10 or 32 bit number combined with 01
//	Num2_lo:
//        .byte    $00
//	Num2_hi:
//        .byte    $00
//
//	// 16 bit number result 01 or 32 bit number combined with 02
//	result1_lo:
//        .byte    $00
//	result1_hi:
//        .byte    $00
//
//	// 16 bit number result 02 or 32 bit number combined with 01
//	result2_lo:
//        .byte    $00
//	result2_hi:
//        .byte    $00
//}

	// To know where in memory the table is create
	* = * "Maths & Conversions"

//=====================================================================================================================
// Display 8bit number on screen - 3 Digists on Screen
//=====================================================================================================================

Display8Bit: {
        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next:    
        jsr div10_8bit
        ora #$30
        sta SCREEN_RAM+(40*22),y     // Location on screen
        dey
        bpl Next
        rts
}


//=====================================================================================================================
// Display 16bit number on screen - 5 Digits on Screen
//=====================================================================================================================

Display16Bit: {
        ldy #$04       // Number of digits to print - 5 in this case for a 16bit
	Next:    
        jsr div10_16bit
        ora #$30
        sta SCREEN_RAM+(40*23),y     // Location on screen
        dey
        bpl Next
        rts
}

//=====================================================================================================================
// Display 32bit number on screen - 10 Digits on Screen
//=====================================================================================================================

Display32Bit: {
        ldy #$09        // Number of digits to print - 10 in case of a 32 bit
	Next:   
        jsr div10_32bit
        ora #$30
        sta SCREEN_RAM+(40*24),y     // Location on screen
        dey
        bpl Next
        rts
}

//=====================================================================================================================
// 8 bit number Division by 10
//=====================================================================================================================

div10_8bit: {
        ldx #$09        // Number of bits - 8 + 1 since 0 is ignored
        lda #$00
        clc
	loop:
        rol
        cmp #$0a
        bcc skip
        sbc #$0a
	skip:    
        rol Num1_lo
        dex
        bne loop
        rts
}

//=====================================================================================================================
// 16 bit number Division by 10
//=====================================================================================================================

div10_16bit: {
        ldx #$11        // Number of bits - 16 + 1 since 0 is ignored
        lda #$00
        clc
	loop:
        rol
        cmp #$0a
        bcc skip
        sbc #$0a
	skip:    
        rol Num1_lo
        rol Num1_hi
        dex
        bne loop
        rts
}

//=====================================================================================================================
// 32 bit number Division by 10
//=====================================================================================================================

div10_32bit: {
        ldx #$21        // Number of bits - 32 + 1 since 0 is ignored
        lda #$00
        clc
	loop:   
        rol
        cmp #$0a
        bcc skip
        sbc #$0a
	skip:
        rol Num2_lo
        rol Num2_hi
        rol Num1_lo
        rol Num1_hi
        dex
        bne loop
        rts
}

//=====================================================================================================================
// Multiplys 8bit x 8bit (MultiplyNum1 * MultiplyNum2)
// Returns result in A and X
// Stores 16 bit result in A(High byte) + X( Low Byte)
// https://codebase64.org/doku.php?id=base:short_8bit_multiplication_16bit_product
// Num1_lo Destroyed
//=====================================================================================================================
Mult8Bit_8Bit: {
        lda #$00
        ldx #$08
        clc
	m0:
		bcc m1
        clc
        adc Num2_lo
	m1:
		ror
        ror Num1_lo
        dex
        bpl m0
        ldx Num1_lo
        rts
}
