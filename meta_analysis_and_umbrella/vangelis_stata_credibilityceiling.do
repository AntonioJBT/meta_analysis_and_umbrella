*Analysis code for credibility ceiling in biomarkers and cancer database 1_06_2013*Ceiling=0.01set mem 700m
use "/Users/stefaniapapatheodorou/Desktop/credibility ceiling/biomarkers 1_Stefania_17_9_11-1.dta", clear*delete Eaton and Tong study because they reported ratio of means and WMD, respectivelydrop if compid==31 | compid==32 | compid==33drop if compid==69 | compid==70 | compid==71 | compid==72 | compid==73 | compid==74*transform WMD to OR for Vegliareplace StudyRR=exp(1.81*StudyRR) if compid==106 | compid==107 | compid==105gen se_wmd=(Study_upper_UL - Study_lower_LL)/3.92 if compid==106 | compid==107 | compid==105gen se_logor=1.81*se_wmd if compid==106 | compid==107 | compid==105replace Study_upper_UL=StudyRR*exp(1.96*se_logor) if compid==106 | compid==107 | compid==105replace Study_lower_LL=StudyRR*exp(-1.96*se_logor) if compid==106 | compid==107 | compid==105gen n=No_cases+No_controlsgen log_StudyRR=ln(StudyRR)gen log_Study_lower_LL=ln(Study_lower_LL)gen log_Study_upper_UL=ln(Study_upper_UL)


gen se = (log_Study_upper_UL - log_Study_lower_LL) / (2*invnormal(.975))

gen x=1.2

gen logx=log(x)gen z=((log_StudyRR-logx)/se)gen prob=1-normal(abs(z))gen ceiling=0.09
gen zc1=invnormal(ceiling)gen newvar=(se^2)replace newvar=(log_StudyRR/zc1)^2 if prob < ceilinggen var=(se^2)gen newse=sqrt(newvar)*Calculate new random effects estimates with inflated variancesgen effectrandom=0gen seesrandom=0gen effectrandom_l=0gen effectrandom_u=0gen float p_z=0gen i_sq=0sort compidquietly summarize compidforvalues i=1/`r(max)' {quietly metan log_StudyRR newse if compid==`i',nograph random eformreplace effectrandom=r(ES) if compid==`i'replace seesrandom=r(selogES) if compid==`i'replace effectrandom_l=r(ci_low) if compid==`i'replace effectrandom_u=r(ci_upp) if compid==`i'replace p_z=r(p_z) if compid==`i'replace i_sq=r(i_sq) if compid==`i'}gen lr=(1-p_z)/p_zsort compidquietly by compid: gen dup=cond(_N==1, 0,_n)drop if dup>1*Repeat this code for ceilings 0.00-0.4 and for x=1.2, x=2.0 and x=5