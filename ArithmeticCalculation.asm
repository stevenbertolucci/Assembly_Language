comment~
Author: Steven Bertolucci
Project: Project8B
Description: 

Declare the following:

numA   dword   11
numB   dword   3
numC   dword   5
numD   dword   17
result   dword   ?

Now, write the code necessary to compute:

;result = numD - ((numA / numB) * numC) + (numD % numC)
% means modulus, which is remainder after division

No input is needed. Show your output with a call to DisplayInt (IO.cpp).  
ExitProcess should return the result. Try and code this in 14 lines or less
in your code segment, and only the data segment variables shown above.
~

extrn ExitProcess:		PROTO
extrn DisplayInt:		PROTO

.data
numA	dword	11
numB	dword	3
numC	dword	5
numD	dword	17

.data?
result	dword	?

.code
main		PROC
	
			sub rsp, 32										;reserve shadow space
			mov ebx, 0										;initialized ebx
			mov eax, dword ptr [numA]						;move value of numA to eax
			mov ebx, dword ptr [numB]						;move value of NumB to ebx
			xor edx, edx									;set edx = 0

			;(numA / numB)
			div ebx											;(numA / numB) quotient in EAX
			mov ebx, eax									;store eax (numA / numB) in temp ebx

			;(numA / numB) * numC)
			mov ebx, dword ptr [numC]						;move value of numC to ebx
			mul ebx											;result of (numA / numB) multiplies with numC
			mov esi, eax									;store value of eax into temp esi
			mov ebx, 0										;set ebx to 0
			mov eax, dword ptr [numD]						;move value of numD to eax
			mov ebx, dword ptr [numC]						;mov value of numC to ebx
			xor edx, edx									;edx = 0
			
			;(numD % numC)
			div ebx											;(numD % numC) remainder in ebx

			;((numA / numB) * numC) + (numD % numC)
			add esi, edx									;add remainder (edx) with value of esi

			neg esi											;make esi negative

			;numD - ((numA / numB) * numC) + (numD % numC)
			add esi, dword ptr [numD]						;numD - value of esi
			
			;store numD - ((numA / numB) * numC) + (numD % numC) in result
			mov result, esi									;store value of esi to result
			lea rcx, result									;get handle ready for DisplayInt
			call DisplayInt									;display int

			add rsp, 32										;restore shadow space
			mov rcx, 0										;exit code
			call ExitProcess								;windows exit

main		ENDP
END

comment~
Window Output Console: 

0

~