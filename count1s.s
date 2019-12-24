// ARM Assembly program which determines the longest string of consecutive 1s (in the binary form of a number) in a list of 
// numbers. This is done by creating a subroutine called ONES where R1 receives the input data and R0 returns the result.

.text
.global _start
_start:
//initial conditions
    LDR R1,=TEST_NUM // Load address into R1
    MOV R0, #0 // R0 will hold the current chain of ones
    MOV R5, #0 //longest chain of ones in all of the words
//loop to go over for each word
LOOPW:
    LDR R3, [R1] //Load data word into R3
    CMP R3, #0
    BLT END //end case for now (if it reaches a -1)
    MOV R0, #0 
    BL ONES
    ADD R1, R1, #4 //next word
    CMP R5, R0 //check if the newfound longest string of consecutive 1s is greater than the current longest chain, if so swap
    BLT CHANGECNT
    B LOOPW
CHANGECNT: 
    MOV R5, R0
    B LOOPW
END: 
    B END    

//ONES subroutine (function)
ONES:
LOOP: 
     CMP R3, #0 // loop until the data contains no more 1’s
     BEQ EXIT
     LSR R2, R3, #1 // perform SHIFT, followed by AND
     AND R3, R3, R2
     ADD R0, #1 // count the string lengths so far
  
   B LOOP
EXIT: //Exiting subroutine, returning to main instructions
     MOV PC, LR
TEST_NUM: .word 0x00000001, 0x00000002, 0x00000003, 0x00000004, -1
.end
