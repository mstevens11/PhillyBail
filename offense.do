
*
foreach kk in 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 {

         use "~/Dropbox/Projects/Bail/Phila/2006/bailOffense_2006.dta", clear
		 


    gen ones=1
    bysort offense: egen totOff=total(ones)
    tab offense if totOff>100
    distinct offense if totOff>500
    *tab offense if totOff>500, gen(off_)
    distinct offense if totOff>500
    
    encode offense, gen(offenseF)
	
	* 2006 only 150
    dummieslab offenseF if totOff>170, from("Conspiracy" "Manufacture" "Serious Bodily Injury" "Firearms" "Contempt" "Violation" "Criminal Attempt" "By Unlaw" "Taking Movable" "Criminal Solicitation" "Prom Pros Inmate In House Of" "Gen Imp Inc of" "Driving Safely" "Subject Other to" "Harrassment" "Delivery" "Possession" "With Intent to" "Prom Pros" "Inmate In House" "Of Prost Business" "Another Person" "Int To Terrorize Another" "Harassment - " "Etc." "Aggravated" "Criminal" "Stalking - Repeatedly" "Overnight Accommodation") ///
        to("Cons" "Manu" "SBI" "FA" "Cont" "Viol" "CrimAtmpt" "" "TakeMovable" "CrimSol" "Prostitution" "" "" "With" "Harass" "Del" "Poss" "Intent" "Prostitute"  "" "" "" "" "Harass" "" "Aggr" "Crim" "Stalk" "OvernightAccom")

	
	* 2006
	foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CorruptionOfMinors CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingManufDelPossW CrimConsEngagingMurder CrimConsEngagingRobberyInflict CrimConsEngagingTheft CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff DisorderlyConduct EndangeringWelfareOfChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel PersonNotToPossessUseFA PossInstrumentOfCrimeWInt ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SecureExecutionDocsByDeception SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
		bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	
		* 2007
	foreach x in AggrAssault ArrestPriorToRequisition BadChecks Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CorruptionOfMinors CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingBurglary CrimConsEngagingManufDelPossW CrimConsEngagingRobberyInflict CrimConsEngagingTheft CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff DisorderlyConduct FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassWithPhysicalContact IdentityTheft IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel PersonNotToPossessUseFA PossInstrumentOfCrimeWInt PossOfMarijuana PossOfFirearmByMinor ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SecureExecutionDocsByDeception SimpleAssault StalkCommitActsToCauseFear TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {		
		bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	
	* 2009
	foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingBurglary CrimConsEngagingManufDelPossW CrimConsEngagingRobberyInflict CrimConsEngagingTheft CrimMischief CrimSolProstituteOf CrimUseOfCommunicationFacility DUIGenImpIncof1stOff DisorderlyConduct EndangeringWelfareofChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassCommLewdThreatening HarassWithPhysicalContact IdentityTheft IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel PersonNotToPossessUseFA PossInstrumentOfCrimeWInt PossOfMarijuana ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SecureExecutionDocsByDeception SimpleAssault StalkCommitActsToCauseFear TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
	bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
 
	* 2008 
	foreach x in AggrAssault ArrestPriorToRequisition BadChecks Burglary CarryFAPublicInPhila ContForViolofOrderorAgreement CorruptionOfMinors CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingBurglary CrimConsEngagingManufDelPossW CrimConsEngagingMurder CrimConsEngagingRobberyInflict CrimConsEngagingTheft CrimMischief CrimSolProstituteOf CrimUseOfCommunicationFacility DUIGenImpIncof1stOff DisorderlyConduct EndangeringWelfareofChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassCommLewdThreatening HarassWithPhysicalContact IdentityTheft IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel PersonNotToPossessUseFA PossInstrumentOfCrimeWInt PossOfMarijuana ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SecureExecutionDocsByDeception SimpleAssault StalkCommitActsToCauseFear TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
	bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	
	* 2010
	foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ConsManufDelPossWIntManufOrDel ConsManuDelorPoss ConsRobberyInflictSBI ContForViolofOrderorAgreement CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimConsEngagingAggrAssault CrimConsEngagingManufDelPossW CrimConsEngagingRobberyInflict CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff DrivWhileOperPrivSuspOrRevoked EndangeringWelfareofChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManufDelPossWIntManufOrDel ManuDelorPossIntent PersonNotToPossessUseFA PossInstrumentOfCrimeWInt PossOfMarijuana ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
				bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	
	* 2011
	foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ConsAggrAssault ConsBurglary ConsManuDelorPoss ConsRobberyInflictSBI ContForViolofOrderorAgreement CrimTresEnterStructure CrimAtmptMurder CrimAtmptTheftTakingMovable CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff EndangeringWelfareofChildren FalseImprisonment FANotToBeCarriedWOLicense HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManuDelorPossIntent PersonNotToPossessUseFA PossInstrumentOfCrimeWInt PossOfMarijuana PossOfFirearmProhibited ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
					bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	
	* 2012
    foreach x in AggrAssault ArrestPriorToRequisition Burglary CarryFAPublicInPhila ConsAggrAssault ConsBurglary ConsManuDelorPoss ConsRobberyInflictSBI ContForViolofOrderorAgreement CrimTresEnterStructure CrimAtmptTheftTakingMovable CrimMischief CrimSolProstituteOf DUIGenImpIncof1stOff EndangeringWelfareofChildren FalseImprisonment FANotToBeCarriedWOLicense ForgeryAlterWriting HarassCommLewdThreatening HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManuDelorPossIntent PossInstrumentOfCrimeWInt PossOfMarijuana PossOfFirearmProhibited ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {        
	bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	
	* 2013
	foreach x in AggrAssault ArrestPriorToRequisition Burglary BurglaryOvernightAccomPerson CarryFAPublicInPhila Cons ContForViolofOrderorAgreement CrimTresBreakIntoStructure CrimTresEnterStructure CrimMischief CrimSolProstitute DUIGenImpIncof1stOff EndangeringWelfareofChildren FANotToBeCarriedWOLicense HarassWithPhysicalContact IntPossContrSubstByPerNotReg ManuDelorPossIntent PossInstrumentOfCrimeWInt PossOfMarijuana PossOfFirearmProhibited ProstituteOfProstBusiness PurcRecOfContSubstbyUnauthPer ReceivingStolenProperty RecklesslyEndangering ResistArrestOtherLawEnforce RetailTheftTakeMdse RobberyInflictSBI RobberyInflictThreatImmBodInj SimpleAssault TerroristicThreatsW TheftByDecepFalseImpression TheftTakingMovableProp TheftFromAMotorVehicle UnauthUseMotorOtherVehicles UnlawfulRestraintSBI UsePossOfDrugParaph {
		bysort docket: egen `x'1=max(`x')
        replace `x'=`x'1
        drop `x'1
    }
	

       
	   * make charge grade dummies
		gen fel=regexm(chargeGrade, "F")
	   	gen mis=regexm(chargeGrade, "M")
	   	gen sum=regexm(chargeGrade, "S")
		
		* summarize charge grades by offense and offense class
		foreach x in fel mis sum {
			bysort offense: egen off_`x'=max(`x')
			bysort offenseClass: egen cl_`x'=max(`x')
		}
		
		* replace if the offense type is consistently a misdemeanor or a felony
			replace fel=1 if fel==0 & off_fel==1 & off_mis!=1 & off_sum!=1
			replace mis=1 if mis==0 & off_mis==1 & off_fel!=1 & off_sum!=1
			replace sum=1 if sum==0 & off_sum==1 & off_mis!=1 & off_fel!=1
	   
	   * by offense class replace if the offense type is consistently a misdemeanor or a felony
			replace fel=1 if fel==0 & cl_fel==1 & cl_mis!=1 & cl_sum!=1
			replace mis=1 if mis==0 & cl_mis==1 & cl_fel!=1 & cl_sum!=1
			replace sum=1 if sum==0 & cl_sum==1 & cl_mis!=1 & cl_fel!=1
	   
	   
	   


		* gen offense totals
        bysort docket: egen tot_off=total(ones)
		bysort docket: egen tot_fel=total(fel)
        bysort docket: egen tot_mis=total(mis)
        bysort docket: egen tot_sum=total(sum)

        * make offense indicators
        gen assault=regexm(offense, "Assault") 
        replace assault=regexm(offense, "Asslt") if assault==0
        replace assault=regexm(offense, "Inflict Serious Bodily Injury") if assault==0


        gen aggAssault=regexm(offense, "Aggravated Assault") 
        gen burglary=regexm(offense, "Burglary") 
        gen robbery=regexm(offense, "Robbery") 
        gen arson=regexm(offense, "Arson") 
        gen drug=regexm(offense, "Manufacture, Delivery, or Possessio")
        replace drug=regexm(offense, "Drug") if drug==0
        replace drug=regexm(offense, "Conspiracy Manufacture, Delivery,") if drug==0
        replace drug=regexm(offense, "Marijuana") if drug==0
        replace drug=regexm(offense, "Int Poss Contr Subst By Per") if drug==0
        replace drug=regexm(offense, "Contraband/Controlled Substance") if drug==0
        replace drug=regexm(offense, "Purc/Rec Of Cont Substby Unauth Per") if drug==0

        gen DUI=regexm(offense, "DUI") 
        gen instr=regexm(offense, "Poss Instrument Of Crime") 
        gen reckless=regexm(offense, "Recklessly Endangering") 
        gen mischief=regexm(offense, "Criminal Mischief") 

  
        gen theft=regexm(offense, "Theft") 
        replace theft=regexm(offense, "Stolen Property") if theft==0 
        replace theft=regexm(offense, "Movable Property") if theft==0 

        gen rape=regexm(offense, "Rape") 
        replace rape=regexm(offense, "Sex") if rape==0 
        replace rape=regexm(offense, "IDSI") if rape==0 
        replace rape=regexm(offense, "Indecent") if rape==0 

        gen firearms=regexm(offense, "Firearms") 
        gen murder=regexm(offense, "Murder") 
		replace murder=regexm(offense, "Homicide") if murder==0 

        gen driveCrime=regexm(offense, "Driv While Oper Priv Susp Or Revoked") 
        replace driveCrime=regexm(offense, "Driving W/O A License") if driveCrime==0 
        replace driveCrime=regexm(offense, "Unauth Use Motor/Other Vehicles") if driveCrime==0 

        gen fraudForge=regexm(offense, "Forgery") 
        replace fraudForge=regexm(offense, "Fraud") if fraudForge==0 
        replace fraudForge=regexm(offense, "Tamper Records") if fraudForge==0 
        replace fraudForge=regexm(offense, "Identity Theft") if fraudForge==0 
        replace fraudForge=regexm(offense, "Counterfeit") if fraudForge==0 
        replace fraudForge=regexm(offense, "Falsification") if fraudForge==0 

         gen intim=regexm(offense, "Intim Wit/Vit") 




		* rename to that it indicates having at least one
        foreach x in fel mis sum assault aggAssault burglary robbery arson drug DUI instr reckless mischief theft rape firearms murder driveCrime fraudForge intim {
              bysort docket: egen has_`x'=max(`x') 
            drop `x'
            gen `x'=has_`x'
            drop has_`x' 
        }

        
        drop offense off_fel off_mis off_sum cl_fel cl_mis cl_sum ones totOff offenseF offenseClass chargeGrade
		duplicates drop
		duplicates drop docket, force


        save "~/Dropbox/Projects/Bail/Phila/2006/offense_clean_2006.dta", replace

}
