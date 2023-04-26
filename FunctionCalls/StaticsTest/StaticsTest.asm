// bootstrap
@256
D=A
@SP
M=D

// call Sys.init
@_RETURN_LABEL_1
D=A
// push return-address

@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M

@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M

@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M

@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M

@SP
A=M
M=D
@SP
M=M+1

@SP
D=M
@5
D=D-A
@0
D=D-A
@ARG
M=D  // ARG = SP - n - 5
@SP
D=M
@LCL
M=D  // LCL = SP
@Sys.init
0;JMP  // goto function
(_RETURN_LABEL_1)
// function Class1.set
(Class1.set)

// push ARG 0
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// pop Class1.vm.0
@SP
AM=M-1
D=M
@Class1.vm.0
M=D
// push ARG 1
@ARG
D=M
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// pop Class1.vm.1
@SP
AM=M-1
D=M
@Class1.vm.1
M=D
// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// return
@LCL
D=M
@R13
M=D  // R13 = FRAME = LCL
@5
D=A
@R13
A=M-D
D=M  // D = *(FRAME-5) = return-address
@R14
M=D  // R14 = return-address
@SP
M=M-1
A=M
D=M
@ARG
A=M  // M = *ARG
M=D  // *ARG = pop()

@ARG
D=M+1
@SP
M=D  // SP = ARG + 1

@R13
AM=M-1  // A = FRAME-1, R13 = FRAME-1
D=M
@THAT
M=D  // THAT = *(FRAME-1)

@R13
AM=M-1
D=M
@THIS
M=D  // THIS = *(FRAME-2)

@R13
AM=M-1
D=M
@ARG
M=D  // ARG = *(FRAME-3)

@R13
AM=M-1
D=M
@LCL
M=D  // LCL = *(FRAME-4)

@R14
A=M
0;JMP  // goto return-address
// function Class1.get
(Class1.get)

// push Class1.vm.0
@Class1.vm.0
D=M
@SP
A=M
M=D
@SP
M=M+1
// push Class1.vm.1
@Class1.vm.1
D=M
@SP
A=M
M=D
@SP
M=M+1

@SP
AM=M-1
D=M
A=A-1
M=M-D
// return
@LCL
D=M
@R13
M=D  // R13 = FRAME = LCL
@5
D=A
@R13
A=M-D
D=M  // D = *(FRAME-5) = return-address
@R14
M=D  // R14 = return-address
@SP
M=M-1
A=M
D=M
@ARG
A=M  // M = *ARG
M=D  // *ARG = pop()

@ARG
D=M+1
@SP
M=D  // SP = ARG + 1

@R13
AM=M-1  // A = FRAME-1, R13 = FRAME-1
D=M
@THAT
M=D  // THAT = *(FRAME-1)

@R13
AM=M-1
D=M
@THIS
M=D  // THIS = *(FRAME-2)

@R13
AM=M-1
D=M
@ARG
M=D  // ARG = *(FRAME-3)

@R13
AM=M-1
D=M
@LCL
M=D  // LCL = *(FRAME-4)

@R14
A=M
0;JMP  // goto return-address
// function Sys.init
(Sys.init)

// push constant 6
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
// push constant 8
@8
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Class1.set
@_RETURN_LABEL_2
D=A
// push return-address

@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M

@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M

@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M

@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M

@SP
A=M
M=D
@SP
M=M+1

@SP
D=M
@5
D=D-A
@2
D=D-A
@ARG
M=D  // ARG = SP - n - 5
@SP
D=M
@LCL
M=D  // LCL = SP
@Class1.set
0;JMP  // goto function
(_RETURN_LABEL_2)
// pop R5 5
@R5
D=M
@5
D=D+A
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
// push constant 23
@23
D=A
@SP
A=M
M=D
@SP
M=M+1
// push constant 15
@15
D=A
@SP
A=M
M=D
@SP
M=M+1
// call Class2.set
@_RETURN_LABEL_3
D=A
// push return-address

@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M

@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M

@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M

@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M

@SP
A=M
M=D
@SP
M=M+1

@SP
D=M
@5
D=D-A
@2
D=D-A
@ARG
M=D  // ARG = SP - n - 5
@SP
D=M
@LCL
M=D  // LCL = SP
@Class2.set
0;JMP  // goto function
(_RETURN_LABEL_3)
// pop R5 5
@R5
D=M
@5
D=D+A
@R13
M=D
@SP
AM=M-1
D=M
@R13
A=M
M=D
// call Class1.get
@_RETURN_LABEL_4
D=A
// push return-address

@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M

@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M

@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M

@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M

@SP
A=M
M=D
@SP
M=M+1

@SP
D=M
@5
D=D-A
@0
D=D-A
@ARG
M=D  // ARG = SP - n - 5
@SP
D=M
@LCL
M=D  // LCL = SP
@Class1.get
0;JMP  // goto function
(_RETURN_LABEL_4)
// call Class2.get
@_RETURN_LABEL_5
D=A
// push return-address

@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M

@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M

@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M

@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M

@SP
A=M
M=D
@SP
M=M+1

@SP
D=M
@5
D=D-A
@0
D=D-A
@ARG
M=D  // ARG = SP - n - 5
@SP
D=M
@LCL
M=D  // LCL = SP
@Class2.get
0;JMP  // goto function
(_RETURN_LABEL_5)
(Sys.init$WHILE)
@Sys.init$WHILE
0;JMP
// function Class2.set
(Class2.set)

// push ARG 0
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// pop Class2.vm.0
@SP
AM=M-1
D=M
@Class2.vm.0
M=D
// push ARG 1
@ARG
D=M
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
// pop Class2.vm.1
@SP
AM=M-1
D=M
@Class2.vm.1
M=D
// push constant 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
// return
@LCL
D=M
@R13
M=D  // R13 = FRAME = LCL
@5
D=A
@R13
A=M-D
D=M  // D = *(FRAME-5) = return-address
@R14
M=D  // R14 = return-address
@SP
M=M-1
A=M
D=M
@ARG
A=M  // M = *ARG
M=D  // *ARG = pop()

@ARG
D=M+1
@SP
M=D  // SP = ARG + 1

@R13
AM=M-1  // A = FRAME-1, R13 = FRAME-1
D=M
@THAT
M=D  // THAT = *(FRAME-1)

@R13
AM=M-1
D=M
@THIS
M=D  // THIS = *(FRAME-2)

@R13
AM=M-1
D=M
@ARG
M=D  // ARG = *(FRAME-3)

@R13
AM=M-1
D=M
@LCL
M=D  // LCL = *(FRAME-4)

@R14
A=M
0;JMP  // goto return-address
// function Class2.get
(Class2.get)

// push Class2.vm.0
@Class2.vm.0
D=M
@SP
A=M
M=D
@SP
M=M+1
// push Class2.vm.1
@Class2.vm.1
D=M
@SP
A=M
M=D
@SP
M=M+1

@SP
AM=M-1
D=M
A=A-1
M=M-D
// return
@LCL
D=M
@R13
M=D  // R13 = FRAME = LCL
@5
D=A
@R13
A=M-D
D=M  // D = *(FRAME-5) = return-address
@R14
M=D  // R14 = return-address
@SP
M=M-1
A=M
D=M
@ARG
A=M  // M = *ARG
M=D  // *ARG = pop()

@ARG
D=M+1
@SP
M=D  // SP = ARG + 1

@R13
AM=M-1  // A = FRAME-1, R13 = FRAME-1
D=M
@THAT
M=D  // THAT = *(FRAME-1)

@R13
AM=M-1
D=M
@THIS
M=D  // THIS = *(FRAME-2)

@R13
AM=M-1
D=M
@ARG
M=D  // ARG = *(FRAME-3)

@R13
AM=M-1
D=M
@LCL
M=D  // LCL = *(FRAME-4)

@R14
A=M
0;JMP  // goto return-address
