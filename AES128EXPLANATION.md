# `aes128.s` Explanation

This guide tries to explain the assembly code in `aes128.s` in detail.

### How AES-128 Works

At the most basic level, AES-128 encrypts a 16-byte chunk of plaintext data into a 16-byte chunk of ciphertext data using a 16-byte cipher key.

The algorithm works roughly as follows:

- Initial round key addition: The plaintext is XORed with the cipher key.
- Rounds 1 through 9
  - Each round uses a different round key, which is derived from the previous round key using the key schedule / key expansion algorithm
    - We need to calculate these before doing the actual math for the round.
  - Perform the SubBytes, ShiftRows, MixColumns, and AddRoundKey steps.
    - There's some beautiful math behind these steps that you can read about on the [Wikipedia page](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard), but they're not important for us here because we have a CPU instruction to do it for us.
- Round 10
  - The last round is different because it omits the MixColumns step.
    - We use a CPU instruction for this as well.

### Setup

Starting from line 8, with the `aes128_enc:` label specifying the `aes128_enc` function:

    endbr64
    push rbp
    mov rbp, rsp

For those unfamiliar with assembly, this is the standard function prologue.
It basically sets up the C stack for our function.
It's not super important for us today since we don't have any local variables and will be doing everything in CPU registers.

    movdqu xmm0, [rdx]  # xmm0 <- 16-byte cipher key
    movdqu xmm1, [rdi]  # xmm1 <- 16-byte plaintext

The `movdqu` (move double quad word unaligned) instruction loads 16 bytes of data from the address specified into an `xmm` register.

The first argument is stored in `rdi`, and the third in `rdx`. So `movdqu xmm0, [rdx]` loads the 16-byte cipher key into `xmm0`, and similarly for the plaintext.

### Initial round key addition

    pxor xmm1, xmm0

XORs the plaintext in `xmm1` with the cipher key in `xmm0`, storing the result back in `xmm1`.

### Round 1 key schedule

    movdqa xmm3, xmm0  # xmm3 <- store copy of old key

Stores a copy of the current key in `xmm3` for later.

    aeskeygenassist xmm2, xmm0, 0x01  # store new xor constant in least significant 4 bytes of xmm2

`aeskeygenassist` is an instruction that gives us a magic constant used for the key schedule. It's stored in `xmm2`.

    pshufd xmm2, xmm2, 0xff  # fill entire xmm2 register

However, `aeskeygenassist` only fills the low 4 bytes of `xmm2`, so `pshufd` replicates that value across all 16 bytes of `xmm2`.

    pxor xmm0, xmm2

Now we XOR our constant `A A A A` with the current key.
If our cipher key `xmm0` looked like `w0 w1 w2 w3` (where each `w` is 4 bytes), after this operation it looks like `w0^A w1^A w2^A w3^A`.

    pslldq xmm3, 4

This performs a logical left byte shift on `xmm3`, which was our original key, by 4 bytes.
So if our key was `w0 w1 w2 w3` in memory, logically it looks like `w3 w2 w1 w0`, and shifting it gives you `w2 w1 w0 0`, which in memory is `0 w0 w1 w2` due to little-endian order.

    pxor xmm0, xmm3

This XORs our modified key `w0^A w1^A w2^A w3^A` with `0 w0 w1 w2`, resulting in `w0^A w1^w0^A w2^w1^A w3^w2^A`.

    pslldq xmm3, 4
    pxor xmm0, xmm3
    pslldq xmm3, 4
    pxor xmm0, xmm3

We repeat this process a few more times to get the new key.
`xmm0` now contains `w0^A w1^w0^A w2^w1^w0^A w3^w2^w1^w0^A`.

This is now our round 1 key. Future rounds will perform the same transformation, starting with the previous round key.

### Round 1, actually

    aesenc xmm1, xmm0

In a single instruction, round 1 is performed on the data in `xmm1` using the round key in `xmm0`.

### Round 2 and onward

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

The round 2 code is fairly similar to round 1's.
The only significant difference is that the constant for the key schedule is now `0x02` instead of `0x01`.

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

### Round 10

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

Round 10 uses the `aesenclast` instruction, which performs the final AES round without the MixColumns step.

### Return

    movdqu [rsi], xmm1
    leave
    ret

Place the ciphertext in `xmm1` at the location in memory pointed to by `rsi` (the second argument). Then `leave` and `ret` cleans up the stack and returns to the caller.
