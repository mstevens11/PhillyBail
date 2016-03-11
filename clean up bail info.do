** now using git hub!!

use "~/Dropbox/Projects/Bail/Phila/2005/bailInfo2_2005.dta", clear

foreach jj in 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015{
    append using "~/Dropbox/Projects/Bail/Phila/`jj'/bailInfo2_`jj'.dta"
}

* keep track of order
gen n=_n

* format dates
    foreach x in date postDate {
        gen `x'1=date(`x', "MDY")
        drop `x'
        gen `x'=`x'1
        format `x' %td
        drop `x'1
    }

gen dockYear=real(substr(docket, -4,4))
drop if dockYear>=2014

/* For each docket:
need to get date bail was set and date it was posted
need to get an indicator for whether or not it was ever posted	
need to get an indicator for if that person was let out free

*/
	
* make one single date variable
    gen dateBoth= date
    gen posted=regexm(postingStatus, "Posted")
    gen set=regexm(bailAction, "^Set$")
    gen outFree=regexm(bailType, "Nonmonetary")
    replace outFree=regexm(bailType, "Nominal") if outFree==0
    replace outFree=regexm(bailType, "Unsecured") if outFree==0
    replace outFree=regexm(bailType, "ROR") if outFree==0

    foreach x in V100 V4 V6 V8 V9 postingStatus docket V3 V10 V5 V7 V14 V13 V11 V15 V16 V12 V17 Nebbia_Status___None postDate_1 bailAction bailType percentage amount V2  {
        replace dateBoth=date(`x', "MDY")  if dateBoth==.
        replace posted=regexm(`x', "Posted") if posted==0
        replace set=regexm(`x', "^Set$") if set==0
        replace outFree=regexm(`x', "Nonmonetary") if outFree==0
        replace outFree=regexm(`x', "Nominal") if outFree==0
        replace outFree=regexm(`x', "Unsecured") if outFree==0
        replace outFree=regexm(`x', "ROR") if outFree==0
    }

    * clean up dates
    format dateBoth %td
	bysort docket: egen minDateBoth=min(dateBoth)
    format minDateBoth %td

    * clean up bail amounts 
    gen bailAmt=""
    foreach x in V100 V4 V6 V8 V9 postingStatus docket V3 V10 V5 V7 V14 V13 V11 V15 V16 V12 V17 Nebbia_Status___None postDate_1 bailAction bailType percentage amount V2  {
        replace bailAmt=`x'  if regexm(`x', "\\$")==1 & bailAmt==""  
    }
    destring bailAmt, replace force ig("$",",",".")
    replace bailAmt=bailAmt/100
    
    * find first bail amount
    gen bail_n=dateBoth if bailAmt!=.
    bysort docket: egen firstBail=min(bail_n)
    gen firstBailAmt2=bailAmt if firstBail==bail_n
    bysort docket: egen firstBailAmt=min(firstBailAmt2)



** merge in bail start date
foreach x in 2006 2007 2008 2009 2010 2011 2012 2013  {
	merge m:1 docket using "~/Dropbox/Projects/Bail/Phila/`x'/bailInfo_`x'.dta", keepusing(startDate) gen(mer) update replace
    drop if mer==2
    drop mer
}
  
gen bailSetDate=date(startDate, "MDY")
format bailSetDate %td

    * get rid of all later actions that did not result in release
	*drop if outFree==0 & set==0 & posted==0


    bysort docket: egen bailSetFirst=min(dateBoth)
    *replace dateBoth=bailSetDate if dateBoth==.

	* indicator for being let free initially
    gen outFreeI=(outFree==1 & dateBoth==bailSetDate)
    bysort docket: egen ROR=max(outFreeI)

    * indicator for later ROR
	gen laterROR=outFree==1 & outFreeI!=1
	gen dateLateROR1=dateBoth if laterROR==1
    bysort docket: egen dateLateROR=min(dateLateROR1)
    gen time2lateROR=dateLateROR-bailSetDate if dateLateROR!=.


	* date that bail is posted
    gen postDate2=dateBoth if posted==1
    bysort docket: egen datePosted=min(postDate2)
    gen time2Posted=datePosted-bailSetDate if datePosted!=.


*** build the release date variable
gen out=1 if outFreeI==1 | posted==1 | laterROR==1
gen outDate=dateBoth if out==1
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
	

keep docket relReason relDate  firstBailAmt ROR bailSetFirst

duplicates drop 


save "~/Dropbox/Projects/Bail/Phila/Working/bailData.dta", replace




