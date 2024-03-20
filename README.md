# VoxAngeles
VoxAngeles Corpus: Phonetic segmentation of the UCLA Phonetics Lab Archive

VoxAngeles is a corpus of audited phonetic transcriptions and phone-level alignments of the UCLA Phonetics Lab Archive (Ladefoged et al., 2009, http://archive.phonetics.ucla.edu/), along with phonetic measurements including word and phone durations, vowel f0 and vowel formants. The audited portion of the corpus currently contains data from 95 languages across 21 language families. Unaudited automatic alignments are also available for an additional 11 languages.

The repository contains four primary directories:

1) The ``data`` directory contains three subdirectories:

+ **audited_aligned**: Manually corrected phone-level alignments and audited phonetic transcriptions for the word-level segmentations provided in the CMU Release of the UCLA Phonetics Lab Archive (Li et al., 2021, https://github.com/xinjli/ucla-phonetic-corpus). The force aligned output in the ``processing/forced_alignment`` folder was manually corrected and audited, frequently with close reference to the original field notes hosted on the UCLA Phonetics Lab Archive. 
+ **phonetic_measurements**: Resulting phonetic measurements (duration, corner vowel formants, corner vowel f0) from the ``processing/phonetic_extraction`` scripts
+ **unaudited**: Force-aligned phone-level alignments and original phonetic transcriptions directly from the UCLA Phonetics Lab Archive. These data have not yet been manually corrected, but they are force-aligned.
 

2) The ``lrec-coling_analyses`` directory contains data and R processing scripts relevant for the analyses conducted in the LREC-COLING 2024 paper for the comparison between the VoxAngeles and UCLA transcriptions, as well as the VoxAngeles and MFA alignments (``voxangeles_mfa_comparison.R``), the intrinsic f0 analysis (``voxangeles_f0_analysis.R``) and the creation of the map (``map``). 

3) The ``processing`` directory contains two subdirectories and one script:
+ **forced_alignment**: The documentation of the procedure for force-aligning the CMU Release of the UCLA Phonetics Lab Archive (retrieved May 2023) using the Montreal Forced Aligner (MFA) and the Interlingual-MFA toolkit. The raw TextGrid output from the MFA alignment, as well as relevant scripts and text files are included in this directory.
+ the modifyLabelsBoundaries.praat script, which was used in processing to automatically open the files in the Praat Editor window and save them after closing
+ **phonetic_extraction**: This contains the Praat scripts for extracting phonetic measurements (duration, corner vowel formants, corner vowel f0)


4) The ``transcription`` directory contains files relevant for generating the reference file **voxangeles_transcriptions.tsv**. This file contains a list of the audited and updated transcriptions: the columns correspond to the language, file, raw transcription, intermediate 1 transcription, intermediate 2 transcription, and the updated transcription. The raw and intermediate transcriptions were obtained from the CMU release, where the raw output was the original scraped transcription, and the intermediate 1 and 2 transcriptions simplified the transcription with and without spaces between segments. Our processing began with the intermediate 1 transcription as segment spacing had already been provided. The updated row is our final audited transcription of the word after manual inspection, standardization, and frequently after consultation with the original field notes.


### References

Ladefoged, P., Blankenship, B., Schuh, R. G., Jones, P., Gfroerer, N., Griffiths, E., Harrington, L., Hipp, C., Jones, P., Kaneko, M., Moore-Cantwell, C., Oh, G., Pfister, K., Vaughan, K., Videc, R., Weismuller, S., Weiss, S., White, J., Conlon, S., Lee, WS. J., and Toribio, R. (2009). The UCLA Phonetics Lab Archive.  Los Angeles, CA: UCLA Department of Linguistics. http://archive.phonetics.ucla.edu 

Li, X., Metze, F., Mortensen, D. R., Black, A. W., and Watanabe, S. (2022). Phone inventories and recognition for every language. In Proceedings of the Thirteenth Language Resources and Evaluation Conference (pp. 1061–1067).

### Corpus notes
The corpus is free to use under a CC BY-NC 4.0 license. 

For use of this corpus, please cite:

Chodroff, E., Pažon, B., Baker, A., and Moran, S. (2024). Phonetic segmentation of the UCLA Phonetics Lab Archive. In *Proceedings of the 2024 Joint International Conference on Computational Linguistics, Language Resources and Evaluation (LREC-COLING 2024)*. Turin, Italy.