

//histogram

foreach Y of varlist $control {
	hist `Y'	 , name (`Y' , replace)
	graph export `Y'.png, replace
	}
	
	drop if logenvrAEW==0
	drop if logNon_envrAEW==0
	drop if envrAEW_ratio==0
	
foreach Y of varlist $dep_var {
	sum `Y' 
	local m_`Y' = r(mean)
	twoway histogram `Y'  , by(ETS) xline(`m_`Y'') name(`Y', replace)
	graph export `Y'.png, replace
	}
	
		
foreach Y of varlist $dep_altvar {
	hist `Y' , by (ETS)	 name (`Y' , replace)
	graph export `Y'.png, replace
	}
	
//add histograms to excel file
putexcel set "DATAdesc.xlsx" , sheet (histogram) replace
putexcel A1=  image(t_Assets.png)
putexcel B5 = image(t_Revenue.png)
putexcel C10 =image(t_ROA.png)
putexcel D15 =image(t_EBIT.png)
putexcel E20 =image(t_CurrentLiability.png)
putexcel F25 =image(logenvrAERD.png)
putexcel G30 =image(logenvrAEW.png)
putexcel H35 =image(logNon_envrAEW.png)
putexcel I40 =image(envrAEW_ratio.png)
putexcel J45 =image(logenvrAE.png)
putexcel save

//Codebook of data (definitions)
codebookout variable_defenition.xlsx, replace

//summary statistics
tabstat logenvrAEW logNon_envrAEW envrAEW_ratio  t_Assets t_Revenue t_ROA t_CurrentLiability, stats(count mean sd min max) long f(%6.2f) c(s) by(ETS) save
mat T = r(StatTotal)'
putexcel set "DATAdesc.xlsx" , sheet (sumstat) modify
putexcel A1 = matrix(T), names
asdoc sum, save(sumstat.doc) title(\i) fhc(\b) by (ETS) replace
putexcel save

//plot for more intution about data
gen envrAEW = exp(logenvrAEW)-1
egen avg3 = mean (envrAEW_ratio ) ,by(ETS Covered year) //report
egen avg1 = mean (envrAEW ) ,by(ETS Covered year) // paper!

duplicates drop year ETS Covered  , force
drop if year==.
keep year ETS Covered avg1 avg3

twoway (line avg3 year if Covered == 1) (line avg3 year if Covered == 0, lpattern(dash_dot) lcolor(red)), by(, title("")) legend(order(1 "Covered Sectors" 2 "NonCovered Sectors")) by(ETS, note("")) ytitle("") xlabel(2003(1)2015, angle(45)) xline(2011) plotregion(color(white)) name(average_patent_by_ETS,replace)
graph export average3_patent_by_ETS.png , replace


twoway (line avg3 year if ETS == 1) (line avg3 year if ETS == 0, lpattern(dash_dot) lcolor(red)), by(, title("")) legend(order(1 "ETS" 2 "Non ETS")) by(Covered, note("")) ytitle("") xlabel(2003(1)2015, angle(45)) xline(2011) plotregion(color(white)) name(average_patent_by_Sector,replace)
graph export average3_patent_by_Sector.png , replace


twoway (line avg1 year if Covered == 1) (line avg1 year if Covered == 0, lpattern(dash_dot) lcolor(red)), by(, title("")) legend(order(1 "Covered Sectors" 2 "NonCovered Sectors")) by(ETS, note("")) ytitle("") xlabel(2003(1)2015, angle(45)) xline(2011) plotregion(color(white)) name(average_patent_by_ETS,replace)
graph export average1_patent_by_ETS.png , replace


twoway (line avg1 year if ETS == 1) (line avg1 year if ETS == 0, lpattern(dash_dot) lcolor(red)), by(, title("")) legend(order(1 "ETS" 2 "Non ETS")) by(Covered, note("")) ytitle("") xlabel(2003(1)2015, angle(45)) xline(2011) plotregion(color(white)) name(average_patent_by_Sector,replace)
graph export average1_patent_by_Sector.png , replace


putexcel set "DATAdesc.xlsx" , sheet (intution_plot) modify
putexcel A1=  image(average3_patent_by_ETS.png)
putexcel N1 = image(average3_patent_by_Sector.png)
putexcel A30 = image(average1_patent_by_ETS.png)
putexcel N30 = image(average1_patent_by_Sector.png)
putexcel save


