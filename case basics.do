


**** pull just the basic case info
foreach jj in  2006  2007 2008 2009 2010 2011 2012 2013 2014 2015 {

	cd "~/Dropbox/Projects/Bail/Phila/`jj'/"

	use "~/Dropbox/Projects/Bail/Phila/`jj'/CSR_keep_`jj'.dta",clear


	keep name DOB docket sex race arrDt defAtty dispDt dispJudge OTN DC procStat OTN zip 
	duplicates drop
	
	* decode docket
	foreach x in  docket {
		decode `x', gen(`x'S)
		drop `x'
		gen `x'= `x'S
        drop `x'S
	}
	
	
	** keep only relevant docket info
	gen year  = real(substr(docket,-4,4))
	keep if year>=`jj'
	gen county  = real(substr(docket,4,2))
	keep if county==51
	gen typeCase = substr(docket,7,2)
	keep if typeCase=="CR"


	drop typeCase county   
	

	* decode the rest
	foreach x in name DOB sex race arrDt defAtty dispDt dispJudge OTN DC procStat  zip  {
		decode `x', gen(`x'S)
		drop `x'
		gen `x'= `x'S
        drop `x'S
	}
        rename DOB dob
		
			

	
	* convert dates to date format
	foreach x in arrDt dispDt {
		gen `x'1=date(`x', "MDY")
		drop `x'
		gen `x'=`x'1
		drop `x'1
		format `x' %td
	}
	

	********************************
	* merge	in orignal docket number in order to get final disposition date
	********************************
	
	
	foreach zz in 2006  2007 2008 2009 2010 2011 2012 2013 2014 2015 {
		merge m:1 docket using "~/Dropbox/Projects/Bail/Phila/`zz'/orig_`zz'.dta", keepusing(origDocket) gen(_merge_`zz') update
		replace origDocket="" if origDocket=="Empty" | origDocket=="NA"
		drop if _merge_`zz'==2
	}
	drop _merge*
	replace origDocket=docket if origDocket==""
	
	* replace final disposition dates with the CP disposition date 	
	bysort origDocket: egen maxDispDt=max(dispDt)
	replace dispDt=maxDispDt
	drop maxDispDt
	bysort origDocket: egen minArrDt=max(arrDt)
	replace arrDt=minArrDt
	drop minArrDt
	
	*** fill in info that might be missing on the MC docket with info from the CP docket
	foreach x in defAtty  dispJudge OTN DC procStat {
		sort docket `x'
		bysort docket: replace `x'=`x'[_n+1] if `x'==""
	}
	*** do again!
	foreach x in defAtty  dispJudge OTN DC procStat {
		sort docket `x'
		bysort docket: replace `x'=`x'[_n+1] if `x'==""
	}
	*** do again!
	foreach x in defAtty  dispJudge OTN DC procStat {
		sort docket `x'
		bysort docket: replace `x'=`x'[_n+1] if `x'==""
		duplicates drop
	}
		
	
	
	duplicates drop docket, force
	save  caseBasics_`jj'.dta, replace
}
	
	
	
	
