comment~
Author: Steven Bertolucci
Project: Project10A
Description:
Write a PROC CompareReal to compare two floating-point numbers, 
and return a code indicating which is larger (or if they are equal). 
Return -1 if the second number is smaller, 1 if the second number is 
larger, and 0 if they are equal.

Use C++ for input of the 2 numbers (ReadFloat), 
and for outputting the results (DisplayString).  
Do these things in main.  Use the FPU for the comparison. 
Use real4 values with an acceptable difference of .0003


Examples:

Enter 2 floating-point numbers: 1.25  1.26
The second number is larger.

Enter 2 floating-point numbers: 1.234  1.233
The second number is smaller.

Enter 2 floating-point numbers: 1.2345  1.23477
The numbers are the same.

 

Be very careful to copy the string literals exactly as shown above. 
The slightest difference, a space, period, anything different than what 
is shown above will cause the grader to mark your test as a failure.  
There should always be a space after a prompt!
~

extrn ExitProcess:      PROTO
extrn ReadFloat:        PROTO
extrn DisplayString:    PROTO

.data
prompt      byte        'Enter 2 floating-point numbers: ', 0
out1        byte        'The numbers are the same.', 0
out2        byte        'The second number is smaller.', 0 
out3        byte        'The second number is larger.', 0

sigma       real10      0.0003        ; tolerance for difference

.data?
number1     real4       ?
number2     real4       ?

.code
main    PROC
        finit                   ;initialize the FPU
        push rbp                ;reserve non-volatile
        mov rbp, rsp            ;make base pointer = stack pointer
        sub rsp, 32             ;reserve shadow space

        lea rcx, prompt         ;get prompt ready for output
        call DisplayString      ;display string
        lea rcx, number1        ;get number1 ready for reading
        call ReadFloat          ;read number1
        lea rcx, number2        ;get number2 ready for reading
        call ReadFloat          ;read number1 and number2
        call CompareReal        ;send values to procedure CompareReal

        cmp rax, 0              ;compare if returned value is equal
        je Display1             ;jump to label Display1

        cmp rax, -1             ;compare if returned value is smaller
        je Display2             ;jump to label Display2

        cmp rax, 1              ;compare if returned value is larger
        lea rcx, out3           ;get third output ready to display
        call DisplayString      ;display third message
        jmp Done                ;jump to label Done

Display1:   
        lea rcx, out1           ;get first output ready to display
        call DisplayString      ;display message
        jmp Done                ;jump to label Done

Display2:   
        lea rcx, out2           ;get second output ready to display
        call DisplayString      ;display message

Done:
        add rsp, 32             ;restore shadow space
        pop rbp                 ;restore non-volatile
        mov rcx, 0              ;exit code
        call ExitProcess        ;Windows exit
main    ENDP

CompareReal     PROC
        finit                   ;initialize the FPU
        fld number1             ;load number1 into st0
        fld number2             ;load number2 into st0, pushing number1 to st1
        fsub st, st(1)          ;difference with current value
        fabs                    ;get the absolute value of the difference
        fld sigma               ;load the result in sigma
        fcompp                  ;compare the criteria to the difference
        fstsw ax                ;retrieve comparison result in AX
        fwait                   ;wait for the fpu to finish
        sahf                    ;store ah into flags
        jae Equal               ;tolerance is greater than absolute difference
        fld number2             ;load number2 to compare
        fcompp                  ;compare two numbers
        fstsw ax                ;retrieve comparison result in AX
        fwait                   ;wait for the program to finish 
        sahf                    ;transfer condition codes to the flag register
        jb LessThan             ;jump to label LessThan if number2 is below number1
        ja GreaterThan          ;jump to label GreaterThan if number1 is above number2
LessThan:   
        mov rax, -1             ;store value -1 to rax for returning
        jmp Done                ;jump to label Done

GreaterThan:
        mov rax, 1              ;store value 1 to rax for returning
        jmp Done                ;jump to label Done

Equal:
        mov rax, 0              ;store value 0 to rax for returning

Done:
        ret                     ;return value of rax
CompareReal     ENDP
END

comment~
Window Output Console:

Enter 2 floating-point numbers: 2.2 44.3
The second number is larger.

Enter 2 floating-point numbers: 33.22 33.21
The second number is smaller.

Enter 2 floating-point numbers: 1.22 1.22
The numbers are the same.
~