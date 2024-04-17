	.section	.rodata
LC3:
	.string	"Hello, World!"
LC2:
	.string	"False"
LC4:
	.string	"__main__"
LC1:
	.string	"True"
LC0:
	.string	"%d\n"

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
	subq	$16, %rsp

	# s = "Hello, World!"
	movq	$LC3, %rax
	movq	%rax, -8(%rbp)

	# param s
	# call foo , 1
	movq	-8(%rbp), %rdi
	call	foo

	# t1 = popparam
	movq	%rax, -16(%rbp)

	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L1:
	# t1 = __name__ == "__main__"
	movq	-8(%rbp), %rax
	movq	$LC4, %rdx
	cmpq	%rdx, %rax
	sete	%al
	movb	%al, -9(%rbp)

	# if t1 goto L2
	movb	-9(%rbp), %al
	cmpb	$0, %al
	jg	L2

	# goto L3
	jmp	L3

L2:
	# call main , 0
	call	main

	# goto L4
	jmp	L4

L3:
L4:
