clear all
cls
		   * Master File *

/************************************
Seyed Mohammad Mahdi Hosseini Gohar
				Divar
			Winter 1400
*************************************/

//libraries
*ssc install dataex
*ssc install binscatter
*ssc install grstyle
*ssc install palettes
*ssc install labutil2

// Project Folder Globals
global dirc "D:\Divar"

// Changing Directory
cd $dirc

// Sub Codes
do $dirc\code\DATA_CLEANING.do

do $dirc\code\NofT.do

do $dirc\code\Growth_NofT.do

do $dirc\code\NofT_line.do

do $dirc\code\NofT_Seasonal.do

do $dirc\code\avg_price2_SC_EXteh.do

do $dirc\code\Growth_avg_price2_SC_EXteh.do

do $dirc\code\ave_pri_9798_TEH_dist.do

do $dirc\code\Growth_ave_pri_9798_TEH_dist.do

do $dirc\code\avg_pr2_line.do

do $dirc\code\Age_table.do

do $dirc\code\OTHER_daily.do

do $dirc\code\teh2kol.do
