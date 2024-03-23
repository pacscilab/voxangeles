######
### Extract mean f0 from VoxAngeles files in preparation for formant extraction
## 20 Oct 2023, updated 31 Jan 2024
# E Chodroff
######

### CHANGE ME ###

# Specify the directory with the list of language-specific folders containing TextGrids
directories$ = "/Users/eleanor/Desktop/ucla/"

# If the audio files are in a subfolder within each langauge-specific folder, 
# specify the name here like name_of_audio_dir$ = "audio/"
# otherwise set name_of_audio_dir$ = "/"
name_of_audio_dir$ = "/"

# Specify the output file
outfile$ = "/Users/eleanor/Desktop/voxangeles_meanf0_file.tsv"

# Choose a separator (tab$, ",")
sep$ = tab$

#################

appendFileLine: outfile$, "file", sep$, "meanf0"

Create Strings as folder list: "dirs", directories$
nLangs = Get number of strings

# Loop through language folders and loop through audio files within it
for i from 1 to nLangs
	selectObject: "Strings dirs"
	dir$ = Get string: i

	Create Strings as file list: "files", directories$ + dir$ + "/" + name_of_audio_dir$ + "*.wav"
	nFiles = Get number of strings

	for j from 1 to nFiles
		selectObject: "Strings files"
		filename$ = Get string: j
		basename$ = filename$ - ".wav"
		Read from file: directories$ + dir$ + "/" + name_of_audio_dir$ + filename$
		To Pitch: 0, 75, 500
		f0 = Get mean: 0, 0, "Hertz"
		appendFileLine: outfile$, basename$, sep$, f0
		selectObject: "Sound " + basename$
		plusObject: "Pitch " + basename$
		Remove
	endfor

	selectObject: "Strings files"
	Remove
endfor