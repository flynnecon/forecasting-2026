* First graphics file
* Economic Forecasting Spring 2026
* Started: 22 January 2026
* Updated: 22 January 2026

* Read in the data from Flynn's github site

import delimited https://raw.githubusercontent.com/flynnecon/forecasting-2026/refs/heads/main/data/RSXFS.csv, clear

* Let's fix the date. You can do this with commands to adjust the date that was read in. I find this to often be tedious and you have to know the frequency and that there are no issues. If I know the frequency I can make a new date like I do here. 

gen date = tm(1992m1) + _n-1 
format date %tm

* To make use of the data as a time series and make use of Stata commands designed for that data I set the data appropriately. 

tsset date

* Now I have the ability to make use of the simple time series graph command for a line:

tsline rsxfs, name(simple_retail_1, replace)

*Note that I could do this already though with:

twoway line rsxfs date, name(simple_retail_2,replace)

* One of the reasons to use the tsset command is to allow the use of differencing right away in the line of code. 

tsline d.rsxfs, name(retail_first_difference, replace)

* If I want something more complicated like percentage changes I might want to create the data first:
gen retail_pc = 100*(d.rsxfs/l.rsxfs)
tsline retail_pc, name(retail_percentage_change, replace)