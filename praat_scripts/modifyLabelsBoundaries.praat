### Modify labels and boundaries - VoxAngeles
## 21 Oct 2023
# E Chodroff

# This script loops through wav files and TextGrids in a directory
# In each iteration, the wav file and TextGrid is opened in the Praat Editor window, 
# the script is paused, and the user can then make modifications to the TextGrid.
# When the next button is clicked, then the TextGrid is automatically saved to the directory. 

### CHANGE ME ###
lang$ = "ajp"
basedir$ = "/Users/eleanor/Documents/ucla_phonetic_corpus/ucla_data/"
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