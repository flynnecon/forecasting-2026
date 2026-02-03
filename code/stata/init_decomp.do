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
