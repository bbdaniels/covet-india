// Get QUTUB reference

use "/Users/bbdaniels/Library/CloudStorage/Box-Box/Qutub/REPORTS/2021 EOY/patna_combined.dta" ///
  if case < 5, clear

  gen cp_4 = facilitycode

  gen quality   =     ///
    ((dr_4  == 1 | re_1 == 1 | re_3 == 1 | re_4 == 1 | re_5 == 1)   & case == 1) ///
  | ((dr_4  == 1 | re_1 == 1 | re_3 == 1 | re_4 == 1 | re_5 == 1)   & case == 2) ///
  | ((dr_4  == 1 | med_l_any_1 == 1 )                               & case == 3) /// 
  | ((dr_4  == 1 | re_4 == 1 | re_5 == 1)                           & case == 4) 
  
  collapse (mean) quality , by(cp_4) fast
  lab var quality "Prior Quality"
  
  tempfile qutub
  save `qutub' , replace

// Get and clean COVET rounds

copy "${box}/data/COVET Patna SP Digital Data Entry.dta" ///
     "${git}/data/covet.dta" , replace
     
use "${git}/data/covet.dta" if complete > 0, clear
  replace casex = 1 in 1/356
  replace casex = 9 in 357/l
  
  bys cp_4 casex (submissiondate): gen n = _n
  bys cp_4 casex (submissiondate): gen N = _N
    drop if n != 2 & N > 1
    drop n N
    
  merge m:1 cp_4 using `qutub' , keep(1 3)
  
  gen correct = (dr_4  == 1 | re_1 == 1 | re_3 == 1 | re_4 == 1 | re_5 == 1)
  lab var correct "Correct"
    
save "${git}/data/covet.dta" , replace

// END
