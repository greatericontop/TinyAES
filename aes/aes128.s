.file "aes128.s"
.intel_syntax noprefix


.section .text
.globl aes128_enc
.type aes128_enc, @function
aes128_enc:
    endbr64
    push rbp
    mov rbp, rsp

    # rdi: points to plaintext
    # rsi: points to ciphertext
    # rdx: points to key

    movdqu xmm0, [rdx]  # xmm0 <- 16-byte cipher key
    movdqu xmm1, [rdi]  # xmm1 <- 16-byte plaintext

    # Initial round key addition
    pxor xmm1, xmm0

    # Round 1
    movdqa xmm3, xmm0  # xmm3 <- store copy of old key
    aeskeygenassist xmm2, xmm0, 0x01  # store new xor constant in least significant 4 bytes of xmm2
    pshufd xmm2, xmm2, 0xff  # fill entire xmm2 register

    pxor xmm0, xmm2  # xmm0 = W0^A W1^A W2^A W3^A in memory
    pslldq xmm3, 4  # xmm3 = . W0 W1 W2
    pxor xmm0, xmm3  # xmm0 = W0^A W1^W0^A W2^W1^A W3^W2^A
    pslldq xmm3, 4  # xmm3 = . . W0 W1
    pxor xmm0, xmm3  # xmm0 = W0^A W1^W0^A W2^W1^W0^A W3^W2^W1^A
    pslldq xmm3, 4  # xmm3 = . . . W0
    pxor xmm0, xmm3  # xmm0 = W0^A W1^W0^A W2^W1^W0^A W3^W2^W1^W0^A

    aesenc xmm1, xmm0

    # Round 2
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x02
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 3
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x04
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 4
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x08
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 5
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x10
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 6
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x20
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 7
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x40
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 8
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x80
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 9
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x1b
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenc xmm1, xmm0

    # Round 10
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x36
    pshufd xmm2, xmm2, 0xff

    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

    aesenclast xmm1, xmm0

    # Place result & return
    movdqu [rsi], xmm1
    leave
    ret


.section .text
.globl aes128_dec
.type aes128_dec, @function
aes128_dec:
    endbr64
    push rbp
    mov rbp, rsp
    sub rsp, 160  # space for R1~10 keys

    # rdi: points to ciphertext
    # rsi: points to plaintext
    # rdx: points to key

    movdqu xmm0, [rdx]
    movdqu xmm1, [rdi]

    # Compute entire key schedule immediately and store results in stack
    # Save R0 in xmm4 because I forgot to
    movdqa xmm4, xmm0
    # R1
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x01
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-16], xmm0
    # R2
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x02
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-32], xmm0
    # R3
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x04
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-48], xmm0
    # R4
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x08
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-64], xmm0
    # R5
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x10
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-80], xmm0
    # R6
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x20
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-96], xmm0
    # R7
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x40
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-112], xmm0
    # R8
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x80
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-128], xmm0
    # R9
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x1b
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    movdqa [rbp-144], xmm0
    # R10
    movdqa xmm3, xmm0
    aeskeygenassist xmm2, xmm0, 0x36
    pshufd xmm2, xmm2, 0xff
    pxor xmm0, xmm2
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3
    # Last key remains in xmm0

    # Decryption
    pxor xmm1, xmm0  # R10 round key
    movdqa xmm0, [rbp-144]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0  # R10 shift, R10 sub, [R9 round key & mix in the wrong order, requiring aesimc, I hate intel]
    movdqa xmm0, [rbp-128]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-112]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-96]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-80]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-64]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-48]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-32]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0
    movdqa xmm0, [rbp-16]
    aesimc xmm0, xmm0
    aesdec xmm1, xmm0

    aesdeclast xmm1, xmm4  # R1/R0


    # Return
    movdqu [rsi], xmm1
    leave
    ret
