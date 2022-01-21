comment~
Author: Steven Bertolucci
Project: Project8A
Description:
Write a program to change the case of each letter 
in a user-entered string.  Assume that the user will 
enter only letters (a-z and A-Z) and spaces.  Use 
logic mnemonics, but no arithmetic opcodes.

Start by calling ReadString in main, and saving the string 
in memory. Next, call a proc which changes each lower-case 
letter to upper-case, and each upper-case letter to lower-case. 
Do not change spaces.  Save the modified string in a new memory location.
Finally, display the modified string by calling DisplayString.

Sample output (first line is user-entered):

NOW is THE time FOR all GOOD
now IS the TIME for ALL good
~

extrn ExitProcess:		PROTO
extrn ReadString:		PROTO
extrn DisplayString:	PROTO

.data

.data?
userInput	byte	255 dup(?)
result		byte	255 dup(?)

.code
main			PROC
				sub rsp, 32						;reserve shadow space

				lea rcx, userInput				;prepare rcx with parm1
				call ReadString					;get userInput
				lea rcx, userInput				;save user input in address rcx
				mov rdx, lengthof userInput		;store length of string in rdx

				call ChangeCase					;call to function ChangeCase
				lea rcx, result					;get string ready for output
				call DisplayString				;call function to display string

				add rsp, 32						;restore shadow space
				mov rcx, 0						;exit code
				call ExitProcess				;Windows exit
main			ENDP

ChangeCase		PROC

				cld								;clear flags 
				push rsi						;store source index
				push rdi						;store destination index
				lea rdi, result					;load the address of result in rdi
				mov rsi, rcx					;store string in rsi
				lodsb							;loaded the first character into al
Looper:			
				test al, al						;compare al with al to see if there is a null character
				jz Done							;jump to label Done if there are no character to compare
				
				;check to see if result is between ascii 65 - 90 and 97 - 122
				cmp al, 'A'						;compare al with letter 'A' aka ascii 65
				jge CheckUpperLimit				;jump if greater or equal to 65 to label CheckUpperLimit
				jmp NextIndex					;jump to label NextIndex to continue

CheckUpperLimit:
				cmp al, 'Z'						;compare al with letter 'Z'
				jg CheckLowerCaseLowerLimit		;jump if greater than to label CheckLowerCaseLowerLimit
				jmp ToLowerCase					;jump to label ToLowerCase to convert

CheckLowerCaseLowerLimit:
				cmp al, 'a'						;compare al with letter 'a'
				jge CheckLowerCaseUpperLimit	;jump if greater than to label CheckLowerCaseUpperLimit
				jmp NextIndex					;jump to label NextIndex to convert

CheckLowerCaseUpperLimit:
				cmp al, 'z'						;compare al with letter 'z'
				jle ToUpperCase					;jump if less than or equal to label ToUpperCase
				jmp NextIndex					;jump to label NextIndex to continue

ToUpperCase:	
				xor al, 32						;shift bit #6 to convert case
				jmp NextIndex					;jump to label next index after shifting bits

ToLowerCase:
				xor al, 32						;shift bit #6 to convert case
				
NextIndex:
				stosb							;store string byte
				lodsb							;loaded the first character into al
				jmp Looper						;loop back to label Looper to convert more characters

Done:
				lea rax, result					;store return address at the start of string
				pop rdi							;restore non-volatile
				pop rsi							;restore non-volatile
				ret								;return rax
ChangeCase		ENDP
END

comment~
Window Output Console:

HeLLO WHAT is YOUR name
hEllo what IS your NAME

HELLO WORLD hello world
hello world HELLO WORLD
~