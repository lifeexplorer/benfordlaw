# Environment setup --------
library(tidyverse)
library(lubridate)

# Load data -----------

census_dat <- read_csv(file = "data/Census_Town_n_CityPopulations.csv")
names(census_dat) <- c("State", "Town", "7_2009")


# Digit extraction function ------------

# Mathematical definition of first digit:
# First digit(x) = Abs[Significand(a)]

# funtion to extract the first digit 
fst_digit_extract <- function(number){
  abs(number) %>% 
}



# Note: the first-two digits test is preferred by Mark Nigrini in the book, 
#       as the first digit can conform to Benford's Law even when the data
#       violates some of the underlying mathematical assumptions of the law.

# Census data example ------------

# digit pattern of the US census data
census.bfd <- benford.analysis::benford(census_dat$`7_2009`, number.of.digits = 2)
plot(census.bfd) # plot the first-two digits
