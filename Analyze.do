


clear 
clear mata
clear matrix 
set matsize 10000

cd  "~/Dropbox/Projects/Bail/Phila/Working/"
use "~/Dropbox/Projects/Bail/Phila/Working/PhillyBail_working.dta", clear
do Globals.do

********************************************
******  Descriptive statistics
********************************************


* summary statistics 
eststo clear
estpost tabstat neverOut trial notGuiltAll confine maxDays feeTot age male white black missRace priorCases fel tot_off firstBailAmt guilt guiltPlea tot_guilt tot_guiltPlea allDrop jail3,  by(jail3) listwise columns(statistics) statistics(mean sd)

esttab using "~/Dropbox/Projects/Bail/Phila/Write Up/sumstats.tex", ///
	main(mean) compress nogaps nostar nodepvar unstack  nonumber se b(a2) label replace nonotes nomtitle  ///
	title("Summary statistics") ///
	addnotes("The statistic shown is the mean.")

* offenses 
eststo clear
estpost tabstat aggAss simpAssault murder vandal burglary theft drugSell robbery drugBuy MVtheft possess prost F2firearm F3firearm possMar shopLift DUI1st, listwise columns(statistics) statistics(mean sd)  

esttab using "~/Dropbox/Projects/Bail/Phila/Write Up/sumstats_offense.tex", ///
	main(mean) compress nogaps nostar nodepvar unstack  nonumber se b(a2) label replace nonotes nomtitle  ///
	title("Summary statistics") ///
	addnotes("The statistic shown is the mean.")


* bail amt categorical variable
gen bailAmt="$0" if firstBailAmt==0
replace bailAmt="$1-$2000" if firstBailAmt>0 & firstBailAmt<=2000	
replace bailAmt="$2001-$5000" if firstBailAmt>2000 & firstBailAmt<=5000	
replace bailAmt="$5001-$10000" if firstBailAmt>5000 & firstBailAmt<=10000	
replace bailAmt="$10001-$25000" if firstBailAmt>10000 & firstBailAmt<=25000	
replace bailAmt="$25001-$50000" if firstBailAmt>25000 & firstBailAmt<=50000	
replace bailAmt="$50001-$100000" if firstBailAmt>50000 & firstBailAmt<=100000	
replace bailAmt="$100001-$500000" if firstBailAmt>100000	& firstBailAmt<=500000
replace bailAmt="$500000+" if firstBailAmt>500000	

* make count variables for bail
bysort bailAmt: egen tot=total(ones)
bysort bailAmt: egen totJ=total(jail3)
bysort bailAmt: egen totR=total(release)
bysort bailAmt: egen mB=mean(firstBailAmt)

*make bar chart for bail
preserve
duplicates drop bailAmt, force
graph hbar (asis) totJ totR, ylabel(0 (25000) 125000) legend( order(1 "Detained" 2 "Released") ) over(bailAmt, sort(mB))  bar(1, color(blue*0.6)) bar(2, color(cyan*0.4)) stack
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/bailDist.png", as(png) replace
restore
drop bailAmt tot totJ totR mB

* histogram of days detainedt
hist ptd if ptd>3 & ptd<600, xtitle("Days detained", axis(1) size(large)) xtitle("", axis(2))  ylabel(0(10000)30000) xscale(range(0 600) noextend) xtick(0(20)600) xlabel(0(100)600) xaxis(1 2) xline(81 144) freq ytitle("People detained",size(large)) xlab(81 "Median" 144 "Mean", axis(2))
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/days_ptd.png", as(png) replace


********************************************
******  Socioeconomic disparities
********************************************

reg firstBailAmt $demo $prior $UCR2_main $UCR2_orig $off $control
predict bail_res,r

gen ln_bail=ln(firstBailAmt+1)
reg ln_bail $demo $prior $UCR2_main $UCR2_orig $off $control
predict ln_bail_res,r


reg firstBailAmt $demo $prior $UCR2_main $UCR2_orig $off $control mean_agi
reg ln_bail $demo $prior $UCR2_main $UCR2_orig $off $control mean_agi

* bail residuals versus zipcode income
binscatter ln_bail_res mean_agi, nq(25) line(none) xtitle("Zipcode average gross income",size(large)) ytitle("Log bail amount, residuals", size(large))
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/incomeVbail.png", as(png) replace

* bail residuals versus race
reg ln_bail age male age2 $prior $UCR2_main $UCR2_orig $off $control mean_agi if black==1 | white==1
predict bail_res_BW, r
graph bar bail_res_BW jail3, over(black)



