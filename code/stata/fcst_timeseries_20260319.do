* Time series forecasts
* Economic Forecasting Spring 2026
* Started: 17 March 2026
* Updated: 18 March 2026

* Bring in the data
import delimited https://raw.githubusercontent.com/flynnecon/forecasting-2026/refs/heads/main/data/oil_price_data.csv, clear

* Create the date file
gen date = tm(1977m7) + _n-1 
format date %tm
tsset date
drop month

summarize ndfpp wtisplc

tsline ndfpp wtisplc, name(completedata,replace)
* Note the high degree of correlation between these two series. A logical question to ask would be if it is the dame in the differences.
tsline d.ndfpp d.wtisplc, name(completediff, replace)
* We could also summarize the first difference of the data to give further perspective.
summarize d.ndfpp d.wtisplc

* So now we come to some decisions. For the sake of practicing with messy data we are not going to decompose the time series right now. Normally it might be important or beneficial to generate seasonally adjusted data to make our analysis easier. At the very least it removes a degree of non-stationarity. (Recall that trend and seasonality are essentially prima facie evidence of non-stationary data.) 

* There is more data here than necessary so lets restrict the data. 
gen nd_window = ndfpp if date >= tm(2000m1)
gen nd_training = nd_window if date < tm(2021m1)
gen nd_testing = nd_window if date >= tm(2021m1)

* Let's take a look at the data for these subsets
summarize nd_training nd_testing

* A quick look at the smaller data sets gives us:

tsline nd_training nd_testing if date >= tm(2001m1), name(train_test,replace)

* Let's start with the unit root tests. 
dfuller nd_training
dfuller nd_testing

 * It is pretty clearly the case we fail to reject the null hypothesis. This means we should use the first difference of the data. Let's check the outcome differences. 

dfuller d.nd_training
dfuller d.nd_testing


arima nd_training, arima(1 1 0)
estimates store train_ar1

arima nd_training, arima(2 1 0)
estimates store train_ar2

estimates stats train_ar1 train_ar2

* This could be a laborious process if we have to punch in the code for every possible model we want to include. Fortunately there are some commands developed to help us with this effort. 

* We can use lag order selection criteria to figure out the best model. This will report and select the best model based on the model selection critera (AIC,BIC,HQIC).


arimasoc d.nd_training, maxar(12) maxma(0)

* This tells us the model choice is the AR(1). We can restore the earlier results.

estimates restore train_ar1

* Now we make the predictions of our model. 

predict fc1_ndoil if date>=tm(2021m1), y dynamic(tm(2021m1))

* So let's plot this against our testing data. 

tsline fc1_ndoil nd_testing if date >= tm(2021m1)

* This is just the statistical model evaluation, not the forecast model evaluation piece. 