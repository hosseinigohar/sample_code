/*--------------------------------------------------------------
Master file:
			
			  Econometrics I Final Project
			
			Carbon Pricing Induces Innovation:
	Evidence from China’s Regional Carbon Market Pilots
			
			Hosseini Gohar - Hosseini Masoum
				99203047   -	99202534
				
					Summer 1400
---------------------------------------------------------------*/
cls
clear all

	macro def maindir "D:\SUT_ECO\2\Econometrics1_Vesal\Project\PROJECT\code"

	// Change directory: (where Data.dta and codes exist)
	cd "${maindir}"
	
	/*
	//Make needed directory (CAUTION?!:ONE TIME)
	mkdir ${maindir}\plots
	mkdir ${maindir}\docs
	mkdir ${maindir}\excel
	mkdir ${maindir}\word
	*/
	
	//Cleaning
	do Cleaning.do
	
	//Describe the Data
	do Descriptive.do
	
	//Regression
	do main.do
	
	//Placebo Test
	do Placebo.do

