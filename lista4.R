########## Lista de Exercícios 4
# Autor: Maria Rosa Francisco Lourenço Barbosa
# N° aluno: 17764481
# RMS5772 - Introdução ao R para Pesquisa em Saúde
#
# Base de dados: antropo.txt — variáveis antropométricas de adultos masculinos
# CORREÇÃO APLICADA:
#   - Exercício 6: lm(Fat ~ dados[[v]], data = dados) causava erro porque,
#     ao usar data = dados, o R busca "dados[[v]]" como nome de coluna dentro
#     do data frame — o que não existe. Corrigido para lm(dados$Fat ~ dados[[v]]),
#     referenciando os vetores diretamente sem o argumento data =.
# ===========================================================================


# Carrega o banco de dados a partir de arquivo texto tabulado
url <- "https://raw.githubusercontent.com/edsonzmartinez/CursoR/main/dados/antropo.txt"
dados <- read.table(url, header = TRUE, sep = "\t", dec = ".")

str(dados)
head(dados)


# ---------------------------------------------------------------------------
# Exercício 1 – Peso em quilogramas
# Converte libras para kg (1 lb = 0,45359237 kg)
# ---------------------------------------------------------------------------
dados$WeightKg <- dados$Weight * 0.45359237

head(dados[, c("Weight", "WeightKg")])


# ---------------------------------------------------------------------------
# Exercício 2 – Altura em centímetros
# Converte polegadas para cm (1 in = 2,54 cm)
# ---------------------------------------------------------------------------
dados$HeightCm <- dados$Height * 2.54

head(dados[, c("Height", "HeightCm")])


# ---------------------------------------------------------------------------
# Exercício 3 – Box-plots das variáveis contínuas
# ---------------------------------------------------------------------------
variaveis_continuas <- names(dados)[sapply(dados, is.numeric)]

par(mfrow = c(4, 4), mar = c(3, 3, 2, 1))

for (v in variaveis_continuas) {
  boxplot(dados[[v]],
          main    = v,
          col     = "grey80",
          ylab    = v,
          outline = TRUE)   # outline = TRUE exibe os outliers
}

par(mfrow = c(1, 1))


# ---------------------------------------------------------------------------
# Exercício 4 – Dispersão peso × altura com destaque de outliers
# ---------------------------------------------------------------------------
plot(dados$HeightCm, dados$WeightKg,
     xlab = "Altura (cm)",
     ylab = "Peso (kg)",
     main = "Dispersão: Peso vs Altura",
     pch  = 16,
     col  = "grey40")

# Identifica possíveis outliers pela distância de Mahalanobis
coords  <- cbind(dados$HeightCm, dados$WeightKg)
d2      <- mahalanobis(coords, colMeans(coords), cov(coords))
outlier <- which(d2 > qchisq(0.975, df = 2))

# Destaca os outliers em vermelho e numera as observações
points(dados$HeightCm[outlier], dados$WeightKg[outlier],
       pch = 16, col = "red")
text(dados$HeightCm[outlier], dados$WeightKg[outlier],
     labels = outlier, pos = 3, cex = 0.75, col = "red")


# ---------------------------------------------------------------------------
# Exercício 5 – Histogramas: idade, peso e estatura
# ---------------------------------------------------------------------------
par(mfrow = c(1, 3))

hist(dados$Age,
     main   = "Distribuição da Idade",
     xlab   = "Idade (anos)",
     col    = "grey70",
     border = "white")

hist(dados$WeightKg,
     main   = "Distribuição do Peso",
     xlab   = "Peso (kg)",
     col    = "grey70",
     border = "white")

hist(dados$HeightCm,
     main   = "Distribuição da Altura",
     xlab   = "Altura (cm)",
     col    = "grey70",
     border = "white")

par(mfrow = c(1, 1))


# ---------------------------------------------------------------------------
# Exercício 6 – Dispersão entre Fat e as demais variáveis
# CORREÇÃO: substituído lm(Fat ~ dados[[v]], data = dados)
#           por      lm(dados$Fat ~ dados[[v]])
#           O argumento data = dados exige nomes de colunas na fórmula;
#           dados[[v]] é um vetor externo e causava erro.
# ---------------------------------------------------------------------------
outras_vars <- setdiff(names(dados)[sapply(dados, is.numeric)], "Fat")

n  <- length(outras_vars)
nc <- 4
nr <- ceiling(n / nc)

par(mfrow = c(nr, nc), mar = c(3, 3, 2, 1))

