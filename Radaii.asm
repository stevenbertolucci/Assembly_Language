comment~
Author: Steven Bertolucci
Project: Project10D
Description:
Extra-credit (optional) for 8 points.

A computer game requires the programmer to 
compute the area of 4 circular objects on the game board.

Write a program which:

1) Prompts the user "Please enter the radii of 4 circles:  "
2) Uses a loop to read in the values of 4 single-precision 
radius values.  Do not use any immediate addressing in your loop.
3) Computes the area of each of the 4 circles.  Use no more than 4 
SSE instructions.
4) Displays an output of "The areas of your 4 circles are:  " 
followed by the 4 areas.  Use a loop for the display; and again use
no immediate addressing.
Sample run:

Please enter the radii of 4 circles: 1.0 2.0 3.0 4
The areas of your 4 circles are: 3.14159 12.56636 28.27431 50.26544
~

extrn DisplayString:	PROTO
extrn ReadFloatV:		PROTO
extrn DisplayFloatV:	PROTO
extrn ExitProcess:		PROTO

.data
prompt		byte		'Please enter the radii of 4 circles: ', 0
output		byte		'The areas of your 4 circles are: ', 0
four		qword		4
align 16
pi			real4		4 dup(3.14159)

.data?
radius		real4		4 dup(?)
area		real4		4 dup(?)

.code
main	PROC
    push rbp							;reserve non-volatile
	push rbx							;reserve non-volatile
    mov rbp, rsp						;make base pointer = stack pointer
	sub rsp, 32							;reserve shadow space

	lea rcx, prompt						;get prompt ready to display
	call DisplayString					;display the prompt
	xor rbx, rbx						;counter for Radii label
Radii:
	cmp rbx, four						;compare to see if all 4 radii have been entered
	je Result							;jump if not equal to label Result
	call ReadFloatV						;read the radius
	lea rcx, radius						;get radius ready for reading
	movss dword ptr [rcx+4*rbx], xmm0	;store returned value in a variable
	inc rbx								;increment index
	jmp Radii							;jump back to Radii label
Result:
	movaps xmm0, radius					;load all 4 values from radius into xmm0
	vbroadcastss xmm1, pi				;fill all float in xmm registers
	mulps xmm0, xmm0					;square the values in xmm0
	mulps xmm0, xmm1					;multiply squared values by pi
	movaps area, xmm0					;store values back into memory
	lea rcx, output						;get values ready to display
	call DisplayString					;display the string
Done:	
	xor rbx, rbx						;set rbx to 0
DoneLoop:
	lea rcx, area						;load array base into rcx
	movss xmm0, real4 ptr [rcx + 4*rbx]	;move into xmm0 the value to display
	call DisplayFloatV					;display the area
	inc rbx								;increment index
	cmp rbx, four						;check if rbx is less than 4
	jl DoneLoop							;loop back while rbx is less than 4

	add rsp, 32							;restore shadow space
	pop rbx								;restore non-volatile
	pop rbp								;restore non-volatile
	mov rcx, 0							;exit code
	call ExitProcess					;Windows exit
main	ENDP
END

comment~ 
Window Output Console:

Please enter the radii of 4 circles: 1.0 2.0 3.0 4
The areas of your 4 circles are: 3.14159 12.56636 28.27431 50.26544

Please enter the radii of 4 circles: 5 10 15 20
The areas of your 4 circles are: 78.53975 314.159 706.8578 1256.636

Please enter the radii of 4 circles: 2.5 3.5 5.5 7.5
The areas of your 4 circles are: 19.63494 38.48448 95.0331 176.7144

~
