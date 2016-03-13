*2005 2007 2008 2009 2010 2011 2012 2013 2014 2015 

foreach jj in  2006  2007 2008 2009 2010 2011 2012 2013 2014 2015 {

	cd "~/Dropbox/Projects/Bail/Phila/`jj'/"

	use "~/Dropbox/Projects/Bail/Phila/`jj'/CSR_keep_`jj'.dta",clear


	*******>>>>>
	*drop if j>1000
	*drop if j<50000
	
    drop conLen name DOB  sex race  defAtty  dispJudge DC procStat zip
	* drop keyRow misc misc_1 misc_3 misc_2 misc_4 misc_5 sentType1 sentDesc1 sentType3 sentDesc2 sentDesc3 sentType2 

	*************************************
	*** decode
	*************************************


	***** decode factors
	decode Description2, gen(descrip)
    drop Description2
	decode Disposition, gen(disposition)
    drop Disposition
	foreach x in sentDt sentLen grade  statute docket confine j OTN arrDt dispDt {
		decode `x', gen(`x'S)
		drop `x'
		gen `x'= `x'S
        drop `x'S
	}
	
	foreach x in confine j {
		destring `x', replace
	}
		
	
	* drop useless rows
	drop if statute=="" & grade=="" & descrip=="Empty" & disposition=="" & sentLen=="" & confine==0
	
		

	***************************************
	********* miscellaneous cleaning
	***************************************

	
	* convert dates to date format
	foreach x in arrDt dispDt {
		gen `x'1=date(`x', "MDY")
		drop `x'
		gen `x'=`x'1
		drop `x'1
		format `x' %td
	}
	
	
	*************************************
	*** drop useless rows and variables
	*************************************
	
	*drop Seq_No Statute Description Grade Disposition name DOB notDescrip descrip2 grade2 statute2 Description2
	
	********************************
	** build case indicators
	********************************


	** gen charge indicators
	gen fel=regexm(grade, "^F[0-9]?$")
	gen mis=regexm(grade, "^M[0-9]?$")
	gen sum=regexm(grade, "^S[0-9]?$")
	*gen missGrade=regexm(grade, "^$")

    ****** fill in missing charge classes
	
		* summarize charge grades by descrip and statute
		foreach x in fel mis sum {
			bysort descrip: egen off_`x'=max(`x')
			bysort statute: egen cl_`x'=max(`x')
		}
		
		* replace if the descrip  is consistently a misdemeanor or a felony
			replace fel=1 if fel==0 & off_fel==1 & off_mis!=1 & off_sum!=1 
			replace mis=1 if mis==0 & off_mis==1 & off_fel!=1 & off_sum!=1
			replace sum=1 if sum==0 & off_sum==1 & off_mis!=1 & off_fel!=1
	   
	   * replace if statute is consistently a misdemeanor or a felony
			replace fel=1 if fel==0 & cl_fel==1 & cl_mis!=1 & cl_sum!=1
			replace mis=1 if mis==0 & cl_mis==1 & cl_fel!=1 & cl_sum!=1
			replace sum=1 if sum==0 & cl_sum==1 & cl_mis!=1 & cl_fel!=1
	   
	  
	drop off_fel cl_fel off_mis cl_mis off_sum cl_sum
	
	** gen assault indicators
	gen assault=regexm(descrip, "assault") 
	replace assault=regexm(descrip, "ASSAULT") if assault==0
	replace assault=regexm(descrip, "Assault") if assault==0
	replace assault=regexm(descrip, "Ass.") if assault==0
	replace assault=regexm(descrip, "ASS.") if assault==0
	replace assault=regexm(descrip, "ass.") if assault==0
		*replace assault=regexm(descrip, "Asslt") if assault==0


	** gen robbery indicators
	gen robbery=regexm(descrip, "robbery") 
	replace robbery=regexm(descrip, "Robbery") if robbery==0
	replace robbery=regexm(descrip, "ROBBERY") if robbery==0
	replace robbery=regexm(descrip, "Robb.") if robbery==0
	replace robbery=regexm(descrip, "robb.") if robbery==0
	replace robbery=regexm(descrip, "ROBB.") if robbery==0

	** gen drug indicators
	gen drug=regexm(descrip, "drug") 
	replace drug=regexm(descrip, "Drug") if drug==0
	replace drug=regexm(descrip, "DRUG") if drug==0
	replace drug=regexm(descrip, "Marijuana") if drug==0
	replace drug=regexm(descrip, "MARIJUANA") if drug==0
	replace drug=regexm(descrip, "marijuana") if drug==0
	replace drug=regexm(descrip, "cocaine") if drug==0
	replace drug=regexm(descrip, "Cocaine") if drug==0
	replace drug=regexm(descrip, "COCAINE") if drug==0
	replace drug=regexm(descrip, "meth") if drug==0
	replace drug=regexm(descrip, "Meth") if drug==0
	replace drug=regexm(descrip, "METH") if drug==0
	replace drug=regexm(descrip, "heroin") if drug==0
	replace drug=regexm(descrip, "Heroin") if drug==0
	replace drug=regexm(descrip, "HEROIN") if drug==0
	replace drug=regexm(descrip, "Controlled Sub") if drug==0
	replace drug=regexm(descrip, "controlled sub") if drug==0
	replace drug=regexm(descrip, "CONTROLLED SUB") if drug==0
	
	replace drug=regexm(descrip, "CSA") if drug==0
	replace drug=regexm(descrip, "Manuf*.Del") if drug==0
	replace drug=regexm(descrip, "narcotic") if drug==0
	replace drug=regexm(descrip, "Narcotic") if drug==0
	replace drug=regexm(descrip, "NARCOTIC") if drug==0

	

	* type of disposition
	gen guiltPlea=regexm(disposition, "Plea")
	replace guiltPlea=regexm(disposition, "Nolo Contendere") if guiltPlea==0
	replace guiltPlea=regexm(disposition, "Without Verdict") if guiltPlea==0
    gen notGuilt=regexm(disposition, "Not Guilt")
	replace notGuilt=regexm(disposition, "Acquittal") if notGuilt==0
	gen guilt=regexm(disposition, "Guilt")
	replace guilt=1 if guiltPlea==1
	replace guilt=0 if notGuilt==1
	gen held=regexm(disposition, "Held for Court")
	gen dropped=regexm(disposition, "Dismissed")
	replace dropped=regexm(disposition, "Quashed") if dropped==0
	replace dropped=regexm(disposition, "Nolle Prossed") if dropped==0
	replace dropped=regexm(disposition, "Withdrawn") if dropped==0
	gen ARD=regexm(disposition, "ARD")
	gen IGC=regexm(disposition, "IGC")
	
	**
	gen guiltF=guilt*fel
	gen guiltM=guilt*mis
	gen guiltPleaF=guiltPlea*fel
	gen guiltPleaM=guiltPlea*mis
	
/*
	* look in sentLen as well
	replace guiltPlea=regexm(sentLenS, "Plea") if guiltPlea==0
	replace guiltPlea=regexm(sentLenS, "Nolo Contendere") if guiltPlea==0
	replace guiltPlea=regexm(sentLenS, "Without Verdict") if guiltPlea==0
    replace notGuilt=regexm(sentLenS, "Not Guilt") if notGuilt==0
	replace notGuilt=regexm(sentLenS, "Acquittal") if notGuilt==0
	replace guilt=regexm(sentLenS, "Guilt") if guilt==0
	replace guilt=1 if guiltPlea==1
	replace guilt=0 if notGuilt==1
	replace held=regexm(sentLenS, "Held for Court") if held==0
	replace dropped=regexm(sentLenS, "Dismissed") if dropped==0
	replace dropped=regexm(sentLenS, "Quashed") if dropped==0
	replace dropped=regexm(sentLenS, "Nolle Prossed") if dropped==0
	replace dropped=regexm(sentLenS, "Withdrawn") if dropped==0
	replace ARD=regexm(sentLenS, "ARD") if ARD==0
	replace IGC=regexm(sentLenS, "IGC") if IGC==0
*/
	
	***>>>>> fix acquittal prior to disposition


	********************************
	** summarize case indicators by OTN
	********************************
	
	gen OTN2=OTN
	replace OTN2=docket if OTN2=="Empty"


	** type of charges
	bysort OTN2 : egen felChar_O=max(fel)
	bysort OTN2 : egen misChar_O=max(mis)
	bysort OTN2 : egen sumChar_O=max(sum)
	*bysort OTN2 : egen missingChar_O=max(missGrade)
	

	bysort OTN2: egen guiltF_O=max(guiltF)
	bysort OTN2: egen guiltM_O=max(guiltM)
	bysort OTN2: egen guiltPleaF_O=max(guiltPleaF)
	bysort OTN2: egen guiltPleaM_O=max(guiltPleaM)
	bysort OTN2: egen tot_guiltF_O=total(guiltF)
	bysort OTN2: egen tot_guiltM_O=total(guiltM)
	bysort OTN2: egen tot_guiltPleaF_O=total(guiltPleaF)
	bysort OTN2: egen tot_guiltPleaM_O=total(guiltPleaM)

	** drug, assault robbery charges
	foreach x in assault drug robbery  {
		bysort OTN2 : egen `x'_O=max(`x')
	}

	* Disposition
	foreach x in notGuilt guilt guiltPlea held dropped ARD IGC {
		bysort OTN2 : egen `x'_O=max(`x')
	}


	* drop duplicates
	drop descrip disposition sentDt sentLen grade statute confine  fel mis sum assault robbery drug guiltPlea notGuilt guilt held dropped ARD IGC OTN  guiltF guiltM guiltPleaF guiltPleaM

	duplicates drop
	
	* clean up missing dates
	bysort OTN2: egen maxDispDt=max(dispDt)
	replace dispDt=maxDispDt
	drop maxDispDt
	bysort OTN2: egen minArrDt=max(arrDt)
	replace arrDt=minArrDt
	drop minArrDt
	
	
	* get rid of CP entries for Philadelphia
	gen year  = real(substr(docket,-4,4))
	gen county  = real(substr(docket,4,2))
	gen typeCase = substr(docket,7,2)
	gen MC = substr(docket,1,2)
	drop if county==51 & MC=="CP"


	duplicates drop j OTN2, force


	*************************************
	** look at priors and recidivism
	*************************************

	/*
	* estimate arrest and disposition dates
	gen noArrDt=arrDt==.
	gen noDispDt=dispDt==.

	replace arrDt=dispDt-150 if arrDt==. & dispDt!=.
	replace dispDt=arrDt+150 if dispDt==. & arrDt!=.
	*/
	

	
	*************************************
	** prior cases
	*************************************


	gen priorCases=0
	sort j arrDt
	forvalues x = 1/100 {
		replace priorCases=priorCases+1 if (arrDt[_n-`x']<arrDt[_n])   & j[_n]==j[_n-`x'] &  arrDt[_n-`x']!=.  & arrDt[_n]!=.
	}
	
	foreach z in felChar_O assault_O drug_O robbery_O guilt_O {
		gen prior_`z'=0
		sort j arrDt
		forvalues x = 1/100 {
			replace prior_`z'=prior_`z'+1 if  `z'[_n-`x']==1 & (arrDt[_n-`x']<arrDt[_n])   & j[_n]==j[_n-`x'] &  arrDt[_n-`x']!=.  & arrDt[_n]!=.
		}
	}
	
	
		
		
	*************************************
	** arrests during pre-trial period
	*************************************


		
	gen PT_arrest=0
	sort j arrDt
	forvalues x = 1/100 {
		replace PT_arrest=PT_arrest+1 if (arrDt[_n+`x']>arrDt[_n])  & (arrDt[_n+`x']<dispDt[_n])  & j[_n]==j[_n+`x'] & dispDt[_n]!=. & arrDt[_n+`x']!=.  & arrDt[_n]!=.
	}
	
	foreach z in felChar_O assault_O drug_O robbery_O guilt_O {
		gen PT_`z'=0
		sort j arrDt
		forvalues x = 1/100 {
			replace PT_`z'=PT_`z'+1 if  `z'[_n+`x']==1 &(arrDt[_n+`x']>arrDt[_n])  & (arrDt[_n+`x']<dispDt[_n])  & j[_n]==j[_n+`x'] & dispDt[_n]!=. & arrDt[_n+`x']!=.& arrDt[_n]!=.
		}
	}
	
	*************************************
	** arrests after disposition
	*************************************
	
	
	gen AD_arrest=0
	sort j arrDt
	forvalues x = 1/100 {
		replace AD_arrest=AD_arrest+1 if (arrDt[_n+`x']>dispDt[_n])  & j[_n]==j[_n+`x'] & dispDt[_n]!=. & arrDt[_n+`x']!=.
	}
	
	
	foreach z in felChar_O assault_O drug_O robbery_O guilt_O {
		gen AD_`z'=0
		sort j arrDt
		forvalues x = 1/100 {
			replace AD_`z'=AD_`z'+1 if `z'[_n+`x']==1 & (arrDt[_n+`x']>dispDt[_n])  & j[_n]==j[_n+`x'] & dispDt[_n]!=. & arrDt[_n+`x']!=.
		}
	}



	
	*************************************
	** clean up and save
	*************************************
	
	** keep only 
	keep if year>=2006 & year<=2013
	keep if county==51
	keep if typeCase=="CR"
	keep if MC=="MC"
	drop year county typeCase MC

	
	
	*keep docket priorCases CP_O prior_felChar_O prior_assault_O prior_drug_O prior_robbery_O prior_CP_O prior_guilt_O
	*duplicates drop 
drop   dispDt arrDt felChar_O misChar_O sumChar_O guiltF_O guiltM_O guiltPleaF_O guiltPleaM_O tot_guiltF_O tot_guiltM_O tot_guiltPleaF_O tot_guiltPleaM_O assault_O drug_O robbery_O notGuilt_O guilt_O guiltPlea_O held_O dropped_O ARD_O IGC_O
	
duplicates drop docket, force

	
	
	********************************
	save "~/Dropbox/Projects/Bail/Phila/`jj'/CSR_priorCharges_`jj'.dta", replace
	********************************



	********************************

}


	*save "~/Dropbox/Projects/Bail/Phila/2006/CSR_priorCharges_2006.dta", replace


