########## Lista de Exercícios 2
# Autor: Maria Rosa Francisco Lourenço Barbosa 
# N° aluno: 17764481
# RMS5772 - Introdução ao R para Pesquisa em Saúde

# Removendo objetos ativos
rm(list = ls())

# Leitura dos dados (conforme fornecido no enunciado)
urlfile <- "https://raw.githubusercontent.com/edsonzmartinez/cursoR/main/Dados_jogadores.csv"
jog <- read.csv2(urlfile)

# (a) Função para estatísticas descritivas da idade
estat_desc_idade <- function(idade) {
  list(
    media = mean(idade, na.rm = TRUE),
    desvio_padrao = sd(idade, na.rm = TRUE),
    mediana = median(idade, na.rm = TRUE),
    amplitude = diff(range(idade, na.rm = TRUE)),
    iqr = IQR(idade, na.rm = TRUE)
  )
}
# Exemplo de chamada: estat_desc_idade(jog$idade)

# (b) Função para média e desvio padrão da altura de atletas > 25 anos
altura_maior_25 <- function(idade, altura) {
  filtro <- idade > 25
  list(
    media = mean(altura[filtro], na.rm = TRUE),
    desvio_padrao = sd(altura[filtro], na.rm = TRUE)
  )
}
# Exemplo de chamada: altura_maior_25(jog$idade, jog$altura)

# (c) Função para estatísticas descritivas da altura por posição
estat_altura_por_posicao <- function(posicao, altura) {
  tapply(altura, posicao, function(x) {
    c(media = mean(x, na.rm = TRUE),
      desvio_padrao = sd(x, na.rm = TRUE),
      mediana = median(x, na.rm = TRUE))
  })
}
# Exemplo de chamada: estat_altura_por_posicao(jog$posicao, jog$altura)

# (d) Função para correlação de Pearson (idade x altura) com IC 95%
correlacao_idade_altura <- function(idade, altura) {
  cor_teste <- cor.test(idade, altura, method = "pearson", conf.level = 0.95)
  list(
    correlacao = cor_teste$estimate,
    ic_95_inf = cor_teste$conf.int[1],
    ic_95_sup = cor_teste$conf.int[2],
    p_valor = cor_teste$p.value
  )
}
# Exemplo de chamada: correlacao_idade_altura(jog$idade, jog$altura)
# (Interpretação: se o IC incluir valores positivos e p < 0.05, há tendência de atletas mais velhos serem mais altos)

# (e) Funções para frequências absolutas e relativas por posição
freq_posicao <- function(posicao) {
  abs <- table(posicao)
  rel <- prop.table(abs) * 100
  list(frequencia_absoluta = abs, frequencia_relativa = round(rel, 2))
}
# Exemplo de chamada: freq_posicao(jog$posicao)

# (f) Função para contagem de atletas por intervalos de idade
intervalos_idade <- function(idade) {
  cortes <- cut(idade, 
                breaks = c(22, 24, 26, 28, 30, 32, 34),
                right = TRUE,
                include.lowest = FALSE)
  table(cortes)
}
# Exemplo de chamada: intervalos_idade(jog$idade)

# 2. Sequências solicitadas usando seq() ou rep()
seq_a <- seq(40, 20, by = -4)          # 40 36 32 28 24 20
seq_b <- rep(c(9, 5, 2), 3)            # 9 5 2 9 5 2 9 5 2
seq_c <- seq(0, 1, by = 0.2)           # 0.0 0.2 0.4 0.6 0.8 1.0
seq_d <- c(rep(9, 3), rep(7, 3))       # 9 9 9 7 7 7
