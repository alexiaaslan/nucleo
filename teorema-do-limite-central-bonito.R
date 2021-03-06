# TLC

# Preparando o Ambiente
rm(list=ls())

#caso necessario
install.packages("XML")
install.packages("ggplot2")

#carregar os pacotes
library(XML)
library(ggplot2)

# Obtendo os dados online
url <- "http://www.pnud.org.br/atlas/ranking/ranking-idhm-municipios-2010.aspx"
pnud <- readHTMLTable(url, encoding = "utf-8")[[1]]

# Organizando a base de dados
names(pnud) <- c("ranking","municipio","idh","idh.renda","idh.longevidade","idh.educacao")
for (var in 3:6){
  pnud[,var] <- as.numeric(substr(as.character(pnud[,var]),3,5))/1000
}
pnud$ranking <- as.character(pnud$ranking)
pnud$ranking <- as.numeric(substr(pnud$ranking,1,nchar(pnud$ranking)-2))
pnud$municipio <- as.character(pnud$municipio)
pnud$uf <- substr(pnud$municipio, nchar(pnud$municipio)-2, nchar(pnud$municipio)-1)
pnud$municipio <- substr(pnud$municipio, 1, nchar(pnud$municipio)-5)
pnud <- pnud[,c(1, 2, 7, 3:6)]

# 99mil samples n=36
dadosts <- data.frame()
for (i in 1:99999){
  trs <- sample(pnud$idh, 36)
  media <- mean(trs)
  dep <- sd(trs)
  
  dadosts <- rbind(dadosts, c(media,dep))
}
names(dadosts) <- c("medias", "sd")

plot(dadosts$medias, dnorm(dadosts$medias, mean(dadosts$medias), sd(dadosts$medias)), type = "l")

grats <- ggplot(dadosts, aes(x=medias))+
  +   geom_density(alpha=.3)

# 99mil samples n=100
dadoscem <- data.frame()
for (i in 1:99999){
  cem <- sample(pnud$idh, 100)
  media <- mean(cem)
  dep <- sd(cem)
  
  dadoscem <- rbind(dadoscem, c(media,dep))
}

plot(dadoscem$medias, dnorm(dadoscem$medias, mean(dadoscem$medias), sd(dadoscem$medias)), type = "l")

gracem <- ggplot(dadoscem, aes(x=medias))+
  geom_density(alpha=.3)

# 99mil samples n=1600
dadosmil <- data.frame()
for (i in 1:99999){
  mils <- sample(pnud$idh, 1600)
  media <- mean(mils)
  dep <- sd(mils)
  
  dadosmil <- rbind(dadoscem, c(media,dep))
}

plot(dadosmil$medias, dnorm(dadosmil$medias, mean(dadosmil$medias), sd(dadosmil$medias)), type = "l")

gramil <- ggplot(dadosmil, aes(x=medias))+
  geom_density(alpha=.3)