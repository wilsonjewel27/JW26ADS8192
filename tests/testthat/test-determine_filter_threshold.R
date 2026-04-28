#test_determine_filter_threshold

test_that("invalid error message works", {
  data(example_se)

  expect_error(
    determine_filter_threshold(se_ln = example_se, group_var = "not_real"),
    "invalid group_var"
    )
})

test_that("invalid ref_level error message works", {
  data(example_se)

  expect_error(
    determine_filter_threshold(se_ln = example_se, ref_level = "not_real"),
    "invalid ref_level"
  )
})
