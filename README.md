# libasm

## Tips

`gcc -S -masm=intel tmp.c` でIntel記法のアセンブリを出力できる

### LLDB

```
# r8 register が指すメモリアドレスのデータを見る
(lldb)$ memory read '$r8'
# [$rbp - 8] が指すメモリアドレスのデータを見る
(lldb)$ memory read '*(char **)($rbp - 0x8)'

# 現在停止中の行から2行前、10行後を表示するように設定変更
# https://stackoverflow.com/questions/52274360/how-to-list-more-lines-of-code-code-in-lldb
(lldb)$ settings set stop-line-count-before 2
(lldb)$ settings set stop-line-count-after 10
```

## References

- [x86-64 アセンブリ Jun's Homepage](https://www.mztn.org/lxasm64/amd00.html)
- [assemblyでHelloWorld! (Mac)](https://zenn.dev/wake/articles/13114fd46affd2c38d88)
- [x86とx86_64における引数の渡し方の違いをまとめてみた](https://qiita.com/hidenaka824/items/012adf82870c62a4a575)
- [lldb cheat sheet](https://www.nesono.com/sites/default/files/lldb%20cheat%20sheet.pdf)
- [macOS (x86/x86-64) のシステムコールをアセンブラから呼んでみる](https://blog.amedama.jp/entry/macos-system-call-assembler)
- [Intel x86 JUMP quick reference](http://unixwiz.net/techtips/x86-jumps.html)
- [X86アセンブラ/x86アーキテクチャ - Wikibooks](https://ja.wikibooks.org/wiki/X86%E3%82%A2%E3%82%BB%E3%83%B3%E3%83%96%E3%83%A9/x86%E3%82%A2%E3%83%BC%E3%82%AD%E3%83%86%E3%82%AF%E3%83%81%E3%83%A3)
- [x86アセンブリ言語での関数コール](https://vanya.jp.net/os/x86call/)
- [Chapter 11. x86 Assembly Language Programming - FreeBSD](https://docs.freebsd.org/en/books/developers-handbook/x86/)
- [C言語とアセンブリ言語の相互呼び出し](https://qiita.com/hiro4669/items/348ba278aa31aa58fa95)
- [X86_64: レジスタについて](https://sott0n.github.io/posts/x86_64_basic/)
- [lldbでIntel記法を使う](https://qiita.com/hobo0xcc/items/5f24899e010bc89154d1)
- [Assembly-programming](https://www.finddevguides.com/Assembly-programming)
- [libasmTester (2019+)](https://github.com/Tripouille/libasmTester)
- [Call Stack - Wikipedia](https://en.wikipedia.org/wiki/Call_stack)
- [x86 Disassembly/Functions and Stack Frames - WIKIBooks](https://en.wikibooks.org/wiki/X86_Disassembly/Functions_and_Stack_Frames)
- [9.2 Calling of Assembly Language Routine from C Language](http://tool-support.renesas.com/autoupdate/support/onlinehelp/csp/V4.01.00/CS+.chm/Compiler-CCRH.chm/Output/ccrh09c0200y.html)
- [3.9 Local Labels - NASM Doc](https://home.cs.colorado.edu/~main/cs1300-old/nasmdoc/html/nasmdoc3.html#section-3.9)
- [RET — Return from Procedure](https://www.felixcloutier.com/x86/ret)
- [x86 Assembly Guide](https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html)
- [メモリ、バイト、レジスタ - Jun's Homepage](https://www.mztn.org/lxasm64/amd03.html)
- [x86-64のCalling Convention](https://freak-da.hatenablog.com/entry/2021/03/25/172248)