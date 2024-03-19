### Create master transcription file for VoxAngeles
## E. Chodroff
# created 27 January 2024, updated 18 March 2024
# generate output file with raw transcription, intermediate transcriptions, and updated transcriptions
# raw and intermediate transcriptions are obtained from the CMU release
# updated transcriptions are from the VoxAngeles team
# updated transcriptions were generated from the CMU Intermediate 2 form which already had spaces between phones
# the CMU intermediate 2 forms, however, had already removed several diacritics (e.g., tone markings)

require(tidyverse)

d <- read_delim("Desktop/voxangeles_transcriptions_updated_only.tsv", 
                delim = "\t", escape_double = FALSE, 
                locale = locale(encoding = "utf-16"), 
                trim_ws = TRUE)

raw <- data.frame()

mydir <- "Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My Drive/ucla_phonetic_corpus/forced_alignment/ucla_data/"
langs <- list.files(mydir, pattern = "[a-z]*")
raw <- data.frame()
intermediate <- data.frame()

for (lang in 1:length(langs)) {
  lang <- langs[lang]
  raw.i <- read_table(paste0(mydir, lang, "/raw"), col_names = FALSE)
  raw <- rbind(raw, raw.i)
  test.i <- read_delim(paste0(mydir, lang, "/test.txt"), delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
  intermediate <- rbind(intermediate, test.i)
}

colnames(intermediate) <- c("file", "intermediate")
colnames(raw) <- c("file", "raw")
d <- merge(d, intermediate, by = "file")
d <- merge(d, raw, by = "file")
d$intermediate1 <- d$intermediate
d$intermediate2 <- gsub(" ", "", d$intermediate)
d <- d %>% select(lang, file, raw, intermediate1, intermediate2, updated)

write.table(d, "~/Desktop/voxangeles_transcriptions.tsv", sep = "\t", quote = F, row.names = F)
