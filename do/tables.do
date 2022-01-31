// Tables for COVET PPE paper

// Table. Summary statistics

local varlist ///
  covid_label1 ppe_1 ppe_2 ppe_3 ppe_4 ppe_5 ppe_6 ppe_7 ppe_8 ///
  covid_label2 cov_1 cov_2 cov_3 cov_4 dr_cov1 re_cov1 re_cov2 dr_cov2 ///
  covid_label3 cov_6 cov_7 cov_8 cov_9 cov_10 cov_11 cov_12 cov_13 cov_14 cov_15 cov_16 ///
  covid_label4 dr_cov1 re_cov1 re_cov2 dr_cov2

sumstats ///
  (`varlist' if casex == 1) ///
  (`varlist' if casex != 1) ///
using "${git}/outputs/t1-summary.xlsx" ///
, replace stats(mean sd count)

// Table. Regression results

reg correct q2 9.casex , cl(cp_4)
  est sto r1

reg correct q2 9.casex b1.ppe_9, cl(cp_4)
  est sto r2
  
reg dr_cov2 q2 9.casex , cl(cp_4)
  est sto c1

reg dr_cov2 q2 9.casex b1.ppe_9, cl(cp_4)
  est sto c2
  

outwrite r1 r2  c1 c2 ///
  using "${git}/outputs/t2-regression.xlsx" ///
, replace stats(N r2)

// End
