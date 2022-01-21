comment ~
Author: Steven Bertolucci
Project: Project5C
Description: 

Write a multi-threaded program to perform matrix addition on two arrays of unsigned integers.
Matrix addition means that you will add element 1 from arr1  to element 1 of arr2, 
placing the sum in element 1 of arr3.  Another way of saying that is arr1(1) + arr2(1) -> arr3(1).  
Separately, you will add arr1(2) to arr2(2) and save the sum in arr3(2) etc................

arr1 is a 20 byte array containing the values 1, 2, 3, 4 ....20
arr2 is a 20 byte array containing the values 2, 3, 4, 5 ....21

arr3 is a 20 byte array containing the sum of arr1 + arr2
In this example, arr3 will contain 3, 5, 7, 9....41

The first 10 additions should be done by the main thread.  
The next 10 additions should be done in parallel using a separate thread.

Display arr3  using DisplayMemory in  IO.cpp.
~

extrn ExitProcess:				PROTO
extrn ExitThread:				PROTO
extrn CloseHandle:				PROTO
extrn OutputDebugStringA:		PROTO
extrn CreateThread:				PROTO
extrn WaitForSingleObjectEx:    PROTO
extrn DisplayMemory:			PROC

.data
tHandle		qword		0												;thread handle
id			qword		0												;thread ID
msg			byte		'arr1 is a 20 byte array containing the values 1, 2, 3, 4 ....20', 0ah, 0dh, 0
msg2		byte		'arr2 is a 20 byte array containing the values 2, 3, 4, 5 ....21', 0ah, 0dh, 0
msg3		byte		'arr3 will contain the values 3, 5, 7, 9 ....41 ', 0ah, 0dh, 0
array1		byte		1, 2, 3, 4, 5, 6, 7, 8, 9, 10					;variable to hold first half of array1
array2		byte		2, 3, 4, 5, 6, 7, 8, 9, 10, 11					;variable to hold first half of array2
array3		byte		11, 12, 13, 14, 15, 16, 17, 18, 19, 20			;variable to hold second half of array1
array4		byte		12, 13, 14, 15, 16, 17, 18, 19, 20, 21			;variable to hold second half of array2

.data?
array0		byte		10 dup (?)										;variable array0 to hold the first half of arr3
array5		byte		10 dup (?)										;variable array5 to hold the second half of arr3

.code
main		PROC
			push rbp											;save non-volatile
			mov rbp, rsp										;make frame pointer for stack
			sub rsp, 48											;reserve shadow space
			
			lea rcx, msg										;display output in debug window
			call OutputDebugStringA								;call OutputDebugString

			xor rcx, rcx										;parm1 Security Attributes
			xor rdx, rdx										;parm2 stacksize (null=default size)
			lea r8, myThread									;parm3 Pointer to thread PROC
			xor r9, r9											;parm4 parameter to pass to thread
			mov qword ptr[rsp + 40], 0							;parm5 run/suspend flag (null = run)
			lea rbx, id											;&id
			mov [rsp + 48], rbx									;parm6 pointer to thread ID
			call CreateThread									;call CreateThread
			add rsp, 16											;repair stack after call
			cmp rax, 0											;check here for errors
			mov tHandle, rax									;save handle
			
			mov rcx, 8fffffh									;do other stuff while myThread runs		
			mov rcx, lengthof array3							;loop counter rcx = 10
			lea r8, array1										;first half arr1
			lea rdx, array2										;second half arr2
			lea r9, array0										;first half arr3
Loop1:		
			mov al, byte ptr [r8 + rcx - 1]						;al = (first half or arr1) at index [rcx -1]
			add al, byte ptr [rdx + rcx - 1]					;al += (first half of arr2) at index [rcx - 1]
			mov byte ptr [r9 + rcx - 1], al						;move value of al into (first half of arr3) at index [rcx - 1]
			loop Loop1											;loop back to loop1
				
			
			mov rcx, tHandle									;thread handle
			mov rdx, 50000										;MAX time to wait (mSec)
			call WaitForSingleObjectEx							;call WaitForSingleOBject
			

			mov rcx, tHandle									;finish with thread handle
			call CloseHandle									;return non-0 on success

			lea rcx, array0										;load effective address of array0
			mov rdx, lengthof array0 + lengthof array5			;#bytes acutally display
			call DisplayMemory									;display the sum

			add rsp, 48											;restore shadow space
			pop rbp												;restore non-volatile
			mov rcx, 1											;return code
			call ExitProcess									;Windows exit
main		ENDP

myThread	PROC
			push rbp											;save non-volatile
			mov rbp, rsp										;save shadow space to rbp
			sub rsp, 32											;reserve shadow space

			lea rcx, msg2										;display in output window
			call OutputDebugStringA								;Call OutputDebugString
											
			mov rcx, lengthof array3							;loop counter rcx = 10
			lea rdx, array3										;load effective address of array3 to rdx
			lea r8, array4										;load effective address of array4 to r8
			lea r9, array5										;load effective address of array5 to r9
Loop1:		
			mov al, byte ptr [rdx + rcx - 1]					;al = first value in array
			add al, byte ptr [r8 + rcx -1]						;al = first value in array
			mov byte ptr [r9 + rcx - 1], al						;move value of al
			loop Loop1											;loop back to loop1
		
			lea rcx, msg3										;parm2 = ascii message 'arr3 will...'
			call OutputDebugStringA								;call Output Debug Window

			add rsp, 32											;restore shadow space
			pop rbp												;restore non-volatile
			mov rcx, 1234h										;return code
			call ExitThread										;Stop this thread
myThread	ENDP
END

comment ~
Console Output Window:

arr1 is a 20 byte array containing the values 1, 2, 3, 4 ....20

arr2 is a 20 byte array containing the values 2, 3, 4, 5 ....21

arr3 will contain the values 3, 5, 7, 9 ....41

Console Debug Window:

03 05 07 09 0b 0d 0f 11 13 15 17 19 1b 1d 1f 21 23 25 27 29

~




