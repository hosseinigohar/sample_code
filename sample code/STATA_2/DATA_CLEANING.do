clear all
cls

// Changing Directory
cd $dirc\Data

// Data Aggregation 
tempfile cumulator
quietly save `cumulator', emptyok

local month "01 02 03 04 05 06 07 08 09 10 11 12"

foreach Y in 95 96 97 98{
	foreach i of local month{
		*copy http://gsme.sharif.edu/~smm.hosseinigohar/data/Iran_Maskan_koll`Y'`i'.xlsx Iran_Maskan_koll`Y'`i'.xlsx , replace
		import excel "D:\Divar\Data\Iran_Maskan_koll`Y'`i'.xlsx", sheet("Sheet1") firstrow clear
		rename (استان شهرستان منطقهشهرداری مساحت درصد قیمت قیمتیکمترمربع عمربنا نوعاسکلت تاریخثبتقرارداد کدقرارداد ) (province city district area percent price price_per_meter2 lifetime structure date contract_code)
		gen year = substr(date, 3,2)
		gen day = substr(date, 9,2)
		gen month = substr(date,6,2)
		quietly destring district area percent price price_per_meter2 lifetime contract_code , replace force
		drop if contract_code == .
		duplicates drop contract_code, force
		drop کدپستی contract_code نوعقرارداد نوعملک نوعکاربری date
		append using `cumulator', force 
		quietly save `cumulator', replace
							}
					}
					
// Data Cleaning	
drop مبلغقرضالحسنه اجارهماهانه
drop if (lifetime == .|lifetime == -1|lifetime == -2)

* Privince Number
gen prov_num = "00"
replace prov_num = "00"  if province == "مرکزی"
replace prov_num = "01"  if province == "گیلان"
replace prov_num = "02"  if province == "مازندران"
replace prov_num = "03"  if province == "آذربایجان شرقی"
replace prov_num = "04"  if province == "آذربایجان غربی"
replace prov_num = "05"  if province == "كرمانشاه"
replace prov_num = "06"  if province == "خوزستان"
replace prov_num = "07"  if province == "فارس"
replace prov_num = "08"  if province == "كرمان"
replace prov_num = "09"  if province == "خراسان رضوی"
replace prov_num = "10"  if province == "اصفهان"
replace prov_num = "11"  if province == "سيستان وبلوچستان"
replace prov_num = "12"  if province == "كردستان"
replace prov_num = "13"  if province == "همدان"
replace prov_num = "14"  if province == "چهارمحال وبختياري"
replace prov_num = "15"  if province == "لرستان"
replace prov_num = "16"  if province == "ایلام"
replace prov_num = "17"  if province == "كهگيلويه وبويراحمد"
replace prov_num = "18"  if province == "بوشهر"
replace prov_num = "19"  if province == "زنجان"
replace prov_num = "20"  if province == "سمنان"
replace prov_num = "21"  if province == "یزد"
replace prov_num = "22"  if province == "هرمزگان"
replace prov_num = "23"  if province == "تهران"
replace prov_num = "24"  if province == "اردبیل"
replace prov_num = "25"  if province == "قم"
replace prov_num = "26"  if province == "قزوین"
replace prov_num = "27"  if province == "گلستان"
replace prov_num = "28"  if province == "خراسان شمالی"
replace prov_num = "29"  if province == "خراسان جنوبی"
replace prov_num = "30"  if province == "البرز"
replace prov_num = "31"  if province == "مناطق آزاد"  
replace city = "کمالشهر" 	 if city 	 == "كمال شهر"	
replace city = "محمدشهر" 	 if city 	 == "محمد شهر"	
replace city = "بندرعباس" 	 if city 	 == "بندر عباس"	

* Area classification  
gen area_w = "1"
replace area_w = "2" if area >= 51
replace area_w = "3" if area >= 76
replace area_w = "4" if area >= 81
replace area_w = "5" if area >= 101
replace area_w = "6" if area >= 151
replace area_w = "7" if area >= 201
replace area_w = "8" if area >= 301
replace area_w = "9" if area >= 501

* Data weighting-Area 
gen key = prov_num + area_w
merge m:1 key using http://gsme.sharif.edu/~smm.hosseinigohar/data/weight.dta
keep if _merge == 3
drop _merge
destring prov_num, replace force

* Label Provinces
label define prov 00 "Markazi" 01 "Gilan" 02 "Mazandaran" 03 "Azarbayjan-E-Sharghi" 04 "Azarbayjan-E-Gharbi" 05 "Kermanshah" 06 "Khouzestan" 07 "Fars" 08 "Keramn" 09 "Khorasan-E-Razavi" 10 "Isfahan" 11 "Sistan-va-Balouchestan" 12 "Kordestan" 13 "Hamedan" 14 "Bakhtyari" 15 "Lorestan" 16 "Ilam" 17 "Kohkilouye" 18 "Boushehr" 19 "Zanjan" 20 "Semnan" 21 "Yazd" 22 "Hormozgan" 23 "Tehran" 24 "Ardabil" 25 "Qom" 26 "Qazvin" 27 "Golestan" 28 "Khorasan-E-Shomali" 29 "Khorasan-E-Jonoubi" 30 "Alborz" 31 "Mantaghe-Azad"
label values prov_num prov 

* Season Definition
gen season = "بهار"
replace season = "تابستان" if (month=="04"|month=="05"|month=="06")
replace season = "پاییز" if (month=="07"|month=="08"|month=="09")
replace season = "زمستان" if (month=="10"|month=="11"|month=="12")
 
gen S = "1"
replace S= "2" if season == "تابستان"
replace S= "3" if season == "پاییز"
replace S= "4" if season == "زمستان"

* Outlier Cleaning
gen pr2 = price/area
drop if area <=15
drop if area >=2000
drop if (pr2/price_per_meter2 > 1.05 | pr2/price_per_meter2 < 0.95)

* Data weighting-Population and TehranDistricts 
merge m:1 prov_num using http://gsme.sharif.edu/~smm.hosseinigohar/data/pop_w.dta, nogen
sort year month day
merge m:1 district using http://gsme.sharif.edu/~smm.hosseinigohar/data/w_dist_tehran.dta , nogen

* Settings
set autotabgraphs on
graph set window fontface "B Mitra"

* Saving
save DATA.dta,replace
