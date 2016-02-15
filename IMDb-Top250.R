# Get the Top 250 Films list from IMDb

library(rvest)
library(stringr)
library(dplyr)

html <- read_html("http://www.imdb.com/chart/top")

# IMDb ranks are in a <td> element with the class "titleColumn"
ranks <- html %>%
    html_nodes("td.titleColumn") %>%
    html_text(trim=TRUE) %>%
    str_replace("\\.(.*)", "") %>% # remove everything after the "." (inclusive)
    as.numeric()

# Film titles are in a <td> element with the class "titleColumn" inside an <a> element
titles <- html %>%
    html_nodes("td.titleColumn a") %>%
    html_text()

# Year of film release is in a <span> with the class "secondaryInfo"
years <- html %>%
    html_nodes("span.secondaryInfo") %>%
    html_text() %>%
    str_replace("\\(", "") %>% # remove open paren
    str_replace("\\)", "") %>% # remove close paren
    as.numeric()

# Ratings are in a <td> element with the class "imdbRating" inside a <strong> element
ratings <- html %>%
    html_nodes("td.imdbRating strong") %>%
    html_text() %>%
    as.numeric()

imdb.top.250 <- data.frame(Rank=ranks, Title=titles, Year=years, Rating=ratings)


# Average age of films in the top 250
as.integer(format(Sys.Date(), "%Y")) - as.integer(mean(imdb.top.250$Year))

# Make a bar plot showing which years have the most films in the top 250.
counts <- table(imdb.top.250$Year)
barplot(counts, main="Year Distribution", xlab="Year", ylab="Number of Films")

# use dplyr summary functions to display a top ten list of years
imdb.top.250 %>% 
    group_by(Year) %>%
    summarise(total=n()) %>%
    arrange(desc(total)) %>%
    head(10)

# Show films for a particular year
imdb.top.250 %>% 
    filter(Year==2015)

