test_that("bpplapply works", { 
    
    X <- stats::setNames(seq_len(length(letters)), letters)
    
    #### BiocParallel ####
    out1 <- bpplapply(X, print, workers = 1) 
    testthat::expect_true(is.list(out1))
    testthat::expect_equal(names(out1), names(X)) 
    
    #### BiocParallel ####
    out2 <- bpplapply(X, print, workers = 2, use_snowparam = FALSE) 
    testthat::expect_true(is.list(out2))
    testthat::expect_equal(names(out2), names(out2))
    
    #### lapply ####
    out3 <- bpplapply(X, print, workers = 1, apply_fun = lapply) 
    testthat::expect_true(is.list(out3))
    testthat::expect_equal(names(out3), names(X))
    
    #### mapply ####
    out4 <- bpplapply(X, print, workers = 1, apply_fun = mapply) 
    testthat::expect_true(is.vector(out4))
    testthat::expect_equal(names(out4), names(X))
})
