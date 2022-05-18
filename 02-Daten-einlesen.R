# Datenimport
# Folien: https://jobreu.github.io/tidyverse-workshop-esra-2021/slides/02_Data_Import.html

library(tidyverse)

# Klartext-Dateien CVS, TSV, etc. mit readr (Teil von Tidyverse)
# read_csv (US/UK), read_csv2 (DE, Europa)

# Man kann direkt per URL Daten laden
audio <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/audio_features.csv")
audio

# Gepackte Dateien (zip, gz, bz2, xz) auch ohne Entpacken
# Daten: https://osf.io/uzca3/

readr::read_csv2("data/usenews.reutersdni.2019.csv.xz")
reuters = readr::read_csv2("data/usenews.reutersdni.2019.csv.xz")
reuters

# SPSS und STATA Dateien mit haven  (Teil von Tidyverse)
# Daten: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0155112

haven::read_dta("data/pone.0155112.s001.dta")
bos_etal = haven::read_dta("data/pone.0155112.s001.dta")
bos_etal

# Daten: https://osf.io/3byhz/
haven::read_sav("data/dataset_IM.sav")
im = haven::read_sav("data/dataset_IM.sav")
im

# Excel mit readxl (Teil von Tidyverse)

# Daten: https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Fallzahlen_Kum_Tab_aktuell.xlsx
readxl::read_excel("data/Fallzahlen_Kum_Tab_aktuell.xlsx")
rki  = readxl::read_excel("data/Fallzahlen_Kum_Tab_aktuell.xlsx", sheet = 3, skip = 3)
rki

# Daten schreiben mit write_X
haven::write_sav(bos_etal, "data/bos_etal.sav")


# Daten inspizieren -------------------------------------------------------

reuters
names(reuters) # Variablennamen
glimpse(reuters) # Variablenwerte
View(reuters) # RStudio Viewer (auch im Environment anzuklicken)

# Labels in SPSS-Daten

im %>%
  count(t_Geschlecht)

im %>%
  mutate(geschlecht = as_factor(t_Geschlecht)) %>%
  count(geschlecht)

im %>%
  mutate(geschlecht = as.numeric(t_Geschlecht)) %>%
  count(geschlecht)
