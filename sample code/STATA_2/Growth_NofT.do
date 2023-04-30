clear all
cls

// Changing Directory
use $dirc\Data\NofT, replace

// Calculating the Growth of Transactions
gen g_rate = ((N_98 - N_97)/(N_97))*100

// Plotting and Saving Graphs
graph bar (asis) g_rate, over(province_num, label(angle(forty_five))) bar(1, fcolor("138 36 36") lcolor(none%0)) ytitle(درصد) ylabel(, angle(horizontal) format(%9.0gc)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران, color(black)) legend(size(small) linegap(small)) name(g_rate_9798, replace) graphregion(fcolor("243 203 203"))

graph export $dirc\pic\Growth_NofT.png ,replace

