clear all
cls

// Counting the number of transactions over the seasons in 97 and 98 
foreach Y in 97 98{
	tempfile Nex_`Y'
	quietly save `Nex_`Y'', emptyok
	use $dirc\Data\DATA, clear
	keep if (year == "`Y'")
	collapse (count) N_`Y'=pr2 , by(S)
	quietly save `Nex_`Y'', replace
}

// Required cleaning 
merge 1:1 S using `Nex_97', nogen
drop if N_97==.
drop if N_98==.
keep S N_97 N_98 
label variable N_98 "معاملات سال 98"
label variable N_97 "معاملات سال 97"

// Plotting and Saving Graphs
graph bar (asis) N_98 N_97, over(S, relabel(1 "بهار" 2 "تابستان" 3 "پاییز" 4 "زمستان")) ytitle("") ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(av_price_9798, replace) graphregion(fcolor("243 203 203")) bar(1, fcolor("138 36 36") lcolor(none%0)) bar(2, fcolor("248 172 84") lcolor(none%0)) 
graph export $dirc\pic\NofT_Seasonal.png ,replace
