######
### Extract formants (F1, F2, F3) from VoxAngeles vowels
## 20 Oct 2023
# E Chodroff
######

### CHANGE ME ###
# Specify the directory with the list of language-specific folders containing TextGrids
directories$ = "/Users/eleanor/Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My Drive/ucla_phonetic_corpus/ucla_data_aligned/"

# If the TextGrids are in a subfolder within each langauge-specific folder, specify the name here
# otherwise set name_of_dir$ = "" and name_of_audio_dir$ = ""
name_of_dir$ = "/hand_aligned/"
name_of_audio_dir$ = "/audio/"

# Read in file with average f0 values per language
Read Table from tab-separated file: "/Users/eleanor/Desktop/voxangeles_meanf0_file.tsv"
Rename: "files"

# Specify the output file
outfile$ = "/Users/eleanor/Desktop/voxangeles_formants_quartiles.tsv"

# Specify the number of formant points across the vowel
nFormantIntervals = 4

# Choose a separator (tab$, ",")
sep$ = tab$
#################

appendFile: outfile$, "lang", sep$, "file", sep$, "word", sep$, "phone", sep$, "prec", sep$, "foll", sep$, "int", sep$
for t from 1 to nFormantIntervals
	appendFile: outfile$, "f1_" + string$(t), sep$
endfor
for t from 1 to nFormantIntervals
	appendFile: outfile$, "f2_" + string$(t), sep$
endfor
for t from 1 to nFormantIntervals
	appendFile: outfile$, "f3_" + string$(t), sep$
endfor
appendFileLine: outfile$, "pstart", sep$, "pend", sep$, "wstart", sep$, "wend"

Create Strings as folder list: "dirs", directories$
nLangs = Get number of strings

# Loop through language folders and loop through TextGrids within it
for i from 1 to nLangs
	selectObject: "Strings dirs"
	dir$ = Get string: i

	Create Strings as file list: "files", directories$ + dir$ + name_of_dir$ + "*.TextGrid"
	nFiles = Get number of strings

	for j from 1 to nFiles
		@processFile
	endfor

	selectObject: "Strings files"
	Remove
endfor

# Find interval containing the word of interest
procedure processFile
	selectObject: "Strings files"
	filename$ = Get string: j
	basename$ = filename$ - ".TextGrid"

	Read from file: directories$ + dir$ + name_of_dir$ + filename$
	nIntWord = Get number of intervals: 1

	for k from 1 to nIntWord
		@processWordTier
	endfor
	Remove
endproc

# Extract word start and end time; Loop through phone intervals corresponding to the word
procedure processWordTier
	selectObject: "TextGrid " + basename$
	label$ = Get label of interval: 1, k
	if label$ != ""
		word_start = Get start time of interval: 1, k
		word_end = Get end time of interval: 1, k

		nInt = Get number of intervals: 2
		for p from 1 to nInt
			@processPhoneTier
		endfor
	endif
endproc

# Extract start and end time for each phone, as well as preceding and following phone information
procedure processPhoneTier
	selectObject: "TextGrid " + basename$
	phon$ = Get label of interval: 2, p
	start = Get start time of interval: 2, p		
	end = Get end time of interval: 2, p
	dur = end-start
	if index_regex(phon$, "[aɑæɐʊʉɯuiɪɨɪ̈yʏ]")
		
		if p > 1
			prec$ = Get label of interval: 2, p-1
		else
			prec$ = "NA"
		endif

		if p < nInt
			foll$ = Get label of interval: 2, p+1
		else
			foll$ = "NA"
		endif

		appendFile: outfile$, dir$, sep$, basename$, sep$, label$, sep$, phon$, sep$, prec$, sep$, foll$, sep$, string$(p), sep$
		@getFormants

		# round values to 2 decimal points
		start$ = fixed$(start, 2)
		end$ = fixed$(end, 2)
		word_start$ = fixed$(word_start, 2)
		word_end$ = fixed$(word_end, 2)
		
		appendFile: outfile$, start$, sep$, end$, sep$, word_start$, sep$, word_end$, newline$
	endif
endproc

# Get formant values
procedure getFormants
	selectObject: "Table files"
	row = Search column: "file", basename$
	
	f0 = Get value: row, "meanf0"
	if f0 < 160
		pitch_ceiling = 5000
	else
		pitch_ceiling = 5500
	endif

	Read from file: directories$ + dir$ + name_of_audio_dir$ + basename$ + ".wav"
	To Formant (burg): 0, 5, pitch_ceiling, 0.025, 50
	
	for f from 1 to 3
		for x from 1 to nFormantIntervals
			x_time = Get value at time: f, start + x*(dur/nFormantIntervals), "hertz", "linear"
			x_time$ = fixed$(x_time, 2)
			appendFile: outfile$, x_time$, sep$
		endfor
	endfor

	selectObject: "Formant " + basename$
	plusObject: "Sound " + basename$
	Remove
endproc