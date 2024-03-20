### CHANGE ME ###
lang$ = "ajp"
#basedir$ = "/Users/eleanor/Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/Meine Ablage/ucla_phonetic_corpus/ucla_data/"
basedir$ = "/Users/eleanor/Library/CloudStorage/GoogleDrive-eleanor.chodroff@gmail.com/My Drive/ucla_phonetic_corpus/ucla_data/"
#################

wavdir$ = basedir$ + lang$ + "/audio/"
dir$ = basedir$ + lang$ + "/mfa_output/"

Create Strings as file list: "files", dir$ + "*.TextGrid"
nFiles = Get number of strings

for i from 1 to nFiles
	selectObject: "Strings files"
	filename$ = Get string: i
	basename$ = filename$ - ".TextGrid"

	Read from file: dir$ + filename$
	Read from file: wavdir$ + basename$ + ".wav"

	selectObject: "Sound " + basename$
	plusObject: "TextGrid " + basename$
	View & Edit

	pauseScript: "modify labels"

	minusObject: "Sound " + basename$

	Save as text file: dir$ + filename$

	select all
	minusObject: "Strings files"
	Remove
endfor