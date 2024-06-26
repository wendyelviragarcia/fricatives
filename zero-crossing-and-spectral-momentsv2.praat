#############################################################################################################################################################
# 
# zero-crossings-and-spectral-moments (v.2, February 2019, implemented for Praat 5.3.83)
# 
# Script created for analysing fricatives. This script goes through all the files in a folder 
# and gets (for intervals with a given label(s) or every non-empty-intervals) zero-crossings and spectral moments, 
# spectral peak and harmonic to noise ratio.
#
# Wendy Elvira-García (2014). Zero-crossings-and-spectral-moments, v.2 [Praat script]
# 
###########################################################################################################################
#
#									DESCRIPTION
#				This script runs through all the files in a folder and gets its for each non-empty/labelled in certain way interval/:
#				1) speaker's name/region/code/variable (optional)- it gets the firsts characters in the file name
#				2) file name
#				3) interval name 
#				4) start point, end point and duration of the interval
#				5) zero crossing in the firsts 30ms of the interval				
#				6) number of crosses in the whole interval
#				7) zero crosses of the interval*10 /duration of the interval (Román Montes de Oca, 2012)
#				8) Frequency of maximum intensity (spectral peak after filter)
#				9) intensity (min, max and mean)
#				10) centre of gravity 
#				11) skewness
#				12) kurtosis
#				13) standard deviation
#				14) harmonic to noise ratio (mean) 

#				And it writes it in a .txt file (if you open it with Excel remember: decimals are written in Praat with a point, depending on your settings Excel might understand that as thousands).
#				Therefore, Spaniards, you will have to use the "Asistente de importacion" or directly import to R, or open with Numbers
#				
#									INSTRUCTIONS
#				0) You'll need a folder with the Sounds and TextGrids, the textGrid must have an interval tier where non-empty intervals/intervals matching a a label are the sounds you want to analize.
# 				1) Open the script with Praat (Read from file...), the script will open. In the upper menu select Run and Run again. 
#				2) Fill the form, click OK and a new window will open where you will be able to choose the folder where your files are.
#				3) When the script finishes a screen will appear telling you you can check the text file
#
#		comments are always welcome 
#	Wendy Elvira-Garcia
#	Free script under a GNU General Public License contract. 
# 	Comes with no warranty use under your responsability.
#	wendyelviragarcia @ g m a i l . c o m
#	Retrieved from http://stel.ub.edu/labfon/en/praat-scripts
#	Laboratori de Fonètica (University of Barcelona)
#
#	
####################################		PRE		###################################################################################

if praatVersion < 5364
	exit Download Praat version 53.6.4 or later
endif

select all
numberOfSelectedObjects = numberOfSelected ()
if numberOfSelectedObjects <> 0
	pause You have objects in the list. Do you want me to remove them?
	Remove
endif

####################################		FORM	###################################################################################
form Spectral analysis
	comment You need a folder with sounds and their matching 
	comment TextGrids with the fricatives labelled in intervals 
	comment Write the name of the txt file where data will be stored,
	comment the file will be created in the same folder where wavs are.
	comment Folder path (Leave it blank for folder selector)
	sentence Folder /Users/myLab/Desktop
	sentence txtName spectrum-analysis
	comment Where is your by-sound segmentation
	integer tier 3
	boolean filter_(filters_signal_from_1000_to_11000) 1
	comment Analyse intervals where text equals:
	comment If you want to extract more than one label introduce the labels separated 
	comment with commas and WITHOUT spaces
	comment example: s,z,g
	sentence label nonempty
	comment Do you want to analyze only the center part of the fricative? Use a margin.
	real margin 0.001
	comment ¿Do you have the speaker´s code/region in the file name? ¿How many characters has it?
	integer speaker_digits 0
endform
if folder$ = ""
	folder$ = chooseDirectory$ ("Choose the Sound and TextGrid folder:")
endif
txtNameExtension$ = folder$ + "/" + txtName$ + ".txt"

###########		Create table		#############################
if fileReadable (txtNameExtension$)
	pause There is already a file with that name. It will be deleted.
	deleteFile: txtNameExtension$
endif

