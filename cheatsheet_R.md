# Cheat Sheet de R — RMS5772 Introdução ao R para Pesquisa em Saúde
> Baseado nas resoluções das Listas 1 a 5. Cobre operações básicas, estruturas de dados,
> leitura de arquivos, estatística descritiva, visualização, testes de hipóteses e criação de funções.

---

## 1. Operações Fundamentais

### 1.1 Aritméticas e precedência

```r
3 + 4 * 8       # Multiplicação tem precedência: resultado = 35
(3 + 4) * 8     # Parênteses alteram a ordem: resultado = 56
2^3             # Potenciação: 8
sqrt(3)         # Raiz quadrada
abs(8 - 19)     # Valor absoluto: 11
factorial(7)    # Fatorial: 5040
log(9)          # Logaritmo natural (base e)
log(9, base=10) # Logaritmo na base 10
```

A precedência em R segue: `^` > `*`, `/` > `+`, `-`. Use parênteses sempre que houver dúvida.

### 1.2 Funções trigonométricas e constantes

```r
pi              # 3.141593...
cos(pi)         # -1
sin(pi)         # aprox. 0 (erro de ponto flutuante)
sin(pi)^2 + cos(pi)^2  # Identidade trigonométrica: sempre 1
```

### 1.3 Limpeza do ambiente

```r
rm(list = ls())  # Remove todos os objetos do ambiente atual
```

Boa prática executar no início de cada script para evitar conflitos com sessões anteriores.

---

## 2. Tipos e Estruturas de Dados

### 2.1 Vetores e seus tipos

```r
a <- 1:10                   # Inteiro (integer)
b <- letters[1:6]           # Caractere: "a" "b" "c" "d" "e" "f"
d <- c("verde", "azul")     # Caractere explícito
e <- c(4i, 8i, 9i)          # Complexo
f <- c(5 > 2, 7 < 2)        # Lógico: TRUE FALSE
g <- date()                  # Objeto de data/hora como string
```

### 2.2 Inspecionando tipo e classe

```r
mode(x)    # Modo de armazenamento: "numeric", "character", "logical", "complex"
class(x)   # Classe do objeto: "integer", "matrix", "data.frame", "Date", etc.
typeof(x)  # Tipo interno (mais granular que mode)
str(x)     # Resumo compacto da estrutura: classes, tamanhos, primeiros valores
```

Diferenca entre `mode` e `class`: `mode` revela o tipo de armazenamento; `class` revela o comportamento do objeto. Uma matriz de letras tem `mode = "character"` e `class = "matrix"`.

### 2.3 Matrizes

```r
# Criação — byrow = TRUE preenche por linhas
x <- matrix(c(5, 0, 6, 9, 6, 4, 3, 5, 2), nrow = 3, byrow = TRUE)

dim(x)     # Dimensoes: c(3, 3)
diag(x)    # Diagonal principal: c(5, 6, 2)
nrow(x)    # Numero de linhas
ncol(x)    # Numero de colunas
t(x)       # Transposta
```

### 2.4 Fatores (factor)

Usados para variáveis categóricas. Internamente armazenados como inteiros com rótulos.

```r
# Fator ordenado — essencial para controlar a ordem em gráficos
dados$mes_fator <- factor(dados$mes,
                          levels = 1:12,
                          labels = c("janeiro", "fevereiro", ..., "dezembro"))

# Fator a partir de variável binária
dados$AgeGroup_label <- factor(dados$AgeGroup,
                               levels = c(0, 1),
                               labels = c("Até 45 anos", "Acima de 45 anos"))
```

Sem `levels` explícito, R ordena alfabeticamente — o que distorce eixos em gráficos.

---

## 3. Sequências e Repetições

### 3.1 seq()

```r
seq(40, 20, by = -4)    # 40 36 32 28 24 20  (decrescente com passo)
seq(0, 1, by = 0.2)     # 0.0 0.2 0.4 0.6 0.8 1.0
seq(1, 10, length.out = 5)  # 5 valores igualmente espaçados entre 1 e 10
```

