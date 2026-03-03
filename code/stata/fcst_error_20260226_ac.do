* Forecast methods
* Economic Forecasting 2026
* Started: 03 February 2026
* Updated:  February 2026

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

gen pc_sa_window = pc_csus_sa if date >= tm(2000m1)
gen pc_nsa_window = pc_csus_nsa if date >= tm(2000m1)
gen pc_sa_training = pc_sa_window if date < tm(2010m1)
gen pc_nsa_training = pc_nsa_window if date < tm(2010m1)
gen pc_nsa_testing = pc_nsa_window if date >= tm(2010m1)
gen pc_sa_testing = pc_sa_window if date >= tm(2010m1)



gen obs = _n 
qui summarize(obs)
qui scalar end = r(max)
gen obs_window = _n - 156 if date >= tm(2000m1)
gen obs_training = _n - 156 if date >= tm(2000m1) & date < tm(2010m1)
gen obs_testing = _n -276 if date >= tm(2010m1)
qui summarize(obs_window)
qui scalar wind_end = r(max)
qui summarize(obs_training)
qui scalar train_end = r(max)
qui summarize(obs_testing)
qui scalar test_end = r(max)



*tsappend, add(36)


* Create the mean forecast, graph it, and then replace it in the graph.
egen fcstmean = mean(pc_sa_training)
replace fcstmean = . if date < tm(2010m1)
tsline fcstmean pc_sa_testing if date >= tm(2010m1)
gen fcerr_mean = .
replace fcerr_mean = pc_sa_testing - fcstmean

*replace fcstmean = pc_csus_sa if _n < scalar(end)
* An alternative to this replacement is to get rid of values from before the end of the data set, that is to replace with a period (.)

* Graphing the mean forecast and the actual value
tsline pc_csus_sa fcstmean
tsline fcstmean pc_csus_sa


* The naive forecast is the last value is the forecast going forward. 

gen fcstnaive = pc_csus_sa
replace fcstnaive = pc_csus_sa[scalar(end)] if fcstnaive == .
tsline fcstnaive pc_csus_sa, saving(fcstnaive, replace)

* The seasonally naive forecast. This is one you would use only if there was seasonality in the data. I know that seems obvious but sometimes you just do not think it through until you make that mistake.

gen fcstseasnaive = pc_csus_nsa
replace fcstseasnaive = fcstseasnaive[_n-12] if fcstseasnaive == .
tsline fcstseasnaive pc_csus_nsa, saving(fcstseasnaive, replace)

* This one works because of the way we set up the code, but understand there are possibly situaitons where this code would not work. 

*Drift method - over the entire time frame

gen fcstdrift = pc_csus_sa
replace fcstdrift = fcstdrift[_n-1] + ((pc_csus_sa[scalar(end)] - pc_csus_sa[2])/(obs[scalar(end)]-obs[1])) if fcstdrift == .
tsline fcstdrift pc_csus_sa, saving(fcstdrift, replace)
*Selection of the time frame can be very crucial in the performance of a drift forecast.


With forecasts in place we can generate the forecast error which will be actual - predicted value. 
gen fcerr_mean = .
gen fcerr_naive = .
gen fcerr_snaive = .
gen fcerr_drift = .

*Calcualting the forecast errors
replace fcerr_mean = vari - fcstmean if _n > scalar(newend)
replace fcerr_naive = vari - fcstnaive if _n > scalar(newend)
replace fcerr_snaive = vari - fcstseasnaive if _n > scalar(newend)
replace fcerr_drift = vari - fcstdrift if _n > scalar(newend)

*Calculating the absolute errors
gen absfcerr_mean = abs(fcerr_mean)
gen absfcerr_naive = abs(fcerr_naive)
gen absfcerr_snaive = abs(fcerr_snaive)
gen absfcerr_drift = abs(fcerr_drift)

*Calculating the squared errors
gen sqfcerr_mean = fcerr_mean^2
gen sqfcerr_naive = fcerr_naive^2
gen sqfcerr_snaive = fcerr_snaive^2
gen sqfcerr_drift = fcerr_drift^2

*Calcuating the abosulte percentage error
gen apefcerr_mean = absfcerr_mean/vari
gen apefcerr_naive = absfcerr_naive/vari
gen apefcerr_snaive = absfcerr_snaive/vari
gen apefcerr_drift = absfcerr_drift/vari