gen mean_agi2=mean_agi/1000
gen ln_mean_agi=ln(mean_agi)

reg ln_bail $demo $prior $UCR2_main $UCR2_orig $off $control ln_mean_agi if (black==1 | white==1) & ln_bail!=.
est sto ln_bail_black_agi
reg jail3 $demo $prior $UCR2_main $UCR2_orig $off $control ln_mean_agi if black==1 | white==1 & ln_bail!=.
est sto jail3_black_agi


*** race and zipcode income
esttab   ln_bail_black_agi jail3_black_agi ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/SES.tex", /// 
	    replace nogaps compress label nodepvar se keep(black ln_mean_agi) ///
			mtitles( "OLS" "OLS") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How do race and zipcode income relate to bail amount and pretrial detention?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
********************************************
******  First Stage
********************************************

*** first stage
reg jail3 $control $judge_pre
test $judge_pre
reg jail3 $judge_pre $control $demo $prior $off $UCR2_main
test $judge_pre
reg jail3 $control $judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain
test $judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain
reg jail3 $judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $control $demo $prior $off $UCR2_main
test $judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain
reg jail3 $judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $testy2 $ADInt $mainInt $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $control 
test  $judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $testy2



********************************************
******  Identification
********************************************

** f tests 
foreach x in jail3_hat guilt_hat guiltPlea_hat {
display "`x'"
	qui reg `x' $judge_three main AbeDwain Dwain if missCov==0
	test $judge_three
}

** look at permuted results
clear
set obs 1
gen p=.
save "~/Dropbox/Projects/Bail/Phila/Working/permutation/p.dta", replace
foreach test in  guilt_hat guiltPlea_hat jail3_hat $demo $UCR2_orig $off $prior  {
	use  "~/Dropbox/Projects/Bail/Phila/Working/permutation/permu_`test'2.dta", replace
	gen GT=permu_vector1>real_results1

	egen numL=total(GT)
	display "`test'"
	sum real_results1
	sum GT
	sum numL
	gen p=numL/60
	gen test="`test'"
	keep p test real_results1
	keep in 1 
	save "~/Dropbox/Projects/Bail/Phila/Working/permutation/temp.dta", replace
	use "~/Dropbox/Projects/Bail/Phila/Working/permutation/p.dta", clear
	append using  "~/Dropbox/Projects/Bail/Phila/Working/permutation/temp.dta"
	save "~/Dropbox/Projects/Bail/Phila/Working/permutation/p.dta", replace

}

	* histogram the p values
	use "~/Dropbox/Projects/Bail/Phila/Working/permutation/p.dta", clear
	la var p "Empirical P Values"
	hist p,d 
	graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/p.png", as(png) replace

	
	use  "~/Dropbox/Projects/Bail/Phila/Working/PhillyBail_working.dta",clear

