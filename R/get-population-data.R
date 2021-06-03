#' Download Statistik Austria data
#'
#' Download the population data
#' from Statistik Austria
#' \href{https://data.statistik.gv.at/web/meta.jsp?dataset=OGD_bevstandjbab2002_BevStand_2020}{here}.
#' The raw data is downloaded and a single data frame is returned.
#' The data frame contains the columns time_section, sex, state_number, commune_number, commune, age, number.
#'
#' @return A data frame with 392508 rows and 7 variables:
#' \describe{
#'   \item{time_section}{In this case just the year 2020}
#'   \item{sex}{male or female}
#'   \item{state_number}{A number between 1 and 9 indicating one of the states in Austria}
#'   \item{commune_number}{A 5 digit number encoding the commune}
#'   \item{commune}{The name of the commune}
#'   \item{age}{The corresponding age}
#'   \item{number}{The number of people with corresponding age, sex and living in the specified commune}
#' }
#' @export
#'
#' @importFrom readr read_delim parse_number
#' @importFrom dplyr select rename mutate left_join
#' @importFrom stringr str_sub
#'
#' @examples
#' \dontrun{
#' population_df <- get_population_data()
#' }
get_population_data <- function() {

  # Download data -----------------------------------------------------------

  population_link   <- "https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2020.csv"
  code_link         <- "https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2020_HEADER.csv"
  time_section_link <- "https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2020_C-A10-0.csv"
  sex_link          <- "https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2020_C-C11-0.csv"
  commune_link      <- "https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2020_C-GRGEMAKT-0.csv"
  age_link          <- "https://data.statistik.gv.at/data/OGD_bevstandjbab2002_BevStand_2020_C-GALTEJ112-0.csv"

  message("Downloading data")
  population_df   <- read_delim(population_link, delim = ";")
  code_df         <- read_delim(code_link, delim = ";")
  time_section_df <- read_delim(time_section_link, delim = ";")
  sex_df          <- read_delim(sex_link, delim = ";")
  commune_df      <- read_delim(commune_link, delim = ";")
  age_df          <- read_delim(age_link, delim = ";")
  message("Done")

  # Prepare population data --------------------------------------------------------

  population_df <- population_df %>%
    # see code_df to look up code and corresponding name
    rename(time_section_code = `C-A10-0`,
           sex_code          = `C-C11-0`,
           commune_code      = `C-GRGEMAKT-0`,
           age_code          = `C-GALTEJ112-0`,
           number            = `F-ISIS-1`)

  time_section_df <- time_section_df %>%
    select(code, en_name) %>%
    rename(time_section_code = code, time_section = en_name)

  sex_df <- sex_df %>%
    select(code, en_name) %>%
    rename(sex_code = code, sex = en_name)

  commune_df <- commune_df %>%
    select(code, name) %>%
    rename(commune_code = code, commune = name) %>%
    mutate(commune_number = str_sub(commune, start = -6, end = -2),
           commune = str_sub(commune, end = -9),
           state_number = str_sub(commune_number, start = 1, end = 1))

  age_df <- age_df %>%
    select(code, name) %>%
    rename(age_code = code, age = name) %>%
    mutate(age = parse_number(age))

  population_df <- population_df %>%
    left_join(time_section_df) %>%
    left_join(sex_df) %>%
    left_join(commune_df) %>%
    left_join(age_df) %>%
    select(time_section, sex, state_number, commune_number, commune, age, number)

  return(population_df)

}


#' Population data of Austria in the year 2020
#'
#' A dataset containing the population data of Austria
#' in the year 2020.
#' This data set can also be downloaded via by \link[bevstat]{get_population_data}.
#'
#' @format A data frame with 392508 rows and 7 variables:
#' \describe{
#'   \item{time_section}{In this case just the year 2020}
#'   \item{sex}{male or female}
#'   \item{state_number}{A number between 1 and 9 indicating one of the states in Austria}
#'   \item{commune_number}{A 5 digit number encoding the commune}
#'   \item{commune}{The name of the commune, note that communes are not unique, i.e., Krumbach!!}
#'   \item{age}{The corresponding age}
#'   \item{number}{The number of people with corresponding age, sex and living in the specified commune}
#' }
#' @source \url{https://data.statistik.gv.at/web/meta.jsp?dataset=OGD_bevstandjbab2002_BevStand_2020}
"population_df"