### 3.2 rep()

```r
rep(c(9, 5, 2), 3)          # 9 5 2 9 5 2 9 5 2  (repete o vetor inteiro)
rep(c(9, 5, 2), each = 3)   # 9 9 9 5 5 5 2 2 2  (repete cada elemento)
c(rep(9, 3), rep(7, 3))     # 9 9 9 7 7 7  (concatenação de rep's)
```

---

## 4. Leitura de Dados

### 4.1 Formatos suportados

```r
# CSV com separador ponto-e-virgula e decimal virgula (padrao europeu/brasileiro)
jog <- read.csv2("arquivo.csv")
jog <- read.csv2("https://url.com/arquivo.csv")

# CSV com separador virgula e decimal ponto (padrao americano)
dados <- read.csv("arquivo.csv", header = TRUE, sep = ",")

# Arquivo texto tabulado (sep = "\t")
dados <- read.table("arquivo.txt", header = TRUE, sep = "\t", dec = ".")
```

A diferença entre `read.csv` e `read.csv2`: o primeiro usa `,` como separador; o segundo usa `;`. No Brasil, onde a vírgula é o separador decimal, arquivos exportados por Excel geralmente exigem `read.csv2`.

### 4.2 Exploração inicial obrigatória

```r
str(dados)         # Estrutura: tipo de cada coluna, número de linhas
head(dados)        # Primeiras 6 linhas
tail(dados)        # Ultimas 6 linhas
names(dados)       # Nomes das colunas
dim(dados)         # c(nlinhas, ncolunas)
summary(dados)     # Resumo estatístico de todas as colunas
```

---

## 5. Indexação e Filtragem

### 5.1 Indexação por posição

```r
dados[20:40, ]       # Linhas 20 a 40, todas as colunas
dados[, 3]           # Coluna 3, todas as linhas
dados[1, 2]          # Elemento na linha 1, coluna 2
dados[[v]]           # Acessa coluna pelo nome armazenado em variável (retorna vetor)
dados$coluna         # Acessa coluna pelo nome direto (retorna vetor)
```

Atenção: `dados[["coluna"]]` e `dados$coluna` são equivalentes. Use `dados[[v]]` dentro de loops onde `v` é uma string com o nome da variável.

### 5.2 Filtragem lógica

```r
# Duas formas equivalentes de filtrar por ano
subset(dados, ano == 1993)
dados[dados$ano == 1993, ]

# Filtragem com múltiplas condições
dados[dados$ano == 1993 & dados$mes == 6, ]
dados[dados$idade > 25, ]

# Indexação lógica para extrair vetor filtrado
altura_filtrada <- dados$altura[dados$idade > 25]
```

---

## 6. Estatística Descritiva

### 6.1 Medidas de posição e dispersão

```r
mean(x, na.rm = TRUE)      # Media aritmética
median(x, na.rm = TRUE)    # Mediana
sd(x, na.rm = TRUE)        # Desvio padrão amostral
var(x, na.rm = TRUE)       # Variância amostral
IQR(x, na.rm = TRUE)       # Amplitude interquartil (Q3 - Q1)
range(x, na.rm = TRUE)     # c(mínimo, máximo)
diff(range(x, na.rm=TRUE)) # Amplitude total (max - min)
min(x, na.rm = TRUE)
max(x, na.rm = TRUE)
```

O argumento `na.rm = TRUE` é essencial quando há valores ausentes (`NA`). Sem ele, qualquer `NA` no vetor retorna `NA` como resultado.

### 6.2 Tabelas de frequência

```r
table(dados$posicao)              # Frequência absoluta
prop.table(table(dados$posicao))  # Frequência relativa (proporção 0–1)
prop.table(table(dados$posicao)) * 100  # Frequência relativa em %
round(prop.table(...), 2)         # Arredondar para 2 casas decimais
```

