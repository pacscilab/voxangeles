# for each language and each wav file in a language, create a TextGrid with one tier
# the tier will contain one interval that contains the transcript in final.txt for the sound file
# final.txt contains two columns: the first column is the wav file, the second is the transcript

# input: final.txt (which gives us a list of the wav files we need)
# output: TextGrid with one tier with the transcript in it

# Eleanor Chodroff
# July 2023

### CHANGE ME ###
path$ = "/Users/echodroff/Downloads/ucla_data/"
Create Strings as folder list: "folders", path$ + "*"

#Create Strings from tokens: "folders", "abk ace ady aeb afn afr agx ajp aka apc ape apw asm azb", " "
#Create Strings from tokens: "folders", "bhk ffm idu mak abk bin fin ilo mal ace brv isl mlt ady bsq fub its mya aeb bwr gaa kan nan afn cbv gla kea njm afr ces guj khm nld agx cha gwx klu ozm ajp cji hak knn pam aka col hau kri pes apc cpn haw kub prs ape dag heb kye run apw dan hil lad sbc asm deg hin lar tsw azb dyo hni lav tzm bam efi hrv led wuu bem ell hun lgq yue ben ema hye lit bfd eus ibb lkt bfq ewe ibo lug", " "
#################

nFolders = Get number of strings

for k from 1 to nFolders
	selectObject: "Strings folders"
	lang$ = Get string: k
	dir$ = path$ + lang$ + "/"
	call processLang: lang$

endfor

procedure processLang: lang$
	# read in final.txt
	Read Table from tab-separated file: dir$ + "final.txt"

	# create a for loop to loop through all the listed files in that table
	nFiles = Get number of rows

	for i from 1 to nFiles

		selectObject: "Table final"

		# get the name of the file from final.txt
		file$ = Get value: i, "file"

		# get the transcript from final.txt
		transcript$ = Get value: i, "transcript"
		transcript$ = replace$(transcript$, " ", "", 0)


		# read the wav file in to Praat
		Read from file: dir$ + "audio/" + file$ + ".wav"

		# create a TextGrid for the wav file
		To TextGrid: "transcript", ""

		# insert the transcript into the TextGrid 
		Set interval text: 1, 1, transcript$

		# save the TextGrid
		Save as text file: dir$ + "audio/" + file$ + ".TextGrid"

		# clean up
		select all
		minusObject: "Table final"
		minusObject: "Strings folders"
		Remove
	endfor
endproc

