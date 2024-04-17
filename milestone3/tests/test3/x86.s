	.section	.rodata
LC2:
	.string	"__main__"
LC1:
	.string	"Hello, World!"
LC0:
	.string	"%d\n"

	.text

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp

	# param "Hello, World!"
	# call print , 1
	movq	$LC1, %rdi
	call	puts@PLT

	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L1:
	# t1 = __name__ == "__main__"
	movl	-8(%rbp), %eax
	cmpl	$LC2, %eax
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
