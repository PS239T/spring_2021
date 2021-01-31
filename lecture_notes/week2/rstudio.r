## ----include=FALSE------------------------------------------------------------
# You can convert an R markdown file to R script 

if (!require(knitr)) install.packages("knitr")
if (!require(here)) install.packages("here")

library(knitr)
library(here)

knitr::purl("rstudio.Rmd", 
            output = here("lecture_notes/week2/rstudio.r"))




## -----------------------------------------------------------------------------

teachers <- c("Jae", "Nick")

teachers



## -----------------------------------------------------------------------------

# Creating teacher object 
teachers <- c("Jae", "Nick")

teachers



## -----------------------------------------------------------------------------

add_xy <- function(x, y){ # Input  
  
  out <- x + y # Computation 
  
  return(out) # Output 
  
}

add_xy(1, 2)



## -----------------------------------------------------------------------------

install.packages("dplyr") # Install dplyr pkg 
library(dplyr) # Load it 

# If you many pkgs ... 
install.packages("pacman")

pacman::p_load(tidyr, 
               dplyr)



## -----------------------------------------------------------------------------

# You should do this. 
runs <- c("5k", "10k", "15k")

# Don't do this. (This is confusing.)
c("5k", "10k", "15k") -> runs 

# Don't do this. (Scope problem.)
runs = c("5k", "10k", "15k") 


## -----------------------------------------------------------------------------
mean(x = 1:10) # Does it save x?

x <- 1:10 # Does it save x?
mean(x)


## -----------------------------------------------------------------------------

print(1) # Integer
print(1.2) # Double 
print("Jae") # Character
print(TRUE) # Logical



## -----------------------------------------------------------------------------

class(1) # Numeric
class(1.2) # Numeric 
class("Jae") # Character
class(TRUE) # Logical



## -----------------------------------------------------------------------------
#1
class(1)
class(1.2)

#2
typeof(1)
typeof(1.2)

#3
typeof(1L)
typeof(1.2)


## -----------------------------------------------------------------------------

?class # class hierarchy (high-level)
?typeof # R's data types (low-level)

?mean #
??mean # find functions contain that name 


## -----------------------------------------------------------------------------




