clear all
cls

// Data Loading
use $dirc\Data\DATA.dta

// Plotting and Saving Graph
graph bar (count), over(day, label(labsize(minuscule))) over(month) ytitle("") ylabel(, angle(horizontal)) by(, note(منبع: وزارت راه و شهرسازی ج‌ا ایران)) by(, graphregion(fcolor("243 203 203"))) by(year)
graph export $dirc\pic\daily95_98.png ,replace

// Plotting and Saving Graph (for 98)
keep if year =="98"
graph bar (count), over(day, label(labcolor("black") labsize(minuscule))) over(month) bar(1, fcolor(red)) bar(2, fcolor(red)) bar(3, fcolor(red)) bar(4, fcolor(red)) bar(5, fcolor(red)) bar(6, fcolor(red)) bar(7, fcolor(red)) bar(8, fcolor(red)) bar(9, fcolor(red)) bar(10, fcolor(red)) bar(11, fcolor(red)) bar(12, fcolor(red)) bar(13 ,fcolor(red)) bar(14, fcolor(red)) bar(15, fcolor(red)) ytitle("") ytitle(, orientation(horizontal)) ylabel(, angle(horizontal)) note(منبع: وزارت راه و شهرسازی ج‌ا ایران) graphregion(fcolor("243 203 203"))
graph export $dirc\pic\daily98.png ,replace