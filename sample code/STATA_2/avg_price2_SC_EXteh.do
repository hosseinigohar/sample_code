clear all
cls

// Calculate the weighted average of transaction prices in selected cities
// Weighting based on the share of living in a given area of the apartment
foreach Y in 97 98{
	tempfile ave_pri_9798_SC_`Y'
	quietly save `ave_pri_9798_SC_`Y'', emptyok
	use $dirc\Data\DATA, clear
	keep if (year == "`Y'")
	gen t =.
	local selected_city "کرج تبریز مشهد اصفهان شیراز قم اهواز کرمانشاه ري پاكدشت کمالشهر رشت قزوین همدان محمدشهر بندرعباس كرمانشاه قزوين شيراز"
	foreach i of local selected_city{
		replace t = 1 if city=="`i'"
		}
	drop if t !=1
	collapse (mean) ave_pr2_`Y'=pr2  [pw=w], by(city)
	quietly save `ave_pri_9798_SC_`Y'', replace
}

// Required cleaning 
merge 1:1 city using `ave_pri_9798_SC_97', nogen
drop if ave_pr2_97==.
drop if ave_pr2_98==.
encode city, gen (city_num)
keep city_num ave_pr2_97 ave_pr2_98 
label variable ave_pr2_98 "میانگین سال 98"
label variable ave_pr2_97 "میانگین سال 97"

// Plotting and Saving Graphs
graph bar (asis) ave_pr2_98 ave_pr2_97, over(city_num, label(angle(forty_five))) ytitle(هزار ریال) ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(av_price_9798, replace) graphregion(fcolor("243 203 203")) bar(1, fcolor("138 36 36") lcolor(none%0)) bar(2, fcolor("248 172 84") lcolor(none%0))
graph export $dirc\pic\avg_price2_SC_EXteh.png ,replace

// Saving Data
save $dirc\Data\avg_price2_SC_EXteh, replace

