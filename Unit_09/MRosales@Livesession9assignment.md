---
title: "Live Session 9 Assignment"
author: "Manuel Rosales"
date: "3/3/2018"
output:
  html_document:
    keep_md: true
---




```r
library(rvest)
library(tidyr)
library(kableExtra)
```

## Question 1: Harry Potter Cast

a. Navigate to http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1
b. Scrape the page with any R package that makes things easy for you. Of particular interest is the table of the Cast in order of crediting. Please scrape this table (you might have to fish it out of several of the tables from the page) and make it a data.frame() of the Cast in your R environment


```r
url <- 'http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1'
page <- read_html(url)

# Idetifying html nodes and putting cast list into table using rvest::html_table
castTable <- rvest::html_nodes(page, css = 'table.cast_list')
castList <- rvest::html_table(castTable)
castList <- data.frame(castList)
```

c. Clean the data set

* Clean out the empty rows and columns
* Assign variable names
* Adjust Mr. Warwick to just “Griphook / Professor Filius Flitwick”
* Remove observation -- 'Rest of cast listed alphabetically'


```r
# Delete the first row, it has no data
castList <- castList[-1,]

# Delete the meaningless columns (Col1 is empty and Col2 has ... in every row)
castList <-castList[,-c(1,3)]

# Apply meaningful column names
names(castList) <- c("Actor/Actress", "Character")

# Fix the row index
rownames(castList) <- 1:nrow(castList)

# Identify rows containing Actor/Actress = Warick Davis
warwick <- grep('[Ww]arwick' ,castList$`Actor/Actress`, value = FALSE)
warwick
```

```
## [1] 10
```

```r
# Change the character name for Warick Davis
warickCharacter <- gsub(castList[warwick,2], 'Griphook / Professor Filius Flitwick',castList[warwick,2])

# Find row containing 'Rest of cast listed alphabetically' and remove it
rest <- grep('[Rr]est of' ,castList$`Actor/Actress`, value = FALSE)
rest
```

```
## [1] 92
```

```r
castList <- castList[-rest,]
rownames(castList) <- 1:nrow(castList) # Adjust rownames to account for deleted row
```

d. Split the Actor’s name into two columns: FirstName and Surname. Keep in mind that some actors/actresses have middle names as well. Please make sure that the middle names are in the FirstName column, in addition to the first name (example: given the Actor Frank Jeffrey Stevenson, the FirstName column would say “Frank Jeffrey.”)


```r
finalCastList <- castList %>%
        tidyr::separate(`Actor/Actress`, into=c('First Name', 'Surname'), sep='[ ](?=[^ ]+$)') # separate by the last space

top10 <- head(finalCastList,10)
knitr::kable(top10,caption = "Top 10 Actor/Actress and Characters", "html") %>%
  kable_styling(bootstrap_options = c("striped","hover"), full_width = F)
```

<table class="table table-striped table-hover" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>Top 10 Actor/Actress and Characters</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> First Name </th>
   <th style="text-align:left;"> Surname </th>
   <th style="text-align:left;"> Character </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ralph </td>
   <td style="text-align:left;"> Fiennes </td>
   <td style="text-align:left;"> Lord Voldemort </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Michael </td>
   <td style="text-align:left;"> Gambon </td>
   <td style="text-align:left;"> Professor Albus Dumbledore </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alan </td>
   <td style="text-align:left;"> Rickman </td>
   <td style="text-align:left;"> Professor Severus Snape </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Daniel </td>
   <td style="text-align:left;"> Radcliffe </td>
   <td style="text-align:left;"> Harry Potter </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rupert </td>
   <td style="text-align:left;"> Grint </td>
   <td style="text-align:left;"> Ron Weasley </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Emma </td>
   <td style="text-align:left;"> Watson </td>
   <td style="text-align:left;"> Hermione Granger </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Evanna </td>
   <td style="text-align:left;"> Lynch </td>
   <td style="text-align:left;"> Luna Lovegood </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Domhnall </td>
   <td style="text-align:left;"> Gleeson </td>
   <td style="text-align:left;"> Bill Weasley </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Clémence </td>
   <td style="text-align:left;"> Poésy </td>
   <td style="text-align:left;"> Fleur Delacour </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Warwick </td>
   <td style="text-align:left;"> Davis </td>
   <td style="text-align:left;"> Griphook /  
            Professor Filius Flitwick </td>
  </tr>
</tbody>
</table>

## Question 2: NBA Shooting Stats

a. On the ESPN website, there are statistics of each NBA player. Navigate to the San Antonio Spurs current statistics (likely http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs). You are interested in the Shooting Statistics table.
b. Scrape the page and specifically target the Shooting Statistics table.


```r
url <- 'http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs)'
page2 <- read_html(url)

# Idetifying html nodes and putting cast list into table using rvest::html_table
shootingStats <- rvest::html_nodes(page2, css = 'table.tablehead')
shootingStats <- rvest::html_table(shootingStats)
shootingStats <- data.frame(shootingStats)
```

