//This is an ARM assembly program that will add a list of positive numbers (R7) as well as count the number of positive
// numbers in the list (R8). The end of the lists is characterized by a -1. 

.text
.global start
_start:
	LDR R0, =TEST_NUM //R0 is address of list
    LDR R1, [R0] //R1 now has the value at the specified address of R0
    //Initiating counters R7 and R8 with 0
    MOV R8, #0  //R8=number of numbers in list
    MOV R7, #0  //R7=sum of list
  LOOP:
    ADD R7, R7, R1 //R7=R7+value in list
    ADD R8, R8, #1 //R8=R8+1 (counter)
    ADD R0, R0, #4 //Incrementing address for next value in list
    LDR R1, [R0]
    //if the next value in the list is greater than -1, continue
    CMP R1, #0
    BGE LOOP
END: 
    B END
TEST_NUM: .word 1,2,3,5,0xA,-1
//list terminates at -1
.end
