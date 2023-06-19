"""
    pprob_col(Y::Matrix{T},Ycol::Vector{T}; method="moments") where T<:AbstractFloat

Compute the posterior probabilities for Findr test 0 (**correlation test**) for a given column vector `Ycol` against all columns of matrix `Y`.

`Y` and `Ycol` are assumed to have undergone supernormalization with each column having mean zero and variance one. The LLRs are scaled by the number of rows (samples).

The optional parameters `method` determines the mixture distribution fitting method and can be either `moments` (default) for the method of moments, or `kde` for kernel-based density estimation.
"""
function pprob_col(Y::Matrix{T},Ycol::Vector{T}; method="moments") where T<:AbstractFloat
    # number of samples
    ns = size(Y,1) 
    # log-likelihood ratios
    llr = realLLR_col(Y,Ycol) 
    # posterior probabilities
    if method == "moments"
        # Method of moments can fail if moments don't satisfy a positivity condition
        try
            pp, _ = fit_mixdist_mom(llr,ns)
        catch e
            # Fall back on KDE method in case of failure
            @warn "Encountered $e, using KDE instead of moments method."
            pp = fit_mixdist_KDE(llr,ns)
        end        
    elseif method == "kde"
        pp = fit_mixdist_KDE(llr,ns)
    else
        error("Optional `method` parameter must be equal to `moments` or `KDE`.")
    end
    return pp
end

"""
    pprob_col(Y::Matrix{T},Ycol::Vector{T},E::Vector{S}; method="moments") where {T<:AbstractFloat, S<:Integer}   

Compute the posterior probabilities for the Findr causal tests for a given column vector `Ycol` with categorical instrument `E` against all columns of matrix `Y`: 

    - Test 2 (**Linkage test**) 
    - Test 3 (**Mediation test**)
    - Test 4 (**Relevance test**)
    - Test 5 (**Pleiotropy test**)
    
`Y` is assumed to have undergone supernormalization with each column having mean zero and variance one.

For test 2, 4, and 5 the posterior probabilities are the probabilities of the alternative hypothesis being true. For test 3 they are the probabilities of the null hypothesis being true.

The optional parameters `method` determines the mixture distribution fitting method and can be either `moments` (default) for the method of moments, or `kde` for kernel-based density estimation.
"""
function pprob_col(Y::Matrix{T},Ycol::Vector{T},E::Vector{S}; method="moments") where {T<:AbstractFloat, S<:Integer}
    # number of samples and groups
    ns = size(Y,1) 
    ng = length(unique(E))
    # log-likelihood ratios
    llr2, llr3, llr4, llr5 = realLLR_col(Y,Ycol,E)
    # allocate output array
    pp = ones(length(llr2),4)
    if method == "moments"
        # posterior probabilities for test 2
        try
            # Method of moments can fail if moments don't satisfy a positivity condition
            pp[:,1], _ = fit_mixdist_mom(llr2,ns,ng,:link)
        catch e
            # Fall back on KDE method in case of failure
            @warn "Encountered $e, using KDE instead of moments method."
            pp[:,1] = fit_mixdist_KDE(llr2,ns,ng,:link)
        end
        
        # posterior probabilities for test 3, here we swap the role of null and alternative
        try
            # Method of moments can fail if moments don't satisfy a positivity condition
            pp[:,2], _ = fit_mixdist_mom(llr3,ns,ng,:med)
        catch e
            # Fall back on KDE method in case of failure
            @warn "Encountered $e, using KDE instead of moments method."
            pp[:,2] = fit_mixdist_KDE(llr3,ns,ng,:med)
        end      
        
        # posterior probabilities for test 4 and 5
        try
            # Method of moments can fail if moments don't satisfy a positivity condition
            pp[:,3], _ = fit_mixdist_mom(llr4,ns,ng,:relev)
        catch e
            # Fall back on KDE method in case of failure
            @warn "Encountered $e, using KDE instead of moments method."
            pp[:,3] = fit_mixdist_KDE(llr4,ns,ng,:relev)
        end   
        try
            # Method of moments can fail if moments don't satisfy a positivity condition
            pp[:,4], _ = fit_mixdist_mom(llr5,ns,ng,:pleio)
        catch e
            # Fall back on KDE method in case of failure
            @warn "Encountered $e, using KDE instead of moments method."
            pp[:,4] = fit_mixdist_KDE(llr5,ns,ng,:pleio)
        end        
    elseif method == "kde"
        # posterior probabilities for test 2
        pp[:,1] = fit_mixdist_KDE(llr2,ns,ng,:link)
        # posterior probabilities for test 3, here we swap the role of null and alternative
        pp[:,2] = fit_mixdist_KDE(llr3,ns,ng,:med)
        # posterior probabilities for test 4 and 5
        pp[:,3] = fit_mixdist_KDE(llr4,ns,ng,:relev)
        pp[:,4] = fit_mixdist_KDE(llr5,ns,ng,:pleio)
    else
        error("Optional `method` parameter must be equal to `moments` or `KDE`.")
    end
    return pp
