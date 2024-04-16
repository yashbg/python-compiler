	.section	.rodata
.LC0:
	.string	"__main__"
.LC1:
	.string	"%d\n"

	.text

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
	.size	, .-

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
	leaq	0(%rax), %rdx

	movl	$5, %eax
	movl	%eax, (%rdx)

	# return
	leave
	ret

	# endfunc
	.size	, .-

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp

	# t1 = 8
	movl	$8, %eax
	movl	%eax, -4(%rbp)

	# call allocmem , 1
	movl	-4(%rbp), %edi
	call	malloc@PLT

	# t2 = popparam
	movq	%rax, -12(%rbp)

	# call A.__init__ , 1
	movq	-12(%rbp), %rdi
	call	A.__init__

	# t3 = popparam
	movq	%rax, -20(%rbp)

	# a = t3
	movq	-20(%rbp), %rax
	movq	%rax, -28(%rbp)

	# t4 = 12
	movl	$12, %eax
	movl	%eax, -32(%rbp)

	# call allocmem , 1
	movl	-32(%rbp), %edi
	call	malloc@PLT

	# t5 = popparam
	movq	%rax, -40(%rbp)

	# call B.__init__ , 1
	movq	-40(%rbp), %rdi
	call	B.__init__

	# t6 = popparam
	movq	%rax, -48(%rbp)

	# b = t6
	movq	-48(%rbp), %rax
	movq	%rax, -56(%rbp)

	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L1:
	# t1 = __name__ == "__main__"
	movl	-8(%rbp), %eax
	cmpl	$.LC0, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -9(%rbp)

	# if t1 goto L2
	movl	-9(%rbp), %eax
	cmpl	$0, %eax
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
