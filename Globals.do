

*************************************
*** globals
*************************************


* define globals
global demo black age age2 male white 
global off tot_off tot_fel tot_mis  fel mis sum F1 F2 F3 F M1 M2 M3 M totOGS
global prior gagnon pretrial priorCases priorWI5 prior_felChar_DC prior_violCrime_DC prior_guilt_DC onePrior threePriors
global judge_pre Abe DwainE James Jane Patrick Sheila Timothy Francis
global dYear  dockYear_1 dockYear_2 dockYear_3 dockYear_4 dockYear_5 dockYear_6
global dow bailDOW_1 bailDOW_2 bailDOW_3 bailDOW_4 bailDOW_5 bailDOW_6 bailDOW_7
global judge_pre_main2  James_main2 Jane_main2 Patrick_main2 Sheila_main2 Timothy_main2 Francis_main2
global judge_pre_main  James_main Jane_main Patrick_main Sheila_main Timothy_main Francis_main
global judge_pre_AbeDwain Abe_AbeDwain DwainE_AbeDwain James_AbeDwain Patrick_AbeDwain Sheila_AbeDwain Timothy_AbeDwain Francis_AbeDwain
global UCR2 murder rape statRape robbery aggAss aggIndAss burglary theft shopLift arson simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost john pedophile family DUI1st DUI2nd disorderly vagrancy intim accident trespass crimCom falseImprison falseReport fleeOfficer sellGun recklessEndanger resistArrest stalk  MVtheft 
global UCR2_main murder rape robbery aggAss  burglary theft shopLift  simpAssault possess drugSell drugBuy possMar F2firearm F3firearm stolProp vandal weapon prost ///
	 DUI1st DUI2nd  resistArrest stalk  MVtheft 
global UCR2_orig murder_orig rape_orig statRape_orig robbery_orig aggAss_orig aggIndAss_orig burglary_orig theft_orig shopLift_orig arson_orig simpAssault_orig possess_orig drugSell_orig drugBuy_orig possMar_orig F2firearm_orig F3firearm_orig stolProp_orig vandal_orig weapon_orig prost_orig john_orig pedophile_orig family_orig DUI1st_orig DUI2nd_orig disorderly_orig vagrancy_orig intim_orig accident_orig trespass_orig crimCom_orig falseImprison_orig falseReport_orig fleeOfficer_orig sellGun_orig recklessEndanger_orig resistArrest_orig stalk_orig  MVtheft_orig
global control day day2 day3 grave morning $dow  bailDate t1 t2 t3 t3 t4 t5 t6
global judge_three $judge_pre_AbeDwain $judge_pre_main $judge_pre_main2