end


"""
    pprob_col(Y::Matrix{T},E::Vector{S}; method="moments") where {T<:AbstractFloat, S<:Integer}

Compute the posterior probabilities for differential expression of columns of matrix `Y` in the groups defined by  categorical vector `E` using Findr test 2 (**Linkage test**) 
    
`Y` is assumed to have undergone supernormalization with each column having mean zero and variance one.

The optional parameters `method` determines the mixture distribution fitting method and can be either `moments` (default) for the method of moments, or `kde` for kernel-based density estimation.
"""
function pprob_col(Y::Matrix{T},E::Vector{S}; method="moments") where {T<:AbstractFloat, S<:Integer}
    # number of samples and groups
    ns = size(Y,1) 
    ng = length(unique(E))
    # log-likelihood ratios
    llr2 = realLLR_col(Y,E)
    # posterior probabilities for test 2
    if method == "moments"
        # Method of moments can fail if moments don't satisfy a positivity condition
        try
            pp, _ = fit_mixdist_mom(llr2,ns,ng,:link)
        catch e
            # Fall back on KDE method in case of failure
            @warn "Encountered $e, using KDE instead of moments method."
            pp = fit_mixdist_KDE(llr2,ns,ng,:link)
        end
    elseif method == "kde"
        pp = fit_mixdist_KDE(llr2,ns,ng,:link)
    else
        error("Optional `method` parameter must be equal to `moments` or `KDE`.")
    end
    return pp
end



