# Billboard/Spotify data from Tidy Tuesday 38/2021
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-09-14

library(tidyverse)
theme_set(theme_minimal())

# Daten direkt aus dem Internet lesen und ansehen
billboard100 <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/billboard.csv")
billboard100

audio <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/audio_features.csv")
audio

# Daten kombinieren und neue Year Variable aus der Spalte week_id erstellen
song_data <- billboard100 %>%
  left_join(audio) %>%
  mutate(year = as.numeric(str_sub(week_id, start = -4, end = -1)))

# Für Beyonce Jahresmittelwerte der Variable valence berechnen
per_year <- song_data %>%
  filter(performer == "Beyonce") %>%
  group_by(year) %>%
  summarise(mean_valence = mean(valence, na.rm = T))

# So sehen die Mittelwerte aus
per_year

# Grafik aus per_year erstellen
per_year %>%
  ggplot(aes(x = year, y = mean_valence)) +
  geom_point() + # Punktediagramm
  geom_smooth(method = "lm") + # Regressionsgerade
  labs(x = "Year", y = "Valence", title = "Valence of Beyoncé singles over time")

ggsave("beyonce_singles.png", width = 8, height = 4)