global testy Abe_murder DwainE_murder James_murder Jane_murder Patrick_murder Sheila_murder Timothy_murder Francis_murder ///
	Abe_rape DwainE_rape James_rape Jane_rape Patrick_rape Sheila_rape Timothy_rape Francis_rape ///
		Abe_robbery DwainE_robbery James_robbery Jane_robbery Patrick_robbery Sheila_robbery Timothy_robbery Francis_robbery ///
				Abe_aggAss DwainE_aggAss James_aggAss Jane_aggAss Patrick_aggAss Sheila_aggAss Timothy_aggAss Francis_aggAss ///
				Abe_burglary DwainE_burglary James_burglary Jane_burglary Patrick_burglary Sheila_burglary Timothy_burglary Francis_burglary ///
				Abe_theft DwainE_theft James_theft Jane_theft Patrick_theft Sheila_theft Timothy_theft Francis_theft ///
				Abe_shopLift DwainE_shopLift James_shopLift Jane_shopLift Patrick_shopLift Sheila_shopLift Timothy_shopLift Francis_shopLift ///
				Abe_simpAssault DwainE_simpAssault James_simpAssault Jane_simpAssault Patrick_simpAssault Sheila_simpAssault Timothy_simpAssault Francis_simpAssault ///
				Abe_possess DwainE_possess James_possess Jane_possess Patrick_possess Sheila_possess Timothy_possess Francis_possess ///
				Abe_drugSell DwainE_drugSell James_drugSell Jane_drugSell Patrick_drugSell Sheila_drugSell Timothy_drugSell Francis_drugSell ///
				Abe_drugBuy DwainE_drugBuy James_drugBuy Jane_drugBuy Patrick_drugBuy Sheila_drugBuy Timothy_drugBuy Francis_drugBuy ///
				Abe_possMar DwainE_possMar James_possMar Jane_possMar Patrick_possMar Sheila_possMar Timothy_possMar Francis_possMar ///
				Abe_F2firearm DwainE_F2firearm James_F2firearm Jane_F2firearm Patrick_F2firearm Sheila_F2firearm Timothy_F2firearm Francis_F2firearm ///
				Abe_F3firearm DwainE_F3firearm James_F3firearm Jane_F3firearm Patrick_F3firearm Sheila_F3firearm Timothy_F3firearm Francis_F3firearm ///
				Abe_stolProp DwainE_stolProp James_stolProp Jane_stolProp Patrick_stolProp Sheila_stolProp Timothy_stolProp Francis_stolProp ///
				Abe_vandal DwainE_vandal James_vandal Jane_vandal Patrick_vandal Sheila_vandal Timothy_vandal Francis_vandal ///
				Abe_weapon DwainE_weapon James_weapon Jane_weapon Patrick_weapon Sheila_weapon Timothy_weapon Francis_weapon ///
				Abe_prost DwainE_prost James_prost Jane_prost Patrick_prost Sheila_prost Timothy_prost Francis_prost ///
				Abe_DUI1st DwainE_DUI1st James_DUI1st Jane_DUI1st Patrick_DUI1st Sheila_DUI1st Timothy_DUI1st Francis_DUI1st ///
				Abe_DUI2nd DwainE_DUI2nd James_DUI2nd Jane_DUI2nd Patrick_DUI2nd Sheila_DUI2nd Timothy_DUI2nd Francis_DUI2nd ///
				Abe_resistArrest DwainE_resistArrest James_resistArrest Jane_resistArrest Patrick_resistArrest Sheila_resistArrest Timothy_resistArrest Francis_resistArrest ///
				Abe_MVtheft DwainE_MVtheft James_MVtheft Jane_MVtheft Patrick_MVtheft Sheila_MVtheft Timothy_MVtheft Francis_MVtheft ///
				Abe_black DwainE_black James_black Jane_black Patrick_black Sheila_black Timothy_black Francis_black ///
				Abe_age DwainE_age James_age Jane_age Patrick_age Sheila_age Timothy_age Francis_age ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors
	
	global testy2 Abe_murder DwainE_murder James_murder Jane_murder Patrick_murder Sheila_murder Timothy_murder Francis_murder ///
	Abe_rape DwainE_rape James_rape Jane_rape Patrick_rape Sheila_rape Timothy_rape Francis_rape ///
		Abe_robbery DwainE_robbery James_robbery Jane_robbery Patrick_robbery Sheila_robbery Timothy_robbery Francis_robbery ///
				Abe_aggAss DwainE_aggAss James_aggAss Jane_aggAss Patrick_aggAss Sheila_aggAss Timothy_aggAss Francis_aggAss ///
				Abe_burglary DwainE_burglary James_burglary Jane_burglary Patrick_burglary Sheila_burglary Timothy_burglary Francis_burglary ///
				Abe_theft DwainE_theft James_theft Jane_theft Patrick_theft Sheila_theft Timothy_theft Francis_theft ///
				Abe_shopLift DwainE_shopLift James_shopLift Jane_shopLift Patrick_shopLift Sheila_shopLift Timothy_shopLift Francis_shopLift ///
				Abe_simpAssault DwainE_simpAssault James_simpAssault Jane_simpAssault Patrick_simpAssault Sheila_simpAssault Timothy_simpAssault Francis_simpAssault ///
				Abe_possess DwainE_possess James_possess Jane_possess Patrick_possess Sheila_possess Timothy_possess Francis_possess ///
				Abe_drugSell DwainE_drugSell James_drugSell Jane_drugSell Patrick_drugSell Sheila_drugSell Timothy_drugSell Francis_drugSell ///
				Abe_drugBuy DwainE_drugBuy James_drugBuy Jane_drugBuy Patrick_drugBuy Sheila_drugBuy Timothy_drugBuy Francis_drugBuy ///
				Abe_possMar DwainE_possMar James_possMar Jane_possMar Patrick_possMar Sheila_possMar Timothy_possMar Francis_possMar ///
				Abe_F2firearm DwainE_F2firearm James_F2firearm Jane_F2firearm Patrick_F2firearm Sheila_F2firearm Timothy_F2firearm Francis_F2firearm ///
				Abe_F3firearm DwainE_F3firearm James_F3firearm Jane_F3firearm Patrick_F3firearm Sheila_F3firearm Timothy_F3firearm Francis_F3firearm ///
				Abe_stolProp DwainE_stolProp James_stolProp Jane_stolProp Patrick_stolProp Sheila_stolProp Timothy_stolProp Francis_stolProp ///
				Abe_vandal DwainE_vandal James_vandal Jane_vandal Patrick_vandal Sheila_vandal Timothy_vandal Francis_vandal ///
				Abe_prost DwainE_prost James_prost Jane_prost Patrick_prost Sheila_prost Timothy_prost Francis_prost ///
				Abe_DUI1st DwainE_DUI1st James_DUI1st Jane_DUI1st Patrick_DUI1st Sheila_DUI1st Timothy_DUI1st Francis_DUI1st ///
				Abe_DUI2nd DwainE_DUI2nd James_DUI2nd Jane_DUI2nd Patrick_DUI2nd Sheila_DUI2nd Timothy_DUI2nd Francis_DUI2nd ///
				Abe_MVtheft DwainE_MVtheft James_MVtheft Jane_MVtheft Patrick_MVtheft Sheila_MVtheft Timothy_MVtheft Francis_MVtheft ///
				Abe_black DwainE_black James_black Jane_black Patrick_black Sheila_black Timothy_black Francis_black ///
				Abe_age DwainE_age James_age Jane_age Patrick_age Sheila_age Timothy_age Francis_age ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_prior_violCrime DwainE_prior_violCrime James_prior_violCrime Jane_prior_violCrime Patrick_prior_violCrime Sheila_prior_violCrime Timothy_prior_violCrime Francis_prior_violCrime ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors
	
		global testyNoRace Abe_murder DwainE_murder James_murder Jane_murder Patrick_murder Sheila_murder Timothy_murder Francis_murder ///
	Abe_rape DwainE_rape James_rape Jane_rape Patrick_rape Sheila_rape Timothy_rape Francis_rape ///
		Abe_robbery DwainE_robbery James_robbery Jane_robbery Patrick_robbery Sheila_robbery Timothy_robbery Francis_robbery ///
				Abe_aggAss DwainE_aggAss James_aggAss Jane_aggAss Patrick_aggAss Sheila_aggAss Timothy_aggAss Francis_aggAss ///
				Abe_burglary DwainE_burglary James_burglary Jane_burglary Patrick_burglary Sheila_burglary Timothy_burglary Francis_burglary ///
				Abe_theft DwainE_theft James_theft Jane_theft Patrick_theft Sheila_theft Timothy_theft Francis_theft ///
				Abe_shopLift DwainE_shopLift James_shopLift Jane_shopLift Patrick_shopLift Sheila_shopLift Timothy_shopLift Francis_shopLift ///
				Abe_simpAssault DwainE_simpAssault James_simpAssault Jane_simpAssault Patrick_simpAssault Sheila_simpAssault Timothy_simpAssault Francis_simpAssault ///
				Abe_possess DwainE_possess James_possess Jane_possess Patrick_possess Sheila_possess Timothy_possess Francis_possess ///
				Abe_drugSell DwainE_drugSell James_drugSell Jane_drugSell Patrick_drugSell Sheila_drugSell Timothy_drugSell Francis_drugSell ///
				Abe_drugBuy DwainE_drugBuy James_drugBuy Jane_drugBuy Patrick_drugBuy Sheila_drugBuy Timothy_drugBuy Francis_drugBuy ///
				Abe_possMar DwainE_possMar James_possMar Jane_possMar Patrick_possMar Sheila_possMar Timothy_possMar Francis_possMar ///
				Abe_F2firearm DwainE_F2firearm James_F2firearm Jane_F2firearm Patrick_F2firearm Sheila_F2firearm Timothy_F2firearm Francis_F2firearm ///
				Abe_F3firearm DwainE_F3firearm James_F3firearm Jane_F3firearm Patrick_F3firearm Sheila_F3firearm Timothy_F3firearm Francis_F3firearm ///
				Abe_stolProp DwainE_stolProp James_stolProp Jane_stolProp Patrick_stolProp Sheila_stolProp Timothy_stolProp Francis_stolProp ///
				Abe_vandal DwainE_vandal James_vandal Jane_vandal Patrick_vandal Sheila_vandal Timothy_vandal Francis_vandal ///
				Abe_prost DwainE_prost James_prost Jane_prost Patrick_prost Sheila_prost Timothy_prost Francis_prost ///
				Abe_DUI1st DwainE_DUI1st James_DUI1st Jane_DUI1st Patrick_DUI1st Sheila_DUI1st Timothy_DUI1st Francis_DUI1st ///
				Abe_DUI2nd DwainE_DUI2nd James_DUI2nd Jane_DUI2nd Patrick_DUI2nd Sheila_DUI2nd Timothy_DUI2nd Francis_DUI2nd ///
				Abe_MVtheft DwainE_MVtheft James_MVtheft Jane_MVtheft Patrick_MVtheft Sheila_MVtheft Timothy_MVtheft Francis_MVtheft ///
				Abe_age DwainE_age James_age Jane_age Patrick_age Sheila_age Timothy_age Francis_age ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_prior_violCrime DwainE_prior_violCrime James_prior_violCrime Jane_prior_violCrime Patrick_prior_violCrime Sheila_prior_violCrime Timothy_prior_violCrime Francis_prior_violCrime ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors
	
		
    global ADIntDemoNoRace  AbeDwain_age AbeDwain_female AbeDwain_priorCases AbeDwain_prior_violCrime AbeDwain_onePrior AbeDwain_threePrior
    global mainIntDemoNoRace  main_age main_female main_priorCases main_prior_violCrime main_onePrior main_threePrior

	
