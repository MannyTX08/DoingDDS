#################### Question 1 ####################

# a) Log of a positive number
log.pos.num <- log(10, base=10) 
log.pos.num # 1

# b) The default base for the log fucntion is e, this is approximately 2.718282
# Here I confirm that the default base for log is e, in R exp(1) generates e
get.log <- log(10) 
get.log # 2.302585
proove.base <- log(10, exp(1)) 
proove.base # 2.302585
# Calculate a differnet base for log
get.log.newbase <- log(10, base=2) 
get.log.newbase # 3.321928

# c) Log of a negative number
log.neg.num <- log(-10)
log.neg.num # NaN
# Logirithm is only applicable to positive numbers, negative logirithm cannot be done

# d) Square-root of positive number
sqrt.pos.num <- sqrt(25)
sqrt.pos.num # 5

#################### Question 2 ####################

# a) Create vector of 15 standard normal random variables, calculate its mean, and SD
norm.random.vec15 <- rnorm(15)
norm.random.vec15
#  0.28933171 -0.01204824 -1.15483596  0.92676985 -0.29228950 -0.64186075 -0.12691091 -1.67997852  1.66222737
# -0.67325809 -0.06681182 -0.23057105 -0.97413982  2.27287620 -0.71417154

mean(norm.random.vec15) # -0.09437807
sd(norm.random.vec15) # 1.048043

# b) Change mean to 10 and SD to 2 and regenerate 15 random normal variables
#    Calculate mean and SD
norm.random.vec15.custom <- rnorm(15, mean = 10, sd=2)
norm.random.vec15.custom
#  8.779150  7.505030 11.423131 11.976077 11.460077 10.916376 11.717611 10.703407 10.903652 11.261613 12.342031
# 12.681379 11.974597  8.961717  7.061412

mean(norm.random.vec15.custom) # 10.64448
sd(norm.random.vec15.custom) # 1.742888

# c) rnorm generates random numbers whose distribution is normal with optional arguments for mean
#    and sd. The resulting values will be as close to the optional arguments specified.

#################### Question 3 ####################

# a) The weights of 6 individuals in kg are 60, 72, 57, 90, 95, 72
# b) Their heights (in m) are 1.80, 1.85, 1.72, 1.90, 1.74, 1.91.
# c) Enter these vectors into R.
weights.kg <- c(60, 72, 57, 90, 95, 72)
weights.kg
heights.meters <- c(1.80, 1.85, 1.72, 1.90, 1.74, 1.91)
heights.meters

# d) Create scatter plot of weight vs. height and interpret
plot(weights.kg ~ heights.meters, main="Weight (kg) vs Height (m)",
     ylab="Weight (kg)", xlab="Height (m)", pch=19, col="blue")

# Interpretation
# There appears to be a week positive linear relationship between weight in kg and height in meters
# From the function lm we will generate a set of summary statistics to determine if that is the case
my.model <- lm(weights.kg~heights.meters)
summary(my.model) # Pearson's R is 0.216541, this has a weak positive linear relationship

# e) BMI = weight in kg divided by the square of the height in m
bmi <- weights.kg/(heights.meters^2)
bmi # 18.51852 21.03725 19.26717 24.93075 31.37799 19.73630

# f)
weights.mean = mean(weights.kg) # 74.33333

# g) Subtract mean from each weight
weights.minus.mean = weights.kg - weights.mean
weights.minus.mean # -14.333333  -2.333333 -17.333333  15.666667  20.666667  -2.333333

# h)
sum(weights.minus.mean) #  2.842171e-14

#################### Question 4 ####################

Categories = c("Computer Programming", "Math", "Statistics", "Machine Learning", "Domain Expertise", "Communication and Presentation", "Data Visualization")
Rankings = c(2.5,3,3,2,4,4,4)
Manny = data.frame(Categories,Rankings)
Manny
#                              Categories Rankings
# 1                  computer programming        3
# 2                                  math        3
# 3                            statistics        3
# 4                      machine learning        2
# 5                      domain expertise        4
# 6 communication and presentation skills        4
# 7                    data visualization        4

# Bar Graph with Rotated X Labels
# https://stackoverflow.com/questions/10286473/rotating-x-axis-labels-in-r-for-barplot
par(mar = c(15, 4, 2, 2) + 0.2)
end.point <- 0.5 + length(Categories) + length(Categories) - 1
barplot(Rankings, main="Manny's Data Science Profile", col = "gray", 
        names.arg="", las=2, ylim = c(0,5), space = 1)
text(seq(1.5, end.point, by=2), par("usr")[3]-0.25,
     srt=60, adj=1, xpd=TRUE, labels=paste(Categories))