### 6.3 Discretização de variável contínua (cut)

```r
cortes <- cut(idade,
              breaks = c(22, 24, 26, 28, 30, 32, 34),
              right = TRUE,        # Intervalo fechado à direita: (22, 24]
              include.lowest = FALSE)
table(cortes)
```

`right = TRUE` cria intervalos do tipo `(a, b]`; `right = FALSE` cria `[a, b)`.

### 6.4 Estatísticas por grupo (tapply)

```r
# Calcula média por grupo — equivalente a um GROUP BY em SQL
tapply(dados$altura, dados$posicao, mean, na.rm = TRUE)

# Múltiplas estatísticas por grupo
tapply(altura, posicao, function(x) {
  c(media        = mean(x,   na.rm = TRUE),
    desvio_padrao = sd(x,   na.rm = TRUE),
    mediana       = median(x, na.rm = TRUE))
})
```

---

## 7. Funções de Aplicação (Apply Family)

### 7.1 sapply — aplica função em vetor, retorna vetor/matriz simplificado

```r
# Verifica quais colunas são numéricas
sapply(dados, is.numeric)          # Retorna vetor lógico

# Nomes das colunas numéricas
names(dados)[sapply(dados, is.numeric)]

# Calcular correlação de cada variável com Fat
cors <- sapply(outras_vars, function(v) {
  cor(dados$Fat, dados[[v]], use = "complete.obs")
})
```

### 7.2 lapply — aplica função em lista, retorna lista

```r
# Aplicar Shapiro-Wilk a múltiplas variáveis
resultados_sw <- lapply(vars_cont, function(v) {
  sw <- shapiro.test(dados[[v]])
  data.frame(variavel = v, W = sw$statistic, p_valor = sw$p.value)
})

# Combinar lista de data.frames em um só
do.call(rbind, resultados_sw)
```

### 7.3 do.call — chama função com lista de argumentos

```r
# Empilha lista de data.frames verticalmente
resultado_final <- do.call(rbind, lista_de_dataframes)
```

---

## 8. Manipulação de Variáveis

### 8.1 Criação de novas colunas

```r
dados$WeightKg <- dados$Weight * 0.45359237  # Libras para kg
dados$HeightCm <- dados$Height * 2.54         # Polegadas para cm
dados$data     <- as.Date(paste(dados$ano, dados$mes, "01", sep = "-"))
```

`as.Date()` converte string para objeto de data, necessário para eixos temporais em gráficos.

### 8.2 Variável binária com ifelse

```r
dados$AgeGroup <- ifelse(dados$Age <= 45, 0, 1)
# ifelse(condicao, valor_se_verdadeiro, valor_se_falso)
# Vetorizado — funciona sobre todo o vetor de uma vez
```

### 8.3 Utilitários para nomes de colunas

```r
setdiff(a, b)    # Elementos de 'a' que não estão em 'b'
# Exemplo: todas as variáveis numéricas exceto "Fat"
outras_vars <- setdiff(names(dados)[sapply(dados, is.numeric)], "Fat")
```

---

## 9. Visualização — Gráficos Base do R

### 9.1 Configuração de layout multipanel

```r
par(mfrow = c(4, 4), mar = c(3, 3, 2, 1))
# mfrow = c(linhas, colunas) — define grade de painéis
# mar   = c(baixo, esquerda, cima, direita) — margens em linhas de texto

# IMPORTANTE: restaurar após o bloco de gráficos
par(mfrow = c(1, 1))
```

### 9.2 Boxplot