global judge_3x5 Abe_main_robbery Abe_main_possess Abe_main_drugSell Abe_main_aggAss Abe_main_DUI1st DwainE_main_robbery DwainE_main_possess DwainE_main_drugSell DwainE_main_aggAss DwainE_main_DUI1st James_main_robbery James_main_possess James_main_drugSell James_main_aggAss James_main_DUI1st Jane_main_robbery Jane_main_possess Jane_main_drugSell Jane_main_aggAss Jane_main_DUI1st Patrick_main_robbery Patrick_main_possess Patrick_main_drugSell Patrick_main_aggAss Patrick_main_DUI1st Sheila_main_robbery Sheila_main_possess Sheila_main_drugSell Sheila_main_aggAss Sheila_main_DUI1st Timothy_main_robbery Timothy_main_possess Timothy_main_drugSell Timothy_main_aggAss Timothy_main_DUI1st Francis_main_robbery Francis_main_possess Francis_main_drugSell Francis_main_aggAss Francis_main_DUI1st Abe_main2_robbery Abe_main2_possess Abe_main2_drugSell Abe_main2_aggAss Abe_main2_DUI1st DwainE_main2_robbery DwainE_main2_possess DwainE_main2_drugSell DwainE_main2_aggAss DwainE_main2_DUI1st James_main2_robbery James_main2_possess James_main2_drugSell James_main2_aggAss James_main2_DUI1st Jane_main2_robbery Jane_main2_possess Jane_main2_drugSell Jane_main2_aggAss Jane_main2_DUI1st Patrick_main2_robbery Patrick_main2_possess Patrick_main2_drugSell Patrick_main2_aggAss Patrick_main2_DUI1st Sheila_main2_robbery Sheila_main2_possess Sheila_main2_drugSell Sheila_main2_aggAss Sheila_main2_DUI1st Timothy_main2_robbery Timothy_main2_possess Timothy_main2_drugSell Timothy_main2_aggAss Timothy_main2_DUI1st Francis_main2_robbery Francis_main2_possess Francis_main2_drugSell Francis_main2_aggAss Francis_main2_DUI1st
	
	
global ADInt AbeDwain_murder AbeDwain_rape AbeDwain_robbery AbeDwain_aggAss AbeDwain_burglary AbeDwain_theft AbeDwain_shopLift AbeDwain_simpAssault AbeDwain_possess AbeDwain_drugSell AbeDwain_drugBuy AbeDwain_possMar AbeDwain_F2firearm AbeDwain_F3firearm AbeDwain_stolProp AbeDwain_vandal AbeDwain_weapon AbeDwain_prost AbeDwain_DUI1st AbeDwain_DUI2nd AbeDwain_resistArrest AbeDwain_stalk AbeDwain_MVtheft 
global mainInt main_murder main_rape main_robbery main_aggAss main_burglary main_theft main_shopLift main_simpAssault main_possess main_drugSell main_drugBuy main_possMar main_F2firearm main_F3firearm main_stolProp main_vandal main_weapon main_prost main_DUI1st main_DUI2nd main_resistArrest main_stalk main_MVtheft 
global main2Int main2_murder main2_rape main2_robbery main2_aggAss main2_burglary main2_theft main2_shopLift main2_simpAssault main2_possess main2_drugSell main2_drugBuy main2_possMar main2_F2firearm main2_F3firearm main2_stolProp main2_vandal main2_weapon main2_prost main2_DUI1st main2_DUI2nd main2_resistArrest main2_stalk main2_MVtheft 
global DwainInt Dwain_murder Dwain_rape Dwain_robbery Dwain_aggAss Dwain_burglary Dwain_theft Dwain_shopLift Dwain_simpAssault Dwain_possess Dwain_drugSell Dwain_drugBuy Dwain_possMar Dwain_F2firearm Dwain_F3firearm Dwain_stolProp Dwain_vandal Dwain_weapon Dwain_prost Dwain_DUI1st Dwain_DUI2nd Dwain_resistArrest Dwain_stalk Dwain_MVtheft


