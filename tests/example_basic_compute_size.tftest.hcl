provider "azurerm" {
  features {}
}

variables {
  size = "Standard_A2_v2"
}

# Contract test
run "valid_compute_sizes" {

  command = plan

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = contains(["Standard_A1_v2", "Standard_A2_v2", "Standard_A4_v2"], var.size)
    error_message = "The size is not approved for this Virtual Machine"
  }

}

run "invalid_compute_sizes" {

  command = plan

  variables {
    size = "D"
  }

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = !contains(["Standard_A1_v2", "Standard_A2_v2", "Standard_A4_v2"], var.size)
    error_message = "The size is not approved for this Virtual Machine"
  }

}

run "invalid_compute_sizes" {

  command = plan

  variables {
    size = "D"
  }

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = !contains(["Standard_A1_v2", "Standard_A2_v2", "Standard_A4_v2"], var.size)
    error_message = "The size is not approved for this Virtual Machine"
  }

  expect_failures = [
    var.size,
  ]
}
