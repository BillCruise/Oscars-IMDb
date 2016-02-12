# Get the Top 250 list from IMDb

library(rvest)
library(stringr)

html <- read_html("http://www.imdb.com/chart/top")

# Film titles are in a <td> element with the class "titleColumn" inside an <a> element
titles <- html %>%
    html_nodes(".titleColumn a") %>%
    html_text()

# Year of film release is in a <span> with the class "secondaryInfo"
years <- html %>%
    html_nodes(".secondaryInfo") %>%
    html_text() %>%
    str_replace("\\(", "") %>% # remove open paren
    str_replace("\\)", "") %>% # remove close paren
    as.numeric()

# Ratings are in a <td> element with the class "imdbRating" inside a <strong> element
ratings <- html %>%
    html_nodes(".imdbRating strong") %>%
    html_text() %>%
    as.numeric()

imdb.top.250 <- data.frame(Title = titles, Year = years, Rating = ratings)