global ADInt_orig AbeDwain_murder_orig AbeDwain_rape_orig AbeDwain_robbery_orig AbeDwain_aggAss_orig AbeDwain_burglary_orig AbeDwain_theft_orig AbeDwain_shopLift_orig AbeDwain_simpAssault_orig AbeDwain_possess_orig AbeDwain_drugSell_orig AbeDwain_drugBuy_orig AbeDwain_possMar_orig AbeDwain_F2firearm_orig AbeDwain_F3firearm_orig AbeDwain_stolProp_orig AbeDwain_vandal_orig AbeDwain_weapon_orig AbeDwain_prost_orig AbeDwain_DUI1st_orig AbeDwain_DUI2nd_orig AbeDwain_resistArrest_orig AbeDwain_stalk_orig AbeDwain_MVtheft_orig 
global mainInt_orig main_murder_orig main_rape_orig main_robbery_orig main_aggAss_orig main_burglary_orig main_theft_orig main_shopLift_orig main_simpAssault_orig main_possess_orig main_drugSell_orig main_drugBuy_orig main_possMar_orig main_F2firearm_orig main_F3firearm_orig main_stolProp_orig main_vandal_orig main_weapon_orig main_prost_orig main_DUI1st_orig main_DUI2nd_orig main_resistArrest_orig main_stalk_orig main_MVtheft_orig 



    global ADIntDemo AbeDwain_black AbeDwain_age AbeDwain_female AbeDwain_priorCases AbeDwain_prior_violCrime AbeDwain_onePrior AbeDwain_threePrior
    global mainIntDemo main_black main_age main_female main_priorCases main_prior_violCrime main_onePrior main_threePrior

	global clearGuilt  MVtheft==1 | possess==1 | drugSell==1 | drugBuy==1 | possMar==1 | F2firearm==1 | F3firearm==1 | 	 DUI1st==1 | DUI2nd==1    | prost==1
	global clearGuiltCrimes  MVtheft possess  drugSell  drugBuy  possMar  F2firearm  F3firearm  	 DUI1st  DUI2nd  
	global ADIntCG AbeDwain_possess AbeDwain_drugSell AbeDwain_drugBuy AbeDwain_possMar AbeDwain_F2firearm AbeDwain_F3firearm  AbeDwain_DUI1st AbeDwain_DUI2nd  
	global ADIntEv   AbeDwain_murder AbeDwain_rape AbeDwain_robbery AbeDwain_aggAss AbeDwain_burglary AbeDwain_theft AbeDwain_shopLift AbeDwain_simpAssault AbeDwain_stolProp AbeDwain_vandal 
	global mainIntEv   main_murder main_rape main_robbery main_aggAss main_burglary main_theft main_shopLift main_simpAssault main_stolProp main_vandal 
	global main2IntCG main2_possess main2_drugSell main2_drugBuy main2_possMar main2_F2firearm main2_F3firearm  main2_DUI1st main2_DUI2nd  
	global mainIntCG main_possess main_drugSell main_drugBuy main_possMar main_F2firearm main_F3firearm  main_DUI1st main_DUI2nd  

