	.section	.rodata
LC8:
	.string	"Shift-Reduce"
LC7:
	.string	"CLR"
LC5:
	.string	"LALR name:"
LC3:
	.string	"SLR name:"
LC4:
	.string	"CLR name:"
LC2:
	.string	"False"
LC9:
	.string	"__main__"
LC1:
	.string	"True"
LC6:
	.string	"LALR"
LC0:
	.string	"%d\n"

	.text

	.globl	ShiftReduceParser.__init__
	.type	ShiftReduceParser.__init__, @function
ShiftReduceParser.__init__:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -16(%rbp)

	# self.srname = name_
	movq	-24(%rbp), %r10
	leaq	0(%r10), %r11

	movq	-16(%rbp), %rax
	movq	%rax, (%r11)

	# return
	leave
	ret

	# endfunc
	.size	ShiftReduceParser.__init__, .-ShiftReduceParser.__init__

	.globl	LR0Parser.__init__
	.type	LR0Parser.__init__, @function
LR0Parser.__init__:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -32(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)

	# self.srname = parentname_
	movq	-32(%rbp), %r10
	leaq	0(%r10), %r11

	movq	-24(%rbp), %rax
	movq	%rax, (%r11)

	# self.lr0name = myname_
	movq	-32(%rbp), %r10
	leaq	8(%r10), %r11

	movq	-16(%rbp), %rax
	movq	%rax, (%r11)

	# return
	leave
	ret

	# endfunc
	.size	LR0Parser.__init__, .-LR0Parser.__init__

	.globl	CLRParser.__init__
	.type	CLRParser.__init__, @function
CLRParser.__init__:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -32(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)

	# self.srname = parentname_
	movq	-32(%rbp), %r10
	leaq	0(%r10), %r11

	movq	-24(%rbp), %rax
	movq	%rax, (%r11)

	# self.clrname = myname_
	movq	-32(%rbp), %r10
	leaq	8(%r10), %r11

	movq	-16(%rbp), %rax
	movq	%rax, (%r11)

	# return
	leave
	ret

	# endfunc
	.size	CLRParser.__init__, .-CLRParser.__init__

	.globl	LALRParser.__init__
	.type	LALRParser.__init__, @function
LALRParser.__init__:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)

	# self.srname = srname_
	movq	-40(%rbp), %r10
	leaq	0(%r10), %r11

	movq	-32(%rbp), %rax
	movq	%rax, (%r11)

	# self.clrname = clrname_
	movq	-40(%rbp), %r10
	leaq	8(%r10), %r11

	movq	-24(%rbp), %rax
	movq	%rax, (%r11)

	# self.lalrname = myname_
	movq	-40(%rbp), %r10
	leaq	16(%r10), %r11

	movq	-16(%rbp), %rax
	movq	%rax, (%r11)

	# return
	leave
	ret

	# endfunc
	.size	LALRParser.__init__, .-LALRParser.__init__

	.globl	LALRParser.print_name
	.type	LALRParser.print_name, @function
LALRParser.print_name:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)

	# param "SLR name:"
	# call print , 1
	movq	$LC3, %rdi
	call	puts@PLT

	# param self.srname
	# call print , 1
	movq	-16(%rbp), %r10
	leaq	0(%r10), %r11

	movq	(%r11), %rdi
	call	puts@PLT

	# param "CLR name:"
	# call print , 1
	movq	$LC4, %rdi
	call	puts@PLT

	# param self.clrname
	# call print , 1
	movq	-16(%rbp), %r10
	leaq	8(%r10), %r11

	movq	(%r11), %rdi
	call	puts@PLT

	# param "LALR name:"
	# call print , 1
	movq	$LC5, %rdi
	call	puts@PLT

	# param self.lalrname
	# call print , 1
	movq	-16(%rbp), %r10
	leaq	16(%r10), %r11

	movq	(%r11), %rdi
	call	puts@PLT

	# return
	leave
	ret

	# endfunc
	.size	LALRParser.print_name, .-LALRParser.print_name

	.globl	main
	.type	main, @function
main:
	# beginfunc
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp

	# t1 = 24
	movl	$24, %eax
	movl	%eax, -4(%rbp)

	# param t1
	# call allocmem , 1
	movl	-4(%rbp), %edi
	call	malloc@PLT

	# t2 = popparam
	movq	%rax, -12(%rbp)

	# param t2
	# param "LALR"
	# param "CLR"
	# param "Shift-Reduce"
	# call LALRParser.__init__ , 4
	movq	$LC8, %rcx
	movq	$LC7, %rdx
	movq	$LC6, %rsi
	movq	-12(%rbp), %rdi
	call	LALRParser.__init__

	# obj = t2
	movq	-12(%rbp), %rax
	movq	%rax, -20(%rbp)

	# param obj
	# call LALRParser.print_name , 1
	movq	-20(%rbp), %rdi
	call	LALRParser.print_name

	# return
	leave
	ret

	# endfunc
	.size	main, .-main

L1:
	# t1 = __name__ == "__main__"
	movq	-8(%rbp), %rax
	movq	$LC9, %rdx
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
