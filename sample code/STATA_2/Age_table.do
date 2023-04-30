clear all
cls

// Calculate the number of transactions for apartments with different lifetimes (Except Tehran)
foreach Y in 97 98{
	tempfile Nex_`Y'
	quietly save `Nex_`Y'', emptyok
	use $dirc\Data\DATA, clear
	keep if (year == "`Y'" )
	drop if (city == "تهران")
	gen AGE = 1
	replace AGE = 2 if lifetime > 5
	replace AGE = 3 if lifetime > 10
	replace AGE = 4 if lifetime > 15
	replace AGE = 5 if lifetime > 20
	collapse (count) N_`Y'=lifetime  , by(AGE)
	quietly save `Nex_`Y'', replace
}

// Required cleaning and labeling
merge 1:1 AGE using `Nex_97', nogen
label define agelab 1 "< 5" 2 "6 - 10" 3 "11 - 15" 4 "15 - 20" 5 "> 20"
label values AGE agelab
drop if N_97==.
drop if N_98==.
label variable AGE "سن بنا"
label variable N_98 "تعداد معاملات سال 98"
label variable N_97 "تعداد معاملات سال 97"

// Saveing results in excel file
export excel using "$dirc\pic\Age_table_EXteh", firstrow(varlabels) replace


clear all
cls

// Calculate the number of transactions for apartments with different lifetimes (Only Tehran)
foreach Y in 97 98{
	tempfile Nex_`Y'
	quietly save `Nex_`Y'', emptyok
	use $dirc\Data\DATA, clear
	keep if (year == "`Y'" )
	keep if (city == "تهران")
	gen AGE = 1
	replace AGE = 2 if lifetime > 5
	replace AGE = 3 if lifetime > 10
	replace AGE = 4 if lifetime > 15
	replace AGE = 5 if lifetime > 20
	collapse (count) N_`Y'=lifetime  , by(AGE)
	quietly save `Nex_`Y'', replace
}

// Required cleaning and labeling
merge 1:1 AGE using `Nex_97', nogen
label define agelab 1 "< 5" 2 "6 - 10" 3 "11 - 15" 4 "15 - 20" 5 "> 20"
label values AGE agelab
drop if N_97==.
drop if N_98==.
label variable AGE "سن بنا"
label variable N_98 "تعداد معاملات سال 98"
label variable N_97 "تعداد معاملات سال 97"

// Saveing results in excel file
export excel using "$dirc\pic\Age_table_tehran", firstrow(varlabels) replace