global testyEv Abe_murder DwainE_murder James_murder Jane_murder Patrick_murder Sheila_murder Timothy_murder Francis_murder ///
	Abe_rape DwainE_rape James_rape Jane_rape Patrick_rape Sheila_rape Timothy_rape Francis_rape ///
		Abe_robbery DwainE_robbery James_robbery Jane_robbery Patrick_robbery Sheila_robbery Timothy_robbery Francis_robbery ///
			Abe_aggAss DwainE_aggAss James_aggAss Jane_aggAss Patrick_aggAss Sheila_aggAss Timothy_aggAss Francis_aggAss ///
				Abe_burglary DwainE_burglary James_burglary Jane_burglary Patrick_burglary Sheila_burglary Timothy_burglary Francis_burglary ///
				Abe_theft DwainE_theft James_theft Jane_theft Patrick_theft Sheila_theft Timothy_theft Francis_theft ///
				Abe_shopLift DwainE_shopLift James_shopLift Jane_shopLift Patrick_shopLift Sheila_shopLift Timothy_shopLift Francis_shopLift ///
				Abe_simpAssault DwainE_simpAssault James_simpAssault Jane_simpAssault Patrick_simpAssault Sheila_simpAssault Timothy_simpAssault Francis_simpAssault ///
				Abe_vandal DwainE_vandal James_vandal Jane_vandal Patrick_vandal Sheila_vandal Timothy_vandal Francis_vandal ///
				Abe_prost DwainE_prost James_prost Jane_prost Patrick_prost Sheila_prost Timothy_prost Francis_prost ///
				Abe_black DwainE_black James_black Jane_black Patrick_black Sheila_black Timothy_black Francis_black ///
				Abe_age DwainE_age James_age Jane_age Patrick_age Sheila_age Timothy_age Francis_age ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors

	global ev (murder==1 | rape==1 | aggAss==1 | simpAssault==1 | shopLift==1 | robbery==1 | burglary==1  | vandal==1 | theft==1 | ///
		aggIndAss==1 | arson==1 | disorderly==1 | vagrancy==1 | pedophile==1 | statRape==1 | family==1 | ///
		 stalk==1 | stolProp==1 | falseImprison==1 | trespass==1 | intim==1)
	global evCrime murder rape aggAss simpAssault shopLift robbery burglary vandal theft aggIndAss arson disorderly vagrancy pedophile ///
		statRape family  stalk stolProp falseImprison intim
	global evCrime_orig murder_orig rape_orig aggAss_orig simpAssault_orig shopLift_orig robbery_orig burglary_orig vandal_orig theft_orig aggIndAss_orig arson_orig disorderly_orig vagrancy_orig pedophile_orig ///
		statRape_orig family_orig stalk_orig stolProp_orig falseImprison_orig intim_orig
	global clearGuilt  MVtheft==1 | possess==1 | drugSell==1 | drugBuy==1 | possMar==1 | F2firearm==1 | F3firearm==1 | 	 DUI1st==1 | DUI2nd==1    | prost==1
		global clearGuiltCrimes  MVtheft possess  drugSell  drugBuy  possMar  F2firearm  F3firearm  	 DUI1st  DUI2nd   
		global clearGuiltCrimes_orig  MVtheft possess_orig  drugSell_orig  drugBuy_orig  possMar_orig  F2firearm_orig  F3firearm_orig  	 DUI1st_orig  DUI2nd_orig   

		
		global testyCG Abe_possess DwainE_possess James_possess Jane_possess Patrick_possess Sheila_possess Timothy_possess Francis_possess ///
				Abe_drugSell DwainE_drugSell James_drugSell Jane_drugSell Patrick_drugSell Sheila_drugSell Timothy_drugSell Francis_drugSell ///
				Abe_drugBuy DwainE_drugBuy James_drugBuy Jane_drugBuy Patrick_drugBuy Sheila_drugBuy Timothy_drugBuy Francis_drugBuy ///
				Abe_possMar DwainE_possMar James_possMar Jane_possMar Patrick_possMar Sheila_possMar Timothy_possMar Francis_possMar ///
				Abe_F2firearm DwainE_F2firearm James_F2firearm Jane_F2firearm Patrick_F2firearm Sheila_F2firearm Timothy_F2firearm Francis_F2firearm ///
				Abe_F3firearm DwainE_F3firearm James_F3firearm Jane_F3firearm Patrick_F3firearm Sheila_F3firearm Timothy_F3firearm Francis_F3firearm ///
				Abe_DUI1st DwainE_DUI1st James_DUI1st Jane_DUI1st Patrick_DUI1st Sheila_DUI1st Timothy_DUI1st Francis_DUI1st ///
				Abe_DUI2nd DwainE_DUI2nd James_DUI2nd Jane_DUI2nd Patrick_DUI2nd Sheila_DUI2nd Timothy_DUI2nd Francis_DUI2nd ///
				Abe_MVtheft DwainE_MVtheft James_MVtheft Jane_MVtheft Patrick_MVtheft Sheila_MVtheft Timothy_MVtheft Francis_MVtheft ///
				Abe_black DwainE_black James_black Jane_black Patrick_black Sheila_black Timothy_black Francis_black ///
				Abe_age DwainE_age James_age Jane_age Patrick_age Sheila_age Timothy_age Francis_age ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_threePriors DwainE_threePriors James_threePriors Jane_threePriors Patrick_threePriors Sheila_threePriors Timothy_threePriors Francis_threePriors
	

