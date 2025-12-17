.file "aes128.s"
.intel_syntax noprefix


.section .text
.globl aes256_enc
.type aes256_enc, @function
aes256_enc:
    endbr64
    push rbp
    mov rbp, rsp


    leave
    ret
