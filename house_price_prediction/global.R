library(DT)
library(glue)
library(leaflet)
library(plotly)
library(randomForest)
library(scales)
library(shiny)
library(sf)
library(shinydashboard)
library(tidyverse)

options(scipen = 999)

jakarta_rds <- readRDS("jakarta_rds.rds")

jkt_viz <- read.csv("jakarta_clean_2.csv", encoding = "UTF-8")

jkt_viz <- jkt_viz %>% 
  select(-c(X, X.1))

model_rf <- read_rds("model_rf.rds")

validation <- read.csv("validation.csv", stringsAsFactors = T, encoding = "UTF-8") %>% 
  select(-price)

var_importance <- read.csv("var_importance.csv")

jkt_int_no_out <- read.csv("jkt_int_no_out.csv") %>% 
  select(-X)

pilihan_variabel <- jkt_int_no_out %>% 
  select(c("luas_bangunan", "luas_lahan"))
