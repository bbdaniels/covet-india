// Figures for COVET quick hit

// Figure. Top-line results
use "${git}/data/covet.dta" , clear

betterbarci ///
  correct re_1 re_3 re_4 dr_4 med_l_any_?  ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%")
    
betterbarci ///
   re_3 med_l_any_2 re_1 med_l_any_3  ///
  , v over(ppe_9) pct bar legend(on pos(12) ring(1) r(1) region(lw(none))) ///
    ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%")

betterbarci ///
  ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8  ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%")

betterbarci ///
  cov_1 cov_2 cov_3 cov_4 dr_cov1 re_cov1 re_cov2 dr_cov2 ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .05 "5%" .1 "10%" .15 "15%")
    
egen ppe = rsum(ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8)
  
tw (histogram ppe , s(0) w(1) barw(.9) lc(none) fc(gs12) frac yaxis(2)) ///
   (lpoly correct ppe if casex == 1 , lw(thick) ) ///
   (lpoly correct ppe if casex == 9 , lw(thick) ) ///
 , legend(on order(2 "Ordinary Case" 3 "COVID Suspicion") pos(12)) ///
   xtit("Use of PPE index") ///
   yscale(alt) ytit(" ") ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
   yscale(alt ax(2)) ytit(" " , ax(2)) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%", ax(2))

tw (histogram quality , s(0) w(.05) barw(.04) lc(none) fc(gs12) frac yaxis(2)) ///
   (lpoly correct quality if casex == 1 , lw(thick) ) ///
   (lpoly correct quality if casex == 9 , lw(thick) ) ///
 , legend(on order(2 "Ordinary Case" 3 "COVID Suspicion") pos(12)) ///
   xtit("Past quality index") xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
   yscale(alt) ytit(" ") ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
   yscale(alt ax(2)) ytit(" " , ax(2)) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%", ax(2))

tw (histogram quality , s(0) w(.05) barw(.04) lc(none) fc(gs12) frac yaxis(2)) ///
   (lfitci ppe quality, lw(thick) fc(gray%30) alc(white%0)) ///
   (lpoly ppe quality if casex == 1 , lw(thin) ) ///
   (lpoly ppe quality if casex == 9 , lw(thin) ) ///
 , legend(on order(3 "Fitted" 4 "Ordinary" 5 "COVID") r(1) pos(12)) ///
   xtit("Past quality index") xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
   yscale(alt) ytit("Use of PPE index") ylab(0 1 2 3 4) ///
   yscale(alt ax(2)) ytit(" " , ax(2)) ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%", ax(2))

//
