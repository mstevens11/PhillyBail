*2005 2007 2008 2009 2010 2011 2012 2013 2014 2015 

foreach jj in  2006  2007 2008 2009 2010 2011 2012 2013 2014 2015 {

	cd "~/Dropbox/Projects/Bail/Phila/`jj'/"

	use "~/Dropbox/Projects/Bail/Phila/`jj'/CSR_keep_`jj'.dta",clear


	*******>>>>>
	*
	drop if j>1000
	*drop if j<50000
	
    drop conLen name DOB  sex race  defAtty  dispJudge  procStat zip
	* drop keyRow misc misc_1 misc_3 misc_2 misc_4 misc_5 sentType1 sentDesc1 sentType3 sentDesc2 sentDesc3 sentType2 

	*************************************
	*** decode
	*************************************
	rename grade chargeGrade

	***** decode factors
	decode Description2, gen(offense)
    drop Description2
	decode Disposition, gen(disposition)
    drop Disposition
	foreach x in DC sentDt sentLen chargeGrade  statute docket confine j OTN arrDt dispDt {
		decode `x', gen(`x'S)
		drop `x'
		gen `x'= `x'S
        drop `x'S
	}
	
	foreach x in confine j {
		destring `x', replace
	}
		
	
	*************************************
	*** drop useless rows and variables
	*************************************
	
	drop if statute=="" & chargeGrade=="" & offense=="Empty" & disposition=="" & sentLen=="" & confine==0
	
		

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
	
	

	********************************
	** cleam up offense and charge grade info
	********************************

	* change capital to lower case
	replace offense=lower(offense)
	
		* clean up offense names
	replace offense=lower(offense)
	replace offense=subinstr(offense, "criminal attempt ", "", 1)
	replace offense=subinstr(offense, "criminal conspiracy engaging - ", "", 1)
	replace offense=subinstr(offense, "criminal conspiracy engaging ", "", 1)
	replace offense=subinstr(offense, "criminal conspiracy ", "", 1)
	replace offense=subinstr(offense, "conspiracy ", "", 1)
	replace offense=subinstr(offense, "- ", "", 1)

	replace offense=subinstr(offense, "criminal attempt ", "", 1)
	replace offense=subinstr(offense, "- ", "", 1)



	* clean up chargeGrade
	replace chargeGrade="F3" if offense=="firearms not to be carried w/o license"
	replace chargeGrade="M" if offense=="criminal mischief" & chargeGrade==""
	replace chargeGrade="M" if offense=="int poss contr subst by per not reg" & chargeGrade==""
	replace chargeGrade="F" if regexm(offense, "manufacture, delivery, or possession") & chargeGrade==""
	replace chargeGrade="M1" if regexm(offense, "theft by unlaw taking") & chargeGrade==""
	replace chargeGrade="M1" if regexm(offense, "retail theft") & chargeGrade==""
	replace chargeGrade="M1" if offense=="receiving stolen property" & chargeGrade==""
	replace chargeGrade="F1" if offense=="robbery-inflict serious bodily injury" & chargeGrade==""
	replace chargeGrade="F1" if offense=="robbery-inflict" & chargeGrade==""

	

	** gen charge indicators
	gen fel=regexm(chargeGrade, "^F[0-9]?$")
	gen mis=regexm(chargeGrade, "^M[0-9]?$")
	gen sum=regexm(chargeGrade, "^S[0-9]?$")
	*gen misschargeGrade=regexm(chargeGrade, "^$")

    ****** fill in missing charge classes
	
		* summarize charge chargeGrades by offense and statute
		foreach x in fel mis sum {
			bysort offense: egen off_`x'=max(`x')
			bysort statute: egen cl_`x'=max(`x')
		}
		
		* replace if the offense  is consistently a misdemeanor or a felony
			replace fel=1 if fel==0 & off_fel==1 & off_mis!=1 & off_sum!=1 
			replace mis=1 if mis==0 & off_mis==1 & off_fel!=1 & off_sum!=1
			replace sum=1 if sum==0 & off_sum==1 & off_mis!=1 & off_fel!=1
	   
	   * replace if statute is consistently a misdemeanor or a felony
			replace fel=1 if fel==0 & cl_fel==1 & cl_mis!=1 & cl_sum!=1
			replace mis=1 if mis==0 & cl_mis==1 & cl_fel!=1 & cl_sum!=1
			replace sum=1 if sum==0 & cl_sum==1 & cl_mis!=1 & cl_fel!=1
	   
	  
	drop off_fel cl_fel off_mis cl_mis off_sum cl_sum
	
	

	********************************
	** build offense type indicators
	********************************	
	
	
	
	** gen assault indicators
	gen assault=regexm(offense, "assault") 
	replace assault=regexm(offense, "ass.") if assault==0

	** gen robbery indicators
	gen robbery=regexm(offense, "robbery") 
	replace robbery=regexm(offense, "robb.") if robbery==0

	
	** burglary
	gen burglary=regexm(offense, "burglary")
	
	** murder
	gen murder=regexm(offense, "murder")
	
	** rape
	gen rape=regexm(offense, "rape")
	replace rape=regexm(offense, "idsi") if rape==0


	** witness intimidation
	gen intim=regexm(offense, "witness") 
	replace intim=regexm(offense, "intim") if intim==0
	

	
	
	********************************
	** case outcomes
	********************************
	
	
	* type of disposition
	gen guiltPlea=regexm(disposition, "Plea")
	replace guiltPlea=regexm(disposition, "Nolo Contendere") if guiltPlea==0
	replace guiltPlea=regexm(disposition, "Without Verdict") if guiltPlea==0
	gen guilt=regexm(disposition, "Guilt")
	replace guilt=1 if guiltPlea==1
	gen notGuilt=regexm(disposition, "Not Guilt")
	replace notGuilt=regexm(disposition, "Acquittal") if notGuilt==0
	replace guilt=0 if notGuilt==1
	
	** guilty of felony or misdemeaqnor
	gen guiltF=guilt*fel
	gen guiltM=guilt*mis
	gen guiltPleaF=guiltPlea*fel
	gen guiltPleaM=guiltPlea*mis
	

	********************************
	** summarize case indicators by DC
	********************************
	
	gen DC2=DC
	replace DC2=docket if DC2=="Empty" | DC2==""


	** type of charges
	bysort DC2 : egen felChar_DC=max(fel)
	bysort DC2 : egen misChar_DC=max(mis)
	bysort DC2 : egen sumChar_DC=max(sum)
	

	bysort DC2: egen guiltF_DC=max(guiltF)
	bysort DC2: egen guiltM_DC=max(guiltM)
	bysort DC2: egen guiltPleaF_DC=max(guiltPleaF)
	bysort DC2: egen guiltPleaM_DC=max(guiltPleaM)
	bysort DC2: egen tot_guiltF_DC=total(guiltF)
	bysort DC2: egen tot_guiltM_DC=total(guiltM)
	bysort DC2: egen tot_guiltPleaF_DC=total(guiltPleaF)
	bysort DC2: egen tot_guiltPleaM_DC=total(guiltPleaM)

	** drug, assault robbery charges
	foreach x in assault robbery burglary murder rape intim  {
		bysort DC2 : egen `x'_DC=max(`x')
	}
	gen violCrime_DC=assault_DC==1 | robbery_DC==1 | burglary_DC ==1 | murder_DC==1 | rape_DC==1

	* Disposition
	foreach x in  guilt guiltPlea  {
		bysort DC2 : egen `x'_DC=max(`x')
	}


	* drop duplicates
	drop offense disposition sentDt sentLen chargeGrade statute confine  fel mis sum assault robbery burglary murder rape intim guiltPlea notGuilt guilt   guiltF guiltM guiltPleaF guiltPleaM
	duplicates drop
	
	* clean up missing dates
	bysort DC2: egen maxDispDt=max(dispDt)
	replace dispDt=maxDispDt
	drop maxDispDt
	bysort DC2: egen minArrDt=max(arrDt)
	replace arrDt=minArrDt
	drop minArrDt
	
	
	* add bail date to replace arrest date if arrest date is missing
	foreach x in 2006 2007 2008 2009 2010 2011 2012 2013  {
		merge m:1 docket using "~/Dropbox/Projects/Bail/Phila/`x'/bailInfo_`x'.dta", keepusing(startDate) update replace
		drop if _merge==2
		drop _merge
	}

		
	* convert dates to date format
	foreach x in startDate {
		gen `x'1=date(`x', "MDY")
		drop `x'
		gen `x'=`x'1
		drop `x'1
		format `x' %td
	}
	
	*replace arrest date with bail date if missing
	replace arrDt=startDate if arrDt==.
	
	
	* get rid of CP entries for Philadelphia
	gen year  = real(substr(docket,-4,4))
	gen county  = real(substr(docket,4,2))
	gen typeCase = substr(docket,7,2)
	gen MC = substr(docket,1,2)
	drop if county==51 & MC=="CP"
	drop if typeCase=="SU"
	
	
	* build an indicator for being a focal year
	gen focal=year==`jj'
	
	
	* estimate arrest dates for non focal years
	replace arrDt=dispDt-170 if arrDt==. & focal!=1
	replace dispDt=arrDt+170 if dispDt==. & focal!=1

	* assume start date is the same as consecutively numbered start dates for other dockets in the focal year
	sort year docket
	forvalues y = 1/8 {
		replace arrDt=arrDt[_n-1] if arrDt==. & focal==1
	}

	duplicates drop j DC2, force


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
		replace priorCases=priorCases+1 if                    (arrDt[_n-`x']<arrDt[_n])   & j[_n]==j[_n-`x'] &  arrDt[_n-`x']!=.  & arrDt[_n]!=.
	}
	
	foreach z in felChar_DC violCrime_DC guilt_DC {
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
		replace PT_arrest=PT_arrest+1 if              (arrDt[_n+`x']>arrDt[_n])  & (arrDt[_n+`x']<dispDt[_n])  & j[_n]==j[_n+`x'] & dispDt[_n]!=. & arrDt[_n+`x']!=.  & arrDt[_n]!=.
	}
	
	foreach z in felChar_DC violCrime_DC guilt_DC intim_DC {
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
		replace AD_arrest=AD_arrest+1 if                (arrDt[_n+`x']>dispDt[_n])  & j[_n]==j[_n+`x'] & dispDt[_n]!=. & arrDt[_n+`x']!=.
	}
	
	
	foreach z in felChar_DC violCrime_DC guilt_DC  {
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

	
	
	*keep docket priorCases CP_DC prior_felChar_DC prior_assault_DC prior_drug_DC prior_robbery_DC prior_CP_DC prior_guilt_DC
	*duplicates drop 
drop   dispDt arrDt felChar_DC misChar_DC sumChar_DC guiltF_DC guiltM_DC guiltPleaF_DC guiltPleaM_DC tot_guiltF_DC tot_guiltM_DC tot_guiltPleaF_DC tot_guiltPleaM_DC assault_DC burglary_DC murder_DC rape_DC intim_DC robbery_DC  guilt_DC guiltPlea_DC 
	
duplicates drop docket, force

	
	
	********************************
	save "~/Dropbox/Projects/Bail/Phila/`jj'/CSR_priorCharges_`jj'.dta", replace
	********************************



	********************************

}


	*save "~/Dropbox/Projects/Bail/Phila/2006/CSR_priorCharges_2006.dta", replace