global testyEvOrig 	Abe_robbery_orig DwainE_robbery_orig James_robbery_orig Jane_robbery_orig Patrick_robbery_orig Sheila_robbery_orig Timothy_robbery_orig Francis_robbery_orig ///
				Abe_aggAss_orig DwainE_aggAss_orig James_aggAss_orig Jane_aggAss_orig Patrick_aggAss_orig Sheila_aggAss_orig Timothy_aggAss_orig Francis_aggAss_orig ///
				Abe_burglary_orig DwainE_burglary_orig James_burglary_orig Jane_burglary_orig Patrick_burglary_orig Sheila_burglary_orig Timothy_burglary_orig Francis_burglary_orig ///
				Abe_theft_orig DwainE_theft_orig James_theft_orig Jane_theft_orig Patrick_theft_orig Sheila_theft_orig Timothy_theft_orig Francis_theft_orig ///
		        Abe_stolProp_orig DwainE_stolProp_orig James_stolProp_orig Jane_stolProp_orig Patrick_stolProp_orig Sheila_stolProp_orig Timothy_stolProp_orig Francis_stolProp_orig ///
				Abe_simpAssault_orig DwainE_simpAssault_orig James_simpAssault_orig Jane_simpAssault_orig Patrick_simpAssault_orig Sheila_simpAssault_orig Timothy_simpAssault_orig Francis_simpAssault_orig 
				

global testyCGorig Abe_possess_orig DwainE_possess_orig James_possess_orig Jane_possess_orig Patrick_possess_orig Sheila_possess_orig Timothy_possess_orig Francis_possess_orig ///
				Abe_drugSell_orig DwainE_drugSell_orig James_drugSell_orig Jane_drugSell_orig Patrick_drugSell_orig Sheila_drugSell_orig Timothy_drugSell_orig Francis_drugSell_orig ///
				Abe_drugBuy_orig DwainE_drugBuy_orig James_drugBuy_orig Jane_drugBuy_orig Patrick_drugBuy_orig Sheila_drugBuy_orig Timothy_drugBuy_orig Francis_drugBuy_orig ///
				Abe_possMar_orig DwainE_possMar_orig James_possMar_orig Jane_possMar_orig Patrick_possMar_orig Sheila_possMar_orig Timothy_possMar_orig Francis_possMar_orig ///
				Abe_DUI1st_orig DwainE_DUI1st_orig James_DUI1st_orig Jane_DUI1st_orig Patrick_DUI1st_orig Sheila_DUI1st_orig Timothy_DUI1st_orig Francis_DUI1st_orig ///
				Abe_F3firearm_orig DwainE_F3firearm_orig James_F3firearm_orig Jane_F3firearm_orig Patrick_F3firearm_orig Sheila_F3firearm_orig Timothy_F3firearm_orig Francis_F3firearm_orig ///
				Abe_DUI2nd DwainE_DUI2nd James_DUI2nd Jane_DUI2nd Patrick_DUI2nd Sheila_DUI2nd Timothy_DUI2nd Francis_DUI2nd ///
				Abe_F2firearm DwainE_F2firearm James_F2firearm Jane_F2firearm Patrick_F2firearm Sheila_F2firearm Timothy_F2firearm Francis_F2firearm ///
				