for (v in outras_vars) {
  plot(dados[[v]], dados$Fat,
       xlab = v,
       ylab = "Fat (%)",
       main = paste("Fat vs", v),
       pch  = 16,
       col  = "grey40",
       cex  = 0.7)
  abline(lm(dados$Fat ~ dados[[v]]),   # <- CORRIGIDO
         col = "red", lwd = 1.5)
}

par(mfrow = c(1, 1))


# ---------------------------------------------------------------------------
# Exercício 7 – Coeficientes de correlação com Fat
# ---------------------------------------------------------------------------
outras_vars <- setdiff(names(dados)[sapply(dados, is.numeric)], "Fat")

cors <- sapply(outras_vars, function(v) {
  cor(dados$Fat, dados[[v]], use = "complete.obs")
})

# Exibe em ordem decrescente de correlação absoluta
sort(abs(cors), decreasing = TRUE)


# ---------------------------------------------------------------------------
# Exercício 8 – Tendência de Abdomen com a idade
# ---------------------------------------------------------------------------
plot(dados$Age, dados$Abdomen,
     xlab = "Idade (anos)",
     ylab = "Abdômen (cm)",
     main = "Relação entre Idade e Circunferência Abdominal",
     pch  = 16,
     col  = "grey40")

abline(lm(Abdomen ~ Age, data = dados), col = "red", lwd = 2)

# Coeficiente de correlação para quantificar a tendência
cor.test(dados$Age, dados$Abdomen)


# ---------------------------------------------------------------------------
# Exercício 9 – Variável binária de grupo de idade
# ---------------------------------------------------------------------------
dados$AgeGroup <- ifelse(dados$Age <= 45, 0, 1)

table(dados$AgeGroup)

dados$AgeGroup_label <- factor(dados$AgeGroup,
                               levels = c(0, 1),
                               labels = c("Até 45 anos", "Acima de 45 anos"))


# ---------------------------------------------------------------------------
# Exercício 10 – Box-plots por grupo de idade
# ---------------------------------------------------------------------------
vars_cont <- names(dados)[sapply(dados, is.numeric)]
vars_cont <- setdiff(vars_cont, "AgeGroup")

par(mfrow = c(4, 4), mar = c(4, 3, 2, 1))

for (v in vars_cont) {
  boxplot(dados[[v]] ~ dados$AgeGroup_label,
          main     = v,
          xlab     = "Grupo de Idade",
          ylab     = v,
          col      = c("grey70", "grey30"),
          las      = 2,
          cex.axis = 0.75)
}

par(mfrow = c(1, 1))


# ---------------------------------------------------------------------------
# Exercício 11 – Testes de normalidade e QQ-plots
# ---------------------------------------------------------------------------
vars_cont <- setdiff(names(dados)[sapply(dados, is.numeric)], "AgeGroup")

# Testes de Shapiro-Wilk
resultados_sw <- lapply(vars_cont, function(v) {
  sw <- shapiro.test(dados[[v]])
  data.frame(variavel = v, W = sw$statistic, p_valor = sw$p.value)
})
do.call(rbind, resultados_sw)

# QQ-plots
par(mfrow = c(4, 4), mar = c(3, 3, 2, 1))

for (v in vars_cont) {
  qqnorm(dados[[v]],
         main = paste("QQ -", v),
         pch  = 16,
         col  = "grey40",
         cex  = 0.6)
  qqline(dados[[v]], col = "red", lwd = 1.5)
}

par(mfrow = c(1, 1))


# ---------------------------------------------------------------------------
# Exercício 12 – Testes de comparação de médias por grupo de idade
# ---------------------------------------------------------------------------
vars_cont <- setdiff(names(dados)[sapply(dados, is.numeric)], "AgeGroup")

resultados <- lapply(vars_cont, function(v) {
  g0 <- dados[[v]][dados$AgeGroup == 0]
  g1 <- dados[[v]][dados$AgeGroup == 1]

  # Verifica normalidade em cada grupo
  normal <- (shapiro.test(g0)$p.value > 0.05) &
            (shapiro.test(g1)$p.value > 0.05)

  # Escolhe o teste adequado
  if (normal) {
    res   <- t.test(g0, g1)
    teste <- "t de Student"
  } else {
    res   <- wilcox.test(g0, g1)
    teste <- "Wilcoxon"
  }

  data.frame(variavel = v, teste = teste, p_valor = res$p.value)
})

resultado_final <- do.call(rbind, resultados)
resultado_final
