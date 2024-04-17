	.section	.rodata
LC4:
	.string	""
LC3:
	.string	"Sorted array using bubble sort:"
LC2:
	.string	"False"
LC6:
	.string	"__main__"
LC1:
	.string	"True"
LC5:
	.string	"Sorted array using insertion sort:"
LC0:
	.string	"%d\n"

	.text

	.globl	bubbleSort
	.type	bubbleSort, @function
bubbleSort:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)

	# t1 = - 4
	movl	$4, %eax
	negl	%eax
	movl	%eax, -12(%rbp)

	# t2 = array[t1]
	movl	-12(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -16(%rbp)

	# n = t2
	movl	-16(%rbp), %eax
	movl	%eax, -20(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -24(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -24(%rbp)

L1:
	# if i<n goto L2
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	L2

	# goto L3
	jmp	L3

L2:
	# swapped = False
	movb	$0, %al
	movb	%al, -25(%rbp)

	# j = 0
	movl	$0, %eax
	movl	%eax, -29(%rbp)

	# t3 = - i
	movl	-24(%rbp), %eax
	negl	%eax
	movl	%eax, -33(%rbp)

	# t4 = t3 - 1
	movl	-33(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -37(%rbp)

	# t5 = n + t4
	movl	-20(%rbp), %eax
	addl	-37(%rbp), %eax
	movl	%eax, -41(%rbp)

	# j = 0
	movl	$0, %eax
	movl	%eax, -29(%rbp)

L4:
	# if j<t5 goto L5
	movl	-29(%rbp), %eax
	cmpl	-41(%rbp), %eax
	jl	L5

	# goto L6
	jmp	L6

L5:
L7:
	# t6 = j * 4
	movl	-29(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -45(%rbp)

	# t7 = array[t6]
	movl	-45(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -49(%rbp)

	# t8 = j + 1
	movl	-29(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -53(%rbp)

	# t9 = t8 * 4
	movl	-53(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -57(%rbp)

	# t10 = array[t9]
	movl	-57(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -61(%rbp)

	# t11 = t7 > t10
	movl	-49(%rbp), %eax
	cmpl	-61(%rbp), %eax
	setg	%al
	movb	%al, -62(%rbp)

	# if t11 goto L8
	movb	-62(%rbp), %al
	cmpb	$0, %al
	jg	L8

	# goto L9
	jmp	L9

L8:
	# t12 = j * 4
	movl	-29(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -66(%rbp)

	# t13 = array[t12]
	movl	-66(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -70(%rbp)

	# temp = t13
	movl	-70(%rbp), %eax
	movl	%eax, -74(%rbp)

	# t14 = j * 4
	movl	-29(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -78(%rbp)

	# t16 = j + 1
	movl	-29(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -86(%rbp)

	# t17 = t16 * 4
	movl	-86(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -90(%rbp)

	# t18 = array[t17]
	movl	-90(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -94(%rbp)

	# array[t14] = t18
	movl	-78(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	-94(%rbp), %eax
	movl	%eax, (%r11)

	# t19 = j + 1
	movl	-29(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -98(%rbp)

	# t20 = t19 * 4
	movl	-98(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -102(%rbp)

	# array[t20] = temp
	movl	-102(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	-74(%rbp), %eax
	movl	%eax, (%r11)

	# swapped = True
	movb	$1, %al
	movb	%al, -25(%rbp)

	# goto L10
	jmp	L10

L9:
L10:
	# t22 = j
	movl	-29(%rbp), %eax
	movl	%eax, -110(%rbp)

	# j = t22 + 1
	movl	-110(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -29(%rbp)

	# goto L4
	jmp	L4

L6:
L11:
	# t23 = not swapped
	movb	-25(%rbp), %al
	cmpb	$0, %al
	sete	%al
	movb	%al, -111(%rbp)

	# if t23 goto L12
	movb	-111(%rbp), %al
	cmpb	$0, %al
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
	# t24 = i
	movl	-24(%rbp), %eax
	movl	%eax, -115(%rbp)

	# i = t24 + 1
	movl	-115(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -24(%rbp)

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

	# t1 = - 4
	movl	$4, %eax
	negl	%eax
	movl	%eax, -12(%rbp)

	# t2 = arr[t1]
	movl	-12(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -16(%rbp)

	# n = t2
	movl	-16(%rbp), %eax
	movl	%eax, -20(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -24(%rbp)

	# i = 1
	movl	$1, %eax
	movl	%eax, -24(%rbp)

L15:
	# if i<n goto L16
	movl	-24(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	L16

	# goto L17
	jmp	L17

L16:
	# t3 = i * 4
	movl	-24(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -28(%rbp)

	# t4 = arr[t3]
	movl	-28(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -32(%rbp)

	# key = t4
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)

	# t5 = - 1
	movl	$1, %eax
	negl	%eax
	movl	%eax, -40(%rbp)

	# t6 = i + t5
	movl	-24(%rbp), %eax
	addl	-40(%rbp), %eax
	movl	%eax, -44(%rbp)

	# j = t6
	movl	-44(%rbp), %eax
	movl	%eax, -48(%rbp)

L18:
	# t7 = j >= 0
	movl	-48(%rbp), %eax
	cmpl	$0, %eax
	setge	%al
	movb	%al, -49(%rbp)

	# t8 = j * 4
	movl	-48(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -53(%rbp)

	# t9 = arr[t8]
	movl	-53(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -57(%rbp)

	# t10 = key < t9
	movl	-36(%rbp), %eax
	cmpl	-57(%rbp), %eax
	setl	%al
	movb	%al, -58(%rbp)

	# t11 = t7 and t10
	cmpb	$0, -49(%rbp)
	je	L31
	cmpb	$0, -58(%rbp)
	je	L31
	movl	$1, %eax
	jmp	L32
L31:
	movl	$0, %eax
L32:
	movb	%al, -59(%rbp)

	# if t11 goto L19
	movb	-59(%rbp), %al
	cmpb	$0, %al
	jg	L19

	# goto L20
	jmp	L20

L19:
	# t12 = j + 1
	movl	-48(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -63(%rbp)

	# t13 = t12 * 4
	movl	-63(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -67(%rbp)

	# t15 = j * 4
	movl	-48(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -75(%rbp)

	# t16 = arr[t15]
	movl	-75(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -79(%rbp)

	# arr[t13] = t16
	movl	-67(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	-79(%rbp), %eax
	movl	%eax, (%r11)

	# j = j - 1
	movl	-48(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -48(%rbp)

	# goto L18
	jmp	L18

L20:
	# t17 = j + 1
	movl	-48(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -83(%rbp)

	# t18 = t17 * 4
	movl	-83(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -87(%rbp)

	# arr[t18] = key
	movl	-87(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-8(%rbp), %r10
	addq	%r10, %r11

	movl	-36(%rbp), %eax
	movl	%eax, (%r11)

	# t20 = i
	movl	-24(%rbp), %eax
	movl	%eax, -95(%rbp)

	# i = t20 + 1
	movl	-95(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -24(%rbp)

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
	subq	$80, %rsp

	# t1 = - 2
	movl	$2, %eax
	negl	%eax
	movl	%eax, -4(%rbp)

	# t2 = - 9
	movl	$9, %eax
	negl	%eax
	movl	%eax, -8(%rbp)

	# param 24
	# call allocmem , 1
	movl	$24, %edi
	call	malloc@PLT

	# t3 = popparam
	movq	%rax, -16(%rbp)

	# t3[0] = 5
	movq	-16(%rbp), %r10
	leaq	0(%r10), %r11

	movl	$5, %eax
	movl	%eax, (%r11)

	# t3 = t3 + 4
	movl	-16(%rbp), %eax
	addl	$4, %eax
	movl	%eax, -16(%rbp)

	# t3[0] = t1
	movq	-16(%rbp), %r10
	leaq	0(%r10), %r11

	movl	-4(%rbp), %eax
	movl	%eax, (%r11)

	# t3[4] = 45
	movq	-16(%rbp), %r10
	leaq	4(%r10), %r11

	movl	$45, %eax
	movl	%eax, (%r11)

	# t3[8] = 0
	movq	-16(%rbp), %r10
	leaq	8(%r10), %r11

	movl	$0, %eax
	movl	%eax, (%r11)

	# t3[12] = 11
	movq	-16(%rbp), %r10
	leaq	12(%r10), %r11

	movl	$11, %eax
	movl	%eax, (%r11)

	# t3[16] = t2
	movq	-16(%rbp), %r10
	leaq	16(%r10), %r11

	movl	-8(%rbp), %eax
	movl	%eax, (%r11)

	# data1 = t3
	movq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)

	# t4 = - 2
	movl	$2, %eax
	negl	%eax
	movl	%eax, -28(%rbp)

	# t5 = - 9
	movl	$9, %eax
	negl	%eax
	movl	%eax, -32(%rbp)

	# param 24
	# call allocmem , 1
	movl	$24, %edi
	call	malloc@PLT

	# t6 = popparam
	movq	%rax, -40(%rbp)

	# t6[0] = 5
	movq	-40(%rbp), %r10
	leaq	0(%r10), %r11

	movl	$5, %eax
	movl	%eax, (%r11)

	# t6 = t6 + 4
	movl	-40(%rbp), %eax
	addl	$4, %eax
	movl	%eax, -40(%rbp)

	# t6[0] = t4
	movq	-40(%rbp), %r10
	leaq	0(%r10), %r11

	movl	-28(%rbp), %eax
	movl	%eax, (%r11)

	# t6[4] = 45
	movq	-40(%rbp), %r10
	leaq	4(%r10), %r11

	movl	$45, %eax
	movl	%eax, (%r11)

	# t6[8] = 0
	movq	-40(%rbp), %r10
	leaq	8(%r10), %r11

	movl	$0, %eax
	movl	%eax, (%r11)

	# t6[12] = 11
	movq	-40(%rbp), %r10
	leaq	12(%r10), %r11

	movl	$11, %eax
	movl	%eax, (%r11)

	# t6[16] = t5
	movq	-40(%rbp), %r10
	leaq	16(%r10), %r11

	movl	-32(%rbp), %eax
	movl	%eax, (%r11)

	# data2 = t6
	movq	-40(%rbp), %rax
	movq	%rax, -48(%rbp)

	# param data1
	# call bubbleSort , 1
	movq	-24(%rbp), %rdi
	call	bubbleSort

	# param data2
	# call insertionSort , 1
	movq	-48(%rbp), %rdi
	call	insertionSort

	# param "Sorted array using bubble sort:"
	# call print , 1
	movq	$LC3, %rdi
	call	puts@PLT

	# i = 0
	movl	$0, %eax
	movl	%eax, -52(%rbp)

	# i = 0
	movl	$0, %eax
	movl	%eax, -52(%rbp)

L21:
	# if i<5 goto L22
	movl	-52(%rbp), %eax
	cmpl	$5, %eax
	jl	L22

	# goto L23
	jmp	L23

L22:
	# t7 = i * 4
	movl	-52(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -56(%rbp)

	# t8 = data1[t7]
	movl	-56(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-24(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -60(%rbp)

	# param t8
	# call print , 1
	movl	-60(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# t9 = i
	movl	-52(%rbp), %eax
	movl	%eax, -64(%rbp)

	# i = t9 + 1
	movl	-64(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -52(%rbp)

	# goto L21
	jmp	L21

L23:
	# param ""
	# call print , 1
	movq	$LC4, %rdi
	call	puts@PLT

	# param "Sorted array using insertion sort:"
	# call print , 1
	movq	$LC5, %rdi
	call	puts@PLT

	# i = 0
	movl	$0, %eax
	movl	%eax, -52(%rbp)

L24:
	# if i<5 goto L25
	movl	-52(%rbp), %eax
	cmpl	$5, %eax
	jl	L25

	# goto L26
	jmp	L26

L25:
	# t10 = i * 4
	movl	-52(%rbp), %eax
	imull	$4, %eax
	movl	%eax, -68(%rbp)

	# t11 = data2[t10]
	movl	-68(%rbp), %r10d
	movslq %r10d, %r10
	movq	%r10, %r11
	movq	-48(%rbp), %r10
	addq	%r10, %r11

	movl	(%r11), %eax
	movl	%eax, -72(%rbp)

	# param t11
	# call print , 1
	movl	-72(%rbp), %esi
	movq	$LC0, %rdi
	movl	$0, %eax
	call	printf@PLT

	# t12 = i
	movl	-52(%rbp), %eax
	movl	%eax, -76(%rbp)

	# i = t12 + 1
	movl	-76(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -52(%rbp)

	# goto L24
	jmp	L24

L26:
	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L27:
	# t1 = __name__ == "__main__"
	movq	-8(%rbp), %rax
	movq	$LC6, %rdx
	cmpq	%rdx, %rax
	sete	%al
	movb	%al, -9(%rbp)

	# if t1 goto L28
	movb	-9(%rbp), %al
	cmpb	$0, %al
	jg	L28

	# goto L29
	jmp	L29

L28:
	# call main , 0
	call	main

	# goto L30
	jmp	L30

L29:
L30:
