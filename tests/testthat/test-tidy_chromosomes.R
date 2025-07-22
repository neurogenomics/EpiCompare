# This function and its tests were adapted from \code{tidyChromosomes} in the
# \code{BRGenomics} package licensed under the Artistic License 2.0.
# Original author: Mike DeBerardine <https://github.com/mdeber>

library(GenomeInfoDb)  # for dropSeqlevels()

bw <- GRanges(seqnames = c("chr2L", "chrM", "chrX", "chrY", "unassigned"),
              ranges = IRanges(1:5, 2:6))
genome(bw) <- "dm6"

test_that("sex chromosomes", {
    trim_x <- tidy_chromosomes(bw, keep.X = FALSE, keep.M = TRUE,
                              keep.nonstandard = TRUE)
    expect_equal(length(trim_x), length(bw)-1)
    expect_equal(seqinfo(trim_x),
                 sortSeqlevels(dropSeqlevels(seqinfo(bw), "chrX")))
    
    trim_y <- tidy_chromosomes(bw, keep.Y = FALSE, keep.M = TRUE,
                              keep.nonstandard = TRUE)
    expect_equal(length(trim_y), length(bw)-1)
    expect_equal(seqinfo(trim_y),
                 sortSeqlevels(dropSeqlevels(seqinfo(bw), "chrY")))
})

test_that("trim non-standard, keep sex", {
    # default keeps sex, trims M and non-standard
    trim_default <- tidy_chromosomes(bw, keep.X = TRUE, keep.Y = TRUE,
                                    keep.M = FALSE,
                                    keep.nonstandard = FALSE)
    expect_equal(length(trim_default), length(bw)-2)
    expect_equal(seqinfo(trim_default),
                 sortSeqlevels(dropSeqlevels(seqinfo(bw),
                                             c("chrM", "unassigned"))))
})

test_that("use pre-assigned genome", {
    expect_identical(tidy_chromosomes(bw),
                     tidy_chromosomes(bw, genome = "dm6"))
})

test_that("trim from list input", {
    trim_ls <- tidy_chromosomes(list(bw, bw))
    expect_type(trim_ls, "list")
    expect_identical(trim_ls[[1]], tidy_chromosomes(bw))
})

test_that("trim seqinfo object", {
    si <- seqinfo(bw)
    expect_identical(tidy_chromosomes(si), seqinfo(tidy_chromosomes(bw)))
})
