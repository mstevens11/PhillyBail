** now using git hub!!

use "~/Dropbox/Projects/Bail/Phila/2006/bailInfo2_2006.dta", clear

foreach jj in  2007 2008 2009 2010 2011 2012 2013 {
    append using "~/Dropbox/Projects/Bail/Phila/`jj'/bailInfo2_`jj'.dta"
}

	* keep track of order
	gen n=_n

	***>>>>
	*drop if n<200000 | n>250000
	

	gen dockYear=real(substr(docket, -4,4))
	drop if dockYear>=2014

	/* For each docket:
	need to get date bail was set and date it was posted
	need to get an indicator for whether or not it was ever posted	
	need to get an indicator for if that person was let out free

	*/
		
	* make one single date variable
		gen dateBoth= .
		gen posted=0
		gen set=0
		gen outFree=0
		gen bailAmt=""

	* search the different columns for important information
    foreach x in V100 V4 V6 V8 V9 postingStatus docket V3 V10 V5 V7 V14 V13 V11 V15 V16 V12 V17 Nebbia_Status___None postDate_1 bailAction bailType percentage amount V2 date postDate {
        replace dateBoth=date(`x', "MDY")  if dateBoth==.
        replace posted=regexm(`x', "Posted") if posted==0
        replace set=regexm(`x', "^Set$") if set==0
        replace outFree=regexm(`x', "Nonmonetary") if outFree==0
        replace outFree=regexm(`x', "Nominal") if outFree==0
        replace outFree=regexm(`x', "Unsecured") if outFree==0
        replace outFree=regexm(`x', "ROR") if outFree==0
        replace bailAmt=`x'  if regexm(`x', "\\$")==1 & bailAmt==""  
	}

    * clean up variables 
    format dateBoth %td
    destring bailAmt, replace force ig("$",",",".")
    replace bailAmt=bailAmt/100
    
	* find the first entry date in the bail section
	bysort docket: egen minDateBoth=min(dateBoth)
    format minDateBoth %td
	
    * find first bail amount
    gen bail_n=dateBoth if bailAmt!=.
	format bail_n %td
    bysort docket: egen firstBail=min(bail_n)
	format firstBail %td
    gen firstBailAmt2=bailAmt if firstBail==bail_n
    bysort docket: egen firstBailAmt=min(firstBailAmt2)
	drop firstBailAmt2 bail_n firstBail


    * build variable for the first bail date shown in bail section of docket
    bysort docket: egen bailSetDock=min(dateBoth)
	format bailSetDock %td
	la var bailSetDock "First date that shows up in the bail section of the docket"
	
	
	*************** define release reasons
	
	* indicator for being let free initially
    gen outFreeI=(outFree==1 & dateBoth==bailSetDock)
    bysort docket: egen ROR=max(outFreeI)
	la var ROR "ROR at first date on the bail section of the docket"


	*** build a dummy for getting released
	gen out=1 if outFree==1 | posted==1
    bysort docket: egen everOut=max(out)

    ** find first release date
	gen outDate=out*dateBoth
    bysort docket: egen relDate=min(outDate)
	format relDate %td
	drop outDate

    /*
    * indicator for later ROR
	gen laterROR=outFree==1 & outFreeI!=1
	gen dateLateROR1=dateBoth if laterROR==1
	     * select the first ROR
    bysort docket: egen dateLateROR=min(dateLateROR1)
	drop dateLateROR1

	* indicator for bail posted
	gen postBail= posted==1 & ROR!=1 & laterROR!=1
    gen datePostBail1=dateBoth if postBail==1
    bysort docket: egen datePostBail=min(datePostBail1)
	drop datePostBail1
	
	*************** figure out release date

	*** build a dummy for getting released
	gen out=1 if outFreeI==1 | laterROR==1 | postBail==1
	
	** pick up here figuring out why date post bail is not correct
		
	** figure out release date - put in all release dates and take the first one per docket
	gen outDate=bailSetDock if ROR==1
	replace outDate=dateLateROR  if laterROR==1
	replace outDate=datePostBail  if postBail==1
	bysort docket: egen relDate=min(outDate)
	format relDate %td
	drop outDate

	*** build the release reason variable
	gen postOut=relDate==postDate2 & relDate!=. & posted==1
	bysort docket: egen postOut2=max(postOut)
	gen lateROROut=relDate==dateLateROR & relDate!=. & laterROR==1
	bysort docket: egen lateROROut2=max(lateROROut)

	gen relReason="Never out" if relDate==.
	replace relReason="Posted bail" if postOut2==1
	replace relReason="ROR" if ROR==1
	replace relReason="Late ROR" if lateROROut2==1

	 

	/*
	   * out free immediately
		gen ptd=0 if outFreeI==1
		gen relDate=bailSetDate if outFreeI==1
		format relDate %td

		
		* late ROR
		replace ptd=time2lateROR if dateLateROR!=. & ptd==.
		replace relDate=dateLateROR if dateLateROR!=. & relDate==. & ptd!=.

		* posted bail
		replace ptd=time2Posted if datePosted!=. & ptd==.
		replace relDate=datePosted if datePosted!=. & relDate==. & ptd!=.
		replace relDate=datePosted if datePosted<relDate & relDate==.
		** see which comes first, time till posted or time till ROR
		bysort docket: egen everROR=max(outFree)
		bysort docket: egen everPost=max(posted)
		
		* never posted
		replace ptd=9999999 if everROR==0 & everPost==0 & ptd==.
		replace relDate=9999999 if everROR==0 & everPost==0 & relDate==. 


		bysort docket: egen days=min(ptd)


		gen relReason="Out Free Immediately" if outFreeI==1
		replace relReason="Never Posted" if everROR==0 & everPost==0 
		replace relReason="Eventual ROR" if dateLateROR!=. 
		replace relReason="Posted Bail" if datePosted!=. & datePosted<dateLateROR

	*/	
	*/	

	keep docket  relDate everOut firstBailAmt ROR bailSetDock

	duplicates drop 


	save "~/Dropbox/Projects/Bail/Phila/Working/bailData.dta", replace




