# Analysis of intrinsic f0 in the UCLA Phonetics Lab Archive - VoxAngeles Release
# Analyze the midpoint f0 from high and low vowels across languages 
# 17 October 2023, updated 23 March 2024
# E Chodroff

require(tidyverse)
require(lme4)

#################
### LOAD DATA ###
#################
# where's the f0 data, natural class information, and language family info?
analysis_dir <- "/Users/eleanorchodroff/Documents/GitHub/voxangeles/lrec-coling_analyses/"

# read in dataset
d <- read_delim(paste0(analysis_dir, "voxangeles_f0_quartiles.tsv"), delim = "\t", escape_double = FALSE, locale = locale(encoding = "UTF-16"), trim_ws = TRUE)

# read in natural class (manner and voice) information
class <- read_csv(paste0(analysis_dir, "unique_phones_class.csv"))

# read in language family information
ucla <- read_csv(paste0(analysis_dir, 'map/ucla_glottlog.csv'))
fams <- read_csv(paste0(analysis_dir, 'map/lang_families.csv'), col_names = F)

####################
### PROCESS DATA ###
####################
# add in NA row to deal with cases when the preceding or following phone is absent (NA)
class[nrow(class) + 1,] <- c(NA, NA, NA)

# merge with target phone
d <- merge(d, class, by = "phone")

# merge with preceding phone
colnames(class) <- c("phone", "prec_class", "prec_voice")
d <- merge(d, class, by.x = "prec", by.y = "phone")

# merge with following phone
colnames(class) <- c("phone", "foll_class", "foll_voice")
d <- merge(d, class, by.x = "foll", by.y = "phone")

# process family info
colnames(fams) <- c("family_id", "family")

# remove extra njm line
ucla <- subset(ucla, Language != "Naga, Angami")

# merge glottolog language family info
d <- left_join(d, ucla, by = join_by("lang" == "iso_6393"))
d$family_id <- ifelse(d$lang == "eus", "basq1248", d$family_id)

# merge labeled language family info
d <- left_join(d, fams, by = "family_id")

# remove extra columns
d <- d %>% 
  select(-c("markup_description", "description", "child_family_count", "child_language_count", "child_dialect_count"))


# process f0s and durations
d$f0_1 <- ifelse(d$f0_1 == "--undefined--", NA, d$f0_1)
d$f0_2 <- ifelse(d$f0_2 == "--undefined--", NA, d$f0_2)
d$f0_3 <- ifelse(d$f0_3 == "--undefined--", NA, d$f0_3)
d$f0_4 <- ifelse(d$f0_4 == "--undefined--", NA, d$f0_4)

d$f0_1 <- as.numeric(as.character(d$f0_1))
d$f0_2 <- as.numeric(as.character(d$f0_2))
d$f0_3 <- as.numeric(as.character(d$f0_3))
d$f0_4 <- as.numeric(as.character(d$f0_4))

hz2erb <- function(x) {
  output <- (.0043 * x) + 1
  output <- 21.4 * log10(output)
  return(output)
}

d$f0_2_erb <- hz2erb(d$f0_2)
d$vdur <- (d$pend - d$pstart)*1000
d$wdur <- (d$wend - d$wstart)*1000

#####################
### FILTER VOWELS ###
#####################

# remove vowel types with less than 10 tokens
phone_counts <- d %>% 
  group_by(phone) %>% 
  summarise(count = length(phone)) %>% 
  arrange(desc(count))

d <- merge(d, phone_counts, by = "phone")
d <- subset(d, count >= 10)

# remove devoiced vowels
d <- subset(d, phone != "u̥")

# create broad vowel categories
d$broad <- ifelse(grepl(("a|æ|a|ɑ"), d$phone), "a", 
                  ifelse(grepl("i|y|ɪ|ɨ|ʏ", d$phone), "i", "u"))

# calculate number of vowel tokens per language-specific broad category 
phones_per_broad <- d %>% 
  group_by(lang, phone, broad) %>%
  summarise(count = length(phone)) %>%
  group_by(lang, broad) %>%
  summarise(type_count = length(phone), token_count = sum(count))

# calculate mean f0 in hertz, remove averages derived from less than 10 tokens
f0_phone_lang_hz <- d %>% 
  group_by(lang, Language, family, broad) %>%
  summarise(meanf0 = mean(f0_2, na.rm = T), count = length(broad)) %>%
  filter(count >= 10) 

# make the mean f0 in hertz wide (columns for i, a, u)
f0_wide_hz <- f0_phone_lang_hz %>%
  select(-count) %>%
  pivot_wider(names_from = broad, values_from = meanf0) 

