#' Predict values 
#' 
#' Fit a model and make predictions from it.
#' @param df data.frame
#' @param values Values to make predictions from.
#' @param input_var Input variable column name.
#' @param predicted_var Predicted variable name.
#' @inheritParams predict_precision_recall
#' @returns data.frame
#' 
#' @keywords internal
#' @importFrom stats loess predict loess.control
predict_values <- function(df,
                           fun,
                           values, 
                           input_var,
                           predicted_var){
    
    if(length(values)>0){
        messager("+ Predicting",predicted_var,"from",
                 formatC(length(values),big.mark = ","),
                 input_var,"values.")
        #### Fit model ####
        mod <- fun(formula = paste(predicted_var,"~",input_var),
                   control=stats::loess.control(surface="direct"),
                   data = df) 
        #### Make predictions ####
        df2 <- data.frame(input_var=input_var,
                          predicted_var=predicted_var,
                          input=values)
        predicted_col <- "predicted"
        df2[[predicted_col]] <- stats::predict(object = mod, 
                                               df2$input) 
        #### Prevent negative predictions ####
        df2 <- set_min_max(df = df2,
                           colname = predicted_col)
    } else {
        mod <- NULL
        df2 <- NULL
    }
    return(df2)
}
