# Диплом Загитовой Елизаветы э404 на тему 
# "ФАКТОРЫ ЭКОНОМИЧЕСКОЙ ПОДДЕРЖКИ РОССИЙСКИХ РЕГИОНОВ В ПЕРИОД "КОРОНАКРИЗИСА" 
# (2023)

library('lmtest')
library('sandwich')
library('plm')
library('stats')
library('dplyr')
library('fixest')
library('splm')
library('lmtest')
library('MASS')
library('sf')
library('spdep')
library('lattice')
library('spatialreg')

#Подготовка

data$year20<-as.numeric(data$year==2020) 
data$year21<-as.numeric(data$year==2021)

data$laggrat <- stats::lag(data$gratuitous) #Как делать лаги.
data$deltagrat <-data$gratuitous - data$laggrat

data$lagownrev <- stats::lag(data$ownrev) #Как делать лаги.
data$deltaownrev <-data$ownrev - data$lagownrev


data$lagGRP <- stats::lag(data$GRP) #Как делать лаги.
lag(data$GRP)
data$lagGRP
data$lagGRP==lag(data$GRP)
#data1 <- na.omit(data)

data$depend <-data$gratuitous/data$ownrev
data$depend1 <-data$grat_sub/data$ownrev

data1$logrev <-log(data1$ownrev)
data1$laglogrev <- stats::lag(data1$logrev) #Как делать лаги.
data1$deltalogrev <-data1$logrev - data1$laglogrev


data$laggratS <- stats::lag(data$grat_sub) #Как делать лаги.
data$deltagratS <-data$grat_sub - data$laggratS

data$lagbal <- stats::lag(data$bal_dot) #Как делать лаги.
data$deltabal <-data$bal_dot - data$lagbal

data$laggrat <- stats::lag(data$gratuitous) #Как делать лаги.
data$deltagrat <-data$gratuitous - data$laggrat



shape <- read_sf("bs331gg4381.shp")
shape1 <- subset(shape, select =  c(id_1, name_1, varname_1))

shape1[3, "name_1"] <- "Алтайский край"
shape1[4, "name_1"] <- "Амурская область"
shape1[5, "name_1"] <- "Архангельская область"
shape1[6, "name_1"] <- "Белгородская область"
shape1[7, "name_1"] <- "Брянская область"
shape1[70, "name_1"] <- "Удмуртская Республика"
shape1[33, "name_1"] <- "Ханты-Мансийский АО"
shape1[46, "name_1"] <- "Ненецкий АО"
shape1[13, "name_1"] <- "Чукотский АО"
shape1[25, "name_1"] <- "Карачаево-Черкесская Республика"
shape1[20, "name_1"] <- "Кабардино-Балкарская Республика"

shape1[22, "name_1"]<- "Республика Калмыкия"
shape1[42, "name_1"]<- "Республика Мордовия"
shape1[14, "name_1"] <- "Чувашская Республика – Чувашия"
shape1[83, "name_1"] <- "Ямало-Ненецкий АО"
shape1[71, "name_1"] <- "Республика Татарстан (Татарстан)"
shape1[2, "name_1"] <- "Республика Башкортостан"
shape1[16, "name_1"] <- "Республика Дагестан"
shape1[11, "name_1"] <- "Чеченская республика"
shape1[43, "name_1"] <- "г. Москва"
shape1[18, "name_1"] <- "Республика Ингушетия"
shape1[1, "name_1"] <- "Республика Адыгея (Адыгея)"
shape1[15, "name_1"] <- "г. Санкт-Петербург"
shape1[84, "name_1"]<- "Еврейская АО"
shape1[30, "name_1"] <- "Кемеровская область - Кузбасс"
shape1[8, "name_1"] <- "Республика Бурятия"
shape1[32, "name_1"] <- "Республика Хакасия"

shape1[38, "name_1"] <- "Ленинградская область"
shape1[9, "name_1"] <- "Астраханская область"
shape1[10, "name_1"] <- "Ивановская область"
shape1[12, "name_1"] <- "Челябинская область"
shape1[17, "name_1"] <- "Республика Алтай"
shape1[19, "name_1"] <- "Иркутская область"
shape1[21, "name_1"] <- "Калининградская область"

shape1[23, "name_1"] <- "Калужская область"
shape1[24, "name_1"] <- "Камчатский край"
shape1[26, "name_1"] <- "Республика Карелия"
shape1[27, "name_1"] <- "Костромская область"
shape1[28, "name_1"] <- "Краснодарский край"
shape1[29, "name_1"] <- "Красноярский край"

