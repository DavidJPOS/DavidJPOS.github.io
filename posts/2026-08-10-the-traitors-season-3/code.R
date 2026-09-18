###########################################################################
## Project: Personal website --- blog posts
## Script purpose: season 3
## Date: 10-08-2026
## Author: David JP O'Sullivan
###########################################################################

library(tidyverse)

set.seed(1234)
theme_set(theme_minimal(base_size = 12))

M <- 1000 # number of Monte Carlo replicates

# functions ---------------------------------------------------------------

# NOT_FIRST = FALSE : the game as played (life card uniform over all slots).
# NOT_FIRST = TRUE  : condition on the first card turned over being a death
#                     card, by moving the life card off slot 1 to a uniformly
#                     chosen slot among 2, ..., number_cards.
#
# NOTE: sample((2:number_cards), size = 1) relies on 2:number_cards being a
# vector, so this branch is only safe for number_cards >= 4. At number_cards = 2
# R reads sample(2, size = 1) as a draw from 1:2 (the classic sample() gotcha),
# which can wipe the life card entirely. The conditional sweep below therefore
# starts at 4 cards. The number_cards = 2 case is trivial anyway: theory says
# player 1 survives with probability 0.

simulate_single_round <- function(number_cards = 8, NOT_FIRST = FALSE){
  deck <-
    c("live", rep("death", number_cards - 1)) |>
    sample(size = number_cards)

  if(NOT_FIRST == TRUE & deck[1] == "live"){
    new_life_place <- sample((2:number_cards), size = 1)
    deck[new_life_place] <- "live"
    deck[1] <- "death"
  }

  whose_turn <- rep(c("player_1", "player_2"), number_cards/2)
  who_won <- character(1)

  for(i in 1:length(deck)) {
    if(deck[i] == "live"){
      who_won <- whose_turn[i]
      break
    }
  }
  return(who_won)
}

run_mc_simulations <- function(M = 100, ...){
  mc_results <- character(M)
  for(i in 1:M){
    mc_results[i]<- simulate_single_round(...)
  }
  return(mc_results)
}

# simulations: the game as played ----------------------------------------

mc_results <- tibble(who_won = run_mc_simulations(M = M, number_cards = 8))
mc_sum <-
  mc_results |>
  count(who_won) |>
  mutate(per = n/sum(n))
mc_sum

sweep_fair <- tibble(number_cards = 2*(1:10), sim = NA_real_)
for(i in 1:nrow(sweep_fair)){
  mc_res <- run_mc_simulations(M = M, number_cards = sweep_fair$number_cards[i])
  sweep_fair$sim[i] <- sum(mc_res == "player_1")/length(mc_res)

  print(glue::glue("Finished row: {i} of {nrow(sweep_fair)}."))
}

sweep_fair <- sweep_fair |> mutate(theory = 0.5)
sweep_fair

ggplot(sweep_fair, aes(x = number_cards)) +
  geom_line(aes(y = theory, colour = "Theory"), linewidth = 0.8) +
  geom_point(aes(y = sim, colour = "Simulation"), size = 2.5) +
  scale_colour_manual(values = c("Theory" = "#135E63", "Simulation" = "#C1666B")) +
  scale_x_continuous(breaks = 2*(1:10)) +
  coord_cartesian(ylim = c(0, 1)) +
  labs(x = "Number of cards", y = "P(player 1 survives)", colour = NULL)

# simulations: conditional on the first card being a death card ----------

mc_results <- tibble(
  who_won = run_mc_simulations(M = M, number_cards = 8, NOT_FIRST = TRUE)
)
mc_sum <-
  mc_results |>
  count(who_won) |>
  mutate(per = n/sum(n))
mc_sum

sweep_cond <- tibble(number_cards = 2*(2:15), sim = NA_real_)
for(i in 1:nrow(sweep_cond)){
  mc_res <- run_mc_simulations(M = M,
                               number_cards = sweep_cond$number_cards[i],
                               NOT_FIRST = TRUE)
  sweep_cond$sim[i] <- sum(mc_res == "player_1")/length(mc_res)

  print(glue::glue("Finished row: {i} of {nrow(sweep_cond)}."))
}

sweep_cond <-
  sweep_cond |>
  mutate(n = number_cards/2,
         theory = (n - 1)/(2*n - 1))

sweep_cond |> print(n = Inf)

ggplot(sweep_cond, aes(x = number_cards)) +
  geom_hline(yintercept = 0.5, linetype = "dashed", colour = "grey60") +
  geom_line(aes(y = theory, colour = "Theory"), linewidth = 0.8) +
  geom_point(aes(y = sim, colour = "Simulation"), size = 2.5) +
  scale_colour_manual(values = c("Theory" = "#135E63", "Simulation" = "#C1666B")) +
  scale_x_continuous(breaks = 2*(2:15)) +
  coord_cartesian(ylim = c(0, 1)) +
  labs(x = "Number of cards", y = "P(player 1 survives | first card was death)",
       colour = NULL)