*********************************
** Visual IV 
*********************************
	global cov  $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control
	global cov  Dwain_possess Dwain_drugSell Dwain_robbery Dwain_DUI1st $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control
	global cov $control
	global cov AbeDwain Dwain 
  foreach judgey in pre {
  foreach judgey in AbeDwain_main_main2 {

* AbeDwain_main_main2
foreach x in MVtheft_orig {
  foreach judgey in AbeDwain_main_main2 {
	foreach outcome in  guiltPlea{
    global constraint2  `x'==1 
	global cov  $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control

    
	* PTD residual
    reg jail3 $cov if $constraint2
    predict jail3_res2,r

    * mean residuals by judge
	bysort judge_`judgey': egen jail_res_`x'=mean(jail3_res2) if $constraint2 

	* outcome residuals
	reg `outcome' $cov if $constraint2 
	predict g_res_`x',r
	bysort judge_`judgey': egen g_res_`x'_mean=mean(g_res_`x') if $constraint2 

    * identify the judges
	bysort judge_`judgey': sum jail_res_`x' g_res_`x'_mean

	*** graphs
    * scatter plot  overall
    twoway (scatter g_res_`x'_mean jail_res_`x' [fweight=tot_`judgey'] if $constraint2, msymbol(circle_hollow) xtitle("Detention residuals by magistrate", size(large)) ytitle("Conviction residuals", size(large))  ylabel(,labsize(large)) xlabel(,labsize(large)) ) ///
            (lfit g_res_`x'_mean jail_res_`x' if $constraint2, legend(off))
	*graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/VisIV_`x'_`judgey'_`outcome'_cov_neverOut.png", as(png) replace
    
	drop g_res_`x' jail_res_`x' g_res_`x'_mean
    drop jail3_res2
}
}
}


*************************************
*** Judge Preference Graphs
*************************************


****** order judges according to average Pretrial detention
gen judgeGraph=1 if judge_pre=="James O'Brien"
replace judgeGraph=2 if judge_pre=="Timothy P. O'Brien"
replace judgeGraph=3 if judge_pre=="Abe Polokoff" 
replace judgeGraph=4 if judge_pre=="Jane M. Rice"
replace judgeGraph=5 if judge_pre=="Sheila M. Bedford"
replace judgeGraph=6 if judge_pre=="Francis J. Rebstock"
replace judgeGraph=7 if judge_pre=="Patrick Stack"
replace judgeGraph=8 if judge_pre=="Dwain E. Hill"


* unexplained likelihood of Pretrial detention
reg jail3 $control if missCov==0
predict jail3_res2, r

* build variables for bar graph
bysort judgeGraph: egen mJ=mean(jail3_res2)
bysort judgeGraph: egen n=total(ones)
	   
	   gen sdJ=.
	   forvalues i=1/8 {
			sum jail3_res2 if judgeGraph==`i'
			replace sdJ=r(sd) if judgeGraph==`i'
		}
			
generate hiJ = mJ + invttail(n-1,0.025)*(sdJ / sqrt(n))
generate loJ = mJ - invttail(n-1,0.025)*(sdJ / sqrt(n))
gen sdM=sdJ/sqrt(n)
gen hiJ2=mJ+1.96*sdM
gen loJ2=mJ-1.96*sdM

* make bar graph
twoway (bar mJ judgeGraph, xlabel(1(1)8)) (rcap hiJ loJ judgeGraph, ytitle("Pretrial detention, residuals", size(large)) xtitle("Magistrates") legend( order(1 "Magistrate mean" 2 "Confidence Interval") ) )
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/judgeGraph.png", as(png) width(511) height(371) replace


**
reg jail3 AbeDwain Dwain main main2 if missCov==0
predict jail3_res2, r
bysort judge_pre: egen mJgraph=mean(jail3_res2) 
drop jail3_res2

* build judge preference graphs by offense type
*foreach x in  prost_orig MVtheft_orig john_orig shopLift_orig robbery_orig all female threePriors drugSell_orig   possess_orig burglary_orig black DUI1st_orig aggAss_orig simpAssault_orig theft_orig{
foreach x in  shopLift_orig all possess_orig DUI1st_orig simpAssault_orig prost_orig{
foreach judgey in _pre {
reg jail3 $control if missCov==0 & `x'==1
predict jail3_res2, r
		
	* build variables for bar graph
	bysort judge`judgey': egen mJ=mean(jail3_res2) if `x'==1
	bysort judge`judgey': egen n=total(ones) if `x'==1
	   
	bysort judge`judgey': egen sdJ=sd(jail3_res2) if `x'==1
				
	generate hiJ = mJ + invttail(n-1,0.025)*(sdJ / sqrt(n))
	generate loJ = mJ - invttail(n-1,0.025)*(sdJ / sqrt(n))
	display "`x'"

	* make graph
    preserve
    keep mJ sdJ hiJ loJ `x' mJgraph
    keep if `x'==1
    duplicates drop
    sort mJgraph
    gen judgeCount=_n
    sort mJ
	twoway (bar mJ judgeCount if `x'==1)  (rcap hiJ loJ judgeCount  if `x'==1, xlabel(1(1)8) ytitle("Pretrial detention, residuals", size(large)) xtitle("Magistrates") legend( order(1 "Magistrate mean" 2 "Confidence Interval") ) )
    graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/judge`judgey'_`x'.png", as(png) replace
	restore
	drop mJ n sdJ hiJ loJ jail3_res2

}
}


* look at variance by offense type
foreach x in drugSell_orig {
display "`x'"
qui reg jail3 $judge_pre $control  if `x'==1
test $judge_pre
tab `x'
}
********************************************
******  Case outcomes and case severity
********************************************

* probability of confinement conditional on guilt
logit confine $UCR2 $UCR2_orig $prior $demo $off if guilt==1
predict con_hat

* probability of confinement for more than three days
gen confine2=confine
replace confine2=0 if minDays<=30
logit confine2 $UCR2 $UCR2_orig $prior $demo $off if guilt==1
predict con2_hat

* histogram of confinement conditional on guilt
hist con_hat, xtitle("P (Incarceration | Guilt)", size(large)) xaxis(1 2) xline(.17 .81) xlab(.17 "Possession" .81 "Robbery", axis(2))
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/con_hat_hist.png", as(png) replace


* guilt pleas and case severity
binscatter guiltPlea con_hat, line(none) xtitle("P (Incarceration | Guilt)", size(large)) ytitle("Guilty Plea", size(large))  
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/guiltPlea_charge_severity.png", as(png) replace

* ptd and case severity
binscatter jail3 con_hat, line(none) xtitle("P(Incarceration | Guilt)", size(large)) ytitle("Pretrial detention", size(large))
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/ptd_charge_severity.png", as(png) replace


* guilt  and case severity
binscatter guilt con_hat, line(none) xtitle("P (Incarceration | Guilt)", size(large)) ytitle("Guilty of at Least One Charge", size(large))  
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/guilt_charge_severity.png", as(png) replace


* total guilt  and case severity
binscatter tot_guilt2 con_hat, line(none) xtitle("P (Incarceration | Guilt)", size(large)) ytitle("Total convictions", size(large))  
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/tot_guilt_charge_severity.png", as(png) replace


* total guilty pleas  and case severity
binscatter tot_guiltPlea2 con_hat, line(none) xtitle("P (Incarceration | Guilt)", size(large)) ytitle("Total guilty pleas", size(large))  
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/tot_guiltPlea_charge_severity.png", as(png) replace

********************************************
******  Full Sample
********************************************

*** IV - Full Sample
foreach y in guilt guiltPlea   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre ) $control if missCov!=1, r
  est sto `y'_FS_noC
  esttab, keep(jail3) se
  qui jive `y' (`x'=$judge_pre ) $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  , r
est sto `y'_FS
   esttab, keep(jail3) se
}
}

*** IV - Full Sample - Interactions with Time
foreach y in  AD_arrest   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain) $control, r
    est sto `y'_FSITnoC
	  esttab, keep(jail3)
	 qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain) $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control , r
     est sto `y'_FSIT
	   esttab, keep(jail3)

}
}



*** IV - Full Sample - Interactions with Time & Top 5 Crimes
foreach y in  feeTot confine confine1yr confine3mo maxDays minDays   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  ///
	Abe_possess_orig DwainE_possess_orig James_possess_orig Jane_possess_orig Patrick_possess_orig Sheila_possess_orig Timothy_possess_orig Francis_possess_orig ///
	Abe_aggAss_orig DwainE_aggAss_orig James_aggAss_orig Jane_aggAss_orig Patrick_aggAss_orig Sheila_aggAss_orig Timothy_aggAss_orig Francis_aggAss_orig ///
	Abe_drugSell_orig DwainE_drugSell_orig James_drugSell_orig Jane_drugSell_orig Patrick_drugSell_orig Sheila_drugSell_orig Timothy_drugSell_orig Francis_drugSell_orig ///
	Abe_robbery_orig DwainE_robbery_orig James_robbery_orig Jane_robbery_orig Patrick_robbery_orig Sheila_robbery_orig Timothy_robbery_orig Francis_robbery_orig ///
	Abe_DUI1st_orig DwainE_DUI1st_orig James_DUI1st_orig Jane_DUI1st_orig Patrick_DUI1st_orig Sheila_DUI1st_orig Timothy_DUI1st_orig Francis_DUI1st_orig ///
)  $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  , r
est sto `y'_FSIT5C
	   esttab, keep(jail3)
}
}