"""
    fit_mixdist_mom(llr,ns,ng=1,test=:corr)

Fit a two-component mixture distribution of two LBeta distributions to a vector of log-likelihood ratios `llr` using a method-of-moments algorithm. The first component is the true null distribution for a given Findr `test` with sample size `ns` and number of genotype groups `ng`. The second component is the alternative distribution, assumed to follow an [`LBeta`](@ref) distribution. The prior probability `pi0` of an observation belonging to the null component is fixed and determined by the [`pi0est`](@ref) function. Hence only the parameters of the alternative component need to be estimated.

The input variable `test` can take the values:

- :corr - **correlation test** (test 0)
- :link - **linkage test** (test 1/2)
- :med - **mediation test** (test 3)
- :relev - **relevance test** (test 4)
- :pleio - **pleiotropy test** (test 5)

With two input arguments, the correlation test with `ns` samples is used. With three input arguments, or with four arguments and `test` equal to `:corr`, the correlation test with `ns` samples is used and the third argument is ignored.

See also [`fit_mom`](@ref)
"""
function fit_mixdist_mom(llr,ns,ng=1,test=:corr)
    # set null distribution and estimate proportion of true nulls
    dnull = nulldist(ns, ng, test) 
    π0 = pi0est( nullpval(llr, ns, ng, test) )

    if π0 < 1. #< 0.95
        # first and second moment for the Beta distribution corresponding to the null distribution
        bp = 0.5 .* params(dnull)
        bm1 = bp[1] / sum(bp)
        bm2 = bm1 * (bp[1] + 1) / (sum(bp) + 1)

        # transform llr to (mixture of) Beta distributed values
        z = 1 .-  exp.(-2 .* llr)

        # get first and second moment for the Beta distribution corresponding to the alternative distribution
        m1 = ( mean(z) - π0 * bm1 ) / (1 - π0)
        m2 = ( mean(z.^2) - π0 * bm2 ) / (1 - π0)

        # fit the alternative distribution
        dalt = fit_mom(LBeta, m1, m2)
        
        # do some sanity checks:
        #   - in the limit llr -> 0, dnull must dominate
        #   - in the limint llr -> Inf, dalt must dominate
        #   - 
        if dalt.α < dnull.α
            dalt = LBeta(dnull.α,dalt.β)
        end
        if dalt.β > dnull.β 
            dalt = LBeta(dalt.α,dnull.β)
        end

        # evaluate null and alternative distributions and compute posterior probabilities
        pnull = pdf.(dnull, llr)
        palt = pdf.(dalt, llr) 
        pp = (1-π0) .*  palt./ (π0 .* pnull .+ (1-π0) .* palt)

        # Set mixture distribution
        dreal = MixtureModel(LBeta[dnull, dalt],[π0, 1-π0])
    else
        pp = zeros(size(llr))
        dreal = dnull
    end

    # Return posterior probabilities and estimated mixture distribution
    return pp, dreal
end


"""
    fit_mixdist_KDE(llr,ns,[ng,test])

Return posterior probabilities for a vector of log-likelihood ratio values `llr` for a given Findr `test` with sample size `ns` and number of genotype groups `ng`. The input variable `test` can take the values:

- ':corr' - **correlation test** (test 0)
- ':link' - **linkage test** (test 1/2)
- ':med' - **mediation test** (test 3)
- ':relev' - **relevance test** (test 4)
- ':pleio' - **pleiotropy test** (test 5)

With two input arguments, the correlation test with `ns` samples is used. With three input arguments, or with four arguments and `test` equal to ":corr", the correlation test with `ns` samples is used and the third argument is ignored.
"""
function fit_mixdist_KDE(llr,ns,ng=1,test=:corr)
    # Set the null distribution
    dnull = nulldist(ns, ng, test)
    π0 = pi0est( nullpval(llr, ns, ng, test) )
    
    # Evaluate the null distribution p.d.f. on the log-likelihood ratios
    pnull = pdf.(dnull, llr)
    
    # Fit and evaluate the real distribution p.d.f. on the log-likelihood ratios
    preal = fit_kde(llr)

    # Compute the posterior probabilities of the alternative hypothesis being true
    pp = 1 .- π0 * pnull ./ preal

    # Smoothen posterior probs and make monotonically increasing
    perm = sortperm(llr, rev=true);
    inv_perm = invperm(perm);
    pp[pp .< 0] .= 0;
    pp = accumulate(min,pp[perm])[inv_perm];

    return pp
    
end


"""
    fit_kde(llr)

Fit a distribution function to a vector of log-likelihood ratio values `llr` using kernel density estimation. To avoid boundary effects in the KDE, the log-likelihoods (which take values in ``[0,\\infty)``) are first transformed to a vector of `z`,
    
``
z = \\log \\left( e^{2 LLR} - 1 \\right)
``

which takes values in ``(-\\infty,\\infty)``. KDE is applied to `z`, and the probability density function (pdf) for `llr` is obtained from the pdf for `z` by the usual transformation rule for functions of random variables.
"""
function fit_kde(llr)
    # Transform llr values to avoid edge effects in density estimation
    z = log.(exp.(2 .* llr) .- 1)
    
    # Apply kernel density estimation to transformed values
    dfit = kde(z)

    # Evaluate pdf at llr values using rule for transformations of random variables
    pd = 2 * pdf(dfit, z) .* (1 .+ exp.(-z))
    return pd
