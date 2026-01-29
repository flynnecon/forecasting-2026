* Second Graphics File
* Economic Forecasting Spring 2026
* Started: 26 January 2026
* Updated: 26 January 2026

* Bring in the data
import delimited https://raw.githubusercontent.com/flynnecon/forecasting-2026/refs/heads/main/data/oil_price_data.csv, clear

* Create the date file
gen date = tm(1977m7) + _n-1 
format date %tm
tsset date
drop month

* Basic time series graphs
tsline ndfpp, name(ndoilprice, replace)
tsline wtisplc, name(wtiprice, replace)
tsline ndfpp wtisplc, name(oilprice_combined, replace)

* Data Manipulation
gen day = dofm(date)
format day %td
gen year = yofd(day)
gen month = month(day)twoway line ndfpp month

* Season Plots
twoway line ndfpp month
twoway line ndfpp month, connect(L) colorvar(year)
twoway line ndfpp month if date > tm(2020m1), connect(L) colorvar(year)
