# install.packages("readr")

library("readr")
library("stringr")

raw_content<-read_file("06042013 GS 1.txt")
markers<-str_locate_all(raw_content, pattern="MS. CLINTON:|MR. BLANKFEIN:|PARTICIPANT:")
markers<-markers[[1]]
len<-length(markers[,1])
speaker<-character(len)
msg<-character(len)
order<-numeric(len)
speech_id<-rep("GS06042013", len)
for(i in 1 : len) {
  order[i] = i
  speaker[i] = str_trim(str_replace_all(substr(raw_content, markers[i,1], markers[i,2] - 1), "MS.|MR.", ""))
  msg_stop<-if(i==len) str_length(raw_content) else markers[i+1,1] - 1
  msg[i] = str_trim(str_replace_all(substr(raw_content, markers[i,2] + 1, msg_stop), "\r\n|\\s+", " "))
}
df<-data.frame(speech_id, order, speaker, msg)
