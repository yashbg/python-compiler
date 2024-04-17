	.section	.rodata
LC5:
	.string	"__main__"
LC4:
	.string	"Linear search: element is not present"
LC3:
	.string	"Linear search: element is present at index:"
LC2:
	.string	"Binary search: element is not present"
LC1:
	.string	"Binary search: element is present at index:"
LC0:
	.string	"%d\n"

	.text

	.globl	binarySearch
	.type	binarySearch, @function
binarySearch:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movl	%ecx, -20(%rbp)

L1:
	# t1 = low <= high
	movl	-16(%rbp), %eax
	cmpl	-20(%rbp), %eax
	setle	%al
	movb	%al, -21(%rbp)

	# if t1 goto L2
	movb	-21(%rbp), %al
	cmpb	$0, %al
	jg	L2

	# goto L3
	jmp	L3

L2:
	# t2 = - low
	movl	-16(%rbp), %eax
	negl	%eax
	movl	%eax, -25(%rbp)

	# t3 = high + t2
	movl	-20(%rbp), %eax
	addl	-25(%rbp), %eax
	movl	%eax, -29(%rbp)

	# t4 = t3 / 2
	movl	-29(%rbp), %eax
	movl	$2, %ebx
	cltd
	idivl	%ebx
	movl	%eax, -33(%rbp)

	# t5 = low + t4
	movl	-16(%rbp), %eax
	addl	-33(%rbp), %eax
	movl	%eax, -37(%rbp)

	# mid = t5
	movl	-37(%rbp), %eax
	movl	%eax, -41(%rbp)