shape1[31, "name_1"] <- "Хабаровский край"
shape1[34, "name_1"] <- "Кировская область"
shape1[35, "name_1"] <- "Республика Коми"
shape1[36, "name_1"] <- "Курганская область"
shape1[37, "name_1"] <- "Курская область"

shape1[39, "name_1"] <- "Липецкая область"
shape1[40, "name_1"] <- "Магаданская область"
shape1[41, "name_1"] <- "Республика Марий Эл"
shape1[44, "name_1"] <- "Московская область"
shape1[45, "name_1"] <- "Мурманская область"
shape1[47, "name_1"] <- "Республика Северная Осетия – Алания"

shape1[48, "name_1"] <- "Нижегородская область"
shape1[49, "name_1"] <- "Орловская область"
shape1[50, "name_1"] <- "Оренбургская область"
shape1[51, "name_1"] <- "Новгородская область"
shape1[52, "name_1"] <- "Сахалинская область"
shape1[53, "name_1"] <- "Республика Саха (Якутия)"
shape1[54, "name_1"] <- "Новосибирская область"
shape1[55, "name_1"] <- "Омская область"

shape1[56, "name_1"] <- "Пензенская область"
shape1[57, "name_1"] <- "Пермский край"
shape1[58, "name_1"] <- "Приморский край"
shape1[59, "name_1"] <- "Псковская область"
shape1[60, "name_1"] <- "Ростовская область"
shape1[61, "name_1"] <- "Рязанская область"
shape1[62, "name_1"] <- "Самарская область"
shape1[63, "name_1"] <- "Ставропольский край"
shape1[64, "name_1"] <- "Свердловская область" #66 67
shape1[65, "name_1"] <- "Саратовская область"
shape1[66, "name_1"] <- "Смоленская область"

shape1[69, "name_1"] <- "Тамбовская область"
shape1[72, "name_1"] <- "Томская область"
shape1[73, "name_1"] <- "Тульская область"

shape1[74, "name_1"] <- "Республика Тыва"
shape1[75, "name_1"] <- "Тверская область"
shape1[76, "name_1"] <- "Тюменская область"
shape1[77, "name_1"] <- "Ульяновская область"
shape1[78, "name_1"] <- "Владимирская область"
shape1[79, "name_1"] <- "Ярославская область"
shape1[80, "name_1"] <- "Волгоградская область"
shape1[81, "name_1"] <- "Вологодская область"

shape1[82, "name_1"] <- "Воронежская область"
shape1[85, "name_1"] <- "Забайкальский край"

shapenew <- shape1[-c(67), ]
shapenew <- shapenew[-c(67), ]
shape0 <- subset(shapenew, select =  c(name_1, geometry))
shape2 <- subset(shapenew, select =  c(name_1))


oop<-inner_join(shape2, data1,by=c("name_1"="id"))

reg = st_geometry(shape0)
nb_queen = poly2nb(reg)
Wbin = nb2listw(nb_queen, style = "W", zero.policy = TRUE)
listw2U(Wbin)

M = listw2mat(Wbin)
levelplot(M, main = "Матрица весов (бинарная)")

M = listw2mat(Wbin)
levelplot(M, 
          main = "Матрица весов (нормированная)", 
          at = levels, 
          col.regions = ramp(10))

nb_knn = knearneigh(coords, k = 1) %>% knn2nb()
Wbin = nb2listw(nb_knn, style = "B")
M = listw2mat(Wbin)
levelplot(M, 
          main = "Матрица весов (нормированная)", 
          at = levels, 
          col.regions = ramp(10))


#### Таблица 4
# FE

model1 <- feols (deltagrat ~ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21) + log(lagGRP) + log(populat)
                |id_N + year, panel.id = ~id_N + year, data = data)

summary(model1)

#System  GMM (two-step)

model2 <- pgmm (deltagrat ~ lag(deltagrat) + deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21) + log(lagGRP) + 
                log(populat)
              | lag(deltagrat, 2:5)
              | lag(deltaownrev, 1:5),
              model = "twosteps", data = data, index = c("id_N", "year"), transformation = 'ld', fsm = 'full', width = 3)

summary (model2, robust = TRUE)

#Spatial Lag model

