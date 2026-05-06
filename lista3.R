########## Lista de Exercícios 3
# Autor: Maria Rosa Francisco Lourenço Barbosa
# N° aluno: 17764481
# RMS5772 - Introdução ao R para Pesquisa em Saúde
#
# Base de dados: Dados climáticos de Ribeirão Preto, 1991 a 2021
# CORREÇÃO APLICADA:
#   - A URL estava quebrada em duas linhas no PDF original, o que causaria
#     erro ao copiar. Reunida em uma única linha contínua.
# ===========================================================================


# Carrega a base de dados diretamente da URL
url <- "https://raw.githubusercontent.com/edsonzmartinez/CursoR/main/dados/dadosclimaticosRP.csv"
dados <- read.csv(url, header = TRUE, sep = ",")


# ---------------------------------------------------------------------------
# (a) Nome das variáveis
# ---------------------------------------------------------------------------
names(dados)


# ---------------------------------------------------------------------------
# (b) Seis primeiras linhas
# ---------------------------------------------------------------------------
head(dados)


# ---------------------------------------------------------------------------
# (c) Seis últimas linhas
# ---------------------------------------------------------------------------
tail(dados)


# ---------------------------------------------------------------------------
# (d) Linhas 20 a 40
# ---------------------------------------------------------------------------
dados[20:40, ]


# ---------------------------------------------------------------------------
# (e) Linhas do ano de 1993
# ---------------------------------------------------------------------------
subset(dados, ano == 1993)

# Alternativa equivalente usando indexação lógica:
dados[dados$ano == 1993, ]


# ---------------------------------------------------------------------------
# (f) Box-plot da precipitação por mês
# ---------------------------------------------------------------------------
# Converte a variável mês em fator ordenado para garantir a ordem correta no eixo x
dados$mes_fator <- factor(dados$mes, levels = 1:12,
                          labels = c("janeiro",  "fevereiro", "março",    "abril",
                                     "maio",     "junho",     "julho",    "agosto",
                                     "setembro", "outubro",   "novembro", "dezembro"))

boxplot(precipitacao ~ mes_fator, data = dados,
        xlab     = "Mês",
        ylab     = "Precipitação (mm)",
        col      = "grey80",
        las      = 2,
        cex.axis = 0.8)


# ---------------------------------------------------------------------------
# (g) Gráfico de temperaturas mensais (1991–2021)
# ---------------------------------------------------------------------------
# Cria uma variável de data (ano + mês) para o eixo x
dados$data <- as.Date(paste(dados$ano, dados$mes, "01", sep = "-"))

# Define os limites do eixo y para englobar máxima e mínima
ylim_vals <- range(c(dados$tmax, dados$tmin), na.rm = TRUE)

# Plota a temperatura máxima em vermelho
plot(dados$data, dados$tmax,
     type = "l",
     col  = "red",
     ylim = ylim_vals,
     xlab = "",
     ylab = "Temperatura (°C)",
     main = "Temperaturas mensais em Ribeirão Preto, 1991 a 2021",
     xaxt = "n")

# Adiciona a temperatura mínima em azul
lines(dados$data, dados$tmin, col = "blue")

# Adiciona o eixo x com anos rotulados
axis.Date(1,
          at       = seq(min(dados$data), max(dados$data), by = "year"),
          format   = "%Y",
          las      = 2,
          cex.axis = 0.65)

# Adiciona a legenda no canto inferior direito
legend("bottomright",
       legend = c("Temperatura máxima", "Temperatura mínima"),
       col    = c("red", "blue"),
       lty    = 1,
       bty    = "n",
       cex    = 0.8)
