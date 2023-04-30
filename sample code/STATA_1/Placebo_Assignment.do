

use "main_data.dta",clear


// Random assignment of 7 provinces to ETS and non ETS
keep province

 duplicates drop province ,force
 


forvalue r = 1/500 {

 generate Prov_rannum = uniform()
egen ETS`r' = cut(Prov_rannum), group(5)

drop  Prov_rannum
replace  ETS`r' = 0 if  ETS`r'<4 

replace  ETS`r' =1 if  ETS`r'==4 

}
save "random_Province.dta",replace

// Random assignment of 12 Industry code to Covered and not-covered


use "AEA_P-P_table.dta", clear
rename  Nindnme Sector
rename Nnindcd Industy_Code
rename Ind Covered
rename region ETS

keep Industy_Code

 duplicates drop Industy_Code ,force
 
 forvalue r = 1/500 {

 generate Sector_rannum = uniform()
egen Sector`r' = cut(Sector_rannum), group(3)

drop  Sector_rannum
replace  Sector`r' = 0 if  Sector`r'<2 

replace  Sector`r' =1 if  Sector`r'==2 

}
save "random_Sector.dta",replace
 
