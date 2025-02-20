install.packages("DBI")
install.packages("RSQLite")
install.packages("vignett")
install.packages("bookdown")

library(DBI)
library(RSQLite)
library(bookdown)
library(dplyr)
?dbWriteTable
vignette("spec" , package = "DBI")
vignette(package ="DBI")
vignette("DBI", package = "DBI")

Final_db <- dbConnect (RSQLite::SQLite(), "Final.db")

#importing tables ####
Morphometrics <- dbGetQuery (conn = Final_db,
            statement = "SELECT * FROM Morphometrics;")

Capture_Site <- dbGetQuery (conn = Final_db,
            statement = "SELECT * FROM Capture_Site;")
Captures <- dbGetQuery (conn = Final_db,
            statement = "SELECT * FROM Captures;")
Lamprey <- dbGetQuery (conn = Final_db,
            statement = "SELECT * FROM Lamprey;")
Tags <- dbGetQuery (conn = Final_db,
            statement = "SELECT * FROM Tags;")
Fish <- read.csv ("LampreyDataSheet.csv")

test <- dbGetQuery(conn = Final_db,
            statement = "SELECT * FROM Test;")
print(test)
average(test)
average <- mean(test)

#connecting tables Morphometrics to Lamprey to Captures

average <- (mean(test$Genetic))
print(average)
mean(1 + 2 + 3 + 5 + 7 + 9)
(27/6)

average_by_site <- test %>% 
  group_by(Site) %>% 
  summarize(average_value = mean(Genetic))
print(average_by_site)  

library(ggplot2)

?summarize

#Creating table with average length per site
average_length_per_site <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Release Site", -"Genetic.y", -"Release Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Capture Site", "Length (mm)") %>% 
 rename(capture_site = "Capture Site", length = "Length (mm)") %>% 
  group_by(capture_site) %>% 
  summarize(average = mean(length))
print(average_length_per_site)
#lengths at sites

length_bonneville <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Release Site", -"Genetic.y", -"Release Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Capture Site", "Length (mm)") %>% 
  rename(capture_site = "Capture Site", length = "Length (mm)") %>% 
  filter(capture_site == "Bonneville") %>% 
  select("length") %>% 
  rename(bonneville_length = "length")

print(length_bonneville)

length_bonneville <- unlist(length_bonneville)
length

length_sherears <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Release Site", -"Genetic.y", -"Release Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Capture Site", "Length (mm)") %>% 
  rename(capture_site = "Capture Site", length = "Length (mm)") %>% 
  filter(capture_site == "Shears") %>% 
  select("length") %>% 
  rename(sherears_length = "length")

print(length_sherears)
lengths_sites <- list(length_bonneville,length_sherears)

class(lengths_sites)
print(lengths_sites)

lengths_sites$length_bonnville <- data.frame(length_bonneville)
lengths_sites$length_sherears <- data.frame(length_sherears)

lengths_sites <- unlist(lengths_sites)

lengths_sites <- sort(lengths_sites)

boxplot(length_bonneville$bonneville_length,length_sherears$sherears_length,
        names = c("Bonneville Lamprey", "Sherears Lamprey"),
        ylab = "Length (mm)",
        col= c("blue", "red"))
 

  
#create table with average girth per site
average_girth_per_site <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Release Site", -"Genetic.y", -"Release Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Capture Site", "Girth (mm)") %>% 
  rename(capture_site = "Capture Site", girth = "Girth (mm)") %>% 
  group_by(capture_site) %>% 
  summarize(average = mean(girth))

girth_sherears <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Release Site", -"Genetic.y", -"Release Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Capture Site", "Girth (mm)") %>% 
  rename(capture_site = "Capture Site", girth = "Girth (mm)") %>% 
  filter(capture_site == "Shears") %>% 
  select(girth) %>% 
  rename(sherears_girth = "girth")

girth_bonneville <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Release Site", -"Genetic.y", -"Release Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Capture Site", "Girth (mm)") %>% 
  rename(capture_site = "Capture Site", girth = "Girth (mm)") %>% 
  filter(capture_site == "Bonneville") %>% 
  select(girth) %>% 
  rename(bonneville_girth = "girth")

print(girth_bonneville)

boxplot(girth_bonneville$bonneville_girth, girth_sherears$sherears_girth,
        names = c("Bonneville Lamprey", "Sherears Lamprey"),
        ylab = "Girth (mm)",
        col= c("blue", "red"),
        outline = FALSE)