*** IV - Full Sample - Interactions with Time & Top 5 Crimes & priors
foreach y in  feeTot confine confine1yr confine3mo maxDays minDays   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  ///
	Abe_possess_orig DwainE_possess_orig James_possess_orig Jane_possess_orig Patrick_possess_orig Sheila_possess_orig Timothy_possess_orig Francis_possess_orig ///
	Abe_aggAss_orig DwainE_aggAss_orig James_aggAss_orig Jane_aggAss_orig Patrick_aggAss_orig Sheila_aggAss_orig Timothy_aggAss_orig Francis_aggAss_orig ///
	Abe_drugSell_orig DwainE_drugSell_orig James_drugSell_orig Jane_drugSell_orig Patrick_drugSell_orig Sheila_drugSell_orig Timothy_drugSell_orig Francis_drugSell_orig ///
	Abe_robbery_orig DwainE_robbery_orig James_robbery_orig Jane_robbery_orig Patrick_robbery_orig Sheila_robbery_orig Timothy_robbery_orig Francis_robbery_orig ///
	Abe_DUI1st_orig DwainE_DUI1st_orig James_DUI1st_orig Jane_DUI1st_orig Patrick_DUI1st_orig Sheila_DUI1st_orig Timothy_DUI1st_orig Francis_DUI1st_orig ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_prior_violCrime DwainE_prior_violCrime James_prior_violCrime Jane_prior_violCrime Patrick_prior_violCrime Sheila_prior_violCrime Timothy_prior_violCrime Francis_prior_violCrime ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors ///
	)  $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control , r
