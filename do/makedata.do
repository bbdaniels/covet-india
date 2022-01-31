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
  
  anycat med_k_
  
  destring med_l_? , replace force
    lab def med_l 1 "Anti-TB Meds" 2 "Quinolones" 3 "Antibiotics"
    lab val med_l_? med_l
  anycat med_l_
  
  egen checklist = rowmean(h_? h_??)
  
// Data construction

egen ppe = rsum(ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8)
egen cov = rsum(cov_6 cov_7 cov_8 cov_9 cov_10 cov_11 cov_12 cov_13 cov_14 cov_15 cov_16)
egen checkr = cut(checklist) , at(0 .10 .20 .30 .40 .50 .60 .70 .80 .90 1)
egen q2 = cut(quality) , at(0 .10 .20 .30 .40 .50 .60 .70 .80 .90 1)
  replace q2 = q2*10
  lab var q2 "Prior Quality (0-10)"
tab ppe_9, gen(mask)

// Save
    
save "${git}/data/covet.dta" , replace

// END
