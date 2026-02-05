* HW 1
* Economic Forecasting Spring 2026
* Started: 05 January 2026
* Updated: 05 January 2026

*This is your first homework assignment. It focuses on plotting in the ways we already did in class. For the North Dakota data I would like you to:

*1. Create a time series plot the *not seasonally adjusted* employment data.
*2. Create a time series plot of both the *not seasonally adjusted* employment data and the seasonally adjusted employment data on the same chart.
*3. Create a season plot of the *not seasonally adjusted* unemployment data.
*4. Create a subseason plot, sometimes called a cycle plot for the *not seasonally adjusted* unemployment data. 

*To aid you in these efforts I provide the following download and data preparation commands to allow you to worry about creating the necessary plots. 


* Bring in the data
import delimited https://raw.githubusercontent.com/flynnecon/forecasting-2026/refs/heads/main/data/ndlf.csv, clear

* Create the date file
gen date = tm(1976m1) + _n-1 
format date %tm
tsset date
