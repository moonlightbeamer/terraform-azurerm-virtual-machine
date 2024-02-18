provider "azurerm" {
  features {}
}

# Unit test
run "validate_example_basic" {
  command = plan
  module {
    source = "./examples/basic"
  }
}

run "valid_resource_group_name" {

  variables {
    resource_group_name = "my_rg"
  }

  command = plan

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = can(regex("^[\\w\\(\\)\\-\\.]+", var.resource_group_name)) && !endswith(var.resource_group_name, ".")
    error_message = <<EOT
      Resource Group Name must meet the following requirements:
      Alphanumerics, underscores, parentheses, hyphens, periods.
      Can't end with period.
      EOT
  }
}
