clear all
cls

// Data Loading
use $dirc\Data\DATA.dta , clear

// Generating Required variables
drop if city == "تهران" //exclude tehran
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S

// Calculate the weighted average of transaction prices in whole country except tehran
// Weighting based on the share of living in a given area of the apartment
collapse (mean) av_kol = pr2 [pw=w], by(YS2)

// Required cleaning
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname.dta , nogen
labmask a, values(seas_name)
drop seas_name YS2

// Saving Data
save $dirc\Data\kol.dta, replace

// Data Loading
use $dirc\Data\DATA.dta , clear  

// Generating Required variables
keep if city == "تهران" //keeping Tehran
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S

// Calculate the weighted average of transaction prices in tehran
// Weighting based on the share of population in a given district of Tehran
collapse (mean) av_teh = pr2 [pw=w_dist], by(YS2)

// Required cleaning and generating variables
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname.dta , nogen
labmask a, values(seas_name)
drop seas_name YS2
merge 1:1 a using $dirc\Data\kol.dta , nogen
gen teh2kol = av_teh / av_kol

// Plotting and Saving Graphs
twoway (line teh2kol a, lcolor("128 28 28") lwidth(medthick)), ytitle("")  ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\teh2kol.png ,replace




