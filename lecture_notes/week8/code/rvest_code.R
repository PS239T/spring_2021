library(rvest)
library(magrittr)
library(tidyverse)
library(purrr)

rm(list=ls())

#INDIAN EXAMPLE-----------------------------------------------------------------------------

url = "https://supremo.nic.in/ERSheetHtml.aspx?OffIDErhtml=332&PageId="

#figuring out what's going on....
read_html(url) %>%
  html_text()

read_html(url) %>%
  html_table(fill = T)

biodata <-
  read_html(url) %>%
  html_table(fill = T) %>%
  .[[1]]


#say we just want the name and the cadre..., and want to do it with selectors

name <-
  read_html(url) %>%
  html_node(xpath = '//*[(@id = "one-column-emphasis")]//tr[(((count(preceding-sibling::*) + 1) = 1) and parent::*)]//b') %>%
  html_text()

cadre <-
  read_html(url) %>%
  html_node(xpath = '//*[(@id = "one-column-emphasis")]//tr[(((count(preceding-sibling::*) + 1) = 3) and parent::*)]//b') %>%
  html_text()


#let's scale up...notice anything about the URL?

url_chunk1 = "https://supremo.nic.in/ERSheetHtml.aspx?OffIDErhtml="
url_chunk2 = "&PageId="


get_name_cadre <- function(num){
  
  .url_chunk1 = "https://supremo.nic.in/ERSheetHtml.aspx?OffIDErhtml="
  .url_chunk2 = "&PageId="
  
  .page <- read_html(paste0(.url_chunk1, num, .url_chunk2))
  
  .name <-
    .page %>% 
    html_node(xpath = '//tr[(((count(preceding-sibling::*) + 1) = 1) and parent::*)]//b') %>% 
    html_text()
  
  .cadre = 
    .page %>% 
    html_node(xpath = '//*[(@id = "one-column-emphasis")]//tr[(((count(preceding-sibling::*) + 1) = 3) and parent::*)]//b') %>%
    html_text()
  
  return(cbind(.name, .cadre))
}

nums <- seq(1:5)

test <- map(nums, get_name_cadre)
do.call("rbind", test)





#### CONGRESSIONAL STAFFERS EXAMPLE:
# HERE'S THE LINK: https://web.archive.org/web/20160802124104/http://staffers.sunlightfoundation.com/members

#HOW SHOULD WE GO ABOUT SCRAPING THIS? AS A TWO STEP PROBLEM, IS THE ANSWER. 

#FIRST, WE NEED TO GET THE LINKS TO EACH OF THE MEMBERS' STAFF PAGES. THEN WE NEED TO SCRAPE THOSE...


links <-
  read_html("https://web.archive.org/web/20160802124104/http://staffers.sunlightfoundation.com/members") %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  str_subset(., "member")


link <- links[2]

get_staffers = function(link){
  url = paste0("https://web.archive.org", link)
  page = read_html(url) %>% html_table(fill = T) %>% .[[1]]# get the tables
  return(page) #return the staffer page
}


get_staffers(link)

