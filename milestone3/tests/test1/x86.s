bubbleSort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movl	%edi, -8(%rbp)
	movl	%esi, -12(%rbp)

	movl	$0, %eax
	movl	%eax, -16(%rbp)

L1:
	jmp	L3

L2:
	movl	$0, %eax
	movl	%eax, -17(%rbp)

	movl	$0, %eax
	movl	%eax, -21(%rbp)

	movl	-16(%rbp), %eax
	negl	%eax
	movl	%eax, -25(%rbp)

	movl	-25(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -29(%rbp)

	movl	-12(%rbp), %eax
	addl	-29(%rbp), %eax
	movl	%eax, -33(%rbp)

	movl	$0, %eax
	movl	%eax, -21(%rbp)

L4:
	jmp	L6

L5:
L7:
	movl	-21(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -37(%rbp)

	movl	-37(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -41(%rbp)

	movl	-21(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -45(%rbp)

	movl	-45(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -49(%rbp)

	movl	-49(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -53(%rbp)

	movl	-41(%rbp), %eax
	cmpl	-53(%rbp), %eax
	setg	%al
	movzbl	%al, %eax
	movl	%eax, -54(%rbp)

	jmp	L9

L8:
	movl	-21(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -58(%rbp)

	movl	-58(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -62(%rbp)

	movl	-62(%rbp), %eax
	movl	%eax, -66(%rbp)

	movl	-21(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -70(%rbp)

	movl	-21(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -78(%rbp)

	movl	-78(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -82(%rbp)

	movl	-82(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -86(%rbp)

	movl	-70(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-86(%rbp), %eax
	movl	%eax, (%rdx)

	movl	-21(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -90(%rbp)

	movl	-90(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -94(%rbp)

	movl	-94(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-66(%rbp), %eax
	movl	%eax, (%rdx)

	movl	$1, %eax
	movl	%eax, -17(%rbp)

	jmp	L10

L9:
L10:
	movl	-21(%rbp), %eax
	movl	%eax, -102(%rbp)

	movl	-102(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -21(%rbp)

	jmp	L4

L6:
L11:
	movl	-17(%rbp), %eax
	cmpl	$0, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -103(%rbp)

	jmp	L13

L12:
	jmp	L3

	jmp	L14

L13:
L14:
	movl	-16(%rbp), %eax
	movl	%eax, -107(%rbp)

	movl	-107(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)

	jmp	L1

L3:
	leave
	ret

insertionSort:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$96, %rsp
	movl	%edi, -8(%rbp)
	movl	%esi, -12(%rbp)

	movl	$0, %eax
	movl	%eax, -16(%rbp)

	movl	$1, %eax
	movl	%eax, -16(%rbp)

L15:
	jmp	L17

L16:
	movl	-16(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -20(%rbp)

	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -24(%rbp)

	movl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)

	movl	$1, %eax
	negl	%eax
	movl	%eax, -32(%rbp)

	movl	-16(%rbp), %eax
	addl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)

	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)

L18:
	movl	-40(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -45(%rbp)

	movl	-45(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -49(%rbp)

	movl	-28(%rbp), %eax
	cmpl	-49(%rbp), %eax
	setl	%al
	movzbl	%al, %eax
	movl	%eax, -50(%rbp)

	movl	-41(%rbp), %eax
	cmpl	$0, %eax
	setne	%al
	movzbl	%al, %eax
	movl	%eax, -51(%rbp)

	jmp	L20

L19:
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -55(%rbp)

	movl	-55(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -59(%rbp)

	movl	-40(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -67(%rbp)

	movl	-67(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -71(%rbp)

	movl	-59(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-71(%rbp), %eax
	movl	%eax, (%rdx)

	movl	-40(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -40(%rbp)

	jmp	L18

L20:
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -75(%rbp)

	movl	-75(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -79(%rbp)

	movl	-79(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-28(%rbp), %eax
	movl	%eax, (%rdx)

	movl	-16(%rbp), %eax
	movl	%eax, -87(%rbp)

	movl	-87(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)

	jmp	L15

L17:
	leave
	ret

main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp

	movl	$2, %eax
	negl	%eax
	movl	%eax, -4(%rbp)

	movl	$9, %eax
	negl	%eax
	movl	%eax, -8(%rbp)

	movl	$20, %r9d
	call	allocmem

	movl	%eax, -16(%rbp)

	movq	-16(%rbp), %rax
	leaq	0(%rax), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)

	movq	-16(%rbp), %rax
	leaq	4(%rax), %rdx
	movl	$45, %eax
	movl	%eax, (%rdx)

	movq	-16(%rbp), %rax
	leaq	8(%rax), %rdx
	movl	$0, %eax
	movl	%eax, (%rdx)

	movq	-16(%rbp), %rax
	leaq	12(%rax), %rdx
	movl	$11, %eax
	movl	%eax, (%rdx)

	movq	-16(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	movl	%eax, (%rdx)

	movl	-16(%rbp), %eax
	movl	%eax, -24(%rbp)

	movl	$2, %eax
	negl	%eax
	movl	%eax, -28(%rbp)

	movl	$9, %eax
	negl	%eax
	movl	%eax, -32(%rbp)

	movl	$20, %r9d
	call	allocmem

	movl	%eax, -40(%rbp)

	movq	-40(%rbp), %rax
	leaq	0(%rax), %rdx
	movl	-28(%rbp), %eax
	movl	%eax, (%rdx)

	movq	-40(%rbp), %rax
	leaq	4(%rax), %rdx
	movl	$45, %eax
	movl	%eax, (%rdx)

	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movl	$0, %eax
	movl	%eax, (%rdx)

	movq	-40(%rbp), %rax
	leaq	12(%rax), %rdx
	movl	$11, %eax
	movl	%eax, (%rdx)

	movq	-40(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-32(%rbp), %eax
	movl	%eax, (%rdx)

	movl	-40(%rbp), %eax
	movl	%eax, -48(%rbp)

	movl	$5, %r9d
	movl	-24(%rbp), %r8d
	call	bubbleSort

	movl	$5, %r9d
	movl	-48(%rbp), %r8d
	call	insertionSort

	leave
	ret

L21:
	movl	-8(%rbp), %eax
	cmpl	"__main__", %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -9(%rbp)

	jmp	L23

L22:
	call	main

	jmp	L24

L23:
L24:
