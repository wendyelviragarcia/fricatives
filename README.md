# Fricatives


zero-crossings-and-spectral-moments (v.2, February 2019, implemented for Praat 5.3.83)

Script created for analysing fricatives. This script goes through all the files in a folder 
and gets (for intervals with a given label(s) or every non-empty-intervals) zero-crossings and spectral moments, 
spectral peak and harmonic to noise ratio.

Wendy Elvira-García (2014). Zero-crossings-and-spectral-moments, v.2 [Praat script]

# DESCRIPTION
This script runs through all the files in a folder and gets its for each non-empty/labelled in certain way interval/:
1) speaker's name/region/code/variable (optional)- it gets the firsts characters in the file name
2) file name
3) interval name 
4) start point, end point and duration of the interval
5) zero crossing in the firsts 30ms of the interval				
6) number of crosses in the whole interval
7) zero crosses of the interval*10 /duration of the interval (Román Montes de Oca, 2012)
8) Frequency of maximum intensity (spectral peak after filter)
9) intensity (min, max and mean)
10) centre of gravity 
11) skewness
12) kurtosis
13) standard deviation
14) harmonic to noise ratio (mean) 

And it writes it in a .txt file (if you open it with Excel remember: decimals are written in Praat with a point, depending on your settings Excel might understand that as thousands).
Therefore, Spaniards, you will have to use the "Asistente de importacion" or directly import to R, or open with Numbers
				
# INSTRUCTIONS
0) You'll need a folder with the Sounds and TextGrids, the textGrid must have an interval tier where non-empty intervals/intervals matching a a label are the sounds you want to analize.
1) Open the script with Praat (Read from file...), the script will open. In the upper menu select Run and Run again. 
2) Fill the form, click OK and a new window will open where you will be able to choose the folder where your files are.
3) When the script finishes a screen will appear telling you you can check the text file

comments are always welcome 
Wendy Elvira-Garcia (www.wendyelvira.ga)
Free script under a GNU General Public License contract. 
Comes with no warranty use under your responsability.
	
