comment~
Author: Steven Bertolucci 
Project: Project4A
Description: 
Write a program with a loop and indexed addressing that 
exchanges every pair of values in an
array.  The array has an even number of elements. 
Item i will exchange with item i+1, and item i+2 will 
exchange with item i+3, and so on.
The array should contain the following hex values appropriately 
sized for the largest element (20h):
11, 12, 13, 14, 15, 16, 17, 18, 19, 20
Call (IO.cpp) DisplayMemory(unsigned char *pc, int count) once 
before the exchanges, and once after the exchanges to display your results on 2 separate lines.
~

extrn ExitProcess:		PROTO
extrn DisplayMemory:	PROTO
extrn DisplayNewline:	PROTO

.data
.radix 16
array		byte		11, 12, 13, 14, 15, 16, 17, 18, 19, 20
.radix 10


.code
main	PROC

			sub rsp, 32					;reserve shadow space
			push rbp					;save non-volatile
			mov rbp, rsp				;make frame pointer for stack

			lea rcx, array				;point to array
			mov rdx, sizeof array		;bytes to display
			call DisplayMemory			;display array
			call DisplayNewline			;display newline

			;TODO: swap the pairs
			mov rcx, sizeof array / 2	;loop counter
			lea rbx, array				;address in array
			
swap:
			mov al, [rbx]				;1st pair
			mov ah, [rbx + type array]	;second pair
			xchg al, ah
			mov [rbx], al				;first in pair
			mov [rbx + type array], ah	;second in pair
			add rbx, 2
			sub rcx, 1
			jnz swap
			
			
			lea rcx, array				;point to array
			mov rdx, sizeof array		;bytes to display
			call DisplayMemory			;display array

			pop rbp
			add rsp, 32
			mov rcx, 0
			call ExitProcess
main	ENDP
END

comment~
 
Window Console Output Display: 
11 12 13 14 15 16 17 18 19 20
12 11 14 13 16 15 18 17 20 19

~