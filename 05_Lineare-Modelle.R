library(tidyverse)
library(report)
library(marginaleffects)

theme_set(theme_bw())

# Quelle: https://github.com/rfordatascience/tidytuesday/blob/master/data/2022/2022-05-17/
eurovision <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-17/eurovision-votes.csv')
eurovision

eurovision %>%
  group_by(to_country) %>%
  summarise(years = n_distinct(year_c), avg_points = mean(points, na.rm = T)) %>%
  arrange(-years, -avg_points)

d = eurovision %>%
  filter(to_country == "Germany" & semi_final == "f" & is.na(duplicate) & year >= 1990) %>%
  mutate(year_c = year - 2020) # Zentriert auf 2020
d

# Jahres-Scores
d %>%
  group_by(year_c) %>%
  summarise(points = mean(points)) %>%
  ggplot(aes(x = year_c, y = points))+
  geom_line()+
  geom_smooth(method = "lm")

# Jury vs. Publikum
# T-Test etc.
t.test(points ~ jury_or_televoting, data = d)

t1 = t.test(points ~ jury_or_televoting, data = d)
report::report_text(t1)

# Lineares Modell
lm(points ~ jury_or_televoting, data = d)

lm1 = lm(points ~ jury_or_televoting, data = d)
summary(lm1)
anova(lm1)

report::report_table(lm1)

# Zeiteffekt
cor.test(~ points + year_c, data = d)
ct1 = cor.test(~ points + year_c, data = d)
report::report_text(ct1)

lm2 = lm(points ~ year_c, data = d)
summary(lm2)
report::report_table(lm2)

# Zeit und Televoting
lm3 = lm(points ~ jury_or_televoting + year_c, data = d)
report::report_table(lm3)

# Interaktionseffekte
lm4a = lm(points ~ jury_or_televoting + year_c + jury_or_televoting:year_c, data = d)
lm4b = lm(points ~ jury_or_televoting * year_c, data = d)
lm4a; lm4b

report::report_table(lm4a)

# Modellvergleich und partieller F-Test
anova(lm3, lm4a)

# Fancy Stuff mit Modellen
# Geschätze Randmittel
marginaleffects::marginalmeans(lm1) %>%
  summary()

# Kontraste
marginaleffects::comparisons(lm1, contrast_factor = "all") %>%
  summary()

# Vorhergesagte Werte
marginaleffects::predictions(lm4a) %>%
  head()

marginaleffects::predictions(lm4a) %>%
  ggplot(aes(x = year_c, y = predicted,
             group = jury_or_televoting))+
  geom_line(aes(color = jury_or_televoting))+
  geom_ribbon(aes(fill = jury_or_televoting,
                  ymin = conf.low, ymax = conf.high), alpha = .1)+
  geom_jitter(data = d, aes(x = year_c, y = points,
                           color = jury_or_televoting), size = 1, alpha = .2)


# Ausblick: Multilevel-Modell
library(lme4)
mlm1 = lmer(points ~ jury_or_televoting * year_c + (1|from_country), data = d)
summary(mlm1)
report::report_table(mlm1)
marginaleffects::marginaleffects(mlm1) %>%
  summary()
