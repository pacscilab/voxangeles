# Forced alignment of the CMU release of the UCLA Phonetics Lab Data with the MFA and Interlingual MFA

## Pipeline for obtaining forced alignments

1. Download cleaned UCLA Phonetics Corpus at https://github.com/xinjli/ucla-phonetic-corpus

2. Prepare the file called 'text' for input to Praat. Convert first space to a tab and add a header with file and transcript, separated by a tab.

```console
sed 's/ /\t/' abk/text.txt > abk/tmp.txt
cat header.txt abk/tmp.txt > abk/final.txt
```

Iterate over languages (in folder with all languages plus header.txt):

```console
for i in *;
do sed 's/ /\t/' "$i"/text.txt > "$i"/tmp.txt;
cat header.txt "$i"/tmp.txt > "$i"/final.txt;
done
```

3. Run createTextGrids.praat to generate TextGrids for each wav file as input to MFA. Update path to folders.

4. Generate pronunciation lexicon based on transcriptions (concatentate the original text.txt files)

```console
cat [a-z]*/text.txt > ucla_lexicon.txt
```
Run create_mfa_lexicon.py to obtain the lexical item (no spaces, as in the TextGrid) on the leftside and the phonetic transcript (spaces) on the rightside. 

```python
python3 create_mfa_lexicon.py ucla_lexicon.txt ucla_lexicon_tmp.txt
```

Sort and unique this output

```console
sort ucla_lexicon_tmp.txt | uniq > ucla_lexicon_final.txt
rm ucla_lexicon_tmp.txt
```

5. Convert pronunciation lexicon to phone set included in the Montreal Forced Aligner english_mfa acoustic model using the Interlingual MFA library: https://github.com/jhdeov/interlingual-MFA. (We will use the english_mfa acoustic model to perform the alignments and then we will convert the phones back to their original form.)

The english_mfa phones are listed in phones_english_mfa.txt. 
The ucla phones are listed in phones_ucla.txt.
The phone mapping is listed in phone_mapping.txt and was created manually by EC.

Follow instructions in Interlingual MFA to use phone_mapping.txt and ucla_lexicon_final.txt to generate an intermediate "English" pronunciation lexicon called ucla_english_lexicon.txt

6. Align all TextGrids and wav files using the Montreal Forced Aligner with the english_mfa acoustic model and the ucla_english_lexicon.txt pronunciation lexicon. Copy all wav files and TextGrids from all languages to a single folder and create an output folder. Move ucla_english_lexicon.txt to Documents/MFA/pretrained_models/dictionary/.

```console
conda activate aligner
mfa model download acoustic english_mfa
mfa align ~/Desktop/ucla_input ucla_english_lexicon english_mfa ~/Desktop/ucla_output
```

7. Convert phone labels in the TextGrids back to their original form by following the instructions in Interlingual MFA and using the pkl file generated in Step 5.
