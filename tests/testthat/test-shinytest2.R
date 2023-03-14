library(shinytest2)

test_that("{shinytest2} recording: DS-Salaries_histogram", {
  app <- AppDriver$new(name = "DS-Salaries_histogram", height = 601, width = 979)

  app$set_inputs(bins = 28)
  app$expect_values()
})


test_that("{shinytest2} recording: DS-Salaries_hist2", {
  app <- AppDriver$new(variant = platform_variant(), name = "DS-Salaries_hist2", 
      height = 601, width = 979)
  app$set_inputs(bins = 25)
  app$set_inputs(bins = 22)
  app$set_inputs(bins = 47)
  app$expect_values()
  app$expect_screenshot()
})
