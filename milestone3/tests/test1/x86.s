	.section	.rodata
.LC0:
	.string	"__main__"
.LC1:
	.string	"%d\n"

	.text

	.globl	bubbleSort
	.type	bubbleSort, @function
bubbleSort:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$112, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -16(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -16(%rbp)

L1:
	# if i<n goto L2
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	L2

	# goto L3
	jmp	L3

L2:
	# swapped = False
	movl	$0, %eax
	movl	%eax, -17(%rbp)

	# j = 0
	movl	$0, %eax
	movl	%eax, -21(%rbp)

	# t1 = - i
	movl	-16(%rbp), %eax
	negl	%eax
	movl	%eax, -25(%rbp)

	# t2 = t1 - 1
	movl	-25(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -29(%rbp)

	# t3 = n + t2
	movl	-12(%rbp), %eax
	addl	-29(%rbp), %eax
	movl	%eax, -33(%rbp)

	# j = 0
	movl	$0, %eax
	movl	%eax, -21(%rbp)

L4:
	# if j<t3 goto L5
	movl	-21(%rbp), %eax
	cmpl	-33(%rbp), %eax
	jl	L5

	# goto L6
	jmp	L6

L5:
L7:
	# t4 = j * 4
	movl	-21(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -37(%rbp)

	# t5 = array[t4]
	movl	-37(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -41(%rbp)

	# t6 = j + 1
	movl	-21(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -45(%rbp)

	# t7 = t6 * 4
	movl	-45(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -49(%rbp)

	# t8 = array[t7]
	movl	-49(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -53(%rbp)

	# t9 = t5 > t8
	movl	-41(%rbp), %eax
	cmpl	-53(%rbp), %eax
	setg	%al
	movzbl	%al, %eax
	movl	%eax, -54(%rbp)

	# if t9 goto L8
	movl	-54(%rbp), %eax
	cmpl	$0, %eax
	jg	L8

	# goto L9
	jmp	L9

L8:
	# t10 = j * 4
	movl	-21(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -58(%rbp)

	# t11 = array[t10]
	movl	-58(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -62(%rbp)

	# temp = t11
	movl	-62(%rbp), %eax
	movl	%eax, -66(%rbp)

	# t12 = j * 4
	movl	-21(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -70(%rbp)

	# t14 = j + 1
	movl	-21(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -78(%rbp)

	# t15 = t14 * 4
	movl	-78(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -82(%rbp)

	# t16 = array[t15]
	movl	-82(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -86(%rbp)

	# array[t12] = t16
	movl	-70(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-86(%rbp), %eax
	movl	%eax, (%rdx)

	# t17 = j + 1
	movl	-21(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -90(%rbp)

	# t18 = t17 * 4
	movl	-90(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -94(%rbp)

	# array[t18] = temp
	movl	-94(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-66(%rbp), %eax
	movl	%eax, (%rdx)

	# swapped = True
	movl	$1, %eax
	movl	%eax, -17(%rbp)

	# goto L10
	jmp	L10

L9:
L10:
	# t20 = j
	movl	-21(%rbp), %eax
	movl	%eax, -102(%rbp)

	# j = t20 + 1
	movl	-102(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -21(%rbp)

	# goto L4
	jmp	L4

L6:
L11:
	# t21 = not swapped
	movl	-17(%rbp), %eax
	cmpl	$0, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -103(%rbp)

	# if t21 goto L12
	movl	-103(%rbp), %eax
	cmpl	$0, %eax
	jg	L12

	# goto L13
	jmp	L13

L12:
	# goto L3
	jmp	L3

	# goto L14
	jmp	L14

L13:
L14:
	# t22 = i
	movl	-16(%rbp), %eax
	movl	%eax, -107(%rbp)

	# i = t22 + 1
	movl	-107(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)

	# goto L1
	jmp	L1

L3:
	# return
	leave
	ret

	# endfunc
	.size	bubbleSort, .-bubbleSort

	.globl	insertionSort
	.type	insertionSort, @function
insertionSort:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$96, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -16(%rbp)

	# i = 1
	movl	$1, %eax
	movl	%eax, -16(%rbp)

L15:
	# if i<n goto L16
	movl	-16(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	L16

	# goto L17
	jmp	L17

L16:
	# t1 = i * 4
	movl	-16(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -20(%rbp)

	# t2 = arr[t1]
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -24(%rbp)

	# key = t2
	movl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)

	# t3 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -32(%rbp)

	# t4 = i + t3
	movl	-16(%rbp), %eax
	addl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)

	# j = t4
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)

L18:
	# t6 = j * 4
	movl	-40(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -45(%rbp)

	# t7 = arr[t6]
	movl	-45(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -49(%rbp)

	# t8 = key < t7
	movl	-28(%rbp), %eax
	cmpl	-49(%rbp), %eax
	setl	%al
	movzbl	%al, %eax
	movl	%eax, -50(%rbp)

	# t9 = t5 and t8
	cmpl	$0, -41(%rbp)
	je	L28
	cmpl	$0, -50(%rbp)
	je	L28
	movl	$1, %eax
	jmp	L29
L28:
	movl	$0, %eax
L29:
	movzbl	%al, %eax
	movl	%eax, -51(%rbp)

	# if t9 goto L19
	movl	-51(%rbp), %eax
	cmpl	$0, %eax
	jg	L19

	# goto L20
	jmp	L20

L19:
	# t10 = j + 1
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -55(%rbp)

	# t11 = t10 * 4
	movl	-55(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -59(%rbp)

	# t13 = j * 4
	movl	-40(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -67(%rbp)

	# t14 = arr[t13]
	movl	-67(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -71(%rbp)

	# arr[t11] = t14
	movl	-59(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-71(%rbp), %eax
	movl	%eax, (%rdx)

	# j = j - 1
	movl	-40(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -40(%rbp)

	# goto L18
	jmp	L18

L20:
	# t15 = j + 1
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -75(%rbp)

	# t16 = t15 * 4
	movl	-75(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -79(%rbp)

	# arr[t16] = key
	movl	-79(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	addq	%rax, %rdx
	movl	-28(%rbp), %eax
	movl	%eax, (%rdx)

	# t18 = i
	movl	-16(%rbp), %eax
	movl	%eax, -87(%rbp)

	# i = t18 + 1
	movl	-87(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)

	# goto L15
	jmp	L15

L17:
	# return
	leave
	ret

	# endfunc
	.size	insertionSort, .-insertionSort

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp

	# t1 = - 2
	movl	$2, %eax
	negl	%eax
	movl	%eax, -4(%rbp)

	# t2 = - 9
	movl	$9, %eax
	negl	%eax
	movl	%eax, -8(%rbp)

	# call allocmem , 1
	movl	$20, %edi
	call	malloc@PLT

	# t3 = popparam
	movq	%rax, -16(%rbp)

	# t3[0] = t1
	movq	-16(%rbp), %rax
	leaq	0(%rax), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)

	# t3[4] = 45
	movq	-16(%rbp), %rax
	leaq	4(%rax), %rdx
	movl	$45, %eax
	movl	%eax, (%rdx)

	# t3[8] = 0
	movq	-16(%rbp), %rax
	leaq	8(%rax), %rdx
	movl	$0, %eax
	movl	%eax, (%rdx)

	# t3[12] = 11
	movq	-16(%rbp), %rax
	leaq	12(%rax), %rdx
	movl	$11, %eax
	movl	%eax, (%rdx)

	# t3[16] = t2
	movq	-16(%rbp), %rax
	leaq	16(%rax), %rdx
	movl	-8(%rbp), %eax
	movl	%eax, (%rdx)

	# data1 = t3
	movq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)

	# call bubbleSort , 2
	movl	$5, %esi
	movq	-24(%rbp), %rdi
	call	bubbleSort

	# i = 0
	movl	$0, %eax
	movl	%eax, -28(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -28(%rbp)

L21:
	# if i<5 goto L22
	movl	-28(%rbp), %eax
	cmpl	$5, %eax
	jl	L22

	# goto L23
	jmp	L23

L22:
	# t4 = i * 4
	movl	-28(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -32(%rbp)

	# t5 = data1[t4]
	movl	-32(%rbp), %eax
	cltq
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -36(%rbp)

	# call print , 1
	movl	-36(%rbp), %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf@PLT

	# t6 = i
	movl	-28(%rbp), %eax
	movl	%eax, -40(%rbp)

	# i = t6 + 1
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)

	# goto L21
	jmp	L21

L23:
	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L24:
	# t1 = __name__ == "__main__"
	movl	-8(%rbp), %eax
	cmpl	$.LC0, %eax
	sete	%al
	movzbl	%al, %eax
	movl	%eax, -9(%rbp)

	# if t1 goto L25
	movl	-9(%rbp), %eax
	cmpl	$0, %eax
	jg	L25

	# goto L26
	jmp	L26

L25:
	# call main , 0
	call	main

	# goto L27
	jmp	L27

L26:
L27:
