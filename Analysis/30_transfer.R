### risk-transfer function ###

# input the index of old risk-factor, like 'A-01' (string formed) 
# and it will output the new category of risk-factor
risk_transfer <- function(x){
  result <- table[substr(table[, 1], start = 2, stop = 5) == x, 2]
  return(as.character(result))
}
