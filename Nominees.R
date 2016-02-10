# Get all Best Picture nominees from Wikipedia

library(reshape)
library(rvest)

# Grab the page source
html <- read_html("https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture")

# extract the wikitable nodes
tables <- html_nodes(html, ".wikitable")

# convert the tables to a list of dataframes
nominees <- html_table(tables)

# add a year column to each data frame
y <- 1928
for(i in 1:length(nominees)) {
    nominees[[i]]$Year <- y
    y = y + 1
}

# Fix the Producer column name in each data frame
for(i in 1:length(nominees)) {
    names(nominees[[i]])[names(nominees[[i]])=="Production company(s)"] <- "Production Company(s)"
}


# combine all into one data frame
all.nominees <- merge_recurse(nominees)

# save nominees to a tab-separated values file
write.table(all.nominees, file="nominees.tsv", sep="\t")