est sto `y'_FSIT5Cpri
	   esttab, keep(jail3)
}
}



*** IV - Full Sample - Interactions with Time & Top 5 Crimes & priors & demographics
foreach y in  feeTot confine confine1yr confine3mo maxDays minDays   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  ///
	Abe_possess_orig DwainE_possess_orig James_possess_orig Jane_possess_orig Patrick_possess_orig Sheila_possess_orig Timothy_possess_orig Francis_possess_orig ///
	Abe_aggAss_orig DwainE_aggAss_orig James_aggAss_orig Jane_aggAss_orig Patrick_aggAss_orig Sheila_aggAss_orig Timothy_aggAss_orig Francis_aggAss_orig ///
	Abe_drugSell_orig DwainE_drugSell_orig James_drugSell_orig Jane_drugSell_orig Patrick_drugSell_orig Sheila_drugSell_orig Timothy_drugSell_orig Francis_drugSell_orig ///
	Abe_robbery_orig DwainE_robbery_orig James_robbery_orig Jane_robbery_orig Patrick_robbery_orig Sheila_robbery_orig Timothy_robbery_orig Francis_robbery_orig ///
	Abe_DUI1st_orig DwainE_DUI1st_orig James_DUI1st_orig Jane_DUI1st_orig Patrick_DUI1st_orig Sheila_DUI1st_orig Timothy_DUI1st_orig Francis_DUI1st_orig ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_prior_violCrime DwainE_prior_violCrime James_prior_violCrime Jane_prior_violCrime Patrick_prior_violCrime Sheila_prior_violCrime Timothy_prior_violCrime Francis_prior_violCrime ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors ///
				Abe_black DwainE_black James_black Jane_black Patrick_black Sheila_black Timothy_black Francis_black ///
				Abe_age DwainE_age James_age Jane_age Patrick_age Sheila_age Timothy_age Francis_age ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
 ) $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control   , r
est sto `y'_FSIT5CpriD
esttab, keep(jail3)
}
}

*** IV - Full Sample - Interactions with Time & Crime
foreach y in confine maxDays minDays guilt guiltPlea   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  $testy2orig $cgAddOns $evAddOns ) ///
   $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  , r
est sto `y'_FSITC
esttab, keep(jail3)
}
}



	
*** guilty Plea to at least one charge
esttab    guiltPlea_FS_noC guiltPlea_FS guiltPlea_FSIT guiltPlea_FSIT5C guiltPlea_FSIT5CpriD guiltPlea_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/guiltPlea.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")

		

		
	
*** convicted on at least one charge
esttab    guilt_FS_noC guilt_FS guilt_FSIT guilt_FSIT5C guilt_FSIT5CpriD guilt_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/guilt.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
		
		
*** maximum days of incarceration
esttab    maxDays_FS_noC maxDays_FS maxDays_FSIT maxDays_FSIT5C maxDays_FSIT5CpriD maxDays_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/maxDays.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
	
*** minimum days of incarceration
esttab    minDays_FS_noC minDays_FS minDays_FSIT minDays_FSIT5C minDays_FSIT5CpriD minDays_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/minDays.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
		
*** confined for at least one year
esttab    confine1yr_FS_noC confine1yr_FS confine1yr_FSIT confine1yr_FSIT5C confine1yr_FSIT5CpriD confine1yr_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/confine1yr.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
	
*** confinement
esttab    confine_FS_noC confine_FS confine_FSIT confine_FSIT5C confine_FSIT5CpriD confine_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/confine.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
	
*** court feees
esttab    feeTot_FS_noC feeTot_FS feeTot_FSIT feeTot_FSIT5C feeTot_FSIT5CpriD feeTot_FSITC ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/feeTot.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "JIVE" "JIVE"  "JIVE" "JIVE" "JIVE") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("How does pretrial detention affect guilty pleas?") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")		
	
	
	
	
	
**** OLS - Full Sample
foreach z in aggAss simpAssault murder vandal burglary theft drugSell drugBuy robbery MVtheft possess prost F2firearm F3firearm possMar shopLift DUI1st { 
foreach y in guilt  {
 foreach x in jail3 {
  display "`z'"
  qui reg `y' `x'  $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  ///
    if `z'==1, r
  est sto `y'_OLS_FS
  esttab, keep(jail3)
 }
}
}

