clear all
cls

// Data Loading
use $dirc\Data\DATA.dta

drop if province== "تهران" // Exclude Tehran

// Generating Required variables
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S

// Calculate the weighted average of transaction prices in provinces except Tehran
// Weighting based on the share of living in a given area of the apartment
collapse (mean) ave_p2 = pr2 [pw=w] , by(YS2)

// Required cleaning
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname , nogen
labmask a, values(seas_name)
drop seas_name YS2

// Plotting and Saving Graphs
twoway (line ave_p2 a, lcolor("128 28 28") lwidth(medthick)), ytitle(هزار ریال) ytitle(, size(medlarge)) ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\avg_pr2_kol_Exteh.png ,replace

// setting time series for calculating inflation
gen t = _n
tsset t

// calculating inflation
gen inf_kol_ex_teh_seasonal = (D.ave_p2 / L.ave_p2)*100

// Plotting and Saving Graphs
twoway (line inf_kol_ex_teh_seasonal a, lcolor("128 28 28") lwidth(medthick)), ytitle(درصد) ytitle(, size(medlarge)) ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\inf_kol_ex_teh_seasonal.png ,replace

************

clear all
cls

// Data Loading
use $dirc\Data\DATA.dta

// Selecting Selected Cities
gen t =.
	local selected_city "کرج تبریز مشهد اصفهان شیراز قم اهواز کرمانشاه ري پاكدشت کمالشهر رشت قزوین همدان محمدشهر بندرعباس كرمانشاه قزوين شيراز"
	foreach i of local selected_city{
	replace t = 1 if city=="`i'"
	}
drop if t !=1

// Generating Required variables
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S

// Calculate the weighted average of transaction prices in selected cities
// Weighting based on the share of living in a given area of the apartment
collapse (mean) ave_p2 = pr2 [pw=w] , by(YS2 )

// Required cleaning
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname , nogen
labmask a, values(seas_name)
drop seas_name YS2

// Plotting and Saving Graphs
twoway (line ave_p2 a, lcolor("128 28 28") lwidth(medthick)), ytitle(هزار ریال) ytitle(, size(medlarge)) ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\avg_pr2_SC.png ,replace

*************
clear all
cls

//Loading Data
use $dirc\Data\DATA.dta
keep if province== "تهران" //keeping Tehran

// Generating Required variables
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S

// Calculate the weighted average of transaction prices in Tehran
// Weighting based on the share of population in a given district of Tehran
collapse (mean) ave_p2 = pr2 [pw=w_dist] , by(YS2 )

// Required cleaning
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname , nogen
labmask a, values(seas_name)
drop seas_name YS2

// Plotting and Saving Graphs
twoway (line ave_p2 a, lcolor("128 28 28") lwidth(medthick)), ytitle(هزار ریال) ytitle(, size(medlarge)) ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\avg_pr2_TEH.png ,replace

// setting time series for calculating inflation
gen t = _n
tsset t

// calculating inflation
gen inf_teh_seasonal = (D.ave_p2 / L.ave_p2)*100

// Plotting and Saving Graphs
twoway (line inf_teh_seasonal a, lcolor("128 28 28") lwidth(medthick)), ytitle(درصد) ytitle(, size(medlarge)) ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\inf_teh_seasonal.png ,replace