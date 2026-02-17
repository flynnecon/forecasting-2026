* Initial Decompositions
* Economic Forecasting 2026
* Started: 03 February 2026
* Updated: 03 February 2026

import delimited https://raw.githubusercontent.com/flynnecon/forecasting-2026/refs/heads/main/data/us_house_prices.csv, clear

gen date = tm(1987m1) + _n-1
format date %tm
tsset date

tsline csus_nsa csus_sa

gen day = dofm(date)
format day %td
gen year = yofd(day)
gen month = month(day)

gen pc_csus_nsa = 100*d.csus_nsa/l.csus_nsa
gen pc_csus_sa = 100*d.csus_sa/l.csus_sa

tsline pc_*

ucm pc_csus_nsa, model(strend) seasonal(12)
predict smooth_trend, trend
predict seasonal_s, seasonal

* Creating our forecasts using the forecast methods
* Preliminary items we need to create our forecast. 

gen obs = _n 
qui summarize(obs)
qui scalar end = r(max)
tsappend, add(36)

* Create the mean forecast, graph it, and then replace it in the graph.
egen fcstmean = mean(pc_csus_sa)
tsline pc_csus_sa fcstmean
replace fcstmean = pc_csus_sa if _n < scalar(end)
* An alternative to this replacement is to get rid of values from before the end of the data set, that is to replace with a period (.)

* Graphing the mean forecast and the actual value
tsline pc_csus_sa fcstmean
tsline fcstmean pc_csus_sa


* The naive forecast is the last value is the forecast going forward. 

gen fcstnaive = pc_csus_sa
replace fcstnaive = pc_csus_sa[scalar(end)] if fcstnaive == .
tsline fcstnaive, saving(fcstnaive, replace)

* The seasonally naive forecast. This is one you would use only if there was seasonality in the data. I know that seems obvious but sometimes you just do not think it through until you make that mistake.

gen fcstseasnaive = pc_csus_nsa
replace fcstseasnaive = pc_csus_nsa[_n-12] if fcstseasnaive == .
tsline fcstseasnaive, saving(fcstseasnaive, replace)

* This one works because of the way we set up the code, but understand there are possibly situaitons where this code would not work. 

*Drift method - over the entire time frame

gen fcstdrift = pc_csus_sa
replace fcstdrift = fcstdrift[_n-1] + ((pc_csus_sa[scalar(end)] - pc_csus_sa[1])/(obs[scalar(end)]-obs[1])) if fcstdrift == .
tsline fcstdrift, saving(fcstdrift, replace)
*Selection of the time frame can be very crucial in the performance of a drift forecast.