aggAss simpAssault murder vandal burglary theft drugSell drugBuy robbery MVtheft possess prost F2firearm F3firearm possMar shopLift DUI1st

* look at treatment effects across case types
foreach x in  female threePriors drugSell shopLift  robbery drugSell possess burglary black DUI1st aggAss simpAssault theft{
  display "`x'"
  qui reg guilt jail3  $demo $prior $off $UCR2_main $UCR2_orig $control if `x'==0, r
  esttab, keep(jail3)
}



* IV regress
foreach y in guilt  {
foreach x in jail3 {
	ivregress 2sls `y' (`x'=$judge_pre ) $control , r
		ivregress  2sls `y'   $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  (`x'=$judge_pre ) ,  r
}
}

* IV probit
foreach y in  confine2  {
foreach x in jail3 {
		ivprobit `y'  $control $demo $prior $off $UCR2 (`x'=$judge_pre ) ,  r
}
}


*** OLS
esttab  guilt_OLS_FS guiltPlea_OLS_FS feeTot_OLS_FS confine_OLS_FS maxDays_OLS_FS minDays_OLS_FS ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/OLS.tex", /// 
	    replace nogaps compress label nodepvar se  keep(jail3) ///
			mtitles( "OLS" "OLS" "OLS" "OLS" "OLS") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) title("Ordinary least squares results") ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")


		
*** IV - Full Sample - Interactions with Time & Crime
foreach y in  guilt guiltPlea   {
 foreach x in ptd {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  $testy2orig $cgAddOns $evAddOns ) ///
   $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  , r
est sto `y'_`x'_FSITC
esttab, keep(`x')
}
}


* label new variables
la var jail0 "Detained > 0 days"
la var jail1 "Detained > 1 days"
la var jail3 "Detained > 3 days"
la var jail7 "Detained > 7 days"
la var jail14 "Detained > 14 days"
la var jail30 "Detained > 30 days"
la var neverOut "In jail at time of disp."

* conviction increasing days detained
coefplot guilt_jail0_FSITC guilt_jail3_FSITC  guilt_jail14_FSITC  guilt_jail30_FSITC  guilt_neverOut_FSITC, xlabel(, labsize(large)) ylabel(, labsize(large)) keep(jail0 jail1 jail3 jail7 jail14 jail30 neverOut) xline(0) xtitle("Dep. var = conviction", size(large)) legend(off)
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/coefplot_guilt_inc_days.png", as(png) replace

* guilty plea increasing days detained
coefplot guiltPlea_jail0_FSITC guiltPlea_jail3_FSITC  guiltPlea_jail14_FSITC  guiltPlea_jail30_FSITC  guiltPlea_neverOut_FSITC, xlabel(, labsize(large)) ylabel(, labsize(large)) keep(jail0 jail1 jail3 jail7 jail14 jail30 neverOut) xline(0) xtitle("Dep. var = pled guilty", size(large)) legend(off)
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/coefplot_guiltPlea_inc_days.png", as(png) replace

	
* ambiguous-guilt, guilty pleas, increasing days detained
coefplot guiltPlea_jail0_ev5ITC guiltPlea_jail3_ev5ITC   guiltPlea_jail14_ev5ITC guiltPlea_jail30_ev5ITC guiltPlea_neverOut_ev5ITC, xlabel(, labsize(large)) ylabel(, labsize(large)) keep(jail0 jail1 jail3 jail7 jail14 jail30 neverOut) xline(0) xtitle("Dep. var = pled guilty", size(large)) legend(off)
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/coefplot_ev5_guiltPlea_inc_days.png", as(png) replace


* clear-guilt, guilty pleas, increasing days detained
coefplot guiltPlea_jail0_cg5ITC guiltPlea_jail3_cg5ITC   guiltPlea_jail14_cg5ITC guiltPlea_jail30_cg5ITC guiltPlea_neverOut_cg5ITC, xlabel(, labsize(large)) ylabel(, labsize(large)) keep(jail0 jail1 jail3 jail7 jail14 jail30 neverOut) xline(0) xtitle("Dep. var = pled guilty", size(large)) legend(off)
graph export  "~/Dropbox/Projects/Bail/Phila/Write Up/coefplot_cg5_guiltPlea_inc_days.png", as(png) replace


		
		


********************************************
******  Evidence Crimes 
********************************************




*** IV - Evidence Crimes - Interactions with Time, just top 5 crimes
foreach y in confine guilt guiltPlea{
 foreach x in jail3 {
  jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain)  $ADIntDemo  $demo $prior $off  ///
  rape_orig robbery_orig burglary_orig aggAss_orig theft_orig stolProp_orig simpAssault_orig $control $ev_orig $ev_orig_int ///
  if ev==1 & ev5==1, r
  est sto `y'_ev5
  esttab, keep(jail3)
  }
}

