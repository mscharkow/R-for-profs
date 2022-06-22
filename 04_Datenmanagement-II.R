# Datenmanagement II mit dplyr
library(tidyverse)

billboard100 = read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/billboard.csv") %>%
  na.omit()
billboard100

audio = read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/audio_features.csv") %>%
  na.omit()
audio

# Daten verbinden mit join_*

billboard100 %>% left_join(audio)
billboard100 %>% inner_join(audio, by = "song_id")

# Indexbildung old school (mit missing Problematik)

audio %>%
  mutate(my_index = (danceability + energy)/2)

# Indexbildung mit mean()
audio %>%
  rowwise() %>% # WICHTIG
  mutate(my_index = mean(danceability, energy, valence, na.rm = T)) %>%
  select(performer, song, my_index)

# Komplexer Index mit rowMeans()
audio %>%
  mutate(ess_ness = rowMeans(select(., ends_with("ness")))) %>%
  select(performer, song, ess_ness)

# Mutate und summarise mit mehreren Variablen
# Einzelne Funktionen

audio %>%
  group_by(performer) %>%
  summarise_if(is.numeric, mean, na.rm = T)

# Eigene Funktion
audio %>%
  mutate_if(is.numeric, lst(top10pct = ~ . >= quantile(., probs = .9))) %>%
  select(performer, song, contains("top10"))

# Mehrere Funktionen
audio %>%
  group_by(performer) %>%
  summarise_at(vars(energy, valence), lst(mean, sd, min, max), na.rm = T )


# Lange Pipeline

top10_by_year = billboard100 %>%
  filter(week_position <= 10) %>%
  mutate(year = lubridate::mdy(week_id) %>% lubridate::year()) %>%
  filter(year >= 1960) %>%
  left_join(audio) %>%
  group_by(year) %>%
  mutate(n_songs = n_distinct(song_id)) %>%
  summarise_at(vars(n_songs, danceability, energy, speechiness:valence), mean, na.rm =  T)

top10_by_year

top10_by_year %>%
  ggplot(aes(x = year, y = n_songs))+
  geom_line()+
  geom_smooth()+
  theme_minimal()