c. Clean up the table (You might get some warnings if you’re working with tibbles)
+ You’ll want to create an R data.frame() with one observation for each player. Make sure that you do not accidentally include blank rows, a row of column names, or the Totals row in the table as observations.
+ The column PLAYER has two variables of interest in it: the player’s name and their position, denoted by 1-2 letters after their name. Split the cells into two columns, one with Name and the other Position.
+ Check the data type of all columns. Convert relevant columns to numeric. Check the data type of all columns again to confirm that they have changed!


```r
# Use the first row as initial column names and remove row 1 (duplicative)
names(shootingStats) <- shootingStats[1,] 
shootingStats <- shootingStats[-1,]

# Only keep columns associated with Shooting Stats by 
# removing columns named 'GAME STATISTICS' 
shootingStats <- shootingStats[, -which(names(shootingStats) %in% c("GAME STATISTICS"))] 
rownames(shootingStats) <- 1:nrow(shootingStats) # fix row index

# Use the new first row as column names and remove row 1 (duplicative)
names(shootingStats) <- shootingStats[1,] 
shootingStats <- shootingStats[-1,]
rownames(shootingStats) <- 1:nrow(shootingStats) # fix row index

# Remove row associted with 'Totals'
shootingStats <- subset(shootingStats,shootingStats$PLAYER!='Totals')

# Separate player name and position
finalShootingStats<- shootingStats %>%
        separate(PLAYER, into=c('Name', 'Position'), sep=", ") #separate by ,+a space

finalShootingStats
```

```
##                 Name Position FGM  FGA  FG% 3PM 3PA  3P% FTM FTA  FT% 2PM
## 1  LaMarcus Aldridge       PF 8.8 17.6 .501 0.4 1.4 .325 4.4 5.2 0.84 8.4
## 2      Kawhi Leonard       SF 5.8 12.3 .468 1.2 3.9 .314 3.4 4.2 0.82 4.6
## 3           Rudy Gay       SF 4.3  9.1 .470 0.7 2.1 .329 2.1 2.7 0.78 3.6
## 4          Pau Gasol        C 3.9  8.5 .464 0.7 1.7 .398 2.1 2.8 0.77 3.2
## 5        Patty Mills       PG 3.3  7.9 .421 1.9 4.8 .385 1.2 1.4 0.87 1.4
## 6      Manu Ginobili       SG 3.4  7.6 .443 1.1 3.2 .333 1.6 1.9 0.85 2.3
## 7        Danny Green       SG 3.3  8.1 .407 1.8 4.6 .383 0.6 0.8 0.78 1.5
## 8        Tony Parker       PG 3.7  7.7 .476 0.1 0.7 .217 1.0 1.5 0.67 3.6
## 9      Kyle Anderson       SF 3.2  6.2 .517 0.2 0.7 .297 1.5 2.1 0.74 3.0
## 10   Dejounte Murray       PG 3.1  7.0 .440 0.1 0.3 .250 1.2 1.6 0.72 3.0
## 11       Bryn Forbes       SG 2.8  6.8 .414 1.2 3.3 .376 0.5 0.9 0.61 1.6
## 12     Davis Bertans        C 2.2  4.9 .439 1.3 3.4 .371 0.5 0.7 0.79 0.9
## 13 Joffrey Lauvergne        C 2.0  3.8 .532 0.0 0.1 .000 0.6 1.0 0.63 2.0
## 14     Derrick White       PG 0.8  1.6 .480 0.3 0.5 .500 0.8 1.1 0.67 0.5
## 15      Brandon Paul       SG 0.9  2.1 .440 0.3 0.9 .286 0.4 0.6 0.61 0.6
## 16   Darrun Hilliard       SG 0.4  1.4 .263 0.0 0.4 .000 0.4 0.5 0.86 0.4
## 17     Matt Costello       SF 0.3  1.0 .333 0.0 0.0 .000 0.0 0.0 0.00 0.3
##     2PA  2P%   PPS AFG%
## 1  16.2 .516 1.276 0.51
## 2   8.4 .539 1.315 0.52
## 3   7.0 .512 1.244 0.51
## 4   6.8 .480 1.257 0.50
## 5   3.1 .479 1.230 0.54
## 6   4.4 .522 1.232 0.51
## 7   3.5 .440 1.111 0.52
## 8   7.0 .500 1.097 0.49
## 9   5.5 .544 1.315 0.53
## 10  6.7 .449 1.058 0.45
## 11  3.5 .448 1.087 0.50
## 12  1.5 .589 1.240 0.57
## 13  3.7 .550 1.234 0.53
## 14  1.1 .471 1.600 0.56
## 15  1.2 .567 1.193 0.50
## 16  1.0 .385  .842 0.26
## 17  1.0 .333  .667 0.33
```
