test_that("compute_corr works", {
  
    data("CnR_H3K27ac")
    data("CnT_H3K27ac")
    data("encode_H3K27ac")
    peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
    reference <- list("encode_H3K27ac" = encode_H3K27ac)

    #increasing bin_size for speed but lower values will give more granular corr
    bins <- c(500000,100000,10000,5000
              # 1000,500,400,200,100,50
              )
    cor_mats <- mapply(stats::setNames(bins,bins),
                       SIMPLIFY = FALSE,
                       FUN=function(bin_size){
        compute_corr(peakfiles = peakfiles,
                     reference = reference,
                     genome_build = "hg19",
                     workers = 1,
                     bin_size = bin_size)
    })
    cor_mats2 <- mapply(cor_mats, 
                       SIMPLIFY = FALSE,
                       FUN=function(x){diag(x)<-NA;x}) 
    cor_mean <- mapply(cor_mats2, FUN=mean, na.rm=TRUE)
    testthat::expect_equal(round(mean(cor_mean),2),.75)
    #### Larger bin size strongly predicts great inter-sample correlation ####
    testthat::expect_gte(
        cor(as.numeric(names(cor_mean)), cor_mean), .85
    )
    # saveRDS(cor_mats, file = "~/Downloads/compute_corr.cor_mats.rds")
})
