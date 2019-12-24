// ARM Assembly program that performs bubblesort (ascending order) on a list of 32-bit unsigned number. The first value in the list
// is the number of values in the list that must be sorted. This is done by implementing a SWAP subroutine which returns a 1 if a swap
// is done and 0 if otherwise. The address of the first list element to SWAP is passed through R0 and the return value will be passed 
// in R0 back to the main porgram

.text
.global _start
_start:
//initializing conditions
	LDR R1,=LIST //address of to the list into R1
    LDR R6, [R1] //counter for the number of values in the list
    MOV R7, R1
    MOV R0, #1 //goes through the swap function at least once to check
   
    //while loop that continues to sort the list
    WHILE:
    CMP R0,#0 //continue to sort the list until there are no more swaps
    MOV R0,#0
    SUB R6,#1 //counter=counter-1
    MOV R2,R6 
    MOV R1,R7
    BNE FOR //if R0=1 (swap was previously performed), keep sorting the list/check it over again
    B END
   
    //for loop that loops through all the words in the list and calls SWAP subroutine if needed
    FOR:
    ADD R1,R1,#4 
    CMP R0,#1
    MOVEQ R8,R0
    CMP R0,#0
    MOVEQ R8,R0
    MOV R0,R1 //R0 gets R1 to pass as parameter into the SWAP subroutine
    CMP R2,#0
    BLNE SWAP //calling swap routine if adjacent values are not in ascending order
    SUB R2,R2,#1 //keep decrementing the counter of how many values there are as 
    CMP R2,#0 //gone through all words in the list, go back to the WHILE loop and check if swaps have been done (if so, need to loop through list and sort again through swapping)
    MOVEQ R0,R8 
    BEQ WHILE 
    B FOR

	//Begining of subroutine for swapping
    SWAP: //if a value was swapped (yes is R0==1)
    LDR R3,[R0] //value of first element
    LDR R4,[R0,#4] //value of second element
    CMP R3,R4 //list[i]>list[i+1]
    MOVGT R5,R3 //set swap to 1 bc a swap occured
    MOVGT R3,R4 //temporary register, beginning of swap
    MOVGT R4,R5 //end of swap
    STR R3,[R0] //writing elements back into memory
    STR R4, [R0,#4]
    MOVGT R0,#1
    B EXIT
   
    EXIT:
    MOV PC,LR
   
	END: B END
LIST: .word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
.end