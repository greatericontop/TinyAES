.file "aes256.s"
.intel_syntax noprefix


.section .text
.globl aes256_key_expansion
.type aes256_key_expansion, @function
aes256_key_expansion:
    endbr64
    push rbp
    mov rbp, rsp

    # rdi: points to original key
    # rsi: points to expanded key

    movdqu xmm0, [rdi]
    movdqu xmm1, [rdi + 16]

    # R0, R1 keys are just the original key
    movdqu [rsi], xmm0
    movdqu [rsi + 16], xmm1

    # R2, R3 generation


    leave
    ret







.section .text
.globl aes256_enc
.type aes256_enc, @function
aes256_enc:
    endbr64
    push rbp
    mov rbp, rsp

    # rdi: points to plaintext
    # rsi: points to ciphertext
    # rdx:

    movdqu [rsi], xmm1
    leave
    ret


.section .text
.globl aes256_dec
.type aes256_dec, @function
aes256_dec:
    endbr64
    push rbp
    mov rbp, rsp


    leave
    ret
