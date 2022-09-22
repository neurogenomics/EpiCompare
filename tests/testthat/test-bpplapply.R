test_that("bpplapply works", { 
    
    X <- stats::setNames(seq_len(length(letters)), letters)
    out <- bpplapply(X, print) 
    testthat::expect_true(is.list(out))
    testthat::expect_equal(names(out), names(X))
})
