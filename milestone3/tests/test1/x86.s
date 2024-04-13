bubbleSort:
	movl	-4(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	$0, %eax
	movl	%eax, -16(%rbp)
L1:
	jmp	L3
L2:
	movl	-4(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	$0, %eax
	movl	%eax, -21(%rbp)
L4:
	jmp	L6
L5:
L7:
	movl	-4(%rbp), %eax
	movl	%eax, -37(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -49(%rbp)
	jmp	L9
L8:
	movl	-4(%rbp), %eax
	movl	%eax, -58(%rbp)
	movl	-58(%rbp), %eax
	movl	%eax, -62(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -70(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -82(%rbp)
	movl	-82(%rbp), %eax
	movl	%eax, -70(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -94(%rbp)
	movl	-62(%rbp), %eax
	movl	%eax, -94(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -20(%rbp)
	jmp	L10
L9:
L10:
	jmp	L4
L6:
L11:
	jmp	L13
L12:
	jmp	L3
	jmp	L14
L13:
L14:
	jmp	L1
L3:
	popq	%rbp
	ret
insertionSort:
	movl	-4(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	$0, %eax
	movl	%eax, -16(%rbp)
L15:
	jmp	L17
L16:
	movl	-4(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
L18:
	movl	-4(%rbp), %eax
	movl	%eax, -45(%rbp)
	jmp	L20
L19:
	movl	-4(%rbp), %eax
	movl	%eax, -59(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -67(%rbp)
	movl	-67(%rbp), %eax
	movl	%eax, -59(%rbp)
	jmp	L18
L20:
	movl	-4(%rbp), %eax
	movl	%eax, -79(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -79(%rbp)
	jmp	L15
L17:
	popq	%rbp
	ret
main:
	movl	-4(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	$45, %eax
	movl	%eax, -4(%rbp)
	movl	$0, %eax
	movl	%eax, -4(%rbp)
	movl	$11, %eax
	movl	%eax, -4(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	$45, %eax
	movl	%eax, -4(%rbp)
	movl	$0, %eax
	movl	%eax, -4(%rbp)
	movl	$11, %eax
	movl	%eax, -4(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, -44(%rbp)
	popq	%rbp
	ret
L21:
	jmp	L23
L22:
	jmp	L24
L23:
L24:
