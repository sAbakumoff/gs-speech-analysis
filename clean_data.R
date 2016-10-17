library("readr")
library("stringr")

raw_content<-read_file("06042013 GS 1.txt")
markers<-str_locate_all(raw_content, pattern="MS. CLINTON:|MR. BLANKFEIN:|PARTICIPANT:")
markers<-markers[[1]]
for(i in 1 : 3) {
  message(substr(raw_content, markers[i,1], markers[i,2]))
  message(str_trim(str_replace_all(substr(raw_content, markers[i,2] + 1, markers[i+1,1] - 1), "\r\n", "")))
}
