library(ggplot2)
library(readr)
library(dplyr)
library(broom)
library(surreal)

# Example 1
set.seed(856)
test_resid <- tibble(.fitted = rexp(855), .resid = rnorm(855))
ggplot(test_resid, aes(x=.fitted, y=.resid)) + geom_point()
write_csv(test_resid, file="residuals/test_resid.csv")

# Example 2
mtcars_fit2 <- lm(mpg~hp, data=mtcars)
mtcars_all2 <- augment(mtcars_fit2, mtcars)
ggplot(mtcars_all2, aes(x=.fitted, y=.resid)) + geom_point()
write_csv(mtcars_all2, file="residuals/mtcars_all2.csv")

# Example 3
std <- function(x) {
  (x-mean(x))/sd(x)
}
set.seed(332)
sur_data <- surreal_text("visual summaries\n  focus on\n unexpected values", 
                      p = 4, R_squared = 0.1, cex = 1, 
                      n_add_points = 0) |>
  as_tibble() |>
  rename(x1 = X.1,
         x2 = X.2,
         x3 = X.3,
         x4 = X.4) |>
  mutate_all(std)  
sur_model <- lm(y ~ x1 + x2 + x3 + x4, data = sur_data)
sur_all <- augment(sur_model)
ggplot(sur_all, aes(x=.fitted, y=.resid)) +
  geom_point()
write_csv(sur_all, file="residuals/sur_all.csv")

library(lmtest)
test_fit <- lm(.resid~.fitted, data=test_resid)
bptest(test_fit)
resettest(mtcars_fit2, type="regressor")
resettest(sur_model, type="regressor")
bptest(sur_model)
shapiro.test(sur_all$.resid)