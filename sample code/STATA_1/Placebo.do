
/*---------------------------------------------------------------------------------------------------------------
						
						Conducting Placebo Tests, Randomly Assigning ETS Provinces And Covered Sectors

----------------------------------------------------------------------------------------------------------------*/

// do Placebo_Assignment.do


/*



 //Placebo Tests 

joinby province using  random_Province.dta
joinby Industy_Code using random_Sector.dta


gen Covered_random = 0
gen ETS_random = 0

// Re-run baseline DDD model
forvalue r = 1/100 {
replace Covered_random = Sector`r'
replace ETS_random = ETS`r'
quietly xi:  xtreg envrAEW_ratio  c.Covered_random#c.post  c.ETS_random#c.post  c.Covered_random#c.ETS_random#c.post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror)
outreg2  using PlaceboOurs.xls, pvalue nocons  keep(c.Covered_random#c.ETS_random#c.post)
 }

 */
 
import excel "our_placebo_data.xlsx", sheet("Sheet1") firstrow clear
 
 
replace Coef = subinstr(Coef,"*","",.)
replace Pval = subinstr(Pval,")","",.)
replace Pval = subinstr(Pval,"(","",.)


destring Coef , replace
destring Pval , replace

# delimit ; 

twoway (kdensity Coef, yaxis(1)) || (scatter   Pval Coef, yaxis(2)) ||, xline(0.028) name("placebo_logenvrAEW", replace)
legend (label(1 "Coefficient") label(2 "P-Value"))
xtitle("Coefficient")
ytitle("Density", axis(1))
ytitle("P-Value", axis(2));
# delimit cr

graph export placebo_envrAEW_ratio.png, replace



/*---------------------------------------------------------------------------------------------------------------
						
						Conducting Placebo Tests, Randomly Assigning ETS Provinces And Covered Sectors

----------------------------------------------------------------------------------------------------------------*/
/*

 //Placebo Tests 

joinby province using  random_Province.dta
joinby Industy_Code using random_Sector.dta


gen Covered_random = 0
gen ETS_random = 0

// Re-run baseline DDD model
forvalue r = 1/2 {
replace Covered_random = Sector`r'
replace ETS_random = ETS`r'
quietly xi:  xtreg logenvrAEW  c.Covered_random#c.post  c.ETS_random#c.post  c.Covered_random#c.ETS_random#c.post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror)

outreg2  using Placebo_Paper.xls, nocons pvalue  keep(c.Covered_random#c.ETS_random#c.post)

}

*/

import excel "paperplacebodata.xlsx", sheet("Sheet1") firstrow clear
 
 
replace Coef = subinstr(Coef,"*","",.)
replace Pval = subinstr(Pval,")","",.)
replace Pval = subinstr(Pval,"(","",.)


destring Coef , replace
destring Pval , replace
# delimit ; 

twoway (kdensity Coef, yaxis(1)) || (scatter  Pval Coef, yaxis(2))||, xline(0.177) name("placebo_logenvrAEW", replace)
legend (label(1 "Coefficient") label(2 "P-Value"))
xtitle("Coefficient")
ytitle("Density", axis(1))
ytitle("P-Value", axis(2));
# delimit cr

graph export placebo_logenvrAEW.png , replace




