f0_wide_hz$ia <- ifelse(f0_wide_hz$i > f0_wide_hz$a, "yes", "no")
f0_wide_hz$ua <- ifelse(f0_wide_hz$u > f0_wide_hz$a, "yes", "no")
xtabs(~ia, f0_wide_hz)
xtabs(~ua, f0_wide_hz)

# calculate mean f0 in ERB, remove averages derived from less than 10 tokens
f0_phone_lang <- d %>% 
  group_by(lang, Language, family, broad) %>%
  summarise(meanf0 = mean(f0_2_erb, na.rm = T), count = length(broad)) %>%
  filter(count >= 10) 

#################################
### GET F0 MEANS AND RANKINGS ###
#################################

# make the mean f0 in ERB wide (columns for i, a, u)
f0_wide <- f0_phone_lang %>%
  select(-count) %>%
  pivot_wider(names_from = broad, values_from = meanf0)

f0_wide$ia <- ifelse(f0_wide$i > f0_wide$a, "yes", "no")
f0_wide$ua <- ifelse(f0_wide$u > f0_wide$a, "yes", "no")
xtabs(~ia, f0_wide)
xtabs(~ua, f0_wide)

###############
### FIGURES ###
###############
ggplot(f0_wide, aes(x = a, y = i)) + 
  geom_abline(y = 0, x = 1, linetype = "dashed") + 
  #geom_smooth(method = "lm", se = FALSE, color = "black") + 
  geom_point(size = 4) + 
  #geom_text_repel(box.padding = 1, arrow = arrow(length = unit(0.005, "npc")), max.overlaps = 30) +
  theme_minimal(23) + 
  xlab("mean f0 /a/ (ERB)") + 
  ylab("mean f0 /i/ (ERB)") + 
  xlim(2.9, 7.7) + 
  ylim(2.9, 7.7)
ggsave("~/Desktop/voxangeles_ia.png", dpi = 300, units = "in", height = 8, width = 8)
ggsave("~/Desktop/voxangeles_ia.pdf", dpi = 300, units = "in", height = 8, width = 8)

ggplot(f0_wide, aes(x = a, y = u)) + 
  geom_abline(y = 0, x = 1, linetype = "dashed") + 
  #geom_smooth(method = "lm", se = FALSE, color = "black") + 
  geom_point(size = 4) + 
  theme_minimal(23) + 
  xlab("mean f0 /a/ (ERB)") + 
  ylab("mean f0 /u/ (ERB)")  +
  xlim(2.9, 7.7) + 
  ylim(2.9, 7.7)
ggsave("~/Desktop/voxangeles_ua.png", dpi = 300, units = "in", height = 8, width = 8)
ggsave("~/Desktop/voxangeles_ua.pdf", dpi = 300, units = "in", height = 8, width = 8)

ggplot(f0_wide, aes(x = u, y = i)) + 
  geom_abline(y = 0, x = 1, linetype = "dashed") + 
  #geom_smooth(method = "lm", se = FALSE, color = "black") + 
  geom_point(size = 4) + 
  theme_minimal(23) + 
  xlab("mean f0 /u/ (ERB)") + 
  ylab("mean f0 /i/ (ERB)") +
  xlim(2.9, 7.7) + 
  ylim(2.9, 7.7)
ggsave("~/Desktop/voxangeles_iu.png", dpi = 300, units = "in", height = 8, width = 8)
ggsave("~/Desktop/voxangeles_iu.pdf", dpi = 300, units = "in", height = 8, width = 8)

#############
### STATS ###
#############

# correlation
cor.test(~i + a, f0_wide)
cor.test(~u + a, f0_wide)
cor.test(~i + u, f0_wide)

# simple linear regressions
lms_ia <- data.frame(matrix(nrow = length(unique(f0_wide$lang)), ncol = 5))
for (i in 1:length(unique(f0_wide$lang))) {
  langi <- unique(f0_wide$lang)[i]
  sub_vi <- subset(d, lang == langi & broad == "i")
  sub_va <- subset(d, lang == langi & broad == "a")
  newdat <- rbind(sub_vi, sub_va)
  if (nrow(sub_vi) >= 10 & nrow(sub_va) >= 10) {
    fitlm <- lm(f0_2_erb ~ broad, newdat)
    lms_ia[i+1, 1] <- langi
    lms_ia[i+1, 2] <- fitlm$coefficients[2]
    lms_ia[i+1, 3] <- round(summary(fitlm)$coefficients[2,4], digits = 4)
    lms_ia[i+1, 4] <- nrow(sub_vi)
    lms_ia[i+1, 5] <- nrow(sub_va)
  }
}

