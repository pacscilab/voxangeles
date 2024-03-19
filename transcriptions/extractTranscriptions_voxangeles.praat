dir$ = "/Users/eleanor/Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My Drive/ucla_phonetic_corpus/ucla_data_aligned/"
outfile$ = "/Users/eleanor/Desktop/voxangeles_transcriptions_updated_only.tsv"

sep$ = tab$ 
#sep$ = ","

appendFileLine: outfile$, "lang", sep$, "file", sep$, "updated"
Create Strings as folder list: "folders", dir$ + "*"
nFolders = Get number of strings

for i from 1 to nFolders
	selectObject: "Strings folders"
	folderName$ = Get string: i
	
	Create Strings as file list: "files", dir$ + folderName$ + "/hand_aligned/*"
	nFiles = Get number of strings
	for j from 1 to nFiles
		selectObject: "Strings files"
		filename$ = Get string: j
		basename$ = filename$ - ".TextGrid"
		Read from file: dir$ + folderName$ + "/hand_aligned/" + basename$ + ".TextGrid"
		updated$ = Get label of interval: 1, 2
		if updated$ == ""
			updated$ = Get label of interval: 1, 1
		endif
		appendFileLine: outfile$, folderName$, sep$, basename$, sep$, updated$
		Remove
	endfor
	select all
	minusObject: "Strings folders"
	Remove
endfor
