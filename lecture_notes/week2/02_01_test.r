
if (!require(testthat)) install.packages("testthat")

pacman::p_load(testthat)

context("Variable check")

test_that("Check whether instructor variable is setup correctly", {

  instructors <- c("Jae", "Nick")

  expect_equal(class(instructors), "character")

}
)