* IV - Evidence Crimes - Interactions with time and top5 crimes
	foreach y in maxDays {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $testyEvOrig )  $ADIntDemo  $demo $prior $off  ///
  rape_orig robbery_orig burglary_orig aggAss_orig theft_orig stolProp_orig simpAssault_orig $control $ev_orig $ev_orig_int ///
	if ev5==1 & ev==1, r
   est sto `y'_ev5ITC
   esttab, keep(`x')
}
}


**** OLS - ev
foreach y in confine guilt guiltPlea{
 foreach x in jail3 {
  qui reg `y' `x'  $ADIntDemo  $demo $prior $off  ///
  rape_orig robbery_orig burglary_orig aggAss_orig theft_orig stolProp_orig simpAssault_orig $control  $ev_orig $ev_orig_int ///
	if ev==1 & ev5==1 , r
  est sto `y'_OLS_ev5
  esttab, keep(jail3)

 }
}



*** guilt and guilty plea - ev
esttab  guilt_ev5 guilt_ev5ITC guilt_OLS_ev5  guiltPlea_ev5 guiltPlea_ev5ITC guiltPlea_OLS_ev5 ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/ev_guilt_guiltPlea.tex", /// 
	    replace nogaps compress label nodepvar se keep(jail3)  ///
			mtitles( "Ev" "Ev5_ITC" "OLS_ev5"  "Ev" "Ev5_ITC" "OLS_ev5") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")

*** guilt and guilty plea -cg
esttab  guilt_cg5 guilt_cg5ITC guilt_OLS_cg5  guiltPlea_cg5 guiltPlea_cg5ITC guiltPlea_OLS_cg5 ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/cg_guilt_guiltPlea.tex", /// 
	    replace nogaps compress label nodepvar se keep(jail3)  ///
			mtitles( "cg" "cg5_ITC" "OLS_cg5"  "cg" "cg5_ITC" "OLS_cg5") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")
		
		*** confinement
esttab  confine_ev5 confine_ev5ITC confine_OLS_ev5  confine_cg5 confine_cg5ITC confine_OLS_cg5 ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/ev_cg_confine.tex", /// 
	    replace nogaps compress label nodepvar se keep(jail3)  ///
			mtitles( "ev" "ev5_ITC" "OLS_ev5"  "cg" "cg5_ITC" "OLS_cg5") ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")



		

* IV - Evidence Crimes - increasing number of days
	foreach y in guiltPlea {
 foreach x in jail0 jail3 jail14 jail30 neverOut {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $testyEvOrig )  $ADIntDemo  $demo $prior $off  ///
  rape_orig robbery_orig burglary_orig aggAss_orig theft_orig stolProp_orig simpAssault_orig $control $ev_orig $ev_orig_int ///
	if ev5==1 & ev==1, r
   est sto `y'_`x'_ev5ITC
   esttab, keep(`x')
}
}

********************************************
****** Clear Guilt Crimes 
********************************************


*** IV - Clear Guilt Crimes - Interactions with Time
foreach y in confine guilt guiltPlea{
 foreach x in jail3 {
    qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain) $ADIntDemo  $demo $prior $off ///
  DUI2nd_orig F2firearm_orig possess_orig drugSell_orig drugBuy_orig possMar_orig DUI1st_orig F3firearm_orig $cg_orig_int  $control ///
  if clearGuilt==1 & cg5==1, r
   est sto `y'_cg5
   esttab, keep(jail3)
}
}


*** IV - Clear Guilt Crimes - only top 5 crimes
foreach y in  confine guilt guiltPlea {
 foreach x in jail3 {
   jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  $testyCGorig )  $ADIntDemo  $demo $prior $off ///
  DUI2nd_orig F2firearm_orig possess_orig drugSell_orig drugBuy_orig possMar_orig DUI1st_orig F3firearm_orig $cg_orig_int  $control ///
      if  cg5==1 & clearGuilt==1, r
    est sto `y'_cg5ITC
	esttab, keep(jail3)
}
}

**** OLS - clear guilt
foreach y in confine guilt guiltPlea{
 foreach x in jail3 {
  qui reg `y' `x'    $ADIntDemo  $demo $prior $off ///
  DUI2nd_orig F2firearm_orig possess_orig drugSell_orig drugBuy_orig possMar_orig DUI1st_orig F3firearm_orig $cg_orig_int  $control ///
      if  clearGuilt==1 & cg5==1, r
  est sto `y'_OLS_cg5
  esttab, keep(jail3)

 }
}


*** IV - Clear Guilt Crimes - increasing days detained
foreach y in   guiltPlea {
 foreach x in jail0 jail3 jail14 jail30 neverOut {
   qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  $testyCGorig )  $ADIntDemo  $demo $prior $off ///
  DUI2nd_orig F2firearm_orig possess_orig drugSell_orig drugBuy_orig possMar_orig DUI1st_orig F3firearm_orig $cg_orig_int  $control ///
      if  cg5==1 & clearGuilt==1, r
    est sto `y'_`x'_cg5ITC
	esttab, keep(`x')
}
}


********************************************
******  robustness checks 
********************************************

*** robustness checks - controlling for judge fixed effects
foreach y in  guilt guiltPlea   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  $testy2orig $cgAddOns $evAddOns ) $judge_pre ///
   $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  , r
est sto `y'_FS_magFE
esttab, keep(jail3)
}
}

*** robustness checks - controlling for defender type
foreach y in  guilt guiltPlea   {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain  $testy2orig $cgAddOns $evAddOns ) CA PD ///
   $ADIntDemo $mainIntDemo $demo $prior $off $UCR2_main $UCR2_orig $ADInt_orig $mainInt_orig $control  , r
est sto `y'_FS_CAPD
esttab, keep(jail3)
}
}

* ev robustness checks -- controlling for judge fixed effects
	foreach y in guilt guiltPlea {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $testyEvOrig )  $judge_pre $ADIntDemo  $demo $prior $off  ///
  rape_orig robbery_orig burglary_orig aggAss_orig theft_orig stolProp_orig simpAssault_orig $control $ev_orig $ev_orig_int ///
	if ev5==1 & ev==1, r
   est sto `y'_ev5_magFE
   esttab, keep(`x')
}
}

* ev robustness checks -- controlling for CA PD
	foreach y in guilt guiltPlea {
 foreach x in jail3 {
  qui jive `y' (`x'=$judge_pre_main $judge_pre_main2 $judge_pre_AbeDwain $testyEvOrig )  CA PD $ADIntDemo  $demo $prior $off  ///
  rape_orig robbery_orig burglary_orig aggAss_orig theft_orig stolProp_orig simpAssault_orig $control $ev_orig $ev_orig_int ///
	if ev5==1 & ev==1, r
   est sto `y'_ev5_CAPD
   esttab, keep(`x')
}
}

