// Figures for COVET quick hit

// Figure. Top-line results
use "${git}/data/covet.dta" , clear

egen ppe = rsum(ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8)
egen checkr = cut(checklist) , at(0 .10 .20 .30 .40 .50 .60 .70 .80 .90 1)
egen q2 = cut(quality) , at(0 .10 .20 .30 .40 .50 .60 .70 .80 .90 1)
  replace q2 = q2*10
tab ppe_9, gen(mask)

// Figure. Summary Results
betterbarci ///
  correct re_1 re_3 re_4 dr_4 med_l_any_?  ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") barc(maroon gray)
    
  graph export "${git}/outputs/f1-summary.png" , width(2000) replace

// Figure. PPE and Screening
betterbarci ///
  ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8  ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") barc(maroon gray) ///
    nodraw scale(0.7) title("PPE Actions" , pos(11) span)
    
    graph save "${git}/temp/f2-covid-1.gph" ,replace

betterbarci ///
  cov_1 cov_2 cov_3 cov_4 dr_cov1 re_cov1 re_cov2 dr_cov2 ///
  , over(casex) pct bar legend(on pos(12) ring(1) region(lw(none))) ///
    xlab(0 "0%" .05 "5%" .1 "10%" .15 "15%") barc(maroon gray) ///
    nodraw scale(0.7) title("Covid Screening" , pos(11) span)

    graph save "${git}/temp/f2-covid-2.gph" ,replace
    
    grc1leg ///
      "${git}/temp/f2-covid-1.gph" ///
      "${git}/temp/f2-covid-2.gph" ///
    , r(1) pos(12)

  graph export "${git}/outputs/f2-covid.png" , width(2000) replace

// Figure. Mask use
betterbarci ///
   re_3 med_l_any_2 re_1 med_l_any_3  ///
  , over(ppe_9) pct bar legend(on pos(12) ring(1) r(1) region(lw(none))) ///
    xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
    barc(navy navy%80 navy%40 navy%20) nodraw yscale(reverse) ///
    title("Management by Mask Use", pos(11) span)
    
    graph save "${git}/temp/f3-mask-1.gph" ,replace
    
    graph bar mask? ///
    , over(q2) stack legend(on) ///
      ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
      bar(1 , fc(navy%20)) ///
      bar(2 , fc(navy%40)) ///
      bar(3 , fc(navy%80)) ///
      bar(4 , fc(navy)) ///
      title("Mask Use by Prior Quality", pos(11) span)nodraw
      
      graph save "${git}/temp/f3-mask-2.gph" ,replace
      
          grc1leg ///
            "${git}/temp/f3-mask-1.gph" ///
            "${git}/temp/f3-mask-2.gph" ///
          , r(1) pos(12)
    
    graph export "${git}/outputs/f3-mask.png" , width(2000) replace
    
// Figure. Quality and correctness

tw ///
   (lpoly correct q2 if ppe_9 == 0 , lw(thick) lc(navy%20)) ///
   (lpoly correct q2 if ppe_9 == 1 , lw(thick) lc(navy%40)) ///
   (lpoly correct q2 if ppe_9 == 2 , lw(thick) lc(navy%80)) ///
   (lpoly correct q2 if ppe_9 == 3 , lw(thick) lc(navy)) ///
   (histogram q2 , fc(gs14) s(0) w(1) lc(none) barw(0.9) discrete) ///
 , legend(on c(1) size(small) pos(11) ring(0) region(lc(none)) ///
     order(1 "No Mask" 2 "Cloth" 3 "Surgical" 4 "N95")) ///
   xtit("Past quality index") xlab(0(1)10) ///
   ytit(" ") ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") 
   
   graph export "${git}/outputs/f4-mask-correct.png" , width(2000) replace

//
