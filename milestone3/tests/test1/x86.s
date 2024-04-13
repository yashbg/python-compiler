bubbleSort:
	movl	-0(%rbp), %eax
	movl	%eax, -0(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	$0, %eax
	movl	%eax, -12(%rbp)
L1:
L2:
	movl	-0(%rbp), %eax
	movl	%eax, -16(%rbp)
	movl	$0, %eax
	movl	%eax, -17(%rbp)
L4:
L5:
L7:
	movl	-0(%rbp), %eax
	movl	%eax, -33(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -45(%rbp)
L8:
	movl	-0(%rbp), %eax
	movl	%eax, -54(%rbp)
	movl	-54(%rbp), %eax
	movl	%eax, -58(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -66(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -78(%rbp)
	movl	-78(%rbp), %eax
	movl	%eax, -66(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -90(%rbp)
	movl	-58(%rbp), %eax
	movl	%eax, -90(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -16(%rbp)
L9:
L10:
L6:
L11:
L12:
L13:
L14:
L3:
insertionSort:
	movl	-0(%rbp), %eax
	movl	%eax, -0(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	$0, %eax
	movl	%eax, -12(%rbp)
L15:
L16:
	movl	-0(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -32(%rbp)
L18:
	movl	-0(%rbp), %eax
	movl	%eax, -41(%rbp)
L19:
	movl	-0(%rbp), %eax
	movl	%eax, -55(%rbp)
	movl	-0(%rbp), %eax
	movl	%eax, -63(%rbp)
	movl	-63(%rbp), %eax
	movl	%eax, -55(%rbp)
L20:
	movl	-0(%rbp), %eax
	movl	%eax, -75(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -75(%rbp)
L17:
main:
	movl	-0(%rbp), %eax
	movl	%eax, -0(%rbp)
	movl	$45, %eax
	movl	%eax, -0(%rbp)
	movl	$0, %eax
	movl	%eax, -0(%rbp)
	movl	$11, %eax
	movl	%eax, -0(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, -0(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, -16(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -0(%rbp)
	movl	$45, %eax
	movl	%eax, -0(%rbp)
	movl	$0, %eax
	movl	%eax, -0(%rbp)
	movl	$11, %eax
	movl	%eax, -0(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, -0(%rbp)
	movl	-32(%rbp), %eax
	movl	%eax, -40(%rbp)
L21:
L22:
L23:
L24:
