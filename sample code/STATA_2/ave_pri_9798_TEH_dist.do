clear all
cls

// Calculate the weighted average of transaction prices in Tehran
// Weighting based on the share of population in a given district of Tehran
foreach Y in 97 98{
	tempfile ave_pri_9798_TEH_`Y'
	quietly save `ave_pri_9798_TEH_`Y'', emptyok
	use $dirc\Data\DATA, clear
	keep if (year == "`Y'")
	keep if (city == "ري" | city == "تهران")
	collapse (mean) ave_pr2_`Y'=pr2  [pw=w_dist], by(district)
	quietly save `ave_pri_9798_TEH_`Y'', replace
}

// Required cleaning and labeling
merge 1:1 district using `ave_pri_9798_TEH_97', nogen
drop if ave_pr2_97==.
drop if ave_pr2_98==.
label variable ave_pr2_98 "میانگین سال 98"
label variable ave_pr2_97 "میانگین سال 97"

// Plotting and Saving Graphs
graph bar (asis) ave_pr2_98 ave_pr2_97, over(district, label(angle(forty_five))) ytitle(هزار ریال) ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(av_price_9798, replace) graphregion(fcolor("243 203 203")) bar(1, fcolor("138 36 36") lcolor(none%0)) bar(2, fcolor("248 172 84") lcolor(none%0))
graph export $dirc\pic\ave_pri_9798_TEH_dist.png ,replace

// Saving Data
save $dirc\Data\ave_pri_9798_TEH_dist ,replace

