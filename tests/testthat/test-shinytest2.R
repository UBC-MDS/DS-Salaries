library(shinytest2)

test_that("{shinytest2} recording: DS-Salaries-fork1", {
  app <- AppDriver$new(variant = platform_variant(), name = "DS-Salaries-fork1", 
                       seed = 532, height = 722, width = 1235)
  app$set_inputs(navbar = "Top 10 highest paid jobs")
  app$expect_screenshot()
  app$set_inputs(country = "Bolivia")
})

test_that("{shinytest2} recording: DS-Salaries-fork3", {
  app <- AppDriver$new(variant = platform_variant(), name = "DS-Salaries-fork3", 
                       seed = 532, height = 722, width = 1235)
  app$set_inputs(navbar = "Average salary by employment type and by year")
  app$expect_screenshot()
  app$set_inputs(remote_ratio = "50")
})


test_that("{shinytest2} recording: DS-Salaries-fork", {
  app <- AppDriver$new(variant = platform_variant(), name = "DS-Salaries-fork", seed = 532, 
                       height = 722, width = 1235)
  app$set_inputs(navbar = "Average salary by employment type and by year")
  app$expect_screenshot()
  app$set_inputs(exp_levels = c("EN", "SE", "EX"))
})