writeFileLine: folder$ + "/" + txtName$ + ".txt", "Speaker	", "File	", "Interval label	", "Interval start [ms]	", "Interval end [ms]	", "Interval duration [ms]	", "Zero crossings 30 ms 	", "Zero crossings interval	", "Zero crossings* 10 / interval duration [ms]	", "Frequency of max int	", "Min intensity	", "Max intensity	", "Mean intensity	", "Center of gravity [Hz]	", "Skewness	", "Kurtosis	", "Standard deviation [Hz]	", "ratio"

##################	PRELOOP	######################
#creates .wav list to analyze
Create Strings as file list: "list", folder$ + "/" + "*wav"
#cuenta los archivos para saber hasta cuando pasa el bucle (tienes que darle un número, sino sería hasta el infinito)
numberOfFiles = Get number of strings
######################	LOOP FOR FILES	#############################
#empieza el bucle. Para un archivo (que será uno diferente cada vez, pero se llamará ifile) hasta el número de archivos que acabamos de contar
for ifile to numberOfFiles
	selectObject: "Strings list"
	fileName$ = Get string: ifile
	base$ = fileName$ - ".wav"

	# Lee el Sonido
	mySound = Read from file: folder$ +"/"+ base$ + ".wav"
	Open long sound file: folder$ + "/"+ base$ + ".wav"
	# Lee el TextGrid
	Read from file: folder$ + "/"+ base$ + ".TextGrid"
	
	# Consigue el nombre del informante
	speakersId$ = left$ (base$, speaker_digits)

	######################	LOOP FOR TEXGRID INTERVALS	######################
	#get interval label
	select TextGrid 'base$'
	numberOfIntervals = Get number of intervals: tier
	for n to numberOfIntervals
		select TextGrid 'base$'
		intervalLabel$ = Get label of interval: tier, n
		
		# analyze if matches...
		if label$ = "nonempty"
			if intervalLabel$ <> ""
			#analiza, el análisis está programado en un proceso vid. final script
			appendFile: folder$ + "/" + txtName$ + ".txt", speakersId$, tab$, base$, tab$, intervalLabel$, tab$
			@fric_analysis
			endif
		
		endif

		if index(label$, ",") <> 0
			lenLabel = length(label$)
			actualLabel = 1
			while actualLabel < lenLabel
				actualLabel$ = mid$(label$, actualLabel, 1)
				#if there is no comma
				if index(actualLabel$, ",") = 0
					#and the label matches the one in the interval
					if actualLabel$ = intervalLabel$
						
						appendFile: folder$ + "/" + txtName$ + ".txt", speakersId$, tab$, base$, tab$, intervalLabel$, tab$
						@fric_analysis
					endif
				endif
			
				actualLabel = actualLabel+1
			endwhile	
			
		else
			if intervalLabel$ = label$	
			#analiza, el análisis está programado en un proceso vid. final script
			appendFile: folder$ + "/" + txtName$ + ".txt", speakersId$, tab$, base$, tab$, intervalLabel$, tab$
			@fric_analysis
			endif
		endif
		#fin del bucle intervalos
	endfor
	removeObject: "Sound " + base$, "LongSound " + base$, "TextGrid "+ base$
	#fin bucle archivos
endfor
removeObject: "Strings list"
#Escribe en la pantalla info cosas aviso de que acabó de procesar y carpeta donde están.
echo The file has been created. 
printline You can find it here 'folder$'.


############# FIN DEL SCRIPT #################################################################################################################################### 


############# PROCEDIMIENTO PARA EL ANÁLISIS ############# 
procedure fric_analysis ()
	#empieza a escribir la linea en el txt, escribe lo que va a analizar
	
	#creo variables con los valores de inicio y final del intervalo y me los guardo para después poder extraer el sonido
	.intervalStart = Get start point: tier, n			
	.intervalEnd = Get end point: tier, n			
	.intervalDur = .intervalEnd - .intervalStart
	.intervalStartms = .intervalStart*1000
	.intervalEndms= .intervalEnd*1000
	.intervalDurms = .intervalDur*1000
	.intervalStartms$ = fixed$ (.intervalStartms, 0)
	.intervalEndms$ = fixed$ (.intervalEndms, 0)
	.intervalDurms$ = fixed$ (.intervalDurms, 0)

	selectObject: "LongSound " + base$
	#si el intervalo es menor de 0-030 el valor 2 = intervalEnd
	
