# Environment setup --------
library(tidyverse)
library(lubridate)

# load the data downloaded from the book's website
corporate_data <- read_csv(file = "data/CorporatePaymentsData.csv") %>% 
  # parse the Date and remove the dollar symbol (all transactions are in USD)
  mutate(Date = ymd(Date), 
         # divide data into 4 quarters, so that we can focus on the risky quarter, which is identified by Benford's Law
         quarter = quarter(Date, with_year = F), 
        
         # Issue: parse_double() or parse_number() both round the number with only its first decimal number
         # In addition, they cannot deal with the negative number with dollar sign if both of them applied directly
         
         # The use of as.numeric() would introduce the NAs coercion
         #Amount_clean = str_remove(Amount, "\\$") %>% str_remove(',') %>%  as.numeric(),
         
         # parse_double cannot deal with the large number like $1,088,096.11, but parse_number() produce only integer with this large number
         #Amount_clean = str_remove(Amount, "\\$") %>% str_remove(',') %>%  parse_double(),
         Amount_clean = str_remove(Amount, "\\$") %>% str_remove(',') %>%  parse_number())

# Example of number parsing issue above:
# parse_double(corporate_data$Amount, locale = locale(grouping_mark = ',', decimal_mark = '.'))


# Data profile -------------
# Given Page 27 of Benford's Law (Mark Nigrini 2012), it is gentle touch on this topic.
# On the page 74, the author started to point out several key points
hist(corporate_data$Amount_clean)

# zero: these requires specific cares
sum(corporate_data$Amount_clean == 0) # 123
sum(corporate_data$Amount_clean == 0)/nrow(corporate_data) # 0.06%

# negative number percentage
sum(corporate_data$Amount_clean < 0) # 4264
sum(corporate_data$Amount_clean > 0) # 185083

# low value and high value profiling satege are omited.

# Benford's Law Primary test ---------------

# analyse the data with positive and negative number separated.
corporate.bfd.positive <- benford.analysis::benford(corporate_data$Amount_clean, number.of.digits = 1, sign = 'positive')
plot(corporate.bfd.positive)
# Issue: not sure which MAD it produced (for first digit or second digit)
c(corporate.bfd.positive$MAD.conformity, corporate.bfd.positive$MAD)


corporate.bfd.negative <- benford.analysis::benford(corporate_data$Amount_clean, number.of.digits = 1, sign = 'negative')
plot(corporate.bfd.negative)

corporate.bfd.both <- benford.analysis::benford(corporate_data$Amount_clean, number.of.digits = 1, sign = 'both')
plot(corporate.bfd.both)
# Issue: not sure which MAD it produced (for first digit or second digit)
c(corporate.bfd.both$MAD.conformity, corporate.bfd.both$MAD)
