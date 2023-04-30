clear all
cls

// Data Loading
use $dirc\Data\avg_price2_SC_EXteh, clear

// Calculating the Growth of prices
gen g_rate = ((ave_pr2_98 - ave_pr2_97)/(ave_pr2_97))*100

// Plotting and Saving Graph
graph bar (asis) g_rate, over(city_num, label(angle(forty_five))) bar(1, fcolor("138 36 36") lcolor(none%0)) ytitle(درصد) ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(g_rate_9798, replace) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\Growth_avg_price2_SC_EXteh.png ,replace
