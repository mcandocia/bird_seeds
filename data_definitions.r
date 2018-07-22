library(plyr)
library(dplyr)

preferred_feeders = list(
  'Cardinal'=c('A','B','D','E'),
  'Chickadee'=c('A','C','D','F'),
  'Dove'=c('D','E'),
  'Goldfinch'=c('A','C'),
  'Grosbeak'=c('A','D'),
  'House Finch'=c('A','C'),
  'Jay'=c('A','D','E'),
  'Junco'=c('A','D','E'),
  'Nuthatch'=c('A','B','F'),
  'Purple Finch'=c('A','C'),
  'Siskin'=c('B','C'),
  'Sparrow'=c('A','B','D'),
  'Titmouse'=c('A','B','D','F'),
  'Towhee'=c('A','D','E'),
  'Woodpecker'=c('A','D','F')
)

feeder_types = list(
  'A'='Hopper Feeder',
  'B'='Tube Feeder',
  'C'='Nyjer Feeder',
  'D'='Platform Feeder',
  'E'='Ground Feeder',
  'F'='Suet Feeder'
)

bird_names = names(preferred_feeders)

seed_types = c(
  'Black Oil Sunflower',
  'Striped Sunflower',
  'Hulled Sunflower',
  'Millet White/Red',
  'Milo Seed',
  'Nyjer Seed (Thistle)',
  'Shelled Peanuts',
  'Safflower Seed',
  'Corn Products'
)

n_birds = length(bird_names)
n_seeds = length(seed_types)

preferences_unraveled = c(
  'H','H','M','H','M','H','H','L','H','H','L','H','H','H','M', # black oil sunflower
  'H','M','L','M','M','M','H','L','M','M','L','H','M','H','M', # sriped sunflower
  'H','M','M','H','H','H','H','L','M','H','H','H','M','H','H', # hulled sunflower
  'L','N','H','L','N','M','N','L','N','L','N','H','N','L','N', # millet white/red
  'N','N','H','N','N','N','L','N','N','N','N','M','N','N','N', # milo seed
  'N','N','L','H','N','H','N','L','N','H','H','N','L','N','N', # nyjer seed (thistle)
  'N','M','N','N','N','N','M','N','L','N','N','N','M','L','L', # shelled peanuts
  'H','M','M','N','L','L','L','N','L','N','N','L','L','L','L', # safflower seed
  'L','N','M','N','N','N','M','H','N','N','L','M','N','L','L'  # corn products
)

bird_seed_preferences = data.frame(
  bird=rep(bird_names, n_seeds),
  seed=rep(seed_types, each=n_birds),
  preference=preferences_unraveled
) %>%
  mutate(
    preference = factor(as.character(preference), levels=c('N','L','M','H')),
    preference_numeric = as.numeric(preference) - 1

  )

# feeder data frame
feeder_frame = expand.grid(
  bird=bird_names,
  feeder_type=c('A','B','C','D','E','F')
)

feeder_frame$preferred=0
for (bird in bird_names){
  bird_rows = feeder_frame$bird==bird
  feeder_frame[bird_rows,'preference'] = 1*(feeder_frame[bird_rows,'feeder_type'] %in% preferred_feeders[[bird]])
}

feeder_type_frame = data.frame(
  feeder_type=names(feeder_types),
  feeder_name=unlist(feeder_types)
)

feeder_frame = feeder_frame %>% join(feeder_type_frame, by='feeder_type')

# write output CSVs

write.csv(feeder_frame, 'feeder_preferences.csv', row.names=FALSE)
write.csv(bird_seed_preferences, 'bird_seed_preferences.csv', row.names=FALSE)
