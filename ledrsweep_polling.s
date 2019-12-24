//ARM Assembly program which displays a specific LEDR light pattern (two lights sweeping first towards the centre, then 
//outwards towards the edges) on a DE1-SoC board. The pattern begins by having LEDR9 and LEDR0 should be on, then LEDR8 
//and LEDR1, then LEDR7 and LEDR2, etc. When the pattern reaches LEDR5 and LEDR4 being on, the pattern direction reverses. 
//The lights will move every 0.25 seconds. If KEY3 is pressed, the sweeping motion stops. This motion can be resumed by
//pressing KEY3 once again. The timing of the 0.25 seconds is implemented using the MPCORE Private Timer

//Note: this exercise is an example of polling/polled input/output.

.text
.global _start
_start:
	LDR R0,=0xFF200000 // LEDR address in memory
	LDR R1,=0xFFFEC600 // Timer address in memory
	LDR R2,=0xFF200050 // Keys address in memory
	//initializing timer for 0.25 seconds
	LDR R3,=50000000// "counting" to 0.25 seconds
	STR R3, [R1]// loading value into timer
	MOV R3, #0b11 //enabling and initializing auto-reload of timer
	STR R3, [R1, #8]
	//end of initialization of timer
	MOV R4, #1 // Initializing the LEDR that will be sweeping left
	MOV R5, #0b1000000000 // Initializing the LEDR that will be sweeping left
	
//diplaying the LEDR pattern on the board
DISPLAY:
	LDR R7, [R2]
	CMP R7, #0b1000 //checking if the key is pressed, if so go to PAUSE subroutine (pause the sweeping pattern)
	BEQ PAUSE
	ORR R6, R4, R5 
	STR R6, [R0] //writing state of LEDR and changing the displayed pattern

//waiting for the timer to count to 0.25 seconds before doing anything else
WAIT_TIMER:
	LDR R6, [R1, #0xC] //holds the value that tells us if the timer is done counting 0.25 seconds 
	CMP R6, #0
	BEQ WAIT_TIMER //keep counting!
	MOV R8, #1 
	STR R8, [R1, #0xC] //Reseting timer to count 0.25 seconds again once it has finished
	LSL R4, R4, #1 //if done counting, shift the LEDR pattern
	LSR R5, R5, #1
	CMP R4, #0x400 //check bounds of LEDR
	BNE EDGECASE
	MOV R4, #0b10
	MOV R5, #0b100000000
	B DISPLAY

//LEDR are in the middle, change sweeping direction
EDGECASE:
	CMP R4, #0x10
	BNE DISPLAY
	LSL R4, R4, #1 //shifting
	LSR R5, R5, #1
	B DISPLAY

//KEY3 has been pressed! Wait (loop) for (until) release
PAUSE: 
	LDR R7, [R2]
	CMP R7, #0
	BNE PAUSE

CHECK_RESTART:
	LDR R7, [R2]
	CMP R7, #0
	BEQ CHECK_RESTART

//Pattern restarts once KEY3 has been released
RESTART:
	LDR R7, [R2]
	CMP R7, #0
	BNE RESTART
	B _start
.end