model3 <- pspatfit(formula = deltagrat ~ deltaownrev + add + add1 + 
                                     +log(lagGRP) + log(populat), data = oop, listw = Wbin, type = "sar", 
                                   zero.policy = TRUE, index = c("id", "year"))
summary(model3)


#Spatial error within model

model4 <- spml (deltagrat ~ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21)+
                 log(lagGRP) + log(populat),
               data = oop, zero.policy = TRUE,
               index=c("id","year"),
               listw = Wbin, effect = "twoways",
               model = "within", spatial.error = "kkp",
               Hess = T) 


summary(model4)


#### Таблица П3
# FE

model1_1 <- feols (deltagratS ~ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21) + log(lagGRP) + log(populat)
                 |id_N + year, panel.id = ~id_N + year, data = data)

summary(model1_1)

#System  GMM (two-step)

model2_1 <- pgmm (deltagratS ~ lag(deltagratS) + deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21) + log(lagGRP) + 
                  log(populat)
                | lag(deltagratS, 2:5)
                | lag(deltaownrev, 1:5),
                model = "twosteps", data = data, index = c("id_N", "year"), transformation = 'ld', fsm = 'full', width = 3)

summary (model2_1, robust = TRUE)

#Spatial Lag model

model3_1 <- pspatfit(formula = deltagratS ~ deltaownrev + add + add1 + 
                     +log(lagGRP) + log(populat), data = oop, listw = Wbin, type = "sar", 
                   zero.policy = TRUE, index = c("id", "year"))
summary(model3_1)


#Spatial error within model

model4_1 <- spml (deltagratS ~ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21)+
                  log(lagGRP) + log(populat),
                data = oop, zero.policy = TRUE,
                index=c("id","year"),
                listw = Wbin, effect = "twoways",
                model = "within", spatial.error = "kkp",
                Hess = T) 


summary(model4_1)

#Проверка устойчивости: исключение Республика Дагестан, 
#Республика Ингушетия, Чеченская Республика, Республика Крым и г. Севастополь. 

test<-subset(data1, data1$id_N!=85)
test-subset(test, test$id_N!=79)
test<-subset(test, test$id_N!=82)
test<-subset(test, test$id_N!=37)
test<-subset(test, test$id_N!=36)

# FE

model1_2 <- feols (deltagratS ~ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21) + log(lagGRP) + log(populat)
                   |id_N + year, panel.id = ~id_N + year, data = test)

summary(model1_2)

#System  GMM (two-step)

model2_2 <- pgmm (deltagratS ~ lag(deltagratS) + deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21) + log(lagGRP) + 
                    log(populat)
                  | lag(deltagratS, 2:5)
                  | lag(deltaownrev, 1:5),
                  model = "twosteps", data = test, index = c("id_N", "year"), transformation = 'ld', fsm = 'full', width = 3)

summary (model2_2, robust = TRUE)

#Spatial Lag model

model3_2 <- pspatfit(formula = deltagratS ~ deltaownrev + add + add1 + 
                       +log(lagGRP) + log(populat), data = test, listw = Wbin, type = "sar", 
                     zero.policy = TRUE, index = c("id", "year"))
summary(model3_2)


#Spatial error within model

model4_2 <- spml (deltagratS ~ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21)+
                    log(lagGRP) + log(populat),
                  data = test, zero.policy = TRUE,
                  index=c("id","year"),
                  listw = Wbin, effect = "twoways",
                  model = "within", spatial.error = "kkp",
                  Hess = T) 


summary(model4_2)


ols <- lm(deltagrat ~  0+ deltaownrev + I(deltaownrev*year20) + I(deltaownrev*year21)+ log(lagGRP) + log(populat), data = data)
summary(ols)

pFtest(fixed, ols)


#Таблица 5

model5_1 <- feols ( log(depend) ~ log(lagGRP)+ I(log(lagGRP)*year20) + I(log(lagGRP)*year21) + 
                    log(populat)
                  |  year, panel.id = ~id_N + year, data = data)
summary(model5_1)

model5_2 <- pgmm (log(depend) ~ log(lag(depend)) +log(lagGRP)+ I(log(lagGRP)*year20) + I(log(lagGRP)*year21) + 
                 log(populat)
               | lag(log(depend), 2:5)
               | lag(log(lagGRP), 1:5),
               model = "twosteps", data = data, index = c("id_N", "year"), transformation = 'ld', fsm = 'full', width = 3)

summary (model5_2, robust = TRUE)