```r
# Boxplot simples de um vetor
boxplot(dados$precipitacao,
        main = "Precipitação",
        ylab = "mm",
        col  = "grey80")

# Boxplot por grupo (notação formula: variavel ~ grupo)
boxplot(precipitacao ~ mes_fator, data = dados,
        xlab     = "Mês",
        ylab     = "Precipitação (mm)",
        col      = "grey80",
        las      = 2,      # Rótulos do eixo x na vertical
        cex.axis = 0.8)    # Tamanho da fonte dos rótulos dos eixos

# Boxplot por grupo com vetor externo (sem data =)
boxplot(dados[[v]] ~ dados$AgeGroup_label,
        col = c("grey70", "grey30"))
```

`outline = TRUE` (padrão) exibe os outliers como pontos; `outline = FALSE` os oculta.

### 9.3 Gráfico de dispersão (plot)

```r
plot(dados$HeightCm, dados$WeightKg,
     xlab = "Altura (cm)",
     ylab = "Peso (kg)",
     main = "Dispersão: Peso vs Altura",
     pch  = 16,        # Tipo de ponto (16 = círculo preenchido)
     col  = "grey40")

# Adicionar pontos sobre gráfico existente
points(x_outlier, y_outlier, pch = 16, col = "red")

# Adicionar rótulos de texto
text(x, y, labels = indices, pos = 3, cex = 0.75, col = "red")
# pos: 1=baixo, 2=esquerda, 3=cima, 4=direita
```

### 9.4 Série temporal com plot + lines

```r
# Primeiro traçado — cria o eixo
plot(dados$data, dados$tmax,
     type = "l",        # "l" = linha
     col  = "red",
     ylim = range(c(dados$tmax, dados$tmin), na.rm = TRUE),
     xlab = "",
     ylab = "Temperatura (°C)",
     main = "Temperaturas mensais",
     xaxt = "n")        # Suprime eixo x automático

# Linha adicional sobre o mesmo gráfico
lines(dados$data, dados$tmin, col = "blue")

# Eixo x customizado para datas
axis.Date(1,
          at     = seq(min(dados$data), max(dados$data), by = "year"),
          format = "%Y",
          las    = 2,
          cex.axis = 0.65)
```

### 9.5 Histograma

```r
hist(dados$Age,
     main   = "Distribuição da Idade",
     xlab   = "Idade (anos)",
     col    = "grey70",
     border = "white")   # Cor das bordas das barras
```

### 9.6 Legenda

```r
legend("bottomright",
       legend = c("Temperatura máxima", "Temperatura mínima"),
       col    = c("red", "blue"),
       lty    = 1,      # Tipo de linha (1 = sólida)
       bty    = "n",    # Sem borda ao redor da legenda
       cex    = 0.8)    # Tamanho do texto
```

Posições válidas para legenda: `"topleft"`, `"topright"`, `"bottomleft"`, `"bottomright"`, `"top"`, `"bottom"`, `"left"`, `"right"`, `"center"`.

---

## 10. Regressão Linear e Correlação

### 10.1 Reta de regressão (lm + abline)

```r
# Notação formula com data = — colunas pelo nome
abline(lm(Abdomen ~ Age, data = dados), col = "red", lwd = 2)

# Notação direta com vetores — usar quando a coluna é acessada via [[v]]
abline(lm(dados$Fat ~ dados[[v]]), col = "red", lwd = 1.5)
```

Erro comum: usar `lm(Fat ~ dados[[v]], data = dados)`. O R procura `dados[[v]]` como nome de coluna dentro do data frame, não encontra e retorna erro. A solução é referenciar os vetores diretamente sem `data =`.

### 10.2 Correlação de Pearson

```r
# Coeficiente simples
cor(dados$Fat, dados[[v]], use = "complete.obs")

# Teste com IC e p-valor
cor.test(dados$Age, dados$Abdomen)
cor.test(idade, altura, method = "pearson", conf.level = 0.95)
# Retorna: $estimate, $conf.int, $p.value
```

### 10.3 Ordenar correlações por magnitude

```r
sort(abs(cors), decreasing = TRUE)
```

---

## 11. Detecção de Outliers

### 11.1 Distância de Mahalanobis

