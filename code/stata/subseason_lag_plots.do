* Two other chart types
* Economic Forecasting 2026
* Started: 29 January 2026
* Updated: 29 January 2026

import delimited https://raw.githubusercontent.com/flynnecon/forecasting-2026/refs/heads/main/data/us_house_prices.csv, clear

gen date = tm(1987m1) + _n-1
format date %tm
tsset date

tsline csus_nsa csus_sa

gen day = dofm(date)
format day %td
gen year = yofd(day)
gen month = month(day)

twoway line csus_nsa month if date > tm(2018m12), connect(L) colorvar(year) name(seasonplot, replace)

twoway line csus_nsa year, by(month) name(subseason, replace)

foreach i in  1 2 3 4 5 6 7 8 9 10 11 12 {
gen homeprice_lag`i' = L`i'.csus_nsa
}

foreach i in  1 2 3 4 5 6 7 8 9 10 11 12 {
scatter csus_nsa homeprice_lag`i', name(pricechart_`i', replace)
}

graph combine pricechart_1 pricechart_2 pricechart_3 pricechart_4 pricechart_5 pricechart_6 pricechart_7 pricechart_8 pricechart_9 pricechart_10 pricechart_11 pricechart_12, col(3) name(lagchart, replace)




