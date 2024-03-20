library(readr)

glottolog_dir <- "/Users/eleanorchodroff/Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My\ Drive/ucla_phonetic_corpus/ucla_archive_metadata/"
# change out with durations file
hand <- read_delim("Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My Drive/ucla_phonetic_corpus/analysis/data_camera/voxangeles_durations.tsv", 
                delim = "\t", escape_double = FALSE, 
                locale = locale(encoding = "utf-16"), 
                trim_ws = TRUE)
mfa <- read_delim("Desktop/mfa_alignments.tsv", delim = "\t", escape_double = FALSE, trim_ws = TRUE)
phones <- read_csv("Desktop/unique_phones_class.csv")

length(unique(hand$lang))
length(unique(hand$file))

# get languages and files per language family

files_per_lang <- hand %>% 
  group_by(lang) %>% 
  summarise(count = length(unique(file)))
summary(files_per_lang$count)

# phone info
phones_per_lang <- hand %>% 
  group_by(lang) %>% 
  summarise(count = length(file))
summary(phones_per_lang$count)

# distinct phones
phones$class <- tolower(phones$class)
phones$class <- ifelse(phones$class %in% c("tap", "trill"), "stop", phones$class)

hand <- left_join(hand, phones, by = "phone")

# get summary of files per language: 20 to 162 files per language with a median of 49 files
hand_counts <- hand %>% group_by(lang) %>% summarise(count = length(unique(file)))
summary(hand_counts$count)

# phone and natural class information
length(unique(hand$phone))
per_class <- hand %>% group_by(class) %>% summarise(count = length(unique(phone)))

# language family information
ucla <- read_csv(paste0(glottolog_dir, 'ucla_metadata.csv'))
glottolog_geo <- read_csv(url('https://cdstar.eva.mpg.de//bitstreams/EAEA0-B701-6328-C3E3-0/languages_and_dialects_geo.csv'))
ucla$iso_6393 <- tolower(ucla$`Ethnologue Code`)
ucla_glottlog <- left_join(ucla, glottolog_geo, by=c("iso_6393"="isocodes"))
glottolog_families <- read_csv(paste0(glottolog_dir, 'glottolog_languoid/languoid.csv'))
ucla_glottlog <- left_join(ucla_glottlog, glottolog_families)
# remove extra njm line
ucla_glottlog <- subset(ucla_glottlog, Language != "Naga, Angami")
fams <- read_csv(paste0(glottolog_dir, 'lang_families.csv'), col_names = F)
colnames(fams) <- c("family_id", "family")

hand <- left_join(hand, ucla_glottlog, by = join_by("lang" == "iso_6393"))
hand$family_id <- ifelse(hand$lang == "eus", "basq1248", hand$family_id)
hand <- left_join(hand, fams, by = "family_id")

# get number of families
length(unique(hand$family))
per_family <- hand %>% 
  group_by(family) %>% 
  summarise(langs = length(unique(lang)),
            files = length(unique(file)))

### COMPARE WITH MFA

mfa$lang_word <- paste(mfa$lang, mfa$word, sep = "_")

# add one to MFA interval number for words that have phone intervals starting at 1 
# if that doesn't occur in hand alignment

update_ints <- c()
for (i in 1:nrow(mfa)) {
  mfa_int <- mfa$int[i]
  if (mfa_int == 1) {
    mfa_langword <- mfa$lang_word[i]
    tmp <- subset(hand, lang_word == mfa_langword)
    if (nrow(tmp) > 0) {
      tmp
      if (tmp$int[1] != 1) {
        update_ints <- append(update_ints, mfa_langword)
      }
    }

  }
}

# update intervals

mfa$update_int <- ifelse(mfa$lang_word %in% update_ints, "yes", "no")
mfa$int <- ifelse(mfa$update_int == "yes", mfa$int + 1, mfa$int)

