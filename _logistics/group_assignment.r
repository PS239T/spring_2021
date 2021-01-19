
# Load library
if (!require("pacman", quietly = TRUE)) { install.packages("pacman") }

pacman::p_load(here, tidyverse)

# Load file
df <- read.csv(here("_logistics", "names.csv"))
df <- df %>%
  select(x) %>%
  rename("name" = "x")

# Randomly assign students into two groups
#set.seed(1234)

df$group_id <- sample(rep(1:2, each = 5), 10, replace = FALSE)

df %>% arrange(group_id)