lms_ia <- na.omit(lms_ia)
colnames(lms_ia) <- c("lang", "beta", "pval", "count_i", "count_a")
lms_ia$direction <- ifelse(lms_ia$beta < 0, "a > i", "i > a")
lms_ia$sig <- ifelse(lms_ia$pval < 0.05/nrow(lms_ia), "sig", "nonsig")
lms_ia$sig_other <- ifelse(lms_ia$pval < 0.05, "sig", "nonsig")
xtabs(~direction + sig, lms_ia)
xtabs(~direction + sig_other, lms_ia)

lms_ia <- left_join(lms_ia, f0_wide[,which(colnames(f0_wide) %in% c("lang", "Language", "family"))], by = "lang")

lms_ua <- data.frame(matrix(nrow = length(unique(f0_wide$lang)), ncol = 5))
for (i in 1:length(unique(f0_wide$lang))) {
  langi <- unique(f0_wide$lang)[i]
  sub_vu <- subset(d, lang == langi & broad == "u")
  sub_va <- subset(d, lang == langi & broad == "a")
  newdat <- rbind(sub_vu, sub_va)
  if (nrow(sub_vu) >= 10 & nrow(sub_va) >= 10) {
    fitlm <- lm(f0_2_erb ~ broad, newdat)
    lms_ua[i+1, 1] <- langi
    lms_ua[i+1, 2] <- fitlm$coefficients[2]
    lms_ua[i+1, 3] <- round(summary(fitlm)$coefficients[2,4], digits = 4)
    lms_ua[i+1, 4] <- nrow(sub_vu)
    lms_ua[i+1, 5] <- nrow(sub_va)
  }
}

lms_ua <- na.omit(lms_ua)
colnames(lms_ua) <- c("lang", "beta", "pval", "count_u", "count_a")
lms_ua$direction <- ifelse(lms_ua$beta < 0, "a > u", "u > a")
lms_ua$sig <- ifelse(lms_ua$pval < 0.05/nrow(lms_ua), "sig", "nonsig")
lms_ua$sig_other <- ifelse(lms_ua$pval < 0.05, "sig", "nonsig")
xtabs(~direction + sig, lms_ua)
xtabs(~direction + sig_other, lms_ua)

lms_ua <- left_join(lms_ua, f0_wide[,which(colnames(f0_wide) %in% c("lang", "Language", "family"))], by = "lang")

# cross-linguistic mixed-effects linear regression
d_final <- subset(d, lang %in% f0_wide$lang)
d_final$broad <- factor(d_final$broad, levels = c("a", "i", "u"))
contrasts(d_final$broad) <- contr.treatment(3)
contrasts(d_final$broad)

# code preceding/following class and voicing
d_final$prec_voice <- ifelse(is.na(d_final$prec_voice), "sil", d_final$prec_voice)
d_final$foll_voice <- ifelse(is.na(d_final$foll_voice), "sil", d_final$foll_voice)

d_final$prec_voice <- factor(d_final$prec_voice, levels = c("vcd", "vcl", "sil"))
contrasts(d_final$prec_voice) <- contr.treatment(3)
contrasts(d_final$prec_voice)
d_final$foll_voice <- factor(d_final$foll_voice, levels = c("vcd", "vcl", "sil"))
contrasts(d_final$foll_voice) <- contr.treatment(3)
contrasts(d_final$foll_voice)

d_final <- subset(d_final, !is.na(f0_2_erb))

has_ia <- unique(subset(f0_wide, !is.na(f0_wide$i))$lang)
has_ua <- unique(subset(f0_wide, !is.na(f0_wide$u))$lang)
d_ia <- subset(d_final, lang %in% has_ia & broad %in% c("i", "a"))
d_ua <- subset(d_final, lang %in% has_ua & broad %in% c("u", "a"))

d_ia$broad <- factor(d_ia$broad, levels = c("a", "i"))
contrasts(d_ia$broad) <- contr.treatment(2)
d_ua$broad <- factor(d_ua$broad, levels = c("a", "u"))
contrasts(d_ua$broad) <- contr.treatment(2)

fit_ia <- lmer(f0_2_erb ~ broad*prec_voice*foll_voice + vdur + (1 + broad | lang), d_ia)
summary(fit_ia)

fit_ua <- lmer(f0_2_erb ~ broad*prec_voice*foll_voice + vdur + (1 + broad | lang), d_ua)
summary(fit_ua)






