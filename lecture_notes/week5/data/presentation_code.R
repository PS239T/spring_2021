rm(list=ls())

library(AER)

data("CASchools")

head(CASchools)


#one dimensional visualizations of continuous variable: histograms, density plots

ggplot(data = CASchools,
       mapping = aes(x=math)) +
  geom_histogram()

#we can make this figure more interpretable using scales, labels, etc

ggplot(data = CASchools,
       mapping = aes(x=math)) +
  geom_histogram(color = "black", fill = "lightgrey") +
  theme_bw() +
  labs(x = "Average Math Score",
       y = "Number of Observations",
       title = "Distribution of Math Scores") +
  ylim(0, 100) +
  xlim(0, 800)


#two dimensional visualizations: categorical variabel BY continuous variable (options = boxplot)

CASchools %>%
  ggplot(aes(x=county, y = math)) +
  geom_boxplot()

#we might want to filter to places with sufficient numbers of observations
CASchools %>%
  group_by(county) %>%
  mutate(num_schools_county = n()) %>%
  ungroup() %>%
  filter(num_schools_county > 10) %>%
  ggplot(aes(x=county, y = math)) +
  geom_boxplot()


#two dimensional and higher dimensional visualizations - BREAKOUT ROOMS (10 minutes)

#create a new variable that is teacher to student ratio. 
#visualize the relationship between this new variable, and math scores.
#within your figure, also convey information about the average expenditure per pupil.
#extra point for also conveying information about the county.

CASchools %>%
  mutate(ratio = students/teachers) %>%
  ggplot(aes(x=ratio, y = math, size = expenditure)) +
  geom_point()

#smoothing, facetting, summarizing

#smoothing
CASchools %>%
  mutate(ratio = students/teachers) %>%
  ggplot(aes(x=ratio, y = math, size = expenditure)) +
  geom_point() +
  geom_smooth(method = "lm")

#facetting

CASchools %>%
  group_by(county) %>%
  mutate(num_schools_county = n()) %>%
  ungroup() %>%
  filter(num_schools_county > 10) %>%
  mutate(ratio = students/teachers) %>%
  ggplot(aes(x=ratio, y = math)) +
  geom_point() +
  geom_smooth(method = "lm", se = F) +
  facet_wrap(~county)


#summarizing
CASchools %>%
  group_by(county) %>%
  summarise(avg_math = mean(math, na.rm = T),
            num_teachers = sum(teachers, na.rm = T),
            num_students = sum(students, na.rm = T)) %>%
  mutate(ratio = num_students/num_teachers) %>%
  ggplot(aes(x=ratio, y = avg_math)) +
  geom_point() +
  geom_smooth(method = "lm")




#making pretty graphs


CASchools %>%
  mutate(ratio = students/teachers) %>%
  ggplot(aes(x=ratio, y = math, size = expenditure)) +
  geom_point(shape = 21, fill = "lightgrey", color = "black", alpha = 0.7) +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.line.y.left = element_blank())
  


nk_theme <-
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.line.y.left = element_blank())



CASchools %>%
  mutate(ratio = students/teachers) %>%
  ggplot(aes(x=ratio, y = math, size = expenditure)) +
  geom_point(shape = 21, fill = "lightgrey", color = "black", alpha = 0.7) +
  nk_theme





