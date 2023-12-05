# Palmer Penguins

Candidate Number: 1064807

R.md RMarkdown file for Q1 and 2 🔗: https://github.com/1064807/Palmer_Penguins/blob/215e06b42c1a525b1c564ff3facbf2eef47a7156/Palmer_Penguins_Assignment_2023.Rmd

RPubs link of script 🔗: http://rpubs.com/OXF1064807/1124788

Also see below for embedded code and comments:


Install and load necessary packages

<pre>
```r
{r Installing and loading necessary packages}
library(palmerpenguins)
library(ggplot2)
library(janitor)
library(dplyr)
library(plotly) #for interactive plots
```
</pre>

__*Question 1 (Q1a) Creating a figure using the Palmer Penguin data set that is correct but badly communicates the data*__

<pre>
```r
{r Creating poor figure - scatter graph (from hell!) for bill length and flipper length}
#plotting a scatter graph for bill length (x axis) against flipper length (y axis). High point size of 30 and reversed x axis
ggplot(data=penguins,
       aes(x=bill_length_mm,
           y=flipper_length_mm), colour=species)+
  geom_point(size=30)+ #increasing the size of points
  scale_x_reverse() + #reversing the x axis
  labs(x="Bill Length",
       y="Flipper Length")
```
</pre>

![Bad Graph](https://github.com/1064807/Palmer_Penguins/blob/7d045d04aec7e6ca3584dfc73f8400d965ab52c4/Figures/bad_graph.png)

(Q1b) Write about how your design choices mislead the reader about the underlying data (200-300 words)

There are four basic rules for data visualisation and my poorly drawn graph violates all of these principles. Here is how:

Showing the data - the data is hidden because the data is over-plotted and the points are too large. Due to this, it is difficult to see the individual points.

Seeing patterns - patterns are difficult to see because the points are too large and are plotted one on top of the other (over-plotted). Additionally, the x axis has been reversed which makes it difficult to see the true pattern; especially given the fact that the axis label gives no indication of reversal.

Represent magnitudes honestly - due to over-plotting, it is difficult to see the magnitudes as the points are obscured.

Draw graphical elements clearly - graphical elements are not drawn clearly. The points are too large and there is no title. Additionally, the data had not been cleaned appropriately beforehand.

__*Question 2 (Q1a) Write a data analysis pipeline in your .rmd RMarkdown file. You should be aiming to write a clear explanation of the steps as well as clear code*__

__Introduction__

The data set contains size measurements for three species of penguins found on three islands in the Palmer Archipelago, Antarctica (Gorman et al 2014). This data pipeline aims to explore the Palmer Penguin data set further; particularly investigating the interspecific variation in flipper length (i.e. looking to see if flipper length varies due to species).

The data must first be cleaned appropriately.

<pre>
```r
{r Cleaning the data}
# View the structure of the dataset
str(penguins)

# Check for missing values in the original dataset
summary(is.na(penguins))

# Remove NAs from 'species' and 'flipper_length_mm', and ensure flipper length is always positive (i.e. checking data integrity)
cleaned_penguins <- penguins[complete.cases(penguins$species, penguins$flipper_length_mm) & penguins$flipper_length_mm >= 0, ]

# Check the cleaned dataset
summary(is.na(cleaned_penguins))

#Cleaning data is important because missing values can lead to incomplete or inaccurate analyses. Removing NAs ensures that the data is compatible with the functions used in subsequent analyses, preventing potential errors or misinterpretations.
```
</pre>

Secondly, the data must be explored. This can be achieved by creating an exploratory figure

<pre>
```r
{r Exploratory figure - jitter plot for species and flipper length}

# Jitter plot (exploratory figure) for flipper length of each species. Alpha = 0.7 ensures points have some transparency to avoid over-plotting. Species identified by colour.
ggplot(data = cleaned_penguins, aes(x = species, y = flipper_length_mm)) +
  geom_jitter(aes(color = species),
              width = 0.2, 
              alpha = 0.7) +
  labs(title = "Jitter Plot Showing the Distribution of Flipper Lengths by Species",
       x="Species",
       y="Flipper Length (mm)")+
  scale_color_manual(values = c("darkorange","darkgreen","blue3"))
```
</pre>

![Exploratory Graph - Jitterplot](https://github.com/1064807/Palmer_Penguins/blob/7d045d04aec7e6ca3584dfc73f8400d965ab52c4/Figures/jitter_plot.png)

__Hypothesis:__

H0: There is no difference in mean flipper length between species

H1: At least one of the species's mean flipper length significantly differs from at least one other species's mean flipper length

Based on the exploratory figure, I predict that the flipper length of Gentoo penguins will significantly differ from both Chinstrap and Adelie. Therefore, I predict that there is a difference in mean flipper length between species.

__Statistical Methods:__

As the investigation is between a categorical explanatory variable (i.e. species) and continuous response variable (i.e. flipper length), an Analysis of Variance (ANOVA) will be used. The ANOVA is used to test whether individuals chosen from different groups, on average, are more different than individuals chosen from the same group. In this case, investigating whether individuals from different species are, on average, more different regarding flipper length than individuals from the same species. There are four assumptions of ANOVA: normality, homogeneity of variances, independence, and random sampling. These are assumed to be met for the analysis.

<pre>
```r
{r Fitting a linear model to the cleaned data}
#Fitting a linear model to the cleaned data
flipper_mod1 <- lm(flipper_length_mm ~ species, cleaned_penguins)
summary(flipper_mod1) #showing summary of linear model

{r ANOVA}
#Running the ANOVA function
anova(flipper_mod1)
```
</pre>
  
Based on this ANOVA, a post-hoc comparison can be conducted to identify which species are different from each other. The post-hoc comparison is a Tukey-Kramer test (also known as a Tukey Honest Significance Test). It is also called a Tukey HSD for short.

<pre>
```r
{r TukeyHSD}
#Run the TukeyHSD 
TukeyHSD(aov(flipper_mod1))
```
</pre>

__Results:__

Box plots can be used to visualise the results of the ANOVA. This is because the box plot demonstrates the distribution of each group (species) and shows and potential differences in central tendency and spread.

<pre>
```r
{r Box plot for species and flipper length}
#Box plot for flipper length and species. Customizing box plot appearance by changing colour, point size, point transparency, and jitter
ggplot(data = cleaned_penguins, aes(x = species, y = flipper_length_mm, colour = species,  alpha = 0.7)) +
  geom_boxplot(fill = "white", color = "black") +  # Customize box plot appearance
  geom_point(position = position_jitter(), size = 2) +  # Customize point appearance
  scale_color_manual(values = c("darkorange", "darkgreen", "blue3")) +  # Set custom colors
  labs(title = "Distribution of Flipper Lengths by Species",
       x = "Penguin Species", y = "Flipper Length (mm)") +
  theme_minimal()         
 
{r Interactive box plot for species and flipper length}
#Making an Interactive Box plot
boxplot <- ggplot(data = cleaned_penguins, aes(x = species, y = flipper_length_mm, color = species, alpha = 0.8)) +
  geom_boxplot(fill = "white", color = "black") +
  geom_point(position = position_jitter(), size = 2) +
  scale_color_manual(values = c("darkorange", "darkgreen", "blue3")) +
  labs(title = "Distribution of Flipper Lengths by Species",
       x = "Penguin Species", y = "Flipper Length (mm)") +
  theme_minimal()

# Convert ggplot to plot_ly
interactive_boxplot <- ggplotly(boxplot)

# Print the interactive box plot
interactive_boxplot

#Viewers can interact with the plot by rolling over elements to highlight and identify individual points
```
</pre>

![Box Plot - Non-Interactive](https://github.com/1064807/Palmer_Penguins/blob/7d045d04aec7e6ca3584dfc73f8400d965ab52c4/Figures/non-interactive_boxplot.png)

An alternative visualisation method is the violin plot. Violin plots can also be used to visualise the results of the ANOVA as they show the distribution of the data along with the summary statistics and are useful for comparing different groups, which in this case is species.

<pre>
```r
{r Violin plot for species and flipper length}
#Violin plot for flipper length and species. Customizing violin plot appearance by changing colour, point size, point transparency, and jitter
ggplot(data = cleaned_penguins, aes(x = species, y = flipper_length_mm, fill = species, alpha = 0.7)) +
  geom_violin(color = "black", scale = "width", trim = FALSE) +  # Use geom_violin for violin plot
  geom_point(position = position_jitter(width = 0.2), size = 2) +  # Customize point appearance
  scale_fill_manual(values = c("darkorange", "darkgreen", "blue3")) +  # Set custom colors
  labs(title = "Distribution of Flipper Lengths by Species",
       x = "Penguin Species", y = "Flipper Length (mm)") +
  theme_minimal()

{r Interactive violin plot for species and flipper length}
#Making an Interactive Violin plot
violin <- ggplot(data = cleaned_penguins, aes(x = species, y = flipper_length_mm, fill = species, alpha = 0.8)) +
  geom_violin(color = "black", scale = "width", trim = FALSE) +  # Use geom_violin for violin plot
  geom_point(position = position_jitter(width = 0.2), size = 2) +  # Customize point appearance
  scale_fill_manual(values = c("darkorange", "darkgreen", "blue3")) +  # Set custom colors
  labs(title = "Distribution of Flipper Lengths by Species",
       x = "Penguin Species", y = "Flipper Length (mm)") +
  theme_minimal()

# Convert ggplot to plot_ly
interactive_violin <- ggplotly(violin)

# Print the interactive plot
interactive_violin

#Viewers can interact with the plot by rolling over elements to highlight and identify individual points
  ```
</pre>

![Box Plot - Non-Interactive](https://github.com/1064807/Palmer_Penguins/blob/7d045d04aec7e6ca3584dfc73f8400d965ab52c4/Figures/non-interactive_violinplot.png)

__Discussion:__

The coefficient table demonstrate that the mean flipper length for: Adelie penguins is 189.954 mm, Chinstrap penguins is 195.824 mm, and Gentoo penguins is 217.187 mm. Ecologically, Gentoo penguins are deep divers whereas Adelie and Chinstrap penguins are shallow divers. This behavioural segregation appears to be anatomically reflected; with Gentoo penguinis having longer flipper lengths to support them in deeper swimming (Trivelpiece et al 1987). The adjusted R-squred value of 0.777 indicates that 78% of the variation in the dataset is explained by differences between species. This is high for biological data.

The ANOVA table shows a p value of less than 0.05. This shows that there is evidence to reject the null hypothesis because our p-value is less than 0.05 (conventional alpha level). This means that at least one of the species of penguin differs from at least one other species of penguin. However, it is important to note that as these penguin species share phylogenetic relatedness, it is not possible to guarantee independence of points (one of the key assumptions of ANOVA) (Tarroux et al 2018).

To identify which species are different from each other, a Tukey HSD was conducted. The results show that for each pairwise comparison the p-value is less than 0.05. This means that the null hypothesis is rejected (i.e. two group means are the same). Therefore, every species differs in flipper length significant from every other species (i.e. all three species differ from each other significantly).

These results make biological sense as different species have different anatomical/physical/physiological adaptations. As such, each species of penguin is expected to have different flipper size as they may be adapted to different ecological niches.

__Conclusion:__

Based on the results and analysis, we can conclude that flipper length varies between species significantly. This interpecific variation is biologically coherent as ecological discrepencies between species lead to anatomical adaptations and differences. In order of shortest to longest flipper length, the species are: Adelie, Chinstrap, and Gentoo.

__References:__

Gorman KB, Williams TD, Fraser WR (2014). __Ecological sexual dimorphism and environmental variability within a community of Antarctic penguins (genus Pygoscelis)__. PLoS ONE 9(3):e90081. https://doi.org/10.1371/journal.pone.0090081

Tarroux, A., Lydersen, C., Trathan, P. N., & Kovacs, K. M. (2018). __Temporal variation in trophic relationships among three congeneric penguin species breeding in sympatry__. Ecology and evolution, 8(7), 3660–3674. https://doi.org/10.1002/ece3.3937

Trivelpiece, W. Z., Trivelpiece, S. G., & Volkman, N. J. (1987). __Ecological Segregation of Adelie, Gentoo, and Chinstrap Penguins at King George Island, Antarctica__. Ecology, 68(2), 351–361. https://doi.org/10.2307/193926