.intervalStart = .intervalStart + margin
.intervalEnd = .intervalEnd -margin

	.targetEnd = .intervalStart + 0.030
	if .targetEnd > .intervalEnd
		.targetEnd = .intervalEnd
	endif
	#printline '.intervalStart' - '.intervalEnd' targetEnd: '.targetEnd'

	#Extraigo el las 30 primeras ms del intervalo
	selectObject: "LongSound " + base$
	Extract part: .intervalStart, .targetEnd, "yes"
	# Creo el proceso de puntos para contar los pasos por cero que hay en las 30 primeras milesimas de la fricativa
	To PointProcess (zeroes): 1, "yes", "yes"
	.numeroDePuntos = Get number of points
	Remove

	selectObject: "LongSound " + base$
	# Creo el proceso de puntos para contar los pasos por cero que hay en todo el intervalo
	Extract part: .intervalStart, .intervalEnd, "yes"
	Rename: "fricative" ; le doy el nombre de fricative para después poderla llamar
	pointprocess = To PointProcess (zeroes): 1, "yes", "yes"
	.numeroPuntosIntervalo = Get number of points
	.zCrossing = (.numeroPuntosIntervalo*10) / .intervalDurms
	.zCrossing$ = fixed$ (.zCrossing, 2)
	appendFile: folder$ + "/" + txtName$ + ".txt", .intervalStartms$, tab$, .intervalEndms$, tab$, .intervalDurms$, tab$, .numeroDePuntos, tab$, .numeroPuntosIntervalo, tab$, .zCrossing$, tab$ 
	removeObject: pointprocess

	# MOMENTOS ESPECTRALES
	selectObject: "Sound fricative"
	# Using a filter is a suggestion by Ricard Herrero and Daniel Recasens
	if filter = 1
		Filter (pass Hann band): 1000, 11000, 100 ;creará un objeto nuevo que se llamará fricative_band
	endif
	# Creo el objeto intensidad del sonido, dándole un ID (como si fuera una variable) para después podermo seleccionar y llamar por ese nombre
	ltas = To Ltas: 150
	.max_freq = Get frequency of maximum: 0, 11000, "Cubic"
	.max_freq$ = fixed$ (.max_freq, 0)
	appendFile: folder$ + "/" + txtName$ + ".txt", .max_freq$, tab$
	removeObject: ltas
	
	selectObject: "Sound fricative_band"
	# Creo el objeto intensidad del sonido, dándole un ID (como si fuera una variable) para después podermo seleccionar y llamar por ese nombre
	intensity = To Intensity: 500, 0, "yes"
	.min_intensity = Get minimum: 0, 0, "Parabolic"
	.max_intensity = Get maximum: 0, 0, "Parabolic"
	.mean_intensity = Get mean: 0, 0, "energy"
	.min_intensity$ = fixed$ (.min_intensity, 0)
	.max_intensity$ = fixed$ (.max_intensity, 0)
	.mean_intensity$ = fixed$ (.mean_intensity, 0)
	appendFile: folder$ + "/" + txtName$ + ".txt", .min_intensity$, tab$, .max_intensity$, tab$, .mean_intensity$, tab$
	removeObject: intensity
	
	selectObject: "Sound fricative_band"
	# Creo el espectro del sonido, dándole un ID (como si fuera una variable) para después podermo seleccionar y llamar por ese nombre
	spectrum = To Spectrum: "yes"
	.center_gravity = Get centre of gravity: 2
	.center_gravity$ = fixed$ (.center_gravity, 4)
	.skewness = Get skewness: 2
	.skewness$ = fixed$ (.skewness, 4)
	.kurtosis = Get kurtosis: 2
	.kurtosis$ = fixed$(.kurtosis, 4)
	.standard_dev = Get standard deviation: 2
	.standard_dev$ = fixed$ (.standard_dev, 4)
	
	selectObject: mySound
	myHarm = To Harmonicity (cc): 0.01, 75, 0.1, 4.5
	.ratio = Get mean: .intervalStart, .intervalEnd
	.ratio$ = fixed$(.ratio, 2)

	removeObject: myHarm
	#echo '.ratio'
	
	appendFileLine: folder$ + "/" + txtName$ + ".txt", .center_gravity$, tab$, .skewness$, tab$, .kurtosis$, tab$, .standard_dev$, tab$, .ratio, tab$
	removeObject: spectrum
	
selectObject: "Sound fricative", "Sound fricative_band"
	Remove
endproc
