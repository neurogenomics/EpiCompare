test_that("peak score boxplot works", {
    # Load Data
    data("encode_H3K27ac")
    data("CnT_H3K27ac")
    peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)  
    
    # Generate plot
    my_plot <- plot_peak_scores(peaklist = peaklist) 
    
    # Check
    expect_s3_class(my_plot$plot, "ggplot")
    expect_s3_class(my_plot$data, "data.frame")
})