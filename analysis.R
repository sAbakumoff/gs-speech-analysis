library("tidytext")
library("dplyr")
library("wordcloud")
df <- readRDS("data\\data.rds")
data("stop_words")
df %>% filter(speaker=="CLINTON", speech_id=="GS10242013") %>% 
  select(msg) %>% unnest_tokens(word, msg) %>% anti_join(stop_words) %>% 
  count(word) %>% with(wordcloud(word, n, max.words = 30))

