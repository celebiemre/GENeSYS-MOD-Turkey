* ###################### genesysmod_settings.gms #######################
*
* GENeSYS-MOD v3.1 [Global Energy System Model]  ~ March 2022
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Updated to newest OSeMOSYS-Version (2016.08) and further improved with additional equations 2016 - 2022
* by Konstantin L�ffler, Thorsten Burandt, Karlo Hainsch
*
* #############################################################
*
* Copyright 2020 Technische Universit�t Berlin and DIW Berlin
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
* #############################################################



* ################### CHOOSE CALCULATED YEARS ###################
***  TO LEAVE OUT A CERTAIN YEAR, REMOVE COMMENT OF RESPECTIVE LINE ***
*y('2015') = no;
*y('2017') = no;
*y('2018') = no;
*y('2022') = no;
*y('2015') = no;
*y('2018') = no;
*y('2020') = no;
*y('2025') = no;
*y('2030') = no;
y('2035') = no;
*y('2040') = no;
y('2045') = no;
*y('2050') = no;

* ################### OTHER GENERAL INPUTS ###################

DepreciationMethod(r) = 1;
GeneralDiscountRate(r) = 0.05;
TechnologyDiscountRate(r,Companies) = 0.05;
TechnologyDiscountRate(r,Companies) = 0.05;
TechnologyDiscountRate(r,Households) = 0.05;
SocialDiscountRate(r) = %socialdiscountrate%;
DaysInDayType(y,ls,ld) = 7;

scalar InvestmentLimit  Freedom for investment choices to spread across periods. A value of 1 would mean equal share for each period.
                      /1.9/;
scalar NewRESCapacity /0.1/;
ProductionGrowthLimit(y,'Power')=0.05;
ProductionGrowthLimit(y,HeatFuels)=0.05;
ProductionGrowthLimit(y,TransportFuels)=0.05;
ProductionGrowthLimit(y,'Air')=0.025;
scalar StorageLimitOffset /0.015/;



scalar Trajectory2020UpperLimit /3/;
scalar Trajectory2020LowerLimit /0.7/;
GrowthRateTradeCapacity(y,'Power',r,rr) = 0.1;

BaseYearSlack(f) = 0.05;
BaseYearSlack('Power') = 0.05;
BaseYearSlack('Heat_Low_Residential') = 0.05;