model5_3 <- feols (deltalogrev ~ log(lag(GRP))+ I(log(lag(GRP))*year20) + I(log(lag(GRP))*year21) +log(populat)
                  | id_N+year, panel.id = ~id_N + year, data = data)
summary(model5_3)

model5_4 <- pgmm (deltalogrev ~ lag(deltalogrev) +log(lagGRP)+ I(log(lagGRP)*year20) + I(log(lagGRP)*year21) + 
                 log(populat)
               | lag(deltalogrev, 3:5)
               | lag(log(lagGRP), 4:5),
               model = "twosteps", data = data, index = c("id_N", "year"), transformation = 'ld', fsm = 'full', width = 3)

summary (model5_4, robust = TRUE)


model5_5 <- feols ( log(depend1) ~ log(lagGRP)+ I(log(lagGRP)*year20) + I(log(lagGRP)*year21) + 
                      log(populat)
                    |  year, panel.id = ~id_N + year, data = data)
summary(model5_5)

model5_6 <- pgmm (log(depend1) ~ log(lag(depend1)) +log(lagGRP)+ I(log(lagGRP)*year20) + I(log(lagGRP)*year21) + 
                    log(populat)
                  | lag(log(depend1), 2:5)
                  | lag(log(lagGRP), 1:5),
                  model = "twosteps", data = data, index = c("id_N", "year"), transformation = 'ld', fsm = 'full', width = 3)

summary (model5_6, robust = TRUE)


#Таблицы 7-8


covid=subset(data, data$year20_21==1)

covid20=subset(covid, covid$year20==1)
covid21=subset(covid, covid$year21==1)

modelka1 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20 + republic, data = covid20)
summary(modelka1, robust=TRUE) 

modelka2 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_media20 + republic, data = covid20)
summary(modelka2, robust=TRUE) 

modelka3 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20 + pol_constit20, data = covid20)
summary(modelka3, robust=TRUE) 

modelka4 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20 + pol_constit20, data = covid20)
summary(modelka4, robust=TRUE) 


modelka1_1 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20 + pol_president, data = covid20)
summary(modelka1_1, robust=TRUE) 

modelka2_1 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_media20 + pol_president, data = covid20)
summary(modelka2_1, robust=TRUE) 

modelka3_1 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20 + pol_president, data = covid20)
summary(modelka3_1, robust=TRUE) 

modelka4_1 <- lm (log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20 + pol_president, data = covid20)
summary(modelka4_1, robust=TRUE) 



modelka5 <- lm (log(I(covid21/ownrev)) ~ log(lagGRP) + log(populat) + death_excess21 + republic, data = covid21)
summary(modelka5, robust=TRUE) 

modelka6 <- lm (log(I(covid21/ownrev)) ~ log(lagGRP) + log(populat) + death_excess21 + pol_constit21, data = covid21)
summary(modelka6, robust=TRUE) 

modelka7 <- lm (log(I(covid21/ownrev)) ~ log(lagGRP) + log(populat) + death_excess2020 + pol_constit21, data = covid21)
summary(modelka7, robust=TRUE) 

modelka8 <- lm (log(I(covid21/ownrev)) ~ log(lagGRP) + log(populat) + death_excess2020 + republic, data = covid21)
summary(modelka8, robust=TRUE)



modelka5_1 <- lm (log(I(covid21/ownrev)) ~ log(lagGRP) + log(populat) + death_excess21 + pol_president, data = covid21)
summary(modelka5_1, robust=TRUE) 


modelka7_1 <- lm (log(I(covid21/ownrev)) ~ log(lagGRP) + log(populat) + death_excess2020 + pol_president, data = covid21)
summary(modelka7_1, robust=TRUE) 



lambdas <- seq(0.6, 10, by = 0.05) # для этих лямбд будем делать RR
m.rr <- lm.ridge(log(I(covid20/ownrev)) ~ log(lagGRP) + log(populat) + death_excess20+ republic,
                 lambda = lambdas, data = covid20)
head(coef(m.rr))
m.rr$kHKB
m.rr$kLW
m.rr$coef


X <- model.matrix(~ 0 + log(lagGRP) + log(populat) + death_media20 + ownrev +republic + pol_constit20, data = covid20)
cor(X)
XX <- t(X) %*% X
eigen <- eigen(XX)
eigen$values

CI <- sqrt(max(eigen$values) / min(eigen$values))
CI