** robustness checks - full sample
esttab  guilt_FS_magFE guilt_FS_CAPD guiltPlea_FS_magFE guiltPlea_FS_CAPD  ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/FS_robust.tex", /// 
	    replace nogaps compress label nodepvar se keep(jail3)  ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")


** robustness checks - ev
esttab  guilt_ev5_magFE guilt_ev5_CAPD guiltPlea_ev5_magFE guiltPlea_ev5_CAPD  ///
	using "~/Dropbox/Projects/Bail/Phila/Write Up/ev5_robust.tex", /// 
	    replace nogaps compress label nodepvar se keep(jail3)  ///
	star(* 0.10 ** 0.05 *** 0.01 **** 0.001) ///
		stats(N r2 , labels("Observations" "R$^2$")) ///
		addnotes("Heteroskedastic-Robust Standard Errors")



********************************************
******  Felony, NonFelony 
********************************************


**** OLS - Nonfelony
foreach y in  guilt guiltPlea{
 foreach x in jail3 {
  reg `y' `x' $control if fel==0, r
  reg `y' `x'  $demo $prior $off $UCR2_main  $control if fel==0, r
   reg `y' `x'  $demo $prior $off $UCR2_main  $control i.zip2 PD CA if fel==0, r
}
}


**** OLS - Felony
foreach y in  guilt guiltPlea{
 foreach x in jail3 {
  reg `y' `x' $control if fel==0, r
  reg `y' `x'  $demo $prior $off $UCR2_main  $control if fel>0, r
   reg `y' `x'  $demo $prior $off $UCR2_main  $control i.zip2 PD CA if fel>0, r
}
}


********************************************
******  Logit  
********************************************

// set up the program including 1st and 2nd stage
program my2sls
    logit jail3 $judge_pre $control
    predict jail3_hat2, xb

    logit guilt jail3_hat2 $control , or
    drop jail3_hat2
end

// obtain bootstrapped standard errors
bootstrap, reps(100): my2sls
