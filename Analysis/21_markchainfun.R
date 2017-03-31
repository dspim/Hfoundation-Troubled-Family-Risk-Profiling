################## sumMoth  combine  month data 
## you can try  'new_sparse_data.csv'
# data <- read.csv('new_sparse_data.csv')
# ex: sumMonth(data)

sumMonth <- function(data){
  A <- matrix(0, nrow = 1, ncol = ncol(data))
  colnames(A) <- colnames(data)
  Id <- levels(data[, 1])
  for (i in 1:length(Id)){
    iddata <- data[ data[, 1] == Id[i], 1:ncol(data)]
    date <- as.Date(iddata[, 2])
    ym <- format(date, '%y%m')
    count1 <- table(ym)
    levelsym <- levels(factor(ym))
    newcadata <- sapply(1:length(levelsym), FUN = function(x){
      nu <- count1[levelsym[x]]
      if(nu > 1){
        submndata <- iddata[ ym == levelsym[x], 3:ncol(data) ]
        L <- apply(submndata, 2, sum) 
        class(L)
        L[L!=0] = 1
        L <- as.integer(L)
        ve <- L
      }else{
        submndata <- iddata[ ym == levelsym[x], 3:ncol(data) ]
        
        ve <- as.integer(submndata)
        
      }
      return(ve)
    })
    PP <- data.frame('ID'=rep(Id[i], length(levelsym) ),'Date'=paste(1,  levelsym,sep=''), t(newcadata) )
    colnames(PP) <- colnames(data)
    A <- rbind(A, PP)
  }
  A <- data.frame( A[-1, ] )
  return(A)
}
##### transprob function can calulate  parmeters of markov chain  
# ex : monthdata <- sumMonth(data)
#       transprob(monthdata)
transprob <- function(data){
  Id <- levels(factor( data[, 1] ) ) 
  data1 <- data[, 3:ncol(data)]  
  chlidnames <- data[, 1]
  sum1 <- apply(data1, 2, sum)
  nonzeros <- which(sum1 != 0)
  trcount <- t( sapply(1:length(nonzeros) , FUN = function(i){
    cadata <- data1[, nonzeros[i]]  
    apply(  sapply(1:length(Id), FUN = function(j){
      idcadata <- cadata[ chlidnames == Id[j]]
      if(length(idcadata) > 1){
        count <- apply( sapply(1:(length(idcadata)-1), FUN = function(x){
          xbt <- idcadata[x]
          xnt <- idcadata[(x+1)]
          if (xbt == 0 & xnt == 0){
            y <-  c(1, 0, 0, 0)
            
          }else if(xbt == 0 & xnt == 1){
            y <-  c(0, 1, 0, 0)
          }else if(xbt == 1 & xnt == 0){
            y <-  c(0, 0, 1, 0)
          }else{
            y <- c(0, 0, 0, 1)
          }
          return(y)
        }),1, sum)}
      else{count <- rep(0, 4)}  
      return(count)
      
    }), 1, sum)
  }) )
  trprob <- sapply(1:length(nonzeros), FUN = function(x){
    if ( sum(trcount[x, 1:2] ) != 0 & sum(trcount[x, 3:4] ) != 0 ){ 
      c( trcount[x, 1:2] /  sum(trcount[x, 1:2] ), trcount[x, 3:4] /  sum(trcount[x, 3:4]) )
    }else if(sum(trcount[x, 1:2] ) != 0  &  sum(trcount[x, 3:4] ) == 0 ){
      c( trcount[x, 1:2] /  sum(trcount[x, 1:2] ), rep(0, 2) )
    }else if( sum(trcount[x, 1:2] ) == 0 & sum(trcount[x, 3:4] ) != 0  ) {
      c( rep(0, 2), trcount[x, 3:4] /  sum(trcount[x, 3:4]) )
    }
  })
  
  rownames(trprob) <- c('0-0', '0-1', '1-0', '1-1')
  colnames(trprob) <-   colnames( data1)[nonzeros]
  return(t( trprob) )
}
