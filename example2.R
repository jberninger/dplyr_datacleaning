# LA city precincts that voted majority (plurality) Trump in Nov 16 General

# filters: vbm_only = FALSE (these are minor places), location = los angeles, total vote rows (every precinct has 3: in-person, vbm and total)
# mutate columns that have percentage for each candidate
# then filter where percent_trump = max(per_hil, per_john, per_stein, ...)
library(dplyr)
library(stringr)
library(readr)
library(readxl)
library(DT)
setwd("JordanBerninger/nov_election_lacity")
election <- read_excel("/PRES_AND_VICE_PRES_11-08-16_by_Precinct_3496-4802.xls", skip = 2)

colnames(election) <- tolower(colnames(election))

trump_precincts <- election %>% select("location", "precinct", "vbm_only" = "vote by mail only", "type", "ballots" = "ballots cast",
                    "stein" = "jill stein", "clinton" = "hillary clinton", "riva" = "gloria e la riva", 
                    "trump" = "donald j trump", "johnson" = "gary johnson") %>%
  filter(location %in% c("LOS ANGELES", "BEVERLY HILLS") & vbm_only == "N" & type == "TOTAL") %>% 
  mutate(stein_per = round((stein/ballots), digits = 5), clinton_per = round((clinton/ballots), digits = 5), riva_per = round((riva/ballots), digits = 5), 
         trump_per_ballots = round((trump/ballots), digits = 5), johnson_per = round((johnson/ballots), digits = 5)) %>%
  filter(trump_per_ballots > clinton_per & trump_per_ballots > stein_per & trump_per_ballots > riva_per & trump_per_ballots > johnson_per) %>% 
  mutate(sum_votes = stein + clinton + riva + trump + johnson, vote_diff = ballots - sum_votes) %>%  
  mutate(stein_per2 = round((stein/sum_votes), digits = 5), clinton_per2 = round((clinton/sum_votes), digits = 5), riva_per2 = round((riva/sum_votes), digits = 5), 
         trump_per_sum_votes = round((trump/sum_votes), digits = 5), johnson_per2 = round((johnson/sum_votes), digits = 5)) %>% 
  select(c(1:10, 14, 16, 21)) %>% arrange(desc(trump_per_ballots))
  
write.csv(as.data.frame(trump_precincts), file = "trump_precincts.csv")
