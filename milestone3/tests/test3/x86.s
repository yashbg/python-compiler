	.section	.rodata
LC17:
	.string	"__main__"
LC16:
	.string	"String 1 is greater than or equal to String 2"
LC15:
	.string	"String 1 is less than or equal to String 2"
LC13:
	.string	"String 1 is greater than String 2"
LC1:
	.string	"True"
LC2:
	.string	"False"
LC3:
	.string	"Hello, World!"
LC4:
	.string	"abc"
LC6:
	.string	"String 1:"
LC7:
	.string	"String 2:"
LC14:
	.string	"<= >= check:"
LC0:
	.string	"%d\n"
LC9:
	.string	"Strings are equal"
LC5:
	.string	"xyz"
LC10:
	.string	"Strings are not equal"
LC11:
	.string	"< > check:"
LC8:
	.string	"== != check:"
LC12:
	.string	"String 1 is less than String 2"

	.text

	.globl	foo
	.type	foo, @function
foo:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)

	# param s
	# call print , 1
	movq	-8(%rbp), %rdi
	call	puts@PLT

	# return
	leave
	ret

	# endfunc
	.size	foo, .-foo

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp

	# s = "Hello, World!"
	movq	$LC3, %rax
	movq	%rax, -8(%rbp)

	# param s
	# call foo , 1
	movq	-8(%rbp), %rdi
	call	foo

	# t1 = popparam
	movq	%rax, -16(%rbp)

	# s1 = "abc"
	movq	$LC4, %rax
	movq	%rax, -24(%rbp)

	# s2 = "xyz"
	movq	$LC5, %rax
	movq	%rax, -32(%rbp)

	# param "String 1:"
	# call print , 1
	movq	$LC6, %rdi
	call	puts@PLT

	# param s1
	# call foo , 1
	movq	-24(%rbp), %rdi
	call	foo

	# t2 = popparam
	movq	%rax, -40(%rbp)

	# param "String 2:"
	# call print , 1
	movq	$LC7, %rdi
	call	puts@PLT

	# param s2
	# call foo , 1
	movq	-32(%rbp), %rdi
	call	foo

	# t3 = popparam
	movq	%rax, -48(%rbp)

	# param "== != check:"
	# call print , 1
	movq	$LC8, %rdi
	call	puts@PLT

L1:
	# t4 = s1 == s2
	movq	-24(%rbp), %rax
	movq	-32(%rbp), %rdx
	cmpq	%rdx, %rax
	sete	%al
	movb	%al, -49(%rbp)

	# if t4 goto L2
	movb	-49(%rbp), %al
	cmpb	$0, %al
	jg	L2

	# goto L3
	jmp	L3

L2:
	# param "Strings are equal"
	# call foo , 1
	movq	$LC9, %rdi
	call	foo

	# t5 = popparam
	movq	%rax, -57(%rbp)

	# goto L4
	jmp	L4

L3:
L5:
	# t6 = s1 != s2
	movq	-24(%rbp), %rax
	movq	-32(%rbp), %rdx
	cmpq	%rdx, %rax
	setne	%al
	movb	%al, -58(%rbp)

	# if t6 goto L6
	movb	-58(%rbp), %al
	cmpb	$0, %al
	jg	L6

	# goto L7
	jmp	L7

L6:
	# param "Strings are not equal"
	# call foo , 1
	movq	$LC10, %rdi
	call	foo

	# t7 = popparam
	movq	%rax, -66(%rbp)

	# goto L4
	jmp	L4

L7:
L4:
	# param "< > check:"
	# call print , 1
	movq	$LC11, %rdi
	call	puts@PLT

L8:
	# t8 = s1 < s2
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	strcmp@PLT
	testl	 %eax, %eax
	setl	 %al
	movb	 %al, -67(%rbp)

	# if t8 goto L9
	movb	-67(%rbp), %al
	cmpb	$0, %al
	jg	L9

	# goto L10
	jmp	L10

L9:
	# param "String 1 is less than String 2"
	# call foo , 1
	movq	$LC12, %rdi
	call	foo

	# t9 = popparam
	movq	%rax, -75(%rbp)

	# goto L11
	jmp	L11

L10:
L12:
	# t10 = s1 > s2
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	 strcmp@PLT
	testl	 %eax, %eax
	setg	 %al
	movb	 %al, -76(%rbp)

	# if t10 goto L13
	movb	-76(%rbp), %al
	cmpb	$0, %al
	jg	L13

	# goto L14
	jmp	L14

L13:
	# param "String 1 is greater than String 2"
	# call foo , 1
	movq	$LC13, %rdi
	call	foo

	# t11 = popparam
	movq	%rax, -84(%rbp)

	# goto L11
	jmp	L11

L14:
L11:
	# param "<= >= check:"
	# call print , 1
	movq	$LC14, %rdi
	call	puts@PLT

L15:
	# t12 = s1 <= s2
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	 strcmp@PLT
	testl	 %eax, %eax
	setle	 %al
	movb	 %al, -85(%rbp)

	# if t12 goto L16
	movb	-85(%rbp), %al
	cmpb	$0, %al
	jg	L16

	# goto L17
	jmp	L17

L16:
	# param "String 1 is less than or equal to String 2"
	# call foo , 1
	movq	$LC15, %rdi
	call	foo

	# t13 = popparam
	movq	%rax, -93(%rbp)

	# goto L18
	jmp	L18

L17:
L19:
	# t14 = s1 >= s2
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	 strcmp@PLT
	testl	 %eax, %eax
	setge	 %al
	movb	 %al, -94(%rbp)

	# if t14 goto L20
	movb	-94(%rbp), %al
	cmpb	$0, %al
	jg	L20

	# goto L21
	jmp	L21

L20:
	# param "String 1 is greater than or equal to String 2"
	# call foo , 1
	movq	$LC16, %rdi
	call	foo

	# t15 = popparam
	movq	%rax, -102(%rbp)

	# goto L18
	jmp	L18

L21:
L18:
	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L22:
	# t1 = __name__ == "__main__"
	movq	-8(%rbp), %rax
	movq	$LC17, %rdx
	cmpq	%rdx, %rax
	sete	%al
	movb	%al, -9(%rbp)

	# if t1 goto L23
	movb	-9(%rbp), %al
	cmpb	$0, %al
	jg	L23

	# goto L24
	jmp	L24

L23:
	# call main , 0
	call	main

	# goto L25
	jmp	L25

L24:
L25:
