
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@main_body:
		MOV 	$10,-4(%14)
		MOV 	$0,-12(%14)
@switch0:
		JMP	@sw_test0
@sw(0)_case_0:
		MOV 	$1,-8(%14)
		JMP	@sw_exit0:
@sw(0)_case_1:
		MOV 	$2,-8(%14)
		JMP	@sw_exit0
@sw_test0:
		CMPS 	-4(%14),$10
		JEQ	@sw(0)_case_0
		CMPS 	-4(%14),$20
		JEQ	@sw(0)_case_1
@sw_exit0:
@switch1:
		JMP	@sw_test1
@sw(1)_case_0:
		MOV 	$1,-8(%14)
		JMP	@sw_exit1:
@sw(1)_case_1:
		MOV 	$2,-8(%14)
@default_sw1:
		MOV 	$66,-8(%14)
		JMP	@sw_exit1
@sw_test1:
		CMPS 	-8(%14),$0
		JEQ	@sw(1)_case_0
		CMPS 	-8(%14),$2
		JEQ	@sw(1)_case_1
		JMP	@default_sw1
@sw_exit1:
@switch2:
		JMP	@sw_test2
@sw(2)_case_0:
		MOV 	$1,-8(%14)
		JMP	@sw_exit2:
@sw(2)_case_1:
		MOV 	$2,-8(%14)
@sw(2)_case_2:
@if3:
		CMPS 	-12(%14),$0
		JLES	@false3
@true3:
		MOV 	$-6,-8(%14)
		JMP 	@exit3
@false3:
		MOV 	$88,-8(%14)
@exit3:
		JMP	@sw_exit3:
@default_sw3:
		MOV 	$0,-8(%14)
		JMP	@sw_exit3
@sw_test3:
		CMPS 	-8(%14),$55
		JEQ	@sw(3)_case_0
		CMPS 	-8(%14),$66
		JEQ	@sw(3)_case_1
		CMPS 	-8(%14),$70
		JEQ	@sw(3)_case_2
		JMP	@default_sw3
@sw_exit3:
		MOV 	-8(%14),%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET