library(tidyverse)
library(lubridate)

# review lubridate and datetimes
course_begin <- "2022-12-12T16:15:00+01:00"

# convert into datetime (note timezone switches to UTC (London))
course_begin_utc <- ymd_hms(course_begin)
course_begin_utc

# covert into datetime, force time zone to central european time (CET)
course_begin_cet <- ymd_hms(course_begin, tz = "CET")
course_begin_cet

# extract date components
year(course_begin_cet)
month(course_begin_cet)
day(course_begin_cet)
yday(course_begin_cet)

# extract time components
hour(course_begin_cet)
minute(course_begin_cet)
second(course_begin_cet)

# matsim-r
# see https://github.com/matsim-vsp/matsim-r/
install.packages("devtools")
devtools::install_github("matsim-vsp/matsim-r")
library(matsim)

# loading trips (file can be found in week4 on isis webpage for datascience)
# change path of trips table to your local directory 
trips <- readTripsTable("/Users/jakob/Downloads/Data4-20221212/pave188b.output_trips.csv.gz")


# Show a selection of the matsimR functions
plotModalSplitPieChart(trips)

plotModalSplitBarChart(trips)

plotAverageTravelWait(trips)

plotTripsByDistance(trips) # can this be fixed

plotTripDistanceByMode(trips)

plotTripCountByDepTime(trips)

plotStartActCountByDepTime(trips)

plotEndActCountByArrTime(trips)


# Recreate output of plotTripCountByDepTime

trips %>% 
  select(main_mode,dep_time) %>% 
  mutate(hour = hour(dep_time)) %>% 
  group_by(main_mode, hour) %>% 
  summarise(cnt = n()) %>% 
  ggplot() + 
  geom_line(mapping = aes(x = hour, y = cnt, col = main_mode, linetype = main_mode))


# Problem Set

# 1) use read_excel() to read Fallzahlen_Kum_Tab_aktuell.xlsx
# The excel document has several sheets, only read "BL_7-Tage-Inzidenz (fixiert)"
# Hint: use the "skip argument" to disregard the first n rows. 


# 2) Tidy the data such that there are three columns: Date, Bundesland, Incidence
# Hint: use pivot_longer()


# 3) Smooth the data: find average incidence for every week.
# Hint: use week() & year() functions from lubridate.


# 4) Choose any three german states (Bundesländer); filter dataframe to only include them
# Produce a line plot of the incidences


# 5) Check how your plot would look for for different types of color-vision deficiency.
# use functions "cvd_grid" or "view_cvd" in library colorblindr
# See https://github.com/clauswilke/colorblindr for installation and usage


# 6) Use a color scheme that produces a more readable plot for colorblind people
# Use scale_color_see() from the "see" library or find another palette online.
# Also, consider using different line types to further differentiate the Bundesländer


# ------------------------
# Bonus: combine archived RKI Data with new RKI Data
# The RKI data we've been using so far doesn't begin until 2021-09-11.
# Another RKI Dataset "Fallzahlen_Kum_Tab_Archiv.xlsx" covers the period up to and including 2021-09-12


# 1) use read_excel() to read "Fallzahlen_Kum_Tab_Archiv.xlsx"
# The excel document has several sheets, only read "BL_7-Tage-Inzidenz (fixiert)"


# 2) Tidy the data such that there are three columns: Date (in Date format), Bundesland (chr format), Incidence (num format)
# Note: the way excel saves the dates in this case is strange. The date is displayed
# as the number of days since January 1, 1990. Figure out a clever way parse the
# correct date from this number. 


# 3) Join the old RKI Data and the new RKI date
# Hint: use rbind()
# Note: there is an overlap of two days betwen the datasets;
# Deal with this by either manually filtering out two rows before you bind, or by using distinct()



# 4) smooth, filter, and plot new dataset in the same manner as in previous questions

         