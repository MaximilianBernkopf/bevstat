#' Calculate summary statistics of population
#'
#' Takes the data frame returned by \link[bevstat]{get_population_data} or \link[bevstat]{population_df} directly
#' and calculates the relative size of each age group per commune as well as the average age in each commune.
#' Note that the information regarding gender is first summarized.
#' Furthermore, the state name is added, e.g., "Wien", "Burgenland" etc.
#'
#' @param df The data frame returned by \link[bevstat]{get_population_data} or \link[bevstat]{population_df} directly.
#'
#' @return A data frame with 6 variables:
#' \describe{
#'   \item{state}{e.g., "Wien", "Burgenland" etc.}
#'   \item{commune_number}{A 5 digit number encoding the commune}
#'   \item{commune}{The name of the commune}
#'   \item{relative_size_age_group_per_commune}{The relative size of each age group per commun}
#'   \item{average_age_per_commune}{Average age in each commune}
#' }
#' @export
#'
#' @importFrom tibble tibble
#' @importFrom dplyr select left_join group_by summarise mutate ungroup
#'
summarise_population_df <- function(df) {

  # mapping table state to state number
  mapping_table_state <- tibble(state_number = c("1","2","3","4","5","6","7","8","9"),
                                state = c("Burgenland", "Kärnten", "Niederösterreich", "Oberösterreich", "Salzburg", "Steiermark", "Tirol", "Vorarlberg", "Wien"))

  # calculate summary statistics
  population_summary_df <- df %>%
    select(-time_section) %>%
    left_join(mapping_table_state) %>%
    group_by(commune_number,  age, commune, state) %>%
    summarise(number = sum(number)) %>% # summarise sex
    group_by(commune_number) %>%
    mutate(commune_inhabitants = sum(number),
           average_age_per_commune = sum(age*number)/sum(number)) %>%
    ungroup() %>%
    mutate(relative_size_age_group_per_commune = number/commune_inhabitants) %>%
    select(state, commune_number, commune, age, relative_size_age_group_per_commune, average_age_per_commune, commune_inhabitants)

  return(population_summary_df)

}



