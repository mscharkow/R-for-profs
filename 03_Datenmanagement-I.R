library(tidyverse)
covid = read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")
covid
names(covid)

# Variablen auswählen mit select()

covid %>% select(1:5)

covid %>%
  select(iso_code:total_cases)

covid %>%
  select(-iso_code)

covid %>%
  select(starts_with("new"))

covid %>%
  select(contains("vaccin")) %>%
  select(-contains("smooth"))

covid %>%
  select(land = location, tag = date, bip = gdp_per_capita)

covid %>%
  rename(land = location, tag = date, bip = gdp_per_capita)

# Fälle auswählen mit filter()
covid %>%
  filter(location == "Germany")

covid %>%
  filter(location == "Germany") %>%
  filter(date >= as.Date("2022-06-01"))

covid %>%
  filter(!is.na(total_deaths))

# Beides kombinieren

covid %>%
  filter(location %in% c("Austria", "Germany", "Switzerland")) %>%
  select(location, date, new_cases_per_million)

# Variablen ändern mit mutate()

covid %>%
  filter(location == "Germany") %>%
  mutate(new_cases_per_100k = new_cases_per_million / 10) %>%
  select(location, date, new_cases_per_100k) %>%
  tail(10) # Letzte 10 Fälle

covid %>%
  mutate(in_europe = if_else(continent=="Europe", 1, 0)) %>%
  select(location, in_europe) %>%
  sample_n(10) # 10 zufällige Fälle

covid %>%
  select(location, ends_with("smokers")) %>%
  filter(!is.na(female_smokers)) %>%
  mutate(smokers = (female_smokers+male_smokers)/2) %>%
  sample_frac(.10) # 10% Subsample

# Variablen aggregieren mit summarise()

covid %>%
  summarise(mean_deaths_per_million = mean(total_deaths_per_million ))

covid %>%
  summarise(mean_deaths_per_million = mean(total_deaths_per_million, na.rm = TRUE ))

covid %>%
  summarise(mean_gdp = mean(gdp_per_capita, na.rm = TRUE),
            median_gdp = median(gdp_per_capita, na.rm = TRUE))

# Aggregation mit group_by()

covid %>%
  group_by(continent) %>%
  summarise(mean_deaths_per_million = mean(total_deaths_per_million, na.rm = TRUE ))

covid %>%
  group_by(location) %>%
  summarise(n_days = n(), m_repro = mean(reproduction_rate, na.rm = T), sd_repro = sd(reproduction_rate, na.rm = T))

covid %>%
  mutate(month = strftime(date, "%Y-%m")) %>%
  group_by(continent, month) %>%
  summarise(deaths = sum(new_deaths, na.rm = T))