end

"""
    fit_mixdist_EM(llr,ns,ng=1,test=:corr; maxiter=1000, tol=1e-3)

Fit a two-component mixture distribution of two LBeta distributions to a vector of log-likelihood ratios `llr` using an EM algorithm. The first component is the true null distribution for a given Findr `test` with sample size `ns` and number of genotype groups `ng`. The second component is the alternative distribution, assumed to follow an LBeta distribution. The prior probability `pi0` of an observation belonging to the null component is fixed and determined by the `pi0est` function. Hence only the parameters of the alternative component need to be estimated.

The EM algorithm outputs posterior probabilities of the alternative hypothesis being true, in the form of the estimated recognition distribution. The optional parameters `maxiter` (default value 1000) and `tol` (default value 1e-3) control the convergence of the EM algorithm.

The input variable `test` can take the values:

- ':corr' - **correlation test** (test 0)
- ':link' - **linkage test** (test 1/2)
- ':med' - **mediation test** (test 3)
- ':relev' - **relevance test** (test 4)
- ':pleio' - **pleiotropy test** (test 5)

With two input arguments, the correlation test with `ns` samples is used. With three input arguments, or with four arguments and `test` equal to ":corr", the correlation test with `ns` samples is used and the third argument is ignored.
"""
function fit_mixdist_EM(llr,ns,ng=1,test=:corr; maxiter::Int=1000, tol::Float64=1e-3)

    # set null distribution and estimate proportion of true nulls
    dnull = nulldist(ns, ng, test) 
    π0 = pi0est( nullpval(llr, ns, ng, test) )
    
    if π0 < 1.0
        # Initial guess for the alternative distribution: fit an LBeta distribution to the 50% largest llr values
        dalt = fit(LBeta,llr) #fit(LBeta,llr[llr .> quantile(llr,0.5)])

        # Set the current recognition / posterior probability values
        pnull = pdf.(dnull, llr)
        palt = pdf.(dalt, llr) 
        pp = (1-π0) .*  palt./ (π0 .* pnull .+ (1-π0) .* palt)

        # EM until convergence
        converged = false
        it = 0
        while !converged && it < maxiter
            it += 1
            println(it)
            # Update the alternative distribution using current pp
            w = pweights(pp)
            dalt = fit_weighted(LBeta, llr, w)
            if dalt.α < dnull.α
                dalt = LBeta(dnull.α,dalt.β)
            end
            if dalt.β > dnull.β
                dalt = LBeta(dalt.α,dnull.β)
            end
            # Update pp using new params
            palt = pdf.(dalt, llr)
            println(dalt)
        # π0 = 1 - sum(pp)/length(pp)
            pp = (1-π0) .*  palt./ (π0 .* pnull .+ (1-π0) .* palt)
            
            # Check convergence
            converged = norm(pp.-w,Inf) < tol 
            #println(norm(pp.-w,Inf))
        end
        # Set mixture distribution
        dreal = MixtureModel(LBeta[dnull, dalt],[π0, 1-π0])
    else
        pp = zeros(size(llr))
        dreal = dnull
    end

    # Return posterior probabilities and estimated mixture distribution
    return pp, dreal
end

"""
    pi0est(pval)

Estimate the proportion π0 of truly null features in a vector `pval` of p-values using a [bootstrap method](http://varianceexplained.org/files/pi0boot.pdf).
"""
function pi0est(pval)
    λ = 0:0.05:0.95
    pval = sort(pval)
    m = length(pval)
    W = map(x -> sum(pval.>=x),λ)
    π0 = W ./ (m*(1 .- λ))
    minπ0 = minimum(π0) #quantile(π0,0.1)  # 
    mse = (W ./ (m^2 * (1 .- λ).^2)) .* (1 .- W/m) .+ (π0 .- minπ0).^2
    π0[argmin(mse)]
end