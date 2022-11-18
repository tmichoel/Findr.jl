var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Findr","category":"page"},{"location":"#Findr","page":"Home","title":"Findr","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Findr.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Findr]","category":"page"},{"location":"#Findr.LBeta","page":"Home","title":"Findr.LBeta","text":"LBeta(α,β)\n\nThe LBeta distribution with parameters alpha and beta is defined as the distribution of a random variable \n\nX=-frac12(ln(1-Y))\n\nwhere YsimoperatornameBeta(alpha beta)\n\n\n\n\n\n","category":"type"},{"location":"#Distributions.ccdf-Tuple{Findr.LBeta, Real}","page":"Home","title":"Distributions.ccdf","text":"ccdf(d,x)\n\nEvaluate the complementary cumulative distribution function of an LBeta distribution using its relation to the Beta distribution. \n\n\n\n\n\n","category":"method"},{"location":"#Distributions.cdf-Tuple{Findr.LBeta, Real}","page":"Home","title":"Distributions.cdf","text":"cdf(d,x)\n\nEvaluate the cumulative distribution function of an LBeta distribution using its relation to the Beta distribution. \n\n\n\n\n\n","category":"method"},{"location":"#Distributions.logccdf-Tuple{Findr.LBeta, Real}","page":"Home","title":"Distributions.logccdf","text":"logccdf(d,x)\n\nEvaluate the complementary cumulative distribution function of an LBeta distribution using its relation to the Beta distribution. \n\n\n\n\n\n","category":"method"},{"location":"#Distributions.pdf-Tuple{Findr.LBeta, Real}","page":"Home","title":"Distributions.pdf","text":"pdf(d,x)\n\nEvaluate the probability density function of an LBeta distribution with support on xgeq 0. \n\n\n\n\n\n","category":"method"},{"location":"#Findr.groupmeans-Tuple{Any, Any}","page":"Home","title":"Findr.groupmeans","text":"groupmeans(Y,E)\n\nCompute the size and mean of each row of matrix Y for each of the groups (unique values) in categorical vector E.\n\n\n\n\n\n","category":"method"},{"location":"#Findr.llrstats_row-Tuple{Any, Any, Any}","page":"Home","title":"Findr.llrstats_row","text":"llrstats_row(Y,E,row)\n\nCompute the sufficient statistics to compute the log-likelihood ratios for Findr tests 2-5  for a given row (gene) of gene expression matrix Y with categorical instrument E against all other rows of Y.\n\nY is assumed to have undergone supernormalization with each row having mean zero and variance one. The LLRs are scaled by the number of samples.\n\nThe sufficient statistics are:\n\nthe covariance ρ between the given row of matrix Y and all other rows of Y\nthe weighted average variances σ1 of each row of matrix Y over the groups (unique values) in E\nthe weighted average covariance σ2 between the given row of Y and all other rows of Y over the groups (unique values) of E\n\n\n\n\n\n","category":"method"},{"location":"#Findr.nulldist","page":"Home","title":"Findr.nulldist","text":"nulldist(ns,[ng,test])\n\nReturn an LBeta distribution that is the null distribution of the log-likelihood ratio for a given Findr test with sample size ns and number of genotype groups ng. The input variable test can take the values:\n\n':corr' - correlation test (test 0)\n':link' - linkage test (test 1/2)\n':med' - mediation test (test 3)\n':relev' - relevance test (test 4)\n':pleio' - pleiotropy test (test 5)\n\nWith only one input argument, the null distribution for the correlation test with ns samples is returned. With two input arguments, or  with three arguments and test equal to \"corr\", the null distribution for the correlation test with ns samples is returned and the second argument is ignored\n\n\n\n\n\n","category":"function"},{"location":"#Findr.nulllog10pval","page":"Home","title":"Findr.nulllog10pval","text":"nulllog10pval(llr,ns,[ng,test])\n\nReturn negative log10 p-values for a vector of log-likelihood ratio values llr under the null distribution of the log-likelihood ratio for a given Findr test with sample size ns and number of genotype groups ng. The input variable test can take the values:\n\n':corr' - correlation test (test 0)\n':link' - linkage test (test 1/2)\n':med' - mediation test (test 3)\n':relev' - relevance test (test 4)\n':pleio' - pleiotropy test (test 5)\n\nWith two input arguments, the correlation test with ns samples is used. With three input arguments, or with four arguments and test equal to \"corr\", the correlation test with ns samples is used and the third argument is ignored.\n\n\n\n\n\n","category":"function"},{"location":"#Findr.nullpval","page":"Home","title":"Findr.nullpval","text":"nullpval(llr,ns,[ng,test])\n\nReturn p-values for a vector of log-likelihood ratio values llr under the null distribution of the log-likelihood ratio for a given Findr test with sample size ns and number of genotype groups ng. The input variable test can take the values:\n\n':corr' - correlation test (test 0)\n':link' - linkage test (test 1/2)\n':med' - mediation test (test 3)\n':relev' - relevance test (test 4)\n':pleio' - pleiotropy test (test 5)\n\nWith two input arguments, the correlation test with ns samples is used. With three input arguments, or with four arguments and test equal to \":corr\", the correlation test with ns samples is used and the third argument is ignored.\n\n\n\n\n\n","category":"function"},{"location":"#Findr.pi0est-Tuple{Any}","page":"Home","title":"Findr.pi0est","text":"pi0est(pval)\n\nEstimate the proportion π0 of truly null features in a vector pval of p-values using Storey's method\n\n\n\n\n\n","category":"method"},{"location":"#Findr.pi0est2-Tuple{Any}","page":"Home","title":"Findr.pi0est2","text":"pi0est2(pval)\n\nEstimate the proportion π0 of truly null features in a vector llr of log-likelihood ratios\n\n\n\n\n\n","category":"method"},{"location":"#Findr.realLLRcausal_row-Tuple{Any, Any, Any}","page":"Home","title":"Findr.realLLRcausal_row","text":"realLLRcausal_row(Y,E,row)\n\nCompute for a given row (gene) of gene expression matrix Y with categorical instrument E against all other rows of Y the log-likelihood ratios for Findr causal tests: \n\nTest 2 (Linkage test) \nTest 3 (Mediation test)\nTest 4 (Relevance test)\nTest 5 (Pleiotropy test)\n\nY is assumed to have undergone supernormalization with each row having mean zero and variance one. The LLRs are scaled by the number of samples.\n\n\n\n\n\n","category":"method"},{"location":"#Findr.realLLRcorr_row-Tuple{Any, Any}","page":"Home","title":"Findr.realLLRcorr_row","text":"realLLRcorr_row(Y,row)\n\nCompute the log-likelihood ratios for Findr test 0 (correlation test) for a given row (gene) of gene expression matrix Y against all other rows of Y.\n\nY is assumed to have undergone supernormalization with each row having mean zero and variance one. The LLRs are scaled by the number of samples.\n\n\n\n\n\n","category":"method"},{"location":"#Findr.supernormalize","page":"Home","title":"Findr.supernormalize","text":"supernormalize(X[, c])\n\nConvert each row of matrix X of reals into standard normally distributed values using a rank-based inverse normal transformation. Then scale each row to have variance one.\n\nNote that after the inverse normal transformation, each row has mean zero and identical variance (if we use ordinal ranking). Hence rescaling can be done once on the whole matrix.\n\nThe formula and default value for the paramater c come from this paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2921808/\n\n\n\n\n\n","category":"function"},{"location":"#StatsAPI.params-Tuple{Findr.LBeta}","page":"Home","title":"StatsAPI.params","text":"params(d)\n\nGet the parameters of an LBeta distribution.\n\n\n\n\n\n","category":"method"}]
}
