	.section	.rodata
LC5:
	.string	"Recursive function"
LC6:
	.string	"Iterative function"
LC4:
	.string	"Fibonacci sequence:"
LC3:
	.string	"Plese enter a positive integer"
LC2:
	.string	"False"
LC8:
	.string	"__main__"
LC1:
	.string	"True"
LC7:
	.string	"Catalan sequence:"
LC0:
	.string	"%d\n"

	.text

	.globl	recur_fibo
	.type	recur_fibo, @function
recur_fibo:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	%edi, -4(%rbp)

L1:
	# t1 = n <= 1
	movl	-4(%rbp), %eax
	cmpl	$1, %eax
	setle	%al
	movb	%al, -5(%rbp)

	# if t1 goto L2
	movb	-5(%rbp), %al
	cmpb	$0, %al
	jg	L2

	# goto L3
	jmp	L3

L2:
	# push n
	movl	-4(%rbp), %eax

	# return
	leave
	ret

	# goto L4
	jmp	L4

L3:
	# t2 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -9(%rbp)

	# t3 = n + t2
	movl	-4(%rbp), %eax
	addl	-9(%rbp), %eax
	movl	%eax, -13(%rbp)

	# param t3
	# call recur_fibo , 1
	movl	-13(%rbp), %edi
	call	recur_fibo

	# t4 = popparam
	movl	%eax, -17(%rbp)

	# t5 = - 2
	movl	$2, %eax
	negl	%eax
	movl	%eax, -21(%rbp)

	# t6 = n + t5
	movl	-4(%rbp), %eax
	addl	-21(%rbp), %eax
	movl	%eax, -25(%rbp)

	# param t6
	# call recur_fibo , 1
	movl	-25(%rbp), %edi
	call	recur_fibo

	# t7 = popparam
	movl	%eax, -29(%rbp)

	# t8 = t4 + t7
	movl	-17(%rbp), %eax
	addl	-29(%rbp), %eax
	movl	%eax, -33(%rbp)

	# push t8
	movl	-33(%rbp), %eax

	# return
	leave
	ret

L4:
	# return
	leave
	ret

	# endfunc
	.size	recur_fibo, .-recur_fibo

	.globl	iter_fibo
	.type	iter_fibo, @function
iter_fibo:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	%edi, -4(%rbp)

L5:
	# t1 = n <= 1
	movl	-4(%rbp), %eax
	cmpl	$1, %eax
	setle	%al
	movb	%al, -5(%rbp)

	# if t1 goto L6
	movb	-5(%rbp), %al
	cmpb	$0, %al
	jg	L6

	# goto L7
	jmp	L7

L6:
	# push n
	movl	-4(%rbp), %eax

	# return
	leave
	ret

	# goto L8
	jmp	L8