global testy2orig Abe_murder_orig DwainE_murder_orig James_murder_orig Jane_murder_orig Patrick_murder_orig Sheila_murder_orig Timothy_murder_orig Francis_murder_orig ///
	Abe_rape_orig DwainE_rape_orig James_rape_orig Jane_rape_orig Patrick_rape_orig Sheila_rape_orig Timothy_rape_orig Francis_rape_orig ///
		Abe_robbery_orig DwainE_robbery_orig James_robbery_orig Jane_robbery_orig Patrick_robbery_orig Sheila_robbery_orig Timothy_robbery_orig Francis_robbery_orig ///
				Abe_aggAss_orig DwainE_aggAss_orig James_aggAss_orig Jane_aggAss_orig Patrick_aggAss_orig Sheila_aggAss_orig Timothy_aggAss_orig Francis_aggAss_orig ///
				Abe_burglary_orig DwainE_burglary_orig James_burglary_orig Jane_burglary_orig Patrick_burglary_orig Sheila_burglary_orig Timothy_burglary_orig Francis_burglary_orig ///
				Abe_theft_orig DwainE_theft_orig James_theft_orig Jane_theft_orig Patrick_theft_orig Sheila_theft_orig Timothy_theft_orig Francis_theft_orig ///
				Abe_shopLift_orig DwainE_shopLift_orig James_shopLift_orig Jane_shopLift_orig Patrick_shopLift_orig Sheila_shopLift_orig Timothy_shopLift_orig Francis_shopLift_orig ///
				Abe_simpAssault_orig DwainE_simpAssault_orig James_simpAssault_orig Jane_simpAssault_orig Patrick_simpAssault_orig Sheila_simpAssault_orig Timothy_simpAssault_orig Francis_simpAssault_orig ///
				Abe_possess_orig DwainE_possess_orig James_possess_orig Jane_possess_orig Patrick_possess_orig Sheila_possess_orig Timothy_possess_orig Francis_possess_orig ///
				Abe_drugSell_orig DwainE_drugSell_orig James_drugSell_orig Jane_drugSell_orig Patrick_drugSell_orig Sheila_drugSell_orig Timothy_drugSell_orig Francis_drugSell_orig ///
				Abe_drugBuy_orig DwainE_drugBuy_orig James_drugBuy_orig Jane_drugBuy_orig Patrick_drugBuy_orig Sheila_drugBuy_orig Timothy_drugBuy_orig Francis_drugBuy_orig ///
				Abe_possMar_orig DwainE_possMar_orig James_possMar_orig Jane_possMar_orig Patrick_possMar_orig Sheila_possMar_orig Timothy_possMar_orig Francis_possMar_orig ///
				Abe_F2firearm_orig DwainE_F2firearm_orig James_F2firearm_orig Jane_F2firearm_orig Patrick_F2firearm_orig Sheila_F2firearm_orig Timothy_F2firearm_orig Francis_F2firearm_orig ///
				Abe_F3firearm_orig DwainE_F3firearm_orig James_F3firearm_orig Jane_F3firearm_orig Patrick_F3firearm_orig Sheila_F3firearm_orig Timothy_F3firearm_orig Francis_F3firearm_orig ///
				Abe_stolProp_orig DwainE_stolProp_orig James_stolProp_orig Jane_stolProp_orig Patrick_stolProp_orig Sheila_stolProp_orig Timothy_stolProp_orig Francis_stolProp_orig ///
				Abe_vandal_orig DwainE_vandal_orig James_vandal_orig Jane_vandal_orig Patrick_vandal_orig Sheila_vandal_orig Timothy_vandal_orig Francis_vandal_orig ///
				Abe_prost_orig DwainE_prost_orig James_prost_orig Jane_prost_orig Patrick_prost_orig Sheila_prost_orig Timothy_prost_orig Francis_prost_orig ///
				Abe_DUI1st_orig DwainE_DUI1st_orig James_DUI1st_orig Jane_DUI1st_orig Patrick_DUI1st_orig Sheila_DUI1st_orig Timothy_DUI1st_orig Francis_DUI1st_orig ///
				Abe_DUI2nd_orig DwainE_DUI2nd_orig James_DUI2nd_orig Jane_DUI2nd_orig Patrick_DUI2nd_orig Sheila_DUI2nd_orig Timothy_DUI2nd_orig Francis_DUI2nd_orig ///
				Abe_MVtheft_orig DwainE_MVtheft_orig James_MVtheft_orig Jane_MVtheft_orig Patrick_MVtheft_orig Sheila_MVtheft_orig Timothy_MVtheft_orig Francis_MVtheft_orig ///
				Abe_black DwainE_black James_black Jane_black Patrick_black Sheila_black Timothy_black Francis_black ///
				Abe_female DwainE_female James_female Jane_female Patrick_female Sheila_female Timothy_female Francis_female ///
				Abe_priorCases DwainE_priorCases James_priorCases Jane_priorCases Patrick_priorCases Sheila_priorCases Timothy_priorCases Francis_priorCases ///
				Abe_prior_violCrime DwainE_prior_violCrime James_prior_violCrime Jane_prior_violCrime Patrick_prior_violCrime Sheila_prior_violCrime Timothy_prior_violCrime Francis_prior_violCrime ///
				Abe_onePrior DwainE_onePrior James_onePrior Jane_onePrior Patrick_onePrior Sheila_onePrior Timothy_onePrior Francis_onePrior ///
				Abe_gagnon DwainE_gagnon James_gagnon Jane_gagnon Patrick_gagnon Sheila_gagnon Timothy_gagnon Francis_gagnon ///
	
global cgAddOns Abe_F2firearm DwainE_F2firearm James_F2firearm Jane_F2firearm Patrick_F2firearm Sheila_F2firearm Timothy_F2firearm Francis_F2firearm 	///
  Abe_F3firearm DwainE_F3firearm James_F3firearm Jane_F3firearm Patrick_F3firearm Sheila_F3firearm Timothy_F3firearm Francis_F3firearm ///
   Abe_possess DwainE_possess James_possess Jane_possess Patrick_possess Sheila_possess Timothy_possess Francis_possess ///
  Abe_possMar DwainE_possMar James_possMar Jane_possMar Patrick_possMar Sheila_possMar Timothy_possMar Francis_possMar
 
