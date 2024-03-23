### Extract updated transcriptions from VoxAngeles
## 23 Mar 2024
# E Chodroff
######

### CHANGE ME ###
# Specify the directory with the list of language-specific folders containing TextGrids
directories$ = "/Users/eleanorchodroff/Desktop/ucla/"

# If the TextGrids are in a subfolder within each langauge-specific folder, 
# specify the name here, like name_of_dir$ = "hand_aligned/
# otherwise set name_of_dir$ = "/"
name_of_dir$ = "/"

# Specify the output file
outfile$ = "/Users/eleanorchodroff/Desktop/voxangeles_transcriptions_updated_only.tsv"

# Choose a separator (tab$, ",")
sep$ = tab$
#################

appendFileLine: outfile$, "lang", sep$, "file", sep$, "updated"

Create Strings as folder list: "folders", directories$ + "*"
nFolders = Get number of strings

for i from 1 to nFolders
	selectObject: "Strings folders"
	dir$ = Get string: i
	
	Create Strings as file list: "files", directories$ + dir$ + "/" + name_of_dir$ + "*.TextGrid"
	nFiles = Get number of strings
	for j from 1 to nFiles
		selectObject: "Strings files"
		filename$ = Get string: j
		basename$ = filename$ - ".TextGrid"
		Read from file: directories$ + dir$ + "/" + name_of_dir$ + basename$ + ".TextGrid"
		updated$ = Get label of interval: 1, 2
		if updated$ == ""
			updated$ = Get label of interval: 1, 1
		endif
		appendFileLine: outfile$, dir$, sep$, basename$, sep$, updated$
		Remove
	endfor
	select all
	minusObject: "Strings folders"
	Remove
endfor