L4:
	# t6 = mid * 4
	movl	-41(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -45(%rbp)

	# t7 = array[t6]
	movl	-45(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx

	movl	(%rdx), %eax
	movl	%eax, -49(%rbp)

	# t8 = t7 == x
	movl	-49(%rbp), %eax
	cmpl	-12(%rbp), %eax
	sete	%al
	movb	%al, -50(%rbp)

	# if t8 goto L5
	movb	-50(%rbp), %al
	cmpb	$0, %al
	jg	L5

	# goto L6
	jmp	L6

L5:
	# push mid
	movl	-41(%rbp), %eax

	# return
	leave
	ret

	# goto L7
	jmp	L7

L6:
L8:
	# t9 = mid * 4
	movl	-41(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -54(%rbp)

	# t10 = array[t9]
	movl	-54(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx

	movl	(%rdx), %eax
	movl	%eax, -58(%rbp)

	# t11 = t10 < x
	movl	-58(%rbp), %eax
	cmpl	-12(%rbp), %eax
	setl	%al
	movb	%al, -59(%rbp)

	# if t11 goto L9
	movb	-59(%rbp), %al
	cmpb	$0, %al
	jg	L9

	# goto L10
	jmp	L10

L9:
	# t12 = mid + 1
	movl	-41(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -63(%rbp)

	# low = t12
	movl	-63(%rbp), %eax
	movl	%eax, -16(%rbp)

	# goto L7
	jmp	L7

L10:
	# t13 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -67(%rbp)

	# t14 = mid + t13
	movl	-41(%rbp), %eax
	addl	-67(%rbp), %eax
	movl	%eax, -71(%rbp)

	# high = t14
	movl	-71(%rbp), %eax
	movl	%eax, -20(%rbp)

L7:
	# goto L1
	jmp	L1

L3:
	# t15 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -75(%rbp)

	# push t15
	movl	-75(%rbp), %eax

	# return
	leave
	ret

	# return
	leave
	ret

	# endfunc
	.size	binarySearch, .-binarySearch

	.globl	linearSearch
	.type	linearSearch, @function
linearSearch:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -16(%rbp)

	# t1 = - 4
	movl	$4, %eax
	negl	%eax
	movl	%eax, -20(%rbp)

	# t2 = array[t1]
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx

	movl	(%rdx), %eax
	movl	%eax, -24(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -16(%rbp)

L11:
	# if i<t2 goto L12
	movl	-16(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	L12

	# goto L13
	jmp	L13

L12:
L14:
	# t3 = i * 4
	movl	-16(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -28(%rbp)

	# t4 = array[t3]
	movl	-28(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx

	movl	(%rdx), %eax
	movl	%eax, -32(%rbp)

	# t5 = t4 == x
	movl	-32(%rbp), %eax
	cmpl	-12(%rbp), %eax
	sete	%al
	movb	%al, -33(%rbp)

	# if t5 goto L15
	movb	-33(%rbp), %al
	cmpb	$0, %al
	jg	L15

	# goto L16
	jmp	L16

L15:
	# push i
	movl	-16(%rbp), %eax

	# return
	leave
	ret

	# goto L17
	jmp	L17

L16:
L17:
	# t6 = i
	movl	-16(%rbp), %eax
	movl	%eax, -37(%rbp)

	# i = t6 + 1
	movl	-37(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)

	# goto L11
	jmp	L11

L13:
	# t7 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -41(%rbp)

	# push t7
	movl	-41(%rbp), %eax

	# return
	leave
	ret

	# return
	leave
	ret

	# endfunc
	.size	linearSearch, .-linearSearch

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp

	# param 36
	# call allocmem , 1
	movl	$36, %edi
	call	malloc@PLT

	# t1 = popparam
	movq	%rax, -8(%rbp)

	# t1[0] = 8
	movq	-8(%rbp), %rax
	leaq	0(%rax), %rdx

	movl	$8, %eax
	movl	%eax, (%rdx)

	# t1 = t1 + 4
	movl	-8(%rbp), %eax
	addl	$4, %eax
	movl	%eax, -8(%rbp)

	# t1[0] = 3
	movq	-8(%rbp), %rax
	leaq	0(%rax), %rdx

	movl	$3, %eax
	movl	%eax, (%rdx)

	# t1[4] = 4
	movq	-8(%rbp), %rax
	leaq	4(%rax), %rdx

	movl	$4, %eax
	movl	%eax, (%rdx)

	# t1[8] = 5
	movq	-8(%rbp), %rax
	leaq	8(%rax), %rdx

	movl	$5, %eax
	movl	%eax, (%rdx)

	# t1[12] = 6
	movq	-8(%rbp), %rax
	leaq	12(%rax), %rdx

	movl	$6, %eax
	movl	%eax, (%rdx)

	# t1[16] = 7
	movq	-8(%rbp), %rax
	leaq	16(%rax), %rdx

	movl	$7, %eax
	movl	%eax, (%rdx)

	# t1[20] = 8
	movq	-8(%rbp), %rax
	leaq	20(%rax), %rdx

	movl	$8, %eax
	movl	%eax, (%rdx)

	# t1[24] = 9
	movq	-8(%rbp), %rax
	leaq	24(%rax), %rdx

	movl	$9, %eax
	movl	%eax, (%rdx)

	# t1[28] = 10
	movq	-8(%rbp), %rax
	leaq	28(%rax), %rdx

	movl	$10, %eax
	movl	%eax, (%rdx)

	# array = t1
	movq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)

	# l = 8
	movl	$8, %eax
	movl	%eax, -20(%rbp)

	# t2 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -24(%rbp)

	# t3 = l + t2
	movl	-20(%rbp), %eax
	addl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)

	# param array
	# param 4
	# param 0
	# param t3
	# call binarySearch , 4
	movl	-28(%rbp), %ecx
	movl	$0, %edx
	movl	$4, %esi
	movq	-16(%rbp), %rdi
	call	binarySearch

	# t4 = popparam
	movl	%eax, -32(%rbp)

	# result1 = t4
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)

L18:
	# t5 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -40(%rbp)

	# t6 = result1 != t5
	movl	-36(%rbp), %eax
	cmpl	-40(%rbp), %eax
	setne	%al
	movb	%al, -41(%rbp)

	# if t6 goto L19
	movb	-41(%rbp), %al
	cmpb	$0, %al
	jg	L19

	# goto L20
	jmp	L20

L19:
	# param "Binary search: element is present at index:"
	# call print , 1
	movq	$LC1, %rdi
	call	puts@PLT

	# param result1
	# call print , 1
	movl	-36(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# goto L21
	jmp	L21

L20:
	# param "Binary search: element is not present"
	# call print , 1
	movq	$LC2, %rdi
	call	puts@PLT

L21:
	# param array
	# param 4
	# call linearSearch , 2
	movl	$4, %esi
	movq	-16(%rbp), %rdi
	call	linearSearch

	# t7 = popparam
	movl	%eax, -45(%rbp)

	# result2 = t7
	movl	-45(%rbp), %eax
	movl	%eax, -49(%rbp)

L22:
	# t8 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -53(%rbp)

	# t9 = result2 != t8
	movl	-49(%rbp), %eax
	cmpl	-53(%rbp), %eax
	setne	%al
	movb	%al, -54(%rbp)

	# if t9 goto L23
	movb	-54(%rbp), %al
	cmpb	$0, %al
	jg	L23

	# goto L24
	jmp	L24

L23:
	# param "Linear search: element is present at index:"
	# call print , 1
	movq	$LC3, %rdi
	call	puts@PLT

	# param result2
	# call print , 1
	movl	-49(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# goto L25
	jmp	L25

L24:
	# param "Linear search: element is not present"
	# call print , 1
	movq	$LC4, %rdi
	call	puts@PLT

L25:
	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L26:
	# t1 = __name__ == "__main__"
	movq	-8(%rbp), %rax
	movq	$LC5, %rdx
	cmpq	%rdx, %rax
	sete	%al
	movb	%al, -9(%rbp)

	# if t1 goto L27
	movb	-9(%rbp), %al
	cmpb	$0, %al
	jg	L27

	# goto L28
	jmp	L28

L27:
	# call main , 0
	call	main

	# goto L29
	jmp	L29

L28:
L29:
