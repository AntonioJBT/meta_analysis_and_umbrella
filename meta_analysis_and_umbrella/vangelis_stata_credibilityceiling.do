*Analysis code for credibility ceiling in biomarkers and cancer database 1_06_2013
use "/Users/stefaniapapatheodorou/Desktop/credibility ceiling/biomarkers 1_Stefania_17_9_11-1.dta", clear


gen se = (log_Study_upper_UL - log_Study_lower_LL) / (2*invnormal(.975))

gen x=1.2

gen logx=log(x)
