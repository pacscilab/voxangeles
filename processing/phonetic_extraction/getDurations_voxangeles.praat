######
### Extract phone and word durations and labels from VoxAngeles
## 20 Oct 2023
# E Chodroff
######

### CHANGE ME ###

# Specify the directory with the list of language-specific folders containing TextGrids
directories$ = "/Users/eleanor/Desktop/ucla/"

# If the TextGrids are in a subfolder within each langauge-specific folder, 
# specify the name here, like name_of_dir$ = "hand_aligned/
# otherwise set name_of_dir$ = "/"
name_of_dir$ = "/"

# Specify the output file
outfile$ = "/Users/eleanor/Desktop/voxangeles_durations.tsv"

# Choose a separator (tab$, ",")
sep$ = tab$
#################

appendFile: outfile$, "lang", sep$, "file", sep$, "word", sep$, "phone", sep$, "prec", sep$, "foll", sep$, "int", sep$
appendFileLine: outfile$, "pstart", sep$, "pend", sep$, "wstart", sep$, "wend"

Create Strings as folder list: "dirs", directories$
nLangs = Get number of strings

# Loop through language folders and loop through TextGrids within it
for i from 1 to nLangs
	selectObject: "Strings dirs"
	dir$ = Get string: i
	
	Create Strings as file list: "files", directories$ + dir$ + "/" + name_of_dir$ + "*.TextGrid"
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

	Read from file: directories$ + dir$ + "/" + name_of_dir$ + filename$
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
	if phon$ != ""
		
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

		# round values to 4 decimal points
		start$ = fixed$(start, 4)
		end$ = fixed$(end, 4)
		word_start$ = fixed$(word_start, 4)
		word_end$ = fixed$(word_end, 4)
		
		appendFile: outfile$, start$, sep$, end$, sep$, word_start$, sep$, word_end$, newline$
	endif
endproc