#create table with average length per release site
average_length_per_release_site <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Release Site", "Length (mm)") %>% 
  rename(release_site = "Release Site", length = "Length (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  group_by(release_site) %>% 
  summarize(average = mean(length))

print(average_length_per_release_site)

beaver_length_release <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Release Site", "Length (mm)") %>% 
  rename(release_site = "Release Site", length = "Length (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  filter(release_site == "BEAV") %>% 
  select(length) %>% 
  rename(beaver_length = "length")

ws_length_release <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Release Site", "Length (mm)") %>% 
  rename(release_site = "Release Site", length = "Length (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
 filter(release_site == "WS") %>% 
  select(length) %>% 
  rename(ws_length = "length")

hatch_length_release <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Girth (mm)") %>% 
  select("Release Site", "Length (mm)") %>% 
  rename(release_site = "Release Site", length = "Length (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  filter(release_site == "WS Hatch") %>% 
  select(length) %>% 
  rename(hatch_length = "length")

print(hatch_length_release)

boxplot(ws_length_release$ws_length,beaver_length_release$beaver_length,hatch_length_release$hatch_length,
        names = c("Beaver Creek", "Hatchery Release", "Warm Springs"),
        ylab = "Length (mm)",
        col = c("blue","red","green"))

#create table with average girth per relase site
average_girth_per_release_site <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Release Site", "Girth (mm)") %>% 
  rename(release_site = "Release Site", girth = "Girth (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  group_by(release_site) %>% 
  summarize(average = mean(girth))

beaver_girth_release <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Release Site", "Girth (mm)") %>% 
  rename(release_site = "Release Site", girth = "Girth (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  filter(release_site == "BEAV") %>% 
  select(girth) %>% 
  rename(beaver_girth = "girth")

hatch_girth_release <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Release Site", "Girth (mm)") %>% 
  rename(release_site = "Release Site", girth = "Girth (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  filter(release_site == "WS Hatch") %>% 
  select(girth) %>% 
  rename(hatch_girth = "girth")

ws_girth_release <- left_join(Morphometrics, Lamprey, by = "Lamprey ID") %>% 
  select(-"Measurement ID",-"Genetic.x", -"Genetic.y", -"Capture Site", -"PIT Tags #",
         -"Lamprey ID", -"Length (mm)") %>% 
  select("Release Site", "Girth (mm)") %>% 
  rename(release_site = "Release Site", girth = "Girth (mm)") %>% 
  mutate(release_site = case_when(
    release_site == "Beaver" ~ "BEAV",TRUE ~ release_site)) %>% 
  filter(release_site == "WS") %>% 
  select(girth) %>% 
  rename(ws_girth = "girth")

print(hatch_girth_release)

boxplot(beaver_girth_release$beaver_girth,hatch_girth_release$hatch_girth,ws_girth_release$ws_girth,
        names = c("Beaver Creek","Hatchery Release","Warm Springs"),
        ylab = "Girth (mm)",
        col = c("blue","red","green"))

# how many lamprey captured per
capture_per_day_sherears <- Captures %>% 
  select(-"Capture ID", -"Lamprey ID") %>% 
  rename(capture_site = "Capture Site") %>% 
  mutate(capture_site = case_when(
    capture_site == "Shears" ~ "Sherears", TRUE ~ capture_site)) %>% 
  filter(capture_site == "Sherears") %>% 
  group_by(Date) %>% 
  tally
  
capture_per_day_sherears$Date <-gsub("/", "-", capture_per_day_sherears$Date)

print(capture_per_day_sherears)

plot(capture_per_day_sherears$Date, capture_per_day_sherears$n,
     xlab = "Date",
     ylab = "Lamrpey Caught")

capture_per_day_sherears$Date <- as.Date(capture_per_day_sherears$Date, format = "%m-%d-%y")
class(capture_per_day_sherears$Date)
print(capture_per_day_sherears)

capture_per_day_sherears <- capture_per_day_sherears[order(capture_per_day_sherears$Date),]

ggplot(capture_per_day_sherears, aes(x = Date, y = n)) +
  geom_line() +
  geom_point() +
  labs(x = "Date", y = "Captures per Day") +
  theme_minimal()


#survival after tagging
tag_survival_capture_site <- full_join(Lamprey, Tags) %>% 
  select(-"Lamprey ID", -"Capture Site", -"Genetic", -"PIT Tag #",-"PIT Tags #") %>% 
  rename(release_site = "Release Site") %>% 
  mutate(survival = ifelse(Status == "Alive", 1, 0)) %>% 
  filter(release_site == "WS Hatch") %>% 
  select(-"Status") %>% 
  summarize(sum(survival)/40)*100
  
print(tag_survival_capture_site)


