# VoxAngeles
VoxAngeles Corpus: Phonetic Segmentation of the UCLA Phonetics Lab Archive

VoxAngeles is a corpus of audited phonetic transcriptions and phone-level alignments of the UCLA Phonetics Lab Archive (Ladefoged et al., 2009, http://archive.phonetics.ucla.edu/), along with phonetic measurements including word and phone durations, vowel f0 and vowel formants. The corpus currently contains data from 95 languages across 21 language families. 

The audited and aligned data (**audited_aligned**) contain manually corrected phone-level alignments and audited phonetic transcriptions for the word-level segmentations provided in the CMU Release of the UCLA Phonetics Lab Archive (Li et al., 2021, https://github.com/xinjli/ucla-phonetic-corpus). The unaudited data folder (**unaudited**) contains force-aligned phone-level alignments and original phonetic transcriptions directly from the UCLA Phonetics Lab Archive. These data have not yet been manually corrected. 

Word-level segmentations and their corresponding phonetic transcriptions were force-aligned using the procedure outlined here: https://github.com/echodroff/ucla-alignments. For the files in **audited_aligned**, the force aligned output was then manually corrected and audited, frequently with close reference to the original field notes hosted on the UCLA Phonetics Lab Archive. 

The file voxangeles_transcriptions.csv contains a current list of the audited and updated transcriptions: the columns correspond to the language, file, raw transcription, intermediate 1 transcription, intermediate 2 transcription, and the updated transcription. The raw and intermediate transcriptions were obtained from the CMU release, where the raw output was the original scraped transcription, and the intermediate 1 and 2 transcriptions simplified the transcription with and without spaces between segments. Our processing began with the intermediate 1 transcirption as segment spacing had already been provided. The updated row is our final audited transcription of the word after manual inspection, standardization, and frequently after consultation with the original field notes. 

The folder **praat_scripts** contains the Praat scripts for processing the data and extracting phonetic measurements. For processing data, we used the Praat script modifyLabelsBoundaries.praat, which  automatically opened the files in the Praat Editor window and saved them after closing. The remaining scripts were involved in extracting duration, vowel f0, and vowel formant information. The resulting phonetic measurements are stored in **phonetic_measurements**. 

The corpus is free to use under a CC BY-NC 4.0 license. 

The corresponding paper is currently under review at LREC-COLING. In this paper, we conducted an analysis of intrinsic vowel f0. The processing scripts and data are included in the folder **lrec-coling-intrinsicf0**. 

Ladefoged, P., Blankenship, B., Schuh, R. G., Jones, P., Gfroerer, N., Griffiths, E., Harrington, L., Hipp, C., Jones, P., Kaneko, M., Moore-Cantwell, C., Oh, G., Pfister, K., Vaughan, K., Videc, R., Weismuller, S., Weiss, S., White, J., Conlon, S., Lee, WS. J., and Toribio, R. (2009). The UCLA Phonetics Lab Archive.  Los Angeles, CA: UCLA Department of Linguistics. http://archive.phonetics.ucla.edu 

Li, X., Metze, F., Mortensen, D. R., Black, A. W., and Watanabe, S. (2022). Phone inventories and recognition for every language. In Proceedings of the Thirteenth Language Resources and Evaluation Conference (pp. 1061–1067).
