clear
use "main_data.dta", clear


xtset id year
sort id year


  /*----------------------------------------------------------------------------------------------------------------
  
									Simple Difference in Differences
 
 -----------------------------------------------------------------------------------------------------------  */
 
gen treat=Covered*ETS
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y'    c.treat#c.post  $control i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	 outreg2 using Table_Results7.xls, nocons excel ctitle("DiffInDiff")  sortvar(c.Covered#c.ETS#c.post c.treat#c.post )keep(c.treat#c.post) dec(3) addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
	outreg2 using DiffInDiff.doc, nocons  ctitle("DiffInDiff")  keep(c.treat#c.post) dec(3) addtext(Dependent Variable, `Y')
	
	asdoc test c.treat#c.post, save(test.doc) 
	
	}
 
 /*----------------------------------------------------------------------------------------------------------------
 
	Dropiong Industries Which are covered by ETS in some Provinces and  not Covered in some other provinces
 -----------------------------------------------------------------------------------------------------------  */
 
	 // droping Sectors wich are Constant over Provinces
 egen MCovered=mean(Covered) , by (Industy_Code province) 
 drop if MCovered >0 & MCovered <1



 // keeping Sectors wich are Constant always
 egen MCovered1=mean(Covered) , by (Industy_Code) 
 drop if MCovered1 >0 & MCovered1 <1 
  /*----------------------------------------------------------------------------------------------------------------
  
                               Results for various Dependent variables
  ---------------------------------------------------------------------------------------------------------------*/
 
 

// base line model, All dependent Variables
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y'  c.Covered#c.post  c.ETS#c.post  Coverd_ETS_post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror) 
	
	  outreg2 using Table_Results7,nocons excel ctitle("Main Model") label  keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
	outreg2 using baseModel.doc,  nocons ctitle("`Y'") label keep(Coverd_ETS_post) dec(3) 
	
	asdoc test Coverd_ETS_post, save(test.doc) append
	     
	}
	
	
/*----------------------------------------------------------------------------------------------------------------
  
                     Results for EnvrAEW_ratio, Effect of adding Controls and linear year trends
  ---------------------------------------------------------------------------------------------------------------*/	
	// jsut DDD
	
	quietly xi: xtreg  envrAEW_ratio c.Covered#c.post  c.ETS#c.post  Coverd_ETS_post i.year , fe vce(cluster stderror)
	 
	 outreg2 using Table_Results7.xls,nocons excel ctitle("Reduced 1") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, envrAEW_ratio, Control, No, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, No, Industry-Year linear trend, No)
	
	 outreg2 using Reduced1.doc,nocons ctitle("envrAEW_ratio")  label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext( Control, No, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, No, Industry-Year linear trend, No)
	
//---------------------------------------------------------------------------------------------------------	
	
	
	// DDD + Controls
	quietly xi: xtreg envrAEW_ratio  c.Covered#c.post  c.ETS#c.post  Coverd_ETS_post $control , fe vce(cluster stderror)
	  outreg2 using Table_Results7.xls, nocons excel ctitle("Reduced 2") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, envrAEW_ratio, Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, No, Industry-Year linear trend, No)
	
	
	 outreg2 using Reduced1.doc,nocons  ctitle("envrAEW_ratio") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext( Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, No, Industry-Year linear trend, No)
	 
//--------------------------------------------------------------------------------------------------------- 
	 
	 //DDD + controls + Province-year linear trend
	quietly xi: xtreg envrAEW_ratio  c.Covered#c.post  c.ETS#c.post Coverd_ETS_post $control i.year i.province|period , fe vce(cluster stderror) 
	  outreg2 using Table_Results7.xls,nocons excel ctitle("Reduced 3") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, envrAEW_ratio, Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, No)

	outreg2 using Reduced1.doc, nocons  ctitle("envrAEW_ratio") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext( Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, No)

//---------------------------------------------------------------------------------------------------------

	// all control and linear trends
	
	quietly xi: xtreg envrAEW_ratio  c.Covered#c.post  c.ETS#c.post  Coverd_ETS_post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	 outreg2 using Reduced1.doc, nocons  ctitle("envrAEW_ratio") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext( Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	  asdoc test $control, save(test.doc) append
	 
	 

