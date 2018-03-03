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
