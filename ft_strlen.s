global _ft_strlen  ; 他ファイルからアクセスするのにglobalラベルをつける

section .text     ; テキスト領域

_ft_strlen:
  mov rax, 5
  ret