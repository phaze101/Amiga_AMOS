//=====================================================================================================================
// Debug Info Displayed in Hud
// This File will be removed eventually and not part of teh Game
//=====================================================================================================================

	// To know where in memory the table is create
	* = * "Debug Info Start"


#importonce

//=====================================================================================================================
// Debug Info
//=====================================================================================================================

DebugInfo: {
		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenNo in Zero Page 
        lda ScreenNo
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next:    
        jsr div10_8bit
//		clc
//      adc #$1
        sta SCREEN_RAM+(40*22+0),y     // Location on screen
        dey
        bpl Next

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenY in Zero Page 
        lda ScreenY
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next1:    
        jsr div10_8bit
//		clc
//      adc #$1
        sta SCREEN_RAM+(40*22+5),y     // Location on screen
        dey
        bpl Next1

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenX in Zero Page 
        lda ScreenX
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next2:    
        jsr div10_8bit
//		clc
//        adc #$1
        sta SCREEN_RAM+(40*22+10),y     // Location on screen
        dey
        bpl Next2

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenTop in Zero Page 
        lda ScreenTop
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next3:    
        jsr div10_8bit
//		clc
//      adc #$1
        sta SCREEN_RAM+(40*22+15),y     // Location on screen
        dey
        bpl Next3

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenBelow in Zero Page 
        lda ScreenBelow
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next4:    
        jsr div10_8bit
//		clc
//      adc #$1
        sta SCREEN_RAM+(40*22+20),y     // Location on screen
        dey
        bpl Next4

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenLeft in Zero Page 
        lda ScreenLeft
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next5:    
        jsr div10_8bit
//		clc
//		adc #$1
        sta SCREEN_RAM+(40*22+25),y     // Location on screen
        dey
        bpl Next5

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable ScreenRight in Zero Page 
        lda ScreenRight
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next6:    
        jsr div10_8bit
//		clc
//		adc #$1
        sta SCREEN_RAM+(40*22+30),y     // Location on screen
        dey
        bpl Next6

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable Col1 in Zero Page 
        lda Col1
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next7:    
        jsr div10_8bit
//		clc
//		adc #$1
        sta SCREEN_RAM+(40*23+0),y     // Location on screen
        dey
        bpl Next7


		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable Col2 in Zero Page 
        lda Col2
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next8:    
        jsr div10_8bit
//		clc
//		adc #$1
        sta SCREEN_RAM+(40*23+5),y     // Location on screen
        dey
        bpl Next8

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable Col3 in Zero Page 
        lda Col3
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next9:    
        jsr div10_8bit
//		clc
//		adc #$1
        sta SCREEN_RAM+(40*23+10),y     // Location on screen
        dey
        bpl Next9

		//-------------------------------------------------------------------------------------------------------------
		// Print Value of Variable Col4 in Zero Page 
        lda Col4
        sta Num1_lo

        ldy #$02       // Number of digits to print - 3 in this case of sn 8 Bit
	Next10:    
        jsr div10_8bit
//		clc
//		adc #$1
        sta SCREEN_RAM+(40*23+15),y     // Location on screen
        dey
        bpl Next10

		rts
}
