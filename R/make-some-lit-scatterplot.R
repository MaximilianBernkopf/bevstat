#' Plot average age per commune vs the proportion of preschool kids
#'
#' @param population_summary_df The data frame returned by \link[bevstat]{summarise_population_df}
#' @param alpha opacity
#'
#' @return A scatter plot of average age per commune vs the proportion of preschool kids
#' @export
#'
#' @importFrom dplyr filter group_by summarise
#' @importFrom ggplot2 ggplot aes geom_point labs scale_size
#'
plot_preschool_vs_average_age <- function(population_summary_df, alpha = 0.5){

  population_summary_df %>%
    filter(age < 6) %>%
    group_by(state, commune_number, commune, average_age_per_commune, commune_inhabitants) %>%
    summarise(proportion_of_preschool_kids = sum(relative_size_age_group_per_commune)) %>%
    ggplot(aes(proportion_of_preschool_kids, average_age_per_commune, color = state, size = commune_inhabitants)) +
    geom_point(alpha = alpha) +
    labs(title = "Anteil der Vorschulkinder vs Durchschnittsalter auf Gemeindeebene",
         x     = "Anteil der Vorschulkinder",
         y     = "Durschnittsalter",
         size  = "Einwohner (Tausend)",
         color = "Bundesland") +
    scale_size(range = c(0.25, 4),
               breaks = 1000 * c(1, 25, 50, 100, 250),
               labels = c(1, 25, 50, 100, 250))

}
