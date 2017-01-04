/* argument passing: %rdi, %rsi, %rdx, %rcx, %r8, %r9 */
/* return value: %rax */
/* callee saved: %rbx, %rbp, %rsp, %r12-r15 */
/* stack frame (with -pg): return addr = 8(%rbp), prev fp = 0(%rbp) */
/* stack frame (with -fentry): return addr = (%rsp), prev fp = 8(%rsp) */

.globl __xray_entry
__xray_entry:
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %rax

	/* child ip */
	movq 56(%rsp), %rsi
	/* parent ip */
	lea 64(%rsp), %rdi

	/* mcount_args */
	lea 8(%rsp), %rdx

	call xray_entry

	popq %rax
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	retq

.type __xray_entry, @function
.size __xray_entry, .-__xray_entry


.globl __xray_exit
__xray_exit:
	pushq %rdx
	pushq %rax

	/* set the first argument of mcount_exit as pointer to return values */
	movq %rsp, %rdi

	call xray_exit

	popq %rax
	popq %rdx
	retq

.type __xray_exit, @function
.size __xray_exit, .-__xray_exit