global evAddOns Abe_simpAssault DwainE_simpAssault James_simpAssault Jane_simpAssault Patrick_simpAssault Sheila_simpAssault Timothy_simpAssault Francis_simpAssault ///
  Abe_aggAss DwainE_aggAss James_aggAss Jane_aggAss Patrick_aggAss Sheila_aggAss Timothy_aggAss Francis_aggAss  ///
  Abe_stolProp DwainE_stolProp James_stolProp Jane_stolProp Patrick_stolProp Sheila_stolProp Timothy_stolProp Francis_stolProp ///

  
  
global cgAddOns_orig Abe_F2firearm_orig DwainE_F2firearm_orig James_F2firearm_orig Jane_F2firearm_orig Patrick_F2firearm_orig Sheila_F2firearm_orig Timothy_F2firearm_orig Francis_F2firearm_orig 	///
	Abe_F3firearm_orig DwainE_F3firearm_orig James_F3firearm_orig Jane_F3firearm_orig Patrick_F3firearm_orig Sheila_F3firearm_orig Timothy_F3firearm_orig Francis_F3firearm_orig ///
	Abe_possess_orig DwainE_possess_orig James_possess_orig Jane_possess_orig Patrick_possess_orig Sheila_possess_orig Timothy_possess_orig Francis_possess_orig 	///
	Abe_possMar_orig DwainE_possMar_orig James_possMar_orig Jane_possMar_orig Patrick_possMar_orig Sheila_possMar_orig Timothy_possMar_orig Francis_possMar_orig
 
global evAddOns_orig Abe_simpAssault_orig DwainE_simpAssault_orig James_simpAssault_orig Jane_simpAssault_orig Patrick_simpAssault_orig Sheila_simpAssault_orig Timothy_simpAssault_orig Francis_simpAssault_orig ///
	Abe_aggAss_orig DwainE_aggAss_orig James_aggAss_orig Jane_aggAss_orig Patrick_aggAss_orig Sheila_aggAss_orig Timothy_aggAss_orig Francis_aggAss_orig ///
	Abe_stolProp_orig DwainE_stolProp_orig James_stolProp_orig Jane_stolProp_orig Patrick_stolProp_orig Sheila_stolProp_orig Timothy_stolProp_orig Francis_stolProp_orig ///


global ev_orig_controls murder_orig rape_orig robbery_orig aggAss_orig burglary_orig theft_orig shopLift_orig simpAssault_orig vandal_orig
global cg_orig_controls possess_orig drugSell_orig  drugBuy_orig possMar_orig F2firearm_orig F3firearm_orig DUI1st_orig DUI2nd_orig  MVtheft_orig				
	
global cg_orig_int AbeDwain_possess_orig main_possess_orig AbeDwain_drugSell_orig main_drugSell_orig AbeDwain_drugBuy_orig main_drugBuy_orig AbeDwain_possMar_orig main_possMar_orig  AbeDwain_F2firearm_orig main_F2firearm_orig  AbeDwain_F3firearm_orig main_F3firearm_orig  AbeDwain_DUI1st_orig main_DUI1st_orig  AbeDwain_DUI2nd_orig main_DUI2nd_orig  AbeDwain_MVtheft_orig main_MVtheft_orig 
global ev_orig_int AbeDwain_murder_orig main_murder_orig main2_murder_orig AbeDwain_rape_orig main_rape_orig main2_rape_orig AbeDwain_robbery_orig main_robbery_orig main2_robbery_orig AbeDwain_aggAss_orig main_aggAss_orig main2_aggAss_orig AbeDwain_burglary_orig main_burglary_orig main2_burglary_orig AbeDwain_theft_orig main_theft_orig main2_theft_orig AbeDwain_shopLift_orig main_shopLift_orig main2_shopLift_orig AbeDwain_simpAssault_orig main_simpAssault_orig main2_simpAssault_orig AbeDwain_vandal_orig main_vandal_orig main2_vandal_orig 


global cg_int AbeDwain_possess main_possess  AbeDwain_drugSell main_drugSell  AbeDwain_drugBuy main_drugBuy AbeDwain_possMar main_possMar  AbeDwain_F2firearm main_F2firearm AbeDwain_F3firearm main_F3firearm  AbeDwain_DUI1st main_DUI1st  AbeDwain_DUI2nd main_DUI2nd  AbeDwain_MVtheft main_MVtheft 
global ev_int AbeDwain_murder main_murder main2_murder AbeDwain_rape main_rape main2_rape AbeDwain_robbery main_robbery main2_robbery AbeDwain_aggAss main_aggAss main2_aggAss AbeDwain_burglary main_burglary main2_burglary AbeDwain_theft main_theft main2_theft AbeDwain_shopLift main_shopLift main2_shopLift AbeDwain_simpAssault main_simpAssault main2_simpAssault AbeDwain_vandal main_vandal main2_vandal 

