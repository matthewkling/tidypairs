#' Generate data for pairwise scatterplot matrix.
#'
#' Convert a wide dataset into a format that can be fed to ggplot to create a
#' scatterplot matrix. The dataset is restructured into a format with columns
#' for the x and y values, and columns for the x and y facets.
#'
#' @param data Data frame (in "wide" format, i.e. must contain a column for each
#'   xy_vars and z_vars).
#' @param xy_vars Character vector indicating variables to be paired (these
#'   would be the x and y dimensions if the result is used for a scatterplot
#'   matrix).
#' @param z_vars Optional character vector indicating additional variables to
#'   retain for each record.
#' @param mirror Logical indicating whether to include data for both upper and
#'   lower triangles of the matrix (default is FALSE).
#' @param diagonal Logical indicating whether to include data for the diagonal
#'   of the matrix, in which the x and y variables match (default is FALSE).
#' @return A restructured data frame, with columns `x_var`, `y_var`, `x_value`,
#'   and `y_value`, as well as a column for each of `z_vars`.
#' @examples
#' d <- tidypairs(iris, xy_vars = names(iris)[1:4], z_vars = names(iris)[5])
#' library(ggplot2)
#' ggplot(d, aes(x_value, y_value, color = Species)) +
#'   facet_grid(y_var ~ x_var, scales = "free") +
#'   geom_point()
#' @export
tidypairs <- function(data, xy_vars, z_vars = NULL, mirror = F, diagonal = F){

      combos <- utils::combn(sort(xy_vars), 2)
      if(mirror) combos <- cbind(combos, combos[2:1,])
      if(diagonal) combos <- cbind(combos, matrix(rep(xy_vars, each = 2), nrow = 2))

      for(pair in 1:ncol(combos)){
            v1 <- combos[1, pair]
            v2 <- combos[2, pair]
            dpair <- data.frame(pair_id = as.character(pair),
                                x_var = v2,
                                y_var = v1,
                                x_value = data[, v2],
                                y_value = data[, v1])
            names(dpair)[4:5] <- c("x_value", "y_value")
            zdata <- data[, z_vars]
            if(length(z_vars) == 1) zdata <- as.data.frame(zdata)
            names(zdata) <- z_vars
            dpair <- cbind(dpair, zdata)
            if(pair ==1 ) f <- dpair else(f <- rbind(f, dpair))
      }

      return(f)
}
