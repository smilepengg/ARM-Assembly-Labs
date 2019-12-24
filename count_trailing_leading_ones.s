// ARM assembly program that determines the number of 1s in a word (R5), leading 0s (R6), trailing 0s in a word (R7) by 
// writing subroutines called ONES, LEADING, and TRAILING. List is terminated with a -1.

.text
.global _start
_start:
    LDR R0, =TESTNUMLIST //load the address of the list into R2
    MOV R8, #0
    MOV R9, #0
    MOV R10, #0
    LOOPOUT: //Loop to perform the ONES, LEADING, and TRAILING subroutine to every word in the list
        MOV R2, #0 //counting the number of times it has shifted for 1s
        MOV R3, #0 //cnt for leading 0s
        MOV R4, #0 //cnt for trailing 0s
        MOV R5, #0 //longest string of 1s count (output)
        MOV R6, #0 //longest string leading 0s (output)
        MOV R7, #0 //longest string trailing 0s (output)
        LDR R11, [R0]
        MOV R1, R11 //load first word into R1
        CMP R11, #-1 
        BEQ END //if it is a -1 (indication for end of list), then break
        BL ONES //otherwise find out longest list of 1s
        MOV R1, R11
        BL LEADING //calling leading 0s function
        MOV R1, R11
        BL TRAILING //calling trailing 0s function
        ADD R0, R0, #4 //next word in list and repeat
        CMP R5, R8
        MOVGT R8, R5 //if the found ones cnt for the word is greater, replace the value in R8 with R5
        CMP R6, R9 //if the found leading 0 cnt for the word is greater, replace the value in R9 with R6
        MOVGT R9, R6 //if the found trailing 0 cnt for the word is greater, replace the value in R10 with R7
        CMP R7, R10
        MOVGT R10, R7
        B LOOPOUT
	//ONES subroutine to find all the 1s in the word
    ONES: 
        CMP R2,#32 //counter for how many times the bits have been shifted
        BEQ EXIT //if over 32 bits (length of list), done looking for 1s and exit the function
        ADD R2, #1 
        AND R12,R1,#1
        CMP R12, #1 //compare the bit and check if it is a 1, if yes add the the current 1s counter (R5) 
        ADDEQ R5,#1 
        LSR R1, #1
        B ONES //continue with ones function
    //LEADING subroutine to find the number of leading 0s in a word
    LEADING:
        CMP R3, #32
        BEQ EXIT //if over 32 bits, done looking for leading 0s (just in case there are 32 0s)
        ADD R3, #1
        AND R12, R1, #2147483648 //Extract the left most bit 
        CMP R12, #2147483648 
        BEQ EXIT //if the leftmost bit is a 1, exit the leading 0s function
        ADD R6, #1 //if not, add 1 to the leading 0s counter
        LSL R1, #1
        B LEADING //continue with leading 0s function if not encountered a 1
    //TRAILING subroutine to find the number of trailing 0s in a word
    TRAILING:
        CMP R4, #32
        BEQ EXIT //if over 32 bits, done looking for trailing 0s (just in case there are 32 0s)
        ADD R4, #1
        AND R12, R1, #1 //extract right most bit
        CMP R12, #1
        BEQ EXIT //if the right most bit is a 1, exit the trailing 0s function
        ADD R7, #1 //if not, add 1 to the trailing 0s counter
        LSR R1, #1
        B TRAILING //continue with trailing 0s function if not encountered a 1
     EXIT:
        MOV PC, LR
     END: 
        B END
TESTNUMLIST: .word 0x1111,0xffff,-1
.end
