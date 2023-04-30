clear all
cls

// Changing Directory
use $dirc\Data\DATA.dta

// Counting the number of transactions over the provinces except for Tehran
drop if province == "تهران" //Exclude Tehran
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S
collapse (count) N = lifetime  , by(YS2)
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname.dta , nogen
labmask a, values(seas_name)
drop seas_name YS2

// Plotting and Saving Graph
twoway (line N a, lcolor("128 28 28") lwidth(medthick)), ytitle("")  ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\NofT_EX_teh_line.png ,replace

// Data Loading
use $dirc\Data\DATA.dta ,clear

// Counting the number of transactions in Tehran
keep if province == "تهران" //Keeping Tehran
gen NAME = season + "" + year
gen YS2 ="13" +year + "-" +S
collapse (count) N = lifetime  , by(YS2 )
gen a = _n
merge 1:1 a using http://gsme.sharif.edu/~smm.hosseinigohar/data/Sname.dta , nogen
labmask a, values(seas_name)

// Plotting and Saving Graph
twoway (line N a, lcolor("128 28 28") lwidth(medthick)), ytitle("")  ylabel(, angle(horizontal) format(%9.0gc)) xtitle(, color(%0)) xlabel(#16, labels angle(forty_five) format(%12s) valuelabel) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) name(number_of_trans, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\NofT_teh_line.png ,replace
