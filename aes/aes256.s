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

    # R2: Familiar xor with A from aeskeygenassist
    aeskeygenassist xmm2, xmm1, 0x01
    pshufd xmm2, xmm2, 0xff  # A stored in all bits of xmm2

    movdqa xmm3, xmm0
    pxor xmm0, xmm2  # w0^A w1^A w2^A w3^A
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3  # w0^A w1^w0^A w2^w1^w0^A w3^w2^w1^w0^A

    # R3 SubWord
    pxor xmm5, xmm5  # this is our zero "round key"
    pshufd xmm2, xmm0, 0xff  # xmm2 = w3 w3 w3 w3 repeated
    aesenclast xmm2, xmm5  # subword and shiftword on xmm2
    pshufd xmm2, xmm2, 0xff  # put unshifted xmm2 back into all of xmm2

    # Now do standard thing
    movdqa xmm3, xmm1
    pxor xmm1, xmm2
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3

    movdqu [rsi + 32], xmm0
    movdqu [rsi + 48], xmm1

    # R4, R5
    aeskeygenassist xmm2, xmm1, 0x02
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm0
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    pxor xmm5, xmm5
    pshufd xmm2, xmm0, 0xff
    aesenclast xmm2, xmm5
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm1
    pxor xmm1, xmm2
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3

    movdqu [rsi + 64], xmm0
    movdqu [rsi + 80], xmm1

    # R6, R7
    aeskeygenassist xmm2, xmm1, 0x04
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm0
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    pxor xmm5, xmm5
    pshufd xmm2, xmm0, 0xff
    aesenclast xmm2, xmm5
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm1
    pxor xmm1, xmm2
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3

    movdqu [rsi + 96], xmm0
    movdqu [rsi + 112], xmm1

    # R8, R9
    aeskeygenassist xmm2, xmm1, 0x08
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm0
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    pxor xmm5, xmm5
    pshufd xmm2, xmm0, 0xff
    aesenclast xmm2, xmm5
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm1
    pxor xmm1, xmm2
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3

    movdqu [rsi + 128], xmm0
    movdqu [rsi + 144], xmm1

    # R10, R11
    aeskeygenassist xmm2, xmm1, 0x10
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm0
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    pxor xmm5, xmm5
    pshufd xmm2, xmm0, 0xff
    aesenclast xmm2, xmm5
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm1
    pxor xmm1, xmm2
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3

    movdqu [rsi + 160], xmm0
    movdqu [rsi + 176], xmm1

    # R12, R13
    aeskeygenassist xmm2, xmm1, 0x20
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm0
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    pxor xmm5, xmm5
    pshufd xmm2, xmm0, 0xff
    aesenclast xmm2, xmm5
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm1
    pxor xmm1, xmm2
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3
    pslldq xmm3, 4
    pxor xmm1, xmm3

    movdqu [rsi + 192], xmm0
    movdqu [rsi + 208], xmm1

    # R14
    aeskeygenassist xmm2, xmm1, 0x40
    pshufd xmm2, xmm2, 0xff

    movdqa xmm3, xmm0
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    movdqu [rsi + 224], xmm0

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
    # rdx: points to key bytes

    movdqu xmm1, [rdi]

    # R0
    movdqu xmm0, [rdx]
    pxor xmm1, xmm0

    # R1
    movdqu xmm0, [rdx + 16]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 32]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 48]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 64]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 80]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 96]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 112]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 128]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 144]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 160]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 176]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 192]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 208]
    aesenc xmm1, xmm0

    movdqu xmm0, [rdx + 224]
    aesenclast xmm1, xmm0

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