/*----------------------------------------------------------------------------------------------------------------
  
          Instead of a Pre and Post analysis, Each year dummy is interacted with "ETS" and "Covered" Varibles
  ---------------------------------------------------------------------------------------------------------------*/
	
	
	 // Each year effect
	
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y'    c.Covered#i.year  c.ETS#i.year  c.Covered#c.ETS#i.year $control i.year  i.province|period i.Sector|period, fe vce(cluster stderror)
	  outreg2 using Table_Results7.xls, nocons excel ctitle(" `Y'") sortvar(Coverd_ETS_post c.treat#c.post c.Covered#c.ETS#i.year) keep(c.Covered#c.ETS#i.year) dec(3) /*
	*/ addtext(Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
	outreg2 using EachYear.doc, nocons  ctitle(" `Y' ") title("Effect on Each year") label keep(c.Covered#c.ETS#i.year) dec(3) 
	 
	coefplot ,keep(*#*#*)  recast(line) vertical ciopts(recast(rconnected)) name(`Y', replace) xlabel( 1 "2004" 2 "2005" 3 "2006" 4 "2007" 5 "2008" 6 "2009" 7 "2010" 8 "2011" 9 "2012" 10 "2013" 11 "2014" 12 "2015", angle(45)) ylabel(, angle(0)) title(`Y')
	graph export duflo_`Y'.png, replace
	}
	 
	 

/*----------------------------------------------------------------------------------------------------------------
  
                                  Price And Turnover Effects 
  ---------------------------------------------------------------------------------------------------------------*/

// Price

foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y' c.Covered##c.price $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	  outreg2 using Table_Results7.xls, nocons excel ctitle("Price Effect ") sortvar(Coverd_ETS_post c.treat#c.post c.Covered##c.price ) keep(c.Covered##c.price) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
	
	  outreg2 using Price_Turnover.doc, nocons ctitle("`Y' ") keep(c.Covered##c.price) dec(3)
	  
}
	
//---------------------------------------------------------------------------------------------------------

//Turnover	

foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y' c.Covered##c.turnover $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)

	  outreg2 using Table_Results7.xls, nocons excel ctitle(" Turnover Effect ") sortvar(Coverd_ETS_post c.treat#c.post c.Covered##c.turnover) keep(c.Covered##c.turnover) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
		  outreg2 using Price_Turnover.doc, nocons ctitle("`Y' ") keep(c.Covered##c.turnover) dec(3)

	 
}



/*----------------------------------------------------------------------------------------------------------------
  
                                  Robustness Checks: Narrowing Patent Definition 
  ---------------------------------------------------------------------------------------------------------------*/
	
	
	// Robustness Check
	
		// main regression
	foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y'  c.Covered#c.post  c.ETS#c.post  Coverd_ETS_post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror)
   outreg2 using Table_Results7.xls, nocons excel ctitle("Robustness Check, Dep var") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
		  outreg2 using RobustMain.doc, nocons ctitle("`Y' ")  label keep(Coverd_ETS_post) dec(3)

	 
 
 }
	
//-------------------------------------------price and turnover effect------------------------------------
		// price  effect
	foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y' c.Covered##c.price $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	

	  outreg2 using Table_Results7.xls, nocons excel ctitle("Robustness Check, Price") sortvar(Coverd_ETS_post c.treat#c.post c.Covered##c.price )  keep(c.Covered##c.price) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	 
	 		  outreg2 using RobustPriceTurnover.doc, nocons ctitle("`Y' ")   keep(c.Covered##c.price ) dec(3)

	 
}

// Turnover  effect
 
 foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y' c.Covered##c.turnover $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	 
	  outreg2 using Table_Results7.xls,nocons excel ctitle("Robustness Check, Turnover") sortvar(Coverd_ETS_post  c.treat#c.post c.Covered##c.turnover )  keep(c.Covered##c.turnover) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
 outreg2 using RobustPriceTurnover.doc, nocons ctitle("`Y' ")   keep(c.Covered##c.turnover ) dec(3)

	 
}




/*-------------------------------------------Replication-----------------------------------------------------------


                          This Part mainly replicates the tables of the original paper,  in all of the 
						  regressions below, the variable "Covered" is problematic. Covered Industries must be
						  analogous across all provinces, but this is not the case in reality, See the Report
						  (PDF)for more discussion.


--------------------------------------------------------------------------------------------------------------*/



clear
use "main_data.dta"

xtset id year
sort id year

 
/*----------------------------------------------------------------------------------------------------------------
  
				Replicating Table 1 in the reference Paper
  ---------------------------------------------------------------------------------------------------------------*/
// base line model
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y'  c.Covered#c.post  c.ETS#c.post  Coverd_ETS_post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror) 
	 
	  outreg2 using Table_Results7,nocons excel ctitle("Main Model") label  keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
		outreg2 using baseModelProblem.doc,  nocons ctitle("`Y'") label keep(Coverd_ETS_post) dec(3) 

	}
	

	/*----------------------------------------------------------------------------------------------------------------
  
                    Replicating Table 2 in the reference Paper
  ---------------------------------------------------------------------------------------------------------------*/
	

// Price Effect

foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y' c.Covered##c.price $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	  outreg2 using Table_Results7.xls, excel nocons ctitle("Price Effect ") sortvar(Coverd_ETS_post c.treat#c.post c.Covered##c.price ) keep(c.Covered##c.price) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
		  outreg2 using Price_TurnoverProblem.doc, nocons ctitle("`Y' ") keep(c.Covered##c.price) dec(3)

	 
}
	
//-----------------------------------------------------------------------------------------------------

	
// Turnover Effect

foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y' c.Covered##c.turnover $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)

	  outreg2 using Table_Results7.xls, nocons excel ctitle(" Turnover Effect ") sortvar(Coverd_ETS_post c.treat#c.post c.Covered##c.turnover) keep(c.Covered##c.turnover) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
	 outreg2 using Price_TurnoverProblem.doc, nocons ctitle("`Y' ") keep(c.Covered##c.turnover) dec(3)

}
	
	
		/*----------------------------------------------------------------------------------------------------------------
  
                    Replicating Table A.2 in the reference Paper Appendix
  ---------------------------------------------------------------------------------------------------------------*/
	
	// Robustness Check
	
		// main regression
	foreach Y of varlist $dep_altvar {
	quietly xi: xtreg logenvrAEW  c.Covered#c.post  c.ETS#c.post  c.Covered#c.ETS#c.post $control i.year i.province|period i.Sector|period, fe vce(cluster stderror)
   outreg2 using Table_Results7.xls, nocons excel ctitle("Robustness Check, Dep var") label keep(Coverd_ETS_post) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	 		  outreg2 using RobustProblem.doc, nocons ctitle("`Y' ")  label keep(Coverd_ETS_post) dec(3)

 
 }
	
	//----------------------------------------------------------------------------------------------------------
	
		// price effect
	foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y' c.Covered##c.price $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	
	  outreg2 using Table_Results7.xls, nocons excel ctitle("Robustness Check, Price") sortvar(Coverd_ETS_post c.treat#c.post c.Covered##c.price )  keep(c.Covered##c.price) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
		 outreg2 using RobustProblem.doc, nocons ctitle("`Y' ")   keep(c.Covered##c.price ) dec(3)

	 
}

 	//----------------------------------------------------------------------------------------------------------
		// Turnover effect

 foreach Y of varlist $dep_altvar {
	quietly xi: xtreg `Y' c.Covered##c.turnover $control /*
	*/ i.year i.province|period i.Sector|period, fe vce(cluster stderror)
	 
	  outreg2 using Table_Results7.xls, nocons excel ctitle("Robustness Check, Turnover") sortvar(Coverd_ETS_post  c.treat#c.post c.Covered##c.turnover )  keep(c.Covered##c.turnover) dec(3) /*
	*/ addtext(Dependent Variable, `Y',Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	 
	  outreg2 using RobustProblem.doc, nocons ctitle("`Y' ")   keep(c.Covered##c.turnover ) dec(3)

}



/*----------------------------------------------------------------------------------------------------------------
  
          Instead of a Pre and Post analysis, Each year dummy is interacted with "ETS" and "Covered" Varibles
  ---------------------------------------------------------------------------------------------------------------*/
	
	
	 // Each year effect
	
foreach Y of varlist $dep_var {
	quietly xi: xtreg `Y'    c.Covered#i.year  c.ETS#i.year  c.Covered#c.ETS#i.year $control i.year  i.province|period i.Sector|period, fe vce(cluster stderror)
	  outreg2 using Table_Results7.xls, nocons excel ctitle("P each year") sortvar(Coverd_ETS_post c.treat#c.post c.Covered#c.ETS#i.year) keep(c.Covered#c.ETS#i.year) dec(3) /*
	*/ addtext(Control, Yes, Firm FE, Yes, Year FE, Yes, Province-Year linear trend, Yes, Industry-Year linear trend, Yes)
	
	}
	 
	 