# which mfa *files* are not in the hand files
mfa_files <- unique(mfa$file)
hand_files <- unique(hand$file)
dropped_files <- mfa_files[which(!mfa_files %in% hand_files)]

# 65 dropped files from 29 languages
dropped_files <- data.frame(dropped_files)
colnames(dropped_files) <- c("file")
dropped_files$lang <- substr(dropped_files$file, 1, 3)
length(unique(dropped_files$lang))
#write.csv(dropped_files, "~/Desktop/missing_files.csv", quote = F, row.names = F)

# changed words - 1215 words from 84 languages

mfa_words <- unique(mfa$lang_word)
hand_words <- unique(hand$lang_word)
changed_words <- mfa_words[which(!mfa_words %in% hand_words)]

changed_words <- data.frame(changed_words)
colnames(changed_words) <- c("word")
changed_words$lang <- substr(changed_words$word, 1, 3)
length(unique(changed_words$lang))

changed_words_summary <- changed_words %>% 
  group_by(lang) %>% 
  summarise(count = length(lang))
summary(changed_words_summary$count)

# merge mfa and hand alignments for comparison
hand_tmp <- hand %>% 
  select(-c(parent_id,bookkeeping,iso639P3code,description,
            markup_description,child_family_count, child_dialect_count, 
            child_language_count, country_ids, latitude, longitude, macroarea, `Ethnologue Code`,
            glottocode, id, name, level, Language, family_id, family))

mfa_hand <- merge(mfa, hand_tmp, by = c("lang", "file", "word", "lang_word", "phone", "int")) 
colnames(mfa_hand) <- c("lang", "file", "word", "lang_word", "phone", "int", 
                   "mfa_wstart", "mfa_wend", "mfa_pstart", "mfa_pend", 
                   "update_int", "hand_wstart", "hand_wend", "hand_pstart", "hand_pend", 
                   "class")


# several cases where phones might have been deleted or changed 
# (around 6015 cases where we could not match hand phone to original phone); 
# around 26% of the hand-aligned data
nrow(hand) - nrow(mfa_hand)
(nrow(hand) - nrow(mfa_hand)) / nrow(hand)

# calculate difference between phone onset - put it in milliseconds
mfa_hand$diff <- abs(mfa_hand$mfa_pstart - mfa_hand$hand_pstart) * 1000 

# median difference overall
summary(mfa_hand$diff)
# median of the median 6.5 ms, mean of the medians: 7.3 ms, range of medians: 0 to 131 ms
# mean of the mean 24.5, median of the mean: 22 ms, range of means: 0 to 108
per_lang_diff <- mfa_hand %>% 
  group_by(lang) %>% 
  summarise(med = median(diff), mean = mean(diff), min = mean(diff), max = max(diff))
summary(per_lang_diff$med)
summary(per_lang_diff$mean)

# get percent of boundaries within 20 ms: 70% 
nrow(subset(mfa_hand, diff < 20)) / nrow(mfa_hand)

# get percent of boundaries within 10 ms: 57% 
nrow(subset(mfa_hand, diff < 10)) / nrow(mfa_hand)

# get percent of boundaries within 5 ms: 45% 
nrow(subset(mfa_hand, diff < 5)) / nrow(mfa_hand)


mfa_hand$class <- factor(mfa_hand$class, levels = c("fric", "nasal", "stop", "vowel", "approx"))
contrasts(mfa_hand$class) <- contr.sum(5)
contrasts(mfa_hand$class)

mfa_hand$annotator <- ifelse(substr(mfa_hand$lang, 1, 1) < "l", "b", "a")
mfa_hand$annotator <- factor(mfa_hand$annotator, levels = c("a", "b"))
contrasts(mfa_hand$annotator) <- contr.sum(2)

fit <- lmer(diff ~ class + annotator + (1 | lang), mfa_hand)
summary(fit)

nodiff <- subset(mfa_hand, diff == 0)

