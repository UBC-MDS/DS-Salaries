library(shinytest2)

test_that("{shinytest2} recording: tab_test", {
  app <- AppDriver$new(name = "tab_test", seed = 532, height = 976, width = 1619)
  app$set_inputs(navbar = "Top 10 highest paid jobs")
  app$set_inputs(navbar = "Average salary by employment type and by year")
  app$set_inputs(navbar = "Salary map")
  app$set_inputs(navbar = "Top 10 highest paid jobs")
  app$set_inputs(navbar = "Average salary by employment type and by year")
  app$expect_values()
})


test_that("{shinytest2} recording: map-test", {
  app <- AppDriver$new(name = "map-test", seed = 532, height = 976, width = 1619)
  app$set_inputs(comp_size = "S")
  app$set_inputs(comp_size = "L")
  app$set_inputs(comp_size = "M")
  app$set_inputs(comp_size = "L")
  app$expect_values()
})


test_that("{shinytest2} recording: top_10_test", {
  app <- AppDriver$new(name = "top_10_test", seed = 532, height = 976, width = 1619)
  app$set_inputs(navbar = "Top 10 highest paid jobs")
  app$set_inputs(country = "Ireland")
  app$set_inputs(country2 = "United States of America")
  app$set_inputs(country = "Luxembourg")
  app$set_inputs(country2 = "India")
  app$expect_values()
})


test_that("{shinytest2} recording: salary_test", {
  app <- AppDriver$new(name = "salary_test", seed = 532, height = 976, width = 1619)
  app$set_inputs(navbar = "Average salary by employment type and by year")
  app$set_inputs(exp_levels = c("MI", "SE", "EX"))
  app$set_inputs(exp_levels = c("MI", "EX"))
  app$set_inputs(exp_levels = "MI")
  app$set_inputs(exp_levels = character(0))
  app$set_inputs(exp_levels = "SE")
  app$set_inputs(exp_levels = c("MI", "SE"))
  app$set_inputs(remote_ratio = "50")
  app$set_inputs(remote_ratio = "0")
  app$set_inputs(remote_ratio = "100")
  app$expect_values()
})


