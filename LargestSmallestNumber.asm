comment ~
Author: Steven Bertolucci
Project: Project4D
Description: 

Write a MASM program which reads a series of signed integer numbers, 
and displays the largest and smallest value entered. Zero will be 
used to terminate the input (and 0 will not be counted as one of the values).

Use  C++ I/O functions.  Example (user input in boldface):

Enter a series of numbers:
1
300
-17
24
0

Largest: 300
Smallest: -17

 

Enter a series of numbers:
100
250
500
0

Largest: 500
Smallest: 100

If the first value entered is 0, the program 
should end without displaying anything. 
If only one value is entered before the 0, that 
value should be reported as both the largest and smallest.

Include the output from several test runs demonstrating 
that your code works correctly. Paste the test runs into 
your MASM code following the END directive. Submit only your masm code.
~

extrn ExitProcess:      PROTO
extrn ReadInt:          PROC
extrn DisplayInt:       PROC
extrn DisplayString:    PROC
extrn DisplayNewline:   PROC

.data
prompt      byte        'Please enter a series of integer or 0 to exit: ', 0
largest     byte        'Largest: ',0
smallest    byte        'Smallest: ',0

.data?
input       dword       ?                               ;variable to store user input
largeNum    dword       ?                               ;variable to store largest value
smallNum    dword       ?                               ;variable to store smallest value

.code
main        PROC

                push rbp                                ;reserve base pointer rbp
                sub rsp, 32                             ;reserve shadow space


                mov rcx, offset prompt                  ;display number of bytes 
                call DisplayString                      ;display 'Please enter a series of integer or 0 to exit: '
                call DisplayNewline                     ;create a newline after the prompt
    
                mov rcx, offset input                   ;display number of bytes
                call ReadInt                            ;read the user input 

        ;TODO Logic for comparing user input

inputIsZero:    cmp input, 0                            ;check to see if user enters 0
                jz Exit                                 ;if it is 0 jump to Exit
                mov edx, input                          ;store input value into edx
                mov largeNum, edx                       ;store input into largeNum variable
                mov smallNum, edx                       ;store input into smallNum variable

NotZero:        mov rcx, offset input                   ;if input is not zero, store the integers
                call ReadInt                            ;read user input
                cmp input, 0                            ;finish the program if user enters 0
                jz Done                                 ;finish taking input if user enters 0
                mov edx, input                          ;move variable input to edx
                cmp edx, largeNum                       ;comapre input with largest number
                jle NotLarger                           ;if input was Less Than or Equal to largeNum, skip to small check
                mov largeNum, edx                       ;input was larger than large Num, so replace largerNum with input
                jmp NotZero                             ;keep reading input until user enters 0  
       
NotLarger:                                              ;input wasn't the new largest number
                cmp edx, smallNum                       ;compare input with smallest number
                jge NotZero                             ;if input was Greater than or equal to smallNum, go back to "loop"
                mov smallNum, edx                       ;input was smaller than smallNum, so replace smallNum with input
                jmp NotZero                             ;keep reading input until user enters 0
                               
Done:

                call DisplayNewLine                     ;create a space between outputs

                mov rcx, offset largest                 ;display number of bytes
                call DisplayString                      ;Display 'Largest: '
                mov rcx, offset largeNum                ;Display number of bytes
                call DisplayInt                         ;Display the largest integer
                call DisplayNewline                     ;Display newline to separate the words

                mov rcx, offset smallest                ;Display number of bytes
                call DisplayString                      ;Display 'Smallest: '
                mov rcx, offset smallNum                ;display number of bytes
                call DisplayInt                         ;Display the smallest integer
                call DisplayNewline                     ;Display new line


Exit:
                add rsp, 32                             ;restore shadow space
                pop rbp                                 ;restore base pointer rbp
                mov rcx, 0                              ;return code
                call ExitProcess                        ;windows exit
main    ENDP
END

comment~

Window Console Output:

Please enter a series of integer or 0 to exit:
4
-3
5
8
0

Largest: 8
Smallest: -3

Please enter a series of integer or 0 to exit:
1
2
3
4
5
0

Largest: 5
Smallest: 1

Please enter a series of integer or 0 to exit:
298
345
-1342
55
-39
872
0

Largest: 872
Smallest: -1342

Please enter a series of integer or 0 to exit:
1
0

Largest: 1
Smallest: 1

~