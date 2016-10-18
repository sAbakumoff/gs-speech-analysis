# install.packages("readr")

library("readr")
library("stringr")

build_data_frame <- function(file_path, id) {
  raw_content<-read_file(file_path)
  markers<-str_locate_all(raw_content, pattern="MS. CLINTON:|MR. BLANKFEIN:|PARTICIPANT:|SECRETARY CLINTON:|MR. O'NEILL:|FEMALE ATTENDEE:|MALE ATTENDEE:")
  markers<-markers[[1]]
  len<-length(markers[,1])
  speaker<-character(len)
  msg<-character(len)
  order<-numeric(len)
  speech_id<-rep(id, len)
  for(i in 1 : len) {
    order[i] = i
    speaker[i] = str_trim(str_replace_all(substr(raw_content, markers[i,1], markers[i,2] - 1), "MS.|MR.|SECRETARY|FEMALE|MALE", ""))
    msg_stop<-if(i==len) str_length(raw_content) else markers[i+1,1] - 1
    msg[i] = str_trim(str_replace_all(substr(raw_content, markers[i,2] + 1, msg_stop), "\r\n|\\s+", " "))
  }
  df<-data.frame(speech_id, order, speaker, msg, stringsAsFactors = FALSE)
  return(df)
}

speech1<-build_data_frame("06042013 GS 1.txt", "GS06042013")
speech2<-build_data_frame("10242013 GS 2.txt", "GS10242013")
speech3<-build_data_frame("10292013 GS 3.txt", "GS10292013")

all_speeches<-rbind(speech1, speech2, speech3, stringsAsFactors = FALSE)
saveRDS(all_speeches, "data.rds")