```r
coords  <- cbind(dados$HeightCm, dados$WeightKg)
d2      <- mahalanobis(coords, colMeans(coords), cov(coords))
outlier <- which(d2 > qchisq(0.975, df = 2))

# qchisq(0.975, df = 2) é o quantil 97.5% da qui-quadrado com 2 graus de liberdade
# Observações além desse limiar são consideradas outliers multivariados
```

A distância de Mahalanobis é preferível à distância euclidiana porque leva em conta a correlação entre variáveis e as escalas diferentes.

---

## 12. Testes de Normalidade e Não-Paramétricos

### 12.1 Shapiro-Wilk

```r
shapiro.test(dados$Age)
# $statistic W — quanto mais próximo de 1, mais normal
# $p.value   — p < 0.05 indica desvio significativo da normalidade
```

Limitação: para amostras grandes (n > 5000), o teste tende a rejeitar normalidade mesmo com desvios pequenos e sem relevância prática.

### 12.2 QQ-plot

```r
qqnorm(dados[[v]],
       main = paste("QQ -", v),
       pch  = 16,
       col  = "grey40")
qqline(dados[[v]], col = "red", lwd = 1.5)
```

Se os pontos seguem a reta vermelha, a distribuição é aproximadamente normal. Desvios nas caudas indicam assimetria ou caudas pesadas.

### 12.3 Testes de comparação de médias

```r
# Paramétrico — pressupõe normalidade
t.test(g0, g1)

# Não-paramétrico — usa postos (ranks), não pressupõe normalidade
wilcox.test(g0, g1)
```

Estratégia aplicada nas listas: testar normalidade em cada grupo com Shapiro-Wilk; se ambos forem normais (p > 0.05), aplicar t de Student; caso contrário, Wilcoxon.

---

## 13. Criação de Funções

### 13.1 Sintaxe básica

```r
nome_funcao <- function(arg1, arg2, arg3 = valor_padrao) {
  # corpo da função
  return(resultado)  # return() é opcional — R retorna o último objeto avaliado
}
```

### 13.2 Retornando múltiplos valores (list)

```r
estat_desc <- function(x) {
  list(
    media    = mean(x, na.rm = TRUE),
    mediana  = median(x, na.rm = TRUE),
    sd       = sd(x, na.rm = TRUE),
    iqr      = IQR(x, na.rm = TRUE),
    amplitude = diff(range(x, na.rm = TRUE))
  )
}
# Acesso: resultado <- estat_desc(x); resultado$media
```

### 13.3 Validação de entrada e mensagens

```r
# Para com mensagem de erro — interrompe a execução
stop("CT, HDLc e TG devem ser valores numéricos.")

# Aviso — execução continua, mensagem aparece no console
warning("TG >= 400 mg/dL: equação de Friedewald imprecisa.")

# Mensagem informativa — não é erro nem aviso
message("Aviso: hiperlipidemia mista identificada.")
```

Hierarquia: `stop` > `warning` > `message`. Use `stop` para erros que invalidam o resultado, `warning` para imprecisões e `message` para informações diagnósticas.

### 13.4 Argumento lógico com ifelse dentro de função

```r
calcular_ldlc <- function(CT, HDLc, TG, jejum = TRUE) {
  VLDLc    <- TG / 5
  LDLc     <- CT - HDLc - VLDLc
  tg_limite <- ifelse(jejum, 150, 175)  # Limiar depende do estado de jejum
  
  if (LDLc >= 160 && TG >= tg_limite) {
    message("Hiperlipidemia mista.")
  } else if (LDLc > 160) {
    message("Hipercolesterolemia isolada.")
  }
  
  if (TG >= 400) warning("Friedewald impreciso com TG >= 400.")
  
  return(LDLc)
}
```

Diferença entre `&` e `&&`: `&&` é escalar (avalia apenas o primeiro elemento); `&` é vetorizado. Dentro de `if()`, use sempre `&&` e `||`.

---

## 14. Controle de Fluxo