L7:
	# a = 1
	movl	$1, %eax
	movl	%eax, -9(%rbp)

	# b = 0
	movl	$0, %eax
	movl	%eax, -13(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -17(%rbp)

	# i = 1
	movl	$1, %eax
	movl	%eax, -17(%rbp)

L9:
	# if i<n goto L10
	movl	-17(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jl	L10

	# goto L11
	jmp	L11

L10:
	# t2 = a + b
	movl	-9(%rbp), %eax
	addl	-13(%rbp), %eax
	movl	%eax, -21(%rbp)

	# a = t2
	movl	-21(%rbp), %eax
	movl	%eax, -9(%rbp)

	# t3 = - b
	movl	-13(%rbp), %eax
	negl	%eax
	movl	%eax, -25(%rbp)

	# t4 = a + t3
	movl	-9(%rbp), %eax
	addl	-25(%rbp), %eax
	movl	%eax, -29(%rbp)

	# b = t4
	movl	-29(%rbp), %eax
	movl	%eax, -13(%rbp)

	# t5 = i
	movl	-17(%rbp), %eax
	movl	%eax, -33(%rbp)

	# i = t5 + 1
	movl	-33(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -17(%rbp)

	# goto L9
	jmp	L9

L11:
	# push a
	movl	-9(%rbp), %eax

	# return
	leave
	ret

L8:
	# return
	leave
	ret

	# endfunc
	.size	iter_fibo, .-iter_fibo

	.globl	catalan
	.type	catalan, @function
catalan:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movl	%edi, -4(%rbp)

L12:
	# t1 = n <= 1
	movl	-4(%rbp), %eax
	cmpl	$1, %eax
	setle	%al
	movb	%al, -5(%rbp)

	# if t1 goto L13
	movb	-5(%rbp), %al
	cmpb	$0, %al
	jg	L13

	# goto L14
	jmp	L14

L13:
	# push 1
	movl	$1, %eax

	# return
	leave
	ret

	# goto L15
	jmp	L15

L14:
L15:
	# res = 0
	movl	$0, %eax
	movl	%eax, -9(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -13(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -13(%rbp)

L16:
	# if i<n goto L17
	movl	-13(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jl	L17

	# goto L18
	jmp	L18

L17:
	# param i
	# call catalan , 1
	movl	-13(%rbp), %edi
	call	catalan

	# t2 = popparam
	movl	%eax, -17(%rbp)

	# t3 = - i
	movl	-13(%rbp), %eax
	negl	%eax
	movl	%eax, -21(%rbp)

	# t4 = t3 - 1
	movl	-21(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -25(%rbp)

	# t5 = n + t4
	movl	-4(%rbp), %eax
	addl	-25(%rbp), %eax
	movl	%eax, -29(%rbp)

	# param t5
	# call catalan , 1
	movl	-29(%rbp), %edi
	call	catalan

	# t6 = popparam
	movl	%eax, -33(%rbp)

	# t7 = t2 * t6
	movl	-17(%rbp), %eax
	imull	-33(%rbp), %eax
	movl	%eax, -37(%rbp)

	# t8 = res + t7
	movl	-9(%rbp), %eax
	addl	-37(%rbp), %eax
	movl	%eax, -41(%rbp)

	# res = t8
	movl	-41(%rbp), %eax
	movl	%eax, -9(%rbp)

	# t9 = i
	movl	-13(%rbp), %eax
	movl	%eax, -45(%rbp)

	# i = t9 + 1
	movl	-45(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -13(%rbp)

	# goto L16
	jmp	L16

L18:
	# push res
	movl	-9(%rbp), %eax

	# return
	leave
	ret

	# return
	leave
	ret

	# endfunc
	.size	catalan, .-catalan

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp

	# nterms = 10
	movl	$10, %eax
	movl	%eax, -4(%rbp)

L19:
	# t1 = nterms <= 0
	movl	-4(%rbp), %eax
	cmpl	$0, %eax
	setle	%al
	movb	%al, -5(%rbp)

	# if t1 goto L20
	movb	-5(%rbp), %al
	cmpb	$0, %al
	jg	L20

	# goto L21
	jmp	L21

L20:
	# param "Plese enter a positive integer"
	# call print , 1
	movq	$LC3, %rdi
	call	puts@PLT

	# goto L22
	jmp	L22

L21:
	# param "Fibonacci sequence:"
	# call print , 1
	movq	$LC4, %rdi
	call	puts@PLT

	# i = 0
	movl	$0, %eax
	movl	%eax, -9(%rbp)

	# param "Recursive function"
	# call print , 1
	movq	$LC5, %rdi
	call	puts@PLT

L23:
	# t2 = i < nterms
	movl	-9(%rbp), %eax
	cmpl	-4(%rbp), %eax
	setl	%al
	movb	%al, -10(%rbp)

	# if t2 goto L24
	movb	-10(%rbp), %al
	cmpb	$0, %al
	jg	L24

	# goto L25
	jmp	L25

L24:
	# param i
	# call recur_fibo , 1
	movl	-9(%rbp), %edi
	call	recur_fibo

	# t3 = popparam
	movl	%eax, -14(%rbp)

	# param t3
	# call print , 1
	movl	-14(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# t4 = i + 1
	movl	-9(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -18(%rbp)

	# i = t4
	movl	-18(%rbp), %eax
	movl	%eax, -9(%rbp)

	# goto L23
	jmp	L23

L25:
	# i = 0
	movl	$0, %eax
	movl	%eax, -9(%rbp)

	# param "Iterative function"
	# call print , 1
	movq	$LC6, %rdi
	call	puts@PLT

L26:
	# t5 = i < nterms
	movl	-9(%rbp), %eax
	cmpl	-4(%rbp), %eax
	setl	%al
	movb	%al, -19(%rbp)

	# if t5 goto L27
	movb	-19(%rbp), %al
	cmpb	$0, %al
	jg	L27

	# goto L28
	jmp	L28

L27:
	# param i
	# call iter_fibo , 1
	movl	-9(%rbp), %edi
	call	iter_fibo

	# t6 = popparam
	movl	%eax, -23(%rbp)

	# param t6
	# call print , 1
	movl	-23(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# t7 = i + 1
	movl	-9(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -27(%rbp)

	# i = t7
	movl	-27(%rbp), %eax
	movl	%eax, -9(%rbp)

	# goto L26
	jmp	L26

L28:
	# param "Catalan sequence:"
	# call print , 1
	movq	$LC7, %rdi
	call	puts@PLT

	# i = 0
	movl	$0, %eax
	movl	%eax, -9(%rbp)

L29:
	# t8 = i < nterms
	movl	-9(%rbp), %eax
	cmpl	-4(%rbp), %eax
	setl	%al
	movb	%al, -28(%rbp)

	# if t8 goto L30
	movb	-28(%rbp), %al
	cmpb	$0, %al
	jg	L30

	# goto L31
	jmp	L31

L30:
	# param i
	# call catalan , 1
	movl	-9(%rbp), %edi
	call	catalan

	# t9 = popparam
	movl	%eax, -32(%rbp)

	# param t9
	# call print , 1
	movl	-32(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# t10 = i + 1
	movl	-9(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -36(%rbp)

	# i = t10
	movl	-36(%rbp), %eax
	movl	%eax, -9(%rbp)

	# goto L29
	jmp	L29

L31:
L22:
	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L32:
	# t1 = __name__ == "__main__"
	movq	-8(%rbp), %rax
	movq	$LC8, %rdx
	cmpq	%rdx, %rax
	sete	%al
	movb	%al, -9(%rbp)

	# if t1 goto L33
	movb	-9(%rbp), %al
	cmpb	$0, %al
	jg	L33

	# goto L34
	jmp	L34

L33:
	# call main , 0
	call	main

	# goto L35
	jmp	L35

L34:
L35:
