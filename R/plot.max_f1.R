#' Maximum F1 Score (Precision with Sensitivity harmonic mean) plotting
#' 
#' This function allows to use a custom thresholding method to maximize the F1 Score (Precision with Sensitivity harmonic mean). A data.table of values is returned.
#' 
#' @param preds Type: numeric. The predictions.
#' @param labels Type: numeric. The labels (0, 1).
#' @param plots Type: numeric. Whether to plot the data immediately or not.
#' @param ... Other arguments to pass to \code{plot}.
#' 
#' @return A data.table containing the probabilities and their F1 Score (Precision with Sensitivity harmonic mean).
#' 
#' @export

plotting.max_f1 <- function(preds, labels, plots = TRUE, ...) {
  
  DT <- data.table(y_true = labels, y_prob = preds, key = "y_prob")
  cleaner <- !duplicated(DT[, "y_prob"], fromLast = TRUE)
  nump <- sum(labels)
  numn <- length(labels) - nump
  
  DT[, fp_v := cumsum(y_true == 1)]
  DT[, fn_v := numn - as.numeric(cumsum(y_true == 0))]
  DT[, tp_v := nump - fp_v]
  DT <- DT[cleaner, ]
  DT[, f1s := 2 * tp_v / (2 * tp_v + fp_v + fn_v)]
  DT <- DT[is.finite(f1s)]
  if (plots) {
    plot(x = DT[["y_prob"]], y = DT[["f1s"]], ...)
  }
  
  return(DT[, c("y_prob", "f1s")])
  
}