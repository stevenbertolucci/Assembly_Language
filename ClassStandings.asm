comment~
Author: Steven Bertolucci
Project: Project4C
Description:

Assume that 120 semester credits = bachelor's degree. 
Write a program that asks the user for the number of semester
credits completed. The program should respond with a class standing. 
The class standings vs semester credits are shown below:

0 - 29 = "Freshman"
30 - 59 = "Sophomore"
60 - 89 = "Junior"
90 or more = "Senior"

Use DisplayString (IO.cpp) to prompt: "Enter semester credits: "
Use ReadShort to read a number of semester credits.
Use DisplayString to respond with the class standing as shown above.
~

extrn ExitProcess:		PROTO
extrn ReadShort:		PROC
extrn DisplayString:	PROC

.data
prompt		byte		"Enter semester credits: ", 0
class1		byte		"Freshman", 0
class2		byte		"Sophomore", 0
class3		byte		"Junior", 0
class4		byte		"Senior", 0



.data?
credits		word		?						;store user input for credits


.code
main	PROC

				sub rsp, 32						;reserve shadow space
		

				mov rcx, offset prompt			;bytes to display
				call DisplayString				;display the string

				mov rcx, offset credits			;bytes to display
				call ReadShort					;display credits

				;TODO apply logic here

freshman:		cmp credits, 29					;move if less than or equal to 29
				ja sophomore					;jump if above (credits > 29) to sophomore
				mov rcx, offset class1			;bytes to display
				call DisplayString				;display class1 = "Freshman"
				jmp Done						;if it matches, jump to Done

sophomore:		cmp credits, 59					;move if greater than or equal to 30
				ja junior						;jump if above (credits > 59) to junior
				mov rcx, offset class2			;bytes to display
				call DisplayString				;display class2 = "Sophomore"
				jmp Done						;if it matches, jump to Done

junior:			cmp credits, 89					;move if greater 89
				ja senior						;jump to senior if above 89 (credits > 89)
				mov rcx, offset class3			;bytes to display
				call DisplayString				;display class3 = "Junior"
				jmp Done						;if it matches, jump to Done

senior:			cmp credits, 90					;compare if greater 90
				mov rcx, offset class4			;bytes to display
				call DisplayString				;display class4 = "Senior"
				jmp Done						;if it matches, jump to Done

Done:		
				add rsp, 32						;restore stack pointer
				mov rcx, 0						;return code
				call ExitProcess				;Windows exit

main	ENDP
END

comment~

Window Output Console:

Enter semester credits: 33
Sophomore
~