clear all
cls

// Counting the number of transactions over the provinces in 97 and 98 
foreach Y in 97 98{
	tempfile Nex_`Y'
	quietly save `Nex_`Y'', emptyok
	use $dirc\Data\DATA, clear
	keep if (year == "`Y'")
	collapse (count) N_`Y'=pr2 , by(province)
	quietly save `Nex_`Y'', replace
}

merge 1:1 province using `Nex_97', nogen

drop if N_97==.
drop if N_98==.
encode province, gen (province_num)
keep province_num N_97 N_98 
label variable N_98 "معاملات سال 98"
label variable N_97 "معاملات سال 97"

save $dirc\Data\NofT, replace

// Plotting and Saving Graphs
*********************
drop if (province ==8 |province ==5)

graph bar (asis) N_98 N_97, over(province_num, label(angle(forty_five))) ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(av_price_9798, replace) graphregion(fcolor("243 203 203")) bar(1, fcolor("138 36 36") lcolor(none%0)) bar(2, fcolor("248 172 84") lcolor(none%0))
graph export $dirc\pic\NofT_EX_teh_and_alb.png ,replace
 
**********************
use $dirc\Data\NofT, replace
keep if (province ==8 |province ==5)

graph bar (asis) N_98 N_97, over(province_num) ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(av_price_9798, replace) graphregion(fcolor("243 203 203")) bar(1, fcolor("138 36 36") lcolor(none%0)) bar(2, fcolor("248 172 84") lcolor(none%0))
graph export $dirc\pic\NofT_teh_and_alb.png ,replace
 