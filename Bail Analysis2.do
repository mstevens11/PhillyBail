

clear 
clear mata
clear matrix 
set matsize 10000

cd "~/Dropbox/Projects/Bail/Phila/Working/"
*************************************
* build data set
*************************************


** start with bail judge and bail info
use "~/Dropbox/Projects/Bail/Phila/2007/bailInfo_2007.dta", clear
foreach x in 2006 2008 2009 2010 2011 2012 2013  {
	append using "~/Dropbox/Projects/Bail/Phila/`x'/bailInfo_`x'.dta"
}

* drop duplicates
gen ones=1
bysort docket: egen tots=total(ones) 
tab tots
duplicates drop docket, force
drop tots


* merge in all the info on priors, and recidivism
foreach jj in  2006 2007 2008 2009 2010 2011 2012 2013 {
    merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/`jj'/CSR_priorCharges_`jj'.dta", update  gen(_merge_`jj') 
    drop if _merge_`jj'==2
    drop _merge_`jj'
	
}

drop 	misc misc_1 misc_3 misc_2 misc_4 misc_5 sentType1 sentDesc1 sentType3 sentDesc2 sentDesc3 sentType2 keyRow 
drop V7 V7 V12 V13 V9 V3 V6 V8 V11 V2 V14 V15 V4 V16 V5 V17

* merge in case basics and demographic data
foreach jj in 2006 2007 2008 2009 2010 2011 2012 2013  {
    merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/`jj'/caseBasics_`jj'.dta", update  gen(_merge_`jj') 
    drop if _merge_`jj'==2
    drop _merge_`jj'
}

/*
drop eventType  descrip disposition sentLen
drop statute confine off_fel off_fel cl_fel off_mis cl_mis off_sum cl_sum ARD IGC dockYear guiltF guiltM guiltPleaF guiltPleaM guiltF_O guiltM_O guiltPleaF_O guiltPleaM_O tot_guiltF_OD tot_guiltM_O tot_guiltPleaF_O tot_guiltPleaM_O notGuilt_O guilt_O guiltPlea_O held_O dropped_O ARD_O IGC_O overlap order
drop guiltF_OD guiltM_OD guiltPleaF_OD guiltPleaM_OD tot_guiltF_ODD tot_guiltM_OD tot_guiltPleaF_OD tot_guiltPleaM_OD assault_OD drug_OD robbery_OD notGuilt_OD guilt_OD guiltPlea_OD held_OD dropped_OD ARD_OD IGC_OD
*/

* merge in offense info
foreach jj in  2006 2007 2008 2009 2010 2011 2012 2013 {
	merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/`jj'/offense_clean_`jj'.dta", update  gen(_merge_`jj') 
	drop if _merge_`jj'==2
    drop _merge_`jj'
}

* merge better offense info
drop assault aggAssault burglary robbery arson drug DUI instr reckless mischief theft rape firearms murder driveCrime fraudForge intim
	merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/Working/UCR_offense.dta", update  gen(_merge_offense)
	drop if _merge_offense==2
	drop _merge_offense
	
* merge in financial information
	merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/Working/financials.dta", update  gen(_mergeF) 
	drop if _mergeF==2
    drop _mergeF
	
	

* merge in better bail data
	merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/Working/bailData.dta", update  gen(_mergeF) 
	drop if _mergeF==2
    drop _mergeF
	
drop if docket==""



* merge in case outcome data
foreach jj in 2006 2007 2008 2009 2010 2011 2012 2013  {
    merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/`jj'/caseOutcomes_`jj'.dta", update  gen(_merge_`jj') force
    drop if _merge_`jj'==2
    drop _merge_`jj'
}


* merge in detainer info
	merge 1:1 docket using  "~/Dropbox/Projects/Bail/Phila/Working/detainer2.dta", update  gen(_mergeF) 
	drop if _mergeF==2
    drop _mergeF

*************************************
*** clean up data
*************************************

* generate numeric docket
gen dockNo=subinstr(docket, "MC-51-CR-","",1)
gen dockYear=real(substr(docket,-4,4))
drop if dockYear==.


foreach x in startDate startTime room judgeName {
	replace `x'=`x'_1 if `x'=="NA"
	drop `x'_1
}

* replace missing with zero
foreach x in F1 F2 F3 F M1 M2 M3 M {
	replace `x'=0 if `x'==.
}

*convert times 
gen pm=strmatch(startTime, "*pm*")
gen am=strmatch(startTime, "*am*")
gen bailTime=subinstr(startTime, " pm", "",1)
replace bailTime=subinstr(bailTime, " am", "",1)
replace bailTime=subinstr(bailTime, ":", "",1)
destring bailTime, force replace
replace bailTime=bailTime+1200 if pm==1 & bailTime<=1200
replace bailTime=bailTime-1200 if pm==0 & bailTime>=1200
drop pm am


/* turn bail amount into money
destring firstBailAmt, replace force ignore("$",",",".")
replace firstBailAmt=firstBailAmt/100
*/

* convert dates
gen bailDate=date(startDate, "MDY")
format bailDate %td
gen dob1=date(dob, "MDY")
drop dob
gen dob=dob1
drop dob1
format dob %td
format bailSetDate %td
replace bailDate=bailSetDate if bailDate==.


*>>>>
drop if bailDate<td(13sep2006)
drop if bailDate==. & bailSetDate==.

*************************************
*** build covariates etc
*************************************

* build covariates
gen white=race=="White"
gen black=race=="Black"
gen asian=race=="Asian"
gen missRace=race=="" |  race=="Empty"
gen missSex=sex!="Female" & sex!="Male"
gen age=(bailDate-dob)/365
gen missAge=age==.
gen age2=age^2
gen age3=age^3
gen male=.
replace male=1 if sex=="Male"
replace male=0 if sex=="Female"
gen female=male==0
gen priorCases2=priorCases^2

* zip code
destring zip, replace force


* on detainer
gen detainer=0
forvalues z=1/11{
replace detainer=1 if (detainDate`z'-bailDate)>=-7 & (detainDate`z'-bailDate<=21) & bailDate!=.
}
gen noDetain=detainDate1==.

* charges
*gen fel=tot_fel>0
gen has_mis=tot_mis>0

* went to trial
gen trial=0
replace trial=1 if guilt_O==1 & guiltPlea_O!=1
replace trial=1 if notGuilt_O==1
replace confine_O=confine_O-1

* time to disposition (from bail date)
gen time2disp=dispDt-bailDate

* pre-trial detention variables
gen neverOut =ptd==time2disp
gen ptd=relDate-bailDate
replace ptd=time2disp if ptd==.
replace neverOut= ptd==time2disp if neverOut==0
gen jail3=ptd>3
gen jail1=ptd>1
gen jail7=ptd>7
gen jail30=ptd>30 
gen jail60=ptd>60 | neverOut==1
gen jail90=ptd>90 | neverOut==1
gen jail0=ptd>0 

gen timeOut=dispDt-relDate

* min max days
replace minDays=maxDays if minDays==0 & maxDays!=0
gen minDays2=sqrt(minDays)
gen maxDays2=sqrt(maxDays)
gen ln_minDays=ln(minDays+1)
gen ln_maxDays=ln(maxDays+1)


* no trial, no guilty plea, charges dropped
gen allDrop=1
replace allDrop=0 if guilt_O==1
replace allDrop=0 if notGuilt_O==1



* public defender
gen PD=strmatch(defAtty, "*PD*")
replace PD=strmatch(defAtty, "*Defender*") if PD==0
gen CA=strmatch(defAtty, "*CA*")
gen public=PD+CA
replace public=1 if public>1

* shift and weekend indicators
gen bailDay=day(bailDate)
gen bailDOW=dow(bailDate)
gen bailMonth=month(bailDate)
gen bailWeek=week(bailDate)
gen morning=bailTime>=730 & bailTime<1530
gen evening=bailTime>=1530 & bailTime<2330
gen grave=bailTime>=2330 | bailTime<730
gen weekend=bailDay==0 | bailDay==6
gen weekend2=(bailDay==5 & bailTime>1830) | bailDay==6 | (bailDay==0 & bailTime<1830)

gen onePrior=priorCases>=1
gen threePriors=priorCases>=3

* make day in 1 to 365
gen day=.
foreach x in 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 {
    gen day`x'= bailDate if dockYear==`x'
    egen first`x' = min(day`x') 
    replace day=bailDate-first`x'+1 if dockYear==`x'
    drop day`x' first`x'
}
replace day=day+1 if bailTime>=2330


** gen cubic in time of year
gen day2=day^2
gen day3=day^3

* gen ev 
gen ev=$ev
gen all=missCov==0
gen clearGuilt=$clearGuilt

** gen indicator for missing judge names
gen missing=judgeName=="Court Magistrate" | judgeName=="NA" | judgeName=="Arraignment Court Magistrate"  | judgeName=="" 

** base day on 2011
gen day_2011= bailDate if dockYear==2011
    egen first2011 = min(day_2011)
gen day11=bailDate-first2011+1 
replace day11=day11+1 if bailTime>=2330
drop day_2011 first2011

bysort zip: egen totZip=total(ones)
gen zip2=zip
replace zip2=9999999 if totZip<300
drop totZip

* build fee variables
gen feeTot2=fee_tot
replace feeTot2=0 if fee_tot==.
gen feeTot3=feeTot2
replace feeTot3=0 if feeTot3<0
replace feeTot3=10000 if feeTot3>10000


** indicator for missing covariates

** truncate total guilty
gen tot_guiltF_OD2=tot_guiltF_OD
replace tot_guiltF_OD2=50 if tot_guiltF_OD>50
gen tot_guiltM_OD2=tot_guiltM_OD
replace tot_guiltM_OD2=50 if tot_guiltM_OD>50
gen tot_guiltPleaF_OD2=tot_guiltPleaF_OD
replace tot_guiltPleaF_OD2=50 if tot_guiltPleaF_OD>50
gen tot_guiltPleaM_OD2=tot_guiltPleaM_OD
replace tot_guiltPleaM_OD2=50 if tot_guiltPleaM_OD>50
replace guiltPlea_OD=1 if negStip1==1
replace guilt_OD=1 if negStip1==1

	
** clean up recidivism variables
gen AD_arr_eva=AD_arrest>0
gen PT_arr_eva=PT_arrest>0
gen PT_ass_rob=(PT_assault>0 | PT_robbery>0)

** replace bailDate
replace bailDate=bailSetDate if bailDate==.

** add mean zip income
merge m:1 zip using "~/Dropbox/Projects/Bail/Phila/PhillyZipIncome.dta"
drop if _merge==2
drop _merge

* zip code income
gen incZip="$0-$47,000" if mean_agi<=46698.52
replace incZip="$47,000-$67,000" if mean_agi<=66961.84 & mean_agi>46698.52
replace incZip="$67,000-$290,000" if mean_agi>66961.84 & mean_agi!=.

* unique case identifier
tostring dob, gen(DOB)
gen DC_DOB=DOB+""+DC
duplicates tag DC_DOB, gen(dup_DC)
sort DC_DOB dockYear docket
bysort  DC_DOB: gen ord_DC=_n

***********************************

drop if bailDate>=td("18feb2013")
drop if docket==""

***********************************
***********************************
* build judge predictions
***********************************
save "~/Dropbox/Projects/Bail/Phila/Working/bailInfo_working.dta", replace
do "~/Dropbox/Projects/Bail/Phila/Working/judge_predictions2.do"
***********************************

* merge in predictions
merge m:1 day11 dockYear using "~/Dropbox/Projects/Bail/Phila/Working/judge_predict.dta", nogen update
drop if docket==""

* build predicted judge
gen judge_pre=""
replace judge_pre=pred_grave if grave==1
replace judge_pre=pred_evening if evening==1
replace judge_pre=pred_morning if morning==1

* generate variable for work shifts
encode judge_pre, gen(shift)

* fix predicted judges for different eras
replace judge_pre="Abe Polokoff" if judge_pre=="Jane M. Rice" & bailDate<=td(23feb2009)
replace judge_pre="Dwain E. Hill" if judge_pre=="Sheila M. Bedford" & bailDate<=td(21feb2008)
* Devlin was appointed sometime before Jan 2014 and after Feb 18 2013
replace judge_pre="Devlin" if judge_pre=="Timothy P. O'Brien" & bailDate>=td(18feb2013)

* indicators for era
gen AbeDwain=bailDate<=td(23feb2009)
gen Dwain=bailDate<=td(21feb2008)
gen Devlin=bailDate>=td(18feb2013)
gen mainEra=bailDate<td(18feb2013)& bailDate>td(23feb2009)
gen pre07=dockYear<2007
gen preSep06=  bailDate<td(13sep2006) 

* judge dummies
gen Abe=judge_pre=="Abe Polokoff"
gen DwainE=judge_pre=="Dwain E. Hill"
gen James=judge_pre=="James O'Brien"
gen Jane=judge_pre=="Jane M. Rice"
gen Patrick=judge_pre=="Patrick Stack"
gen Sheila=judge_pre=="Sheila M. Bedford"
gen Timothy=judge_pre=="Timothy P. O'Brien"
gen Francis=judge_pre=="Francis J. Rebstock"

* look at different subsamples
gen keep=1 if bailDate<td("18feb2013") &  bailDate>td("23feb2009")
gen keep2= 1
replace keep2=. if bailDate>td("18feb2013")
replace keep2=. if bailDate<=td("23feb2009")& (judge_pre=="Dwain E. Hill" | judge_pre=="Sheila M. Bedford")
gen keep3=bailDate>td(13sep2006) 



* percent working as scheduled
gen asScheduled=judgeName==judge_pre
tab asScheduled if missing!=1 & dockYear>=2007



* make fixed effects
tab judge_pre, gen(judge_pre_)
tab judgeName, gen(judge_)
tab dockYear, gen(dockYear_)
tab bailDOW, gen(bailDOW_)


*************************************
*** globals
*************************************
* define globals
global judge judge_1 judge_2 judge_3 judge_4 judge_5 judge_6 judge_7 judge_8 judge_9
global demo black age  male white asian
global off tot_off tot_fel tot_mis tot_sum fel mis sum 
global prior priorCases prior_felChar_O prior_assault_O prior_drug_O prior_robbery_O prior_guilt_O onePrior threePriors
global covLim black  male priorCases prior_felChar_O prior_assault_O prior_drug_O prior_robbery_O prior_guilt_O
global covFel black age  male priorCases prior_felChar_O prior_assault_O prior_drug_O prior_robbery_O prior_guilt_O tot_fel tot_mis  has_mis tot_off  aggAssault burglary DUI reckless mischief  theft robbery
global covMis black age  male priorCases prior_felChar_O prior_assault_O prior_drug_O prior_robbery_O prior_guilt_O  tot_mis  tot_off   DUI reckless mischief theft 
global covEv assault aggAssault burglary robbery arson theft rape murder
global judge_pre Abe DwainE James Jane Patrick Sheila Timothy Francis
global dYear  dockYear_1 dockYear_2 dockYear_3 dockYear_4 dockYear_5 dockYear_6
global time month_1 month_2 month_3 month_4 month_5 month_6 month_7 month_8 month_9 month_10 month_11 month_12 day_1 day_2 day_3 day_4 day_5 day_6 day_7 year_1 year_2 year_3 year_4 year_5
global judge_F judge_F_1 judge_F_2 judge_F_3 judge_F_4 judge_F_5 judge_F_6 judge_F_7 judge_F_8 judge_F_9 judge_F_10 judge_F_11 judge_F_12
global judge_M judge_M_1 judge_M_2 judge_M_3 judge_M_4 judge_M_5 judge_M_6 judge_M_7
global judge_B judge_B_2 judge_B_3 judge_B_4 judge_B_5 judge_B_6 judge_B_7 judge_B_8 judge_B_9 judge_B_10 judge_B_11 judge_B_12
global judge_fk judge_fk_1 judge_fk_2 judge_fk_3 judge_fk_4 judge_fk_5 judge_fk_6 judge_fk_7 judge_fk_8
global judge_fk2  judge_fk2_1 judge_fk2_2 judge_fk2_3 judge_fk2_4 judge_fk2_5 judge_fk2_6 judge_fk2_7 judge_fk2_8
global dow bailDOW_1 bailDOW_2 bailDOW_3 bailDOW_4 bailDOW_5 bailDOW_6 bailDOW_7
global ev (assault==1 | theft==1 | robbery==1 | burglary==1  | arson==1)
global ev_strict (assault==1 | theft==1 | robbery==1 | burglary==1  | arson==1) & (DUI!=1 & drug!=1 & driveCrime!=1 & firearms!=1)
global possess (DUI==1 | drug==1 | driveCrime==1 | firearms==1) & (assault!=1 & theft!=1 & robbery!=1 & burglary!=1)
global judge_pre_early judge_pre_1_early judge_pre_2_early judge_pre_3_early judge_pre_4_early judge_pre_5_early judge_pre_6_early judge_pre_7_early judge_pre_8_early 
global judge_pre_main2 judge_pre_1_main2 judge_pre_2_main2 judge_pre_3_main2 judge_pre_4_main2 judge_pre_5_main2 judge_pre_6_main2 judge_pre_7_main2 judge_pre_8_main2
global offDum AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CrimTresEnterStructure CrimMischief DUIGenImpIncof1stOff FANotToBeCarriedWOLicense HarassWithPhysicalContact IntPossContrSubstByPerNotReg PossInstrumentOfCrimeWInt ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph
global UCR crimHom rape robbery aggAss burglary larceny MVtheft arson simpAssault forgery fraud stolProp vandal weapon prost sexOff drug gamble family DUI liquor drunk disorderly vagrancy intim accident arrPriorReq catastrophe conspiracy prisoner trespass terror contempt corruptMinors crimCom driveCrim falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk


* generate new judge effects for the early era
foreach x in $judge_pre {
	gen `x'_early=`x'* AbeDwain
}

* generate new judge effects for second half of main Era
gen main2= bailDate>td("23feb2011") & bailDate<td("18feb2013")
foreach x in $judge_pre {
	gen `x'_main2=`x'* main2
}

* indicator for missing covariates
gen missCov=0
foreach x in $demo $off $prior $UCR {
	replace missCov=1 if `x'==.
}




**********************************
****** guess the missing judges
**********************************

/*
* clean up missing bail dates
sort dockYear docket
replace bailDate=bailDate[_n-1] if bailDate==. & bailDate[_n-1] == bailDate[_n+1]
replace bailDate=bailDate[_n-1] if bailDate==. & (bailDate[_n-1] == bailDate[_n+1]| bailDate[_n+1]==.)
replace bailDate=bailDate[_n-1] if bailDate==. 

* simulate the shifts 
 sort bailDate docket
 bysort bailDate: gen n=_n
 bysort bailDate: egen dailyTot=max(n)
 gen fk_grave=n<(dailyTot/3)
 gen fk_morning=n>=(dailyTot/3) & n<2*(dailyTot/3)
 gen fk_eve=n>=(2*(dailyTot/3))

    
* fill in the missing judges 
gen judge_fk=judge_pre
replace judge_fk=pred_grave if fk_grave==1 & bailDate<td(13sep2006) 
replace judge_fk=pred_evening if fk_eve==1 & bailDate<td(13sep2006) 
replace judge_fk=pred_morning if fk_morning==1 & bailDate<td(13sep2006) 
* fix predicted judges for different eras
replace judge_fk="Abe Polokoff" if judge_fk=="Jane M. Rice" & bailDate<=td(23feb2009)
replace judge_fk="Dwain E. Hill" if judge_fk=="Sheila M. Bedford" & bailDate<=td(21feb2008)
tab judge_fk, gen(judge_fk_)


 * generate a variable with all missing judges 
gen judge_fk2=pred_grave if fk_grave==1 
replace judge_fk2=pred_evening if fk_eve==1 
replace judge_fk2=pred_morning if fk_morning==1 
* fix predicted judges for different eras
replace judge_fk2="Abe Polokoff" if judge_fk2=="Jane M. Rice" & bailDate<=td(23feb2009)
replace judge_fk2="Dwain E. Hill" if judge_fk2=="Sheila M. Bedford" & bailDate<=td(21feb2008)
tab judge_fk2, gen(judge_fk2_)


* see how many of the predicted judges are correct
gen asPred=judge_fk2==judge_pre
tab asPred if dockYear>=2007
gen asSched2=judge_fk2==judgeName
tab asSched2 if dockYear>=2007


*/

**********************************
****** label variables
**********************************
la var jail3 "Pre Trial Detention"
la var black "African-American"
la var male Male
la var age Age
la var aggAss "Agg. Assault Charge"
la var burglary "Burglary Charge"
la var DUI DUI
la var reckless "Reckless Misconduct"

la var robbery "Robbery Charge"
la var drug "Drug Charge"
la var priorCases "Num. prior Cases"
la var fel "Felony Charge"
la var tot_fel "Total Felony Charges"
la var tot_mis "Total Misd. Charges"
la var white Caucasian
la var age2 "Age squared"
la var age3 "Age cubed"
*la var firstBailAmt "Bail amount"
la var guiltPlea_O "Pled to at least one charge"
la var guilt_O "Guilty of at least one charge"
la var trial "Went to trial"
la var allDrop "All charges dropped"
la var prior_felChar_O "Prior felony cases"
la var prior_assault_O "Prior assault cases"
la var prior_robbery_O "Prior robbery cases"
la var prior_drug_O "Prior drug cases"
la var prior_guilt_O "Prior guilty cases"
la var feeTot3 "Court fees"
la var notGuilt_O "Not guilty"
la var ptd "Days in pre-trial detention"
la var tot_off "Total charges"
la var fel "Has felony charge"
la var has_mis "Has misdemeanor"
la var guiltPlea_OD "Guilty Plea"

*************************************
*** clean offense covariates
*************************************
/*
* look at missing values for each
foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CorruptionOfMinors CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingManufDelPossW CrimConsEngagingMurder CrimConsEngagingRobberyInflict CrimConsEngagingTheft CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff DisorderlyConduct EndangeringWelfareOfChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel PersonNotToPossessUseFA PossInstrumentOfCrimeWInt ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SecureExecutionDocsByDeception SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
gen miss= `x'==. 
egen `x'm=total(miss)
drop miss 
}


* drop the missing variable testers
foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CorruptionOfMinors CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingManufDelPossW CrimConsEngagingMurder CrimConsEngagingRobberyInflict CrimConsEngagingTheft CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff DisorderlyConduct EndangeringWelfareOfChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel PersonNotToPossessUseFA PossInstrumentOfCrimeWInt ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SecureExecutionDocsByDeception SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
drop `x'm
}

* drop those which don't have at least 500 obs every year
drop SecureExecutionDocsByDeception ManufDelPossWIntManufOrDel PersonNotToPossessUseFA ManufDelPossWIntManufOrDel ForgeryAlterWriting FalseImprisonment EndangeringWelfareOfChildren DisorderlyConduct CrimSolProstituteOf CrimConsEngagingTheft CrimConsEngagingRobberyInflict CrimConsEngagingMurder CrimConsEngagingManufDelPossW CrimConsEngagingAggrAssault CrimAtmptTheftTakingMovable CrimAtmptMurder CorruptionOfMinors
drop BadChecks CrimConsEngagingBurglary IdentityTheft PossOfMarijuana PossOfFirearmByMinor StalkCommitActsToCauseFear CrimUseOfCommunicationFacility EndangeringWelfareofChildren HarassCommLewdThreatening ConsManufDelPossWIntManufOrDel ConsManuDelorPoss ConsRobberyInflictSBI DrivWhileOperPrivSuspOrRevoked ManuDelorPossIntent ConsAggrAssault ConsBurglary PossOfFirearmProhibited BurglaryOvernightAccomPerson Cons CrimTresBreakIntoStructure CrimSolProstitute RobberyInflictThreatImmBodInj


*/
* replace missing with zero for cases that don't have any of the key observations
foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CrimTresEnterStructure CrimMischief DUIGenImpIncof1stOff FANotToBeCarriedWOLicense HarassWithPhysicalContact IntPossContrSubstByPerNotReg PossInstrumentOfCrimeWInt ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
	replace `x'=0 if `x'==. & tot_off!=.
}

* generate originals for offense type
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
gen `x'_orig=`x'
}



**** generate lead charge variable

* murder
foreach x in   rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if murder==1
}

* rape
foreach x in  murder statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if rape==1
}

* pedophile
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if pedophile==1
}



* robbery 
foreach x in  murder rape statRape  aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if robbery==1
}

* burglary
foreach x in  murder rape statRape robbery aggAss aggIndAss  theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if burglary==1
}


* aggAss
foreach x in  murder rape statRape robbery  aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if aggAss==1
}

* arson
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift  simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if arson==1
}

* falseImprison
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom  falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if falseImprison==1
}


* intim
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy  accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if intim==1
}


* F2 firearm
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar  F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if F2firearm==1
}

* stat rape
foreach x in  murder rape  robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if statRape==1
}



* F3 firearm
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm  stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if F3firearm==1
}

** M1 crimes
* prost
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon  john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if prost==1
}

* john
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost  pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if john==1
}



* stalk
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest   MVtheft {
replace `x'=0 if stalk==1
}


** selling
* drugSell
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess  drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if drugSell==1
}

* sellgun
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if sellGun==1
}





*** drug crimes


* drugBuy
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell  possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if drugBuy==1
}

* possess
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault  drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if possess==1
}

* possMar
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy  F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if possMar==1
}






*** theft 
* shoplift
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft  arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if shopLift==1
}

* MVtheft
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm  vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk   {
replace `x'=0 if MVtheft==1
}


* theft
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary  shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if theft==1
}


* stolProp
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm  vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if stolProp==1
}


*** miscellaneous

* resist arrest
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger  stalk  MVtheft {
replace `x'=0 if resistArrest==1
}


* fleeOfficer
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport  sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if fleeOfficer==1
}

* false report
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison  fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if falseReport==1
}

* trespass
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if trespass==1
}

* DUI1st
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family  DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if DUI1st==1
}

* DUI2nd
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st  disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if DUI2nd==1
}

* simple assault
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson  possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if simpAssault==1
}


* vandal
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp  weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if vandal==1
}

* weapon
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal  prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if weapon==1
}

* disorderly
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd  vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if disorderly==1
}

* vagrancy
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly  intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if vagrancy==1
}

* accident
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim  trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
replace `x'=0 if accident==1
}


* 
foreach x in  murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft {
tab `x'
}

************************
** build interactions
************************


foreach y in  $UCR2_main black age female priorCases prior_felChar_O onePrior threePriors{
foreach x in $judge_pre {
gen `x'_`y'=`x'*`y'
}
}

foreach y in   $UCR2_main black age female priorCases prior_felChar_O onePrior threePriors{
foreach x in AbeDwain Dwain {
gen `x'_`y'=`x'*`y'
}
}




** predicted values
reg jail3 $demo $off $prior $UCR2 AbeDwain Dwain
predict jail3_hat
reg guilt_O $demo $off $prior $UCR2 AbeDwain Dwain
predict guilt_hat
reg guiltPlea_O $demo $off $prior $UCR2 AbeDwain Dwain
predict guiltPlea_hat
***********************************
save "~/Dropbox/Projects/Bail/Phila/Working/bailInfo_working.dta", replace
***********************************

