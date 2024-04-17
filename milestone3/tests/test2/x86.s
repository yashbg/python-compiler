	.section	.rodata
LC4:
	.string	"__main__"
LC3:
	.string	"b:"
LC2:
	.string	""
LC1:
	.string	"a:"
LC0:
	.string	"%d\n"

	.text

	.globl	A.__init__
	.type	A.__init__, @function
A.__init__:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)

	# self.x = 1
	movq	-16(%rbp), %rax
	leaq	0(%rax), %rdx

	movl	$1, %eax
	movl	%eax, (%rdx)

	# self.y = 3
	movq	-16(%rbp), %rax
	leaq	4(%rax), %rdx

	movl	$3, %eax
	movl	%eax, (%rdx)

	# return
	leave
	ret

	# endfunc
	.size	A.__init__, .-A.__init__

	.globl	B.__init__
	.type	B.__init__, @function
B.__init__:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)

	# self.x = 1
	movq	-16(%rbp), %rax
	leaq	0(%rax), %rdx

	movl	$1, %eax
	movl	%eax, (%rdx)

	# self.y = 3
	movq	-16(%rbp), %rax
	leaq	4(%rax), %rdx

	movl	$3, %eax
	movl	%eax, (%rdx)

	# self.z = 5
	movq	-16(%rbp), %rax
	leaq	8(%rax), %rdx

	movl	$5, %eax
	movl	%eax, (%rdx)

	# return
	leave
	ret

	# endfunc
	.size	B.__init__, .-B.__init__

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp

	# t1 = 8
	movl	$8, %eax
	movl	%eax, -4(%rbp)

	# param t1
	# call allocmem , 1
	movl	-4(%rbp), %edi
	call	malloc@PLT

	# t2 = popparam
	movq	%rax, -12(%rbp)

	# param t2
	# call A.__init__ , 1
	movq	-12(%rbp), %rdi
	call	A.__init__

	# a = t2
	movq	-12(%rbp), %rax
	movq	%rax, -20(%rbp)

	# t3 = 12
	movl	$12, %eax
	movl	%eax, -24(%rbp)

	# param t3
	# call allocmem , 1
	movl	-24(%rbp), %edi
	call	malloc@PLT

	# t4 = popparam
	movq	%rax, -32(%rbp)

	# param t4
	# call B.__init__ , 1
	movq	-32(%rbp), %rdi
	call	B.__init__

	# b = t4
	movq	-32(%rbp), %rax
	movq	%rax, -40(%rbp)

	# param "a:"
	# call print , 1
	movq	$LC1, %rdi
	call	puts@PLT

	# param a.x
	# call print , 1
	movq	-20(%rbp), %rax
	leaq	0(%rax), %rdx

	movl	(%rdx), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# param a.y
	# call print , 1
	movq	-20(%rbp), %rax
	leaq	4(%rax), %rdx

	movl	(%rdx), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# param ""
	# call print , 1
	movq	$LC2, %rdi
	call	puts@PLT

	# param "b:"
	# call print , 1
	movq	$LC3, %rdi
	call	puts@PLT

	# param b.x
	# call print , 1
	movq	-40(%rbp), %rax
	leaq	0(%rax), %rdx

	movl	(%rdx), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# param b.y
	# call print , 1
	movq	-40(%rbp), %rax
	leaq	4(%rax), %rdx

	movl	(%rdx), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# param b.z
	# call print , 1
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx

	movl	(%rdx), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

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
