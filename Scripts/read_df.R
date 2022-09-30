library(stringr)

path_out = "~/../Desktop/recombio_test/2-Variant-Call-Pipeline/brazil_df/frequency_df/"
path_in = "~/../Desktop/recombio_test/2-Variant-Call-Pipeline/brazil_df/"
file_name = "Brazil_2020_07_df.csv"

files <- list.files(path=path_in, pattern='*.csv')

files

df <- read.table(paste(path_in, file_name, sep = ""),
                     row.names = 1, 
                     header = TRUE)
    
colnames(df) <- c("Total Occurence(# of files)", "Total # of Files in Month")
    
#class(df$`Total Occurence(# of files)`)
#class(df$`Total # of Files in Month`)
    
df$Frequency <- 100 * df$`Total Occurence(# of files)` / df$`Total # of Files in Month`
    
#remove .csv at the end
file_name <- sub("\\..*", "", file_name)
    
write.csv(df, file =  paste(path_out, file_name, "_frequency.csv", sep = ""))
