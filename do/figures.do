// Figures for COVET PPE paper

// Data
use "${git}/data/covet.dta" , clear

// Figure. PPE and Screening
betterbarci ///
  ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8  ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") barc(maroon gray) ///
    nodraw scale(0.7) title("PPE Actions" , pos(11) span)
    
    graph save "${git}/temp/f1-covid-1.gph" ,replace

betterbarci ///
  cov_1 cov_2 cov_3 cov_4 dr_cov1 re_cov1 re_cov2 dr_cov2 ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .05 "5%" .1 "10%" .15 "15%") barc(maroon gray) ///
    nodraw scale(0.7) title("Covid Screening" , pos(11) span)

    graph save "${git}/temp/f1-covid-2.gph" ,replace
    
    grc1leg ///
      "${git}/temp/f1-covid-1.gph" ///
      "${git}/temp/f1-covid-2.gph" ///
    , r(1) pos(12)

  graph export "${git}/outputs/f1-covid.png" , width(2000) replace

// Figure. Summary Results
betterbarci ///
  correct re_1 re_3 re_4 dr_4 med_l_any_?  ///
  , over(casex) pct bar nodraw ///
    legend(on size(small) symxsize(small) ///
      pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") barc(maroon gray)
    
    graph save "${git}/temp/f2-summary-1.gph" ,replace
    
  local x = 2
  local graphs ""
  local legend ""
  foreach var of varlist  re_3 re_4 dr_4 med_l_any_?   { 
    local ++x
    local graphs "`graphs' (lpoly `var' q2 , lc(gs`=16-`x''))"
    local label  : var label `var'
    local legend `"`legend' `x' "`label'" "'
  }
  
  tw  ///
    (lpoly re_1 q2 , lc(black) lw(thick))  ///
    (lpoly dr_cov2 q2 , lc(red) lw(thick)) ///
    `graphs' ///
  , legend(on region(lc(none)) size(small) symxsize(small) ring(1) ///
      order(1 "X-Ray" 2 "COVID Test" `legend') c(3) pos(12)) ///
    ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
    xtit("Past quality index") xlab(0(1)10) nodraw
    
    graph save "${git}/temp/f2-summary-2.gph" ,replace
    
         graph combine ///
           "${git}/temp/f2-summary-1.gph" ///
           "${git}/temp/f2-summary-2.gph" ///
         , r(1) 
    
  graph export "${git}/outputs/f2-summary.png" , width(2000) replace
  
// Figure. PPE Use

  local x = 3
  local graphs ""
  local legend ""
  foreach var of varlist ppe_4 ppe_5 ppe_6 ppe_7 ppe_8 { 
    local ++x
    local graphs "`graphs' (lpoly `var' q2 , lc(gs`=16-`x''))"
    local label  : var label `var'
    local legend `"`legend' `x' "`label'" "'
  }
  
  tw ///
    (lpoly ppe_1 q2 , lc(black) lw(thick))  ///
    (lpoly ppe_2 q2 , lc(red) lw(thick)) ///
    (lpoly ppe_3 q2 , lc(navy) lw(thick)) ///
      `graphs' ///
  , legend(on region(lc(none)) size(small) ///
      order(1 "Other Patients Mask" 2 "Social Distancing" 3 "Provider Masked" `legend') c(1) pos(3)) ///
    ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
    xtit("Past quality index") xlab(0(1)10)
    
   graph export "${git}/outputs/f3-ppe.png" , width(2000) replace

// Figure. Mask use
    
  graph bar mask? ///
  , over(q2) stack legend(on) ///
    ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
    bar(1 , fc(navy%20)) ///
    bar(2 , fc(navy%40)) ///
    bar(3 , fc(navy%80)) ///
    bar(4 , fc(navy)) ///
    title("Mask Use by Prior Quality", pos(11) span) nodraw
    
    graph save "${git}/temp/f3-mask-1.gph" ,replace
        
  betterbarci ///
    re_3 med_l_any_2 re_1 med_l_any_3 dr_cov2 ///
    , over(ppe_9) pct bar legend(on pos(12) ring(1) r(1) region(lw(none))) ///
      xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
      barc(navy navy%80 navy%40 navy%20) nodraw yscale(reverse) ///
      title("Management by Mask Use", pos(11) span)
      
      graph save "${git}/temp/f3-mask-2.gph" ,replace
      
  grc1leg ///
    "${git}/temp/f3-mask-1.gph" ///
    "${git}/temp/f3-mask-2.gph" ///
  , r(1) pos(12) legendfrom("${git}/temp/f3-mask-2.gph")
    
    graph export "${git}/outputs/f4-mask.png" , width(2000) replace
    
// Figure. Quality and correctness

tw ///
   (lfit correct q2 if ppe_9 == 0 , lw(thick) lc(navy%20)) ///
   (lfit correct q2 if ppe_9 == 1 , lw(thick) lc(navy%40)) ///
   (lfit correct q2 if ppe_9 == 2 , lw(thick) lc(navy%80)) ///
   (lfit correct q2 if ppe_9 == 3 , lw(thick) lc(navy)) ///
 , by(casex, iyaxes title("TB Management", pos(11) span) note(" ") legend(off)) ///
   legend(off r(1) size(small) pos(11) ring(0) region(lc(none)) ///
     order(1 "No Mask" 2 "Cloth" 3 "Surgical" 4 "N95" )) ///
   xtit("Past quality index") xlab(0(1)10) ///
   ytit(" ") ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%")  
   
   graph save "${git}/temp/f5-mask-1.gph" , replace
   
   
tw ///
   (lfit dr_cov2 q2 if ppe_9 == 0 , lw(thick) lc(navy%20)) ///
   (lfit dr_cov2 q2 if ppe_9 == 1 , lw(thick) lc(navy%40)) ///
   (lfit dr_cov2 q2 if ppe_9 == 2 , lw(thick) lc(navy%80)) ///
   (lfit dr_cov2 q2 if ppe_9 == 3 , lw(thick) lc(navy)) ///
 , by(casex, iyaxes title("COVID Test", pos(11) span) note(" ") legend(on pos(6))) ///
   legend(off r(1) size(small) pos(11) ring(0) region(lc(none)) ///
     order(1 "No Mask" 2 "Cloth" 3 "Surgical" 4 "N95" )) ///
   xtit("Past quality index") xlab(0(1)10) /// 
   ytit(" ") ylab(0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%")  fysize(55)
   
      graph save "${git}/temp/f5-mask-2.gph" , replace
      
      
    graph combine ///
      "${git}/temp/f5-mask-1.gph" ///
      "${git}/temp/f5-mask-2.gph" ///
    , c(1) imargin(tiny) ysize(6)
    

   graph export "${git}/outputs/f5-mask-screen.png" , width(2000) replace

//
