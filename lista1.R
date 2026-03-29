########## Lista de Exercícios 1
# Autor: Maria Rosa Francisco Lourenço Barbosa 
# N° aluno: 17764481
# RMS5772 - Introdução ao R para Pesquisa em Saúde

# Removendo objetos ativos
rm(list = ls())

# 1. Cálculo das expressões
# (a)
3 + 4 * 8

# (b)
(3 + 4) * 8

# (c)
8 * 5 + 2 * 3

# (d)
8 * (5 + 2) * 3

# (e)
2^3 + 2 * sqrt(3)

# (f)
2 * 8 / 3 + 5 / 6 + 8

# (g)
1 + 2 + 3 + 4 + 5 + 6 + 7 + 8

# (h)
1 * 2 * 3 * 4 * 5 * 6 * 7 * 8

# (i)
(1 + 1/8)^3

# (j)
cos(pi)

# (k)
sin(pi)^2 + cos(pi)^2

# (l)
log(9)

# (m)
abs(8 - 19)

# (n)
2 / factorial(7) + sqrt(2) / 2

# 2. Matriz
# (a)
x <- matrix(c(5, 0, 6, 9, 6, 4, 3, 5, 2), nrow = 3, byrow = TRUE)

# (b) Dimensão da matriz
dim(x)

# (c) Elementos da diagonal principal
diag(x)

# 3. Modo e classe dos objetos
a <- 1:10
b <- letters[1:6]
c <- matrix(letters[1:6], ncol = 2)
d <- c("verde", "azul", "rosa")
e <- c(4i, 8i, 9i)
f <- c(5 > 2, 7 < 2, 8 > 3)
g <- date()

# Resultados
mode(a); class(a)
mode(b); class(b)
mode(c); class(c)
mode(d); class(d)
mode(e); class(e)
mode(f); class(f)
mode(g); class(g)