### 14.1 if / else

```r
if (condicao) {
  # executado se verdadeiro
} else if (outra_condicao) {
  # executado se a segunda for verdadeira
} else {
  # executado em todos os outros casos
}
```

### 14.2 Loop for

```r
for (v in variaveis_continuas) {
  boxplot(dados[[v]], main = v, col = "grey80")
}
```

Padrão recorrente: iterar sobre nomes de colunas com `dados[[v]]` para acessar cada coluna dinamicamente.

### 14.3 ifelse (vetorizado)

```r
dados$AgeGroup <- ifelse(dados$Age <= 45, 0, 1)
# Equivalente a if/else mas opera sobre vetores inteiros de uma vez
```

---

## 15. Utilitários Frequentes

```r
paste("Fat vs", v)               # Concatena strings com espaço
paste0("prefixo", sufixo)        # Concatena sem separador
ceiling(n / nc)                  # Arredondamento para cima (util para definir nrows no par())
length(x)                        # Tamanho de um vetor ou lista
which(condicao_logica)           # Indices onde a condicao e TRUE
cbind(v1, v2)                    # Combina vetores/matrizes por coluna
rbind(df1, df2)                  # Combina data.frames por linha
colMeans(matriz)                 # Media de cada coluna
cov(matriz)                      # Matriz de covariância
is.numeric(x)                    # TRUE se x for numerico
```

---

## 16. Padroes de Codigo Recorrentes nas Listas

### Padrão 1 — Aplicar estatística a todas as variáveis numéricas

```r
vars_num <- names(dados)[sapply(dados, is.numeric)]
resultados <- lapply(vars_num, function(v) {
  data.frame(variavel = v, media = mean(dados[[v]], na.rm = TRUE))
})
do.call(rbind, resultados)
```

### Padrão 2 — Testar e escolher teste estatístico automaticamente

```r
g0 <- dados[[v]][dados$AgeGroup == 0]
g1 <- dados[[v]][dados$AgeGroup == 1]
normal <- (shapiro.test(g0)$p.value > 0.05) & (shapiro.test(g1)$p.value > 0.05)
if (normal) res <- t.test(g0, g1) else res <- wilcox.test(g0, g1)
```

### Padrão 3 — Gráficos multipanel com loop

```r
par(mfrow = c(4, 4), mar = c(3, 3, 2, 1))
for (v in vars_cont) {
  boxplot(dados[[v]] ~ dados$grupo, main = v, col = c("grey70", "grey30"))
}
par(mfrow = c(1, 1))
```

### Padrão 4 — Dispersão com reta de regressão para múltiplas variáveis

```r
for (v in outras_vars) {
  plot(dados[[v]], dados$Fat, xlab = v, ylab = "Fat (%)",
       pch = 16, col = "grey40", cex = 0.7)
  abline(lm(dados$Fat ~ dados[[v]]), col = "red", lwd = 1.5)
}
```

---

## 17. Armadilhas Comuns e Suas Solucoes

| Situacao | Erro tipico | Solucao correta |
|---|---|---|
| Usar `lm()` com `data=` e variavel de coluna dinâmica | `lm(Y ~ dados[[v]], data = dados)` | `lm(dados$Y ~ dados[[v]])` |
| Eixo x de mes desordenado em boxplot | `factor(mes)` sem `levels` | `factor(mes, levels = 1:12, labels = ...)` |
| Resultado `NA` em estatísticas | Ignorar valores faltantes | Sempre usar `na.rm = TRUE` |
| Gráfico multipanel não restaurado | `par(mfrow = c(4,4))` sem restaurar | Sempre fechar com `par(mfrow = c(1,1))` |
| `&&` vs `&` em condicionais | `if (a & b)` pode gerar warning | Usar `&&` em `if()` escalares |
| URL de dados quebrada em múltiplas linhas | Erro ao carregar CSV | Garantir que a URL é uma string única contínua |
