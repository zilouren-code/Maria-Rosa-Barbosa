########## Lista de Exercícios 5 - Criando funções no R
# Autor: Maria Rosa Francisco Lourenço Barbosa 
# N° aluno: 17764481
# RMS5772 - Introdução ao R para Pesquisa em Saúde

# Removendo objetos ativos
rm(list = ls())

# Função principal solicitada no exercício
# Retorna o LDLc calculado pela equação de Friedewald
# e exibe os avisos conforme itens (a), (b) e (c)
calcular_ldlc <- function(CT, HDLc, TG, jejum = TRUE) {
  
  # Validação básica dos argumentos
  if (!is.numeric(CT) || !is.numeric(HDLc) || !is.numeric(TG)) {
    stop("CT, HDLc e TG devem ser valores numéricos.")
  }
  
  # Cálculo do VLDLc e LDLc (equação de Friedewald)
  VLDLc <- TG / 5
  LDLc  <- CT - HDLc - VLDLc
  
  # (a) Aviso de imprecisão quando TG >= 400 mg/dL
  if (TG >= 400) {
    warning("Atenção: Nível de TG >= 400 mg/dL. A equação de Friedewald torna-se imprecisa (hipertrigliceridemia).")
  }
  
  # (b) Hiperlipidemia mista (LDLc >= 160 e TG acima do limite conforme jejum)
  tg_limite <- ifelse(jejum, 150, 175)
  if (LDLc >= 160 && TG >= tg_limite) {
    message("Aviso: As concentrações indicam HIPERLIPIDEMIA MISTA (LDLc >= 160 mg/dL e TG elevado).")
  } else {
    # (c) Hipercolesterolemia isolada (na ausência de mista e LDLc > 160 mg/dL)
    if (LDLc > 160) {
      message("Aviso: As concentrações indicam HIPERCOLESTEROLEMIA ISOLADA (LDLc > 160 mg/dL).")
    }
  }
  
  # Retorna o valor calculado do LDLc
  return(LDLc)
}

# Exemplo de uso (conforme o enunciado)
# calcular_ldlc(CT = 192, HDLc = 54, TG = 143, jejum = TRUE)
# Deve retornar 109.4 e não exibir nenhum aviso
