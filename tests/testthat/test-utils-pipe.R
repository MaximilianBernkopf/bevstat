test_that("pipe is exported", {
  add_x_and_y <- function(x,y){ x + y }
  expect_equal(7, 5 %>% add_x_and_y(2))
})
