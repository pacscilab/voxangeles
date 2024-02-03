# create map of languages

dir <- "/Users/eleanorchodroff/Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My Drive/ucla_phonetic_corpus/analysis/map/"
ucla_glottlog <- read_csv(paste0(dir, "ucla_glottlog.csv"), col_names = TRUE, trim_ws = TRUE)
langs <- read_delim(paste0(dir, "langs.tsv"), delim = "\t", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE)
colnames(langs) <- c("iso_6393")
corpus <- merge(langs, ucla_glottlog, by = "iso_6393")

# njm matched twice: Naga, Angami and Angami; we'll take the broader (I think it's actually Khonoma Angami), but in this case, the lines are otherwise identical, so it won't matter
corpus <- subset(corpus, Language != "Naga, Angami")

corpus$family_id <- ifelse(corpus$Language == "Basque", "basq1248", corpus$family_id)
ggplot(data=corpus, aes(x=longitude, y=latitude, color=family_id)) + 
  borders("world", colour="gray70", fill="gray70") + 
  geom_point(size = 3) +
  theme_minimal(23) +
  theme(legend.position="none") +
  scale_color_viridis_d()
ggsave(paste0(dir, "map_family_corpus.png"), plot = last_plot(), units = "in", height = 6, width = 10, dpi = 300 )
ggsave(paste0(dir, "map_family_corpus.pdf"), plot = last_plot(), units = "in", height = 6, width = 10, dpi = 300 )

