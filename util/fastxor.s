.file "fastxor.s"
.intel_syntax noprefix


.section .text
.globl fastxor
.type fastxor, @function
fastxor:
    endbr64

    # rdi: pointer to a
    # rsi: pointer to b
    # rdx: pointer to result

    movdqu xmm0, [rdi]
    movdqu xmm1, [rsi]
    pxor xmm0, xmm1
    movdqu [rdx], xmm0

    ret
