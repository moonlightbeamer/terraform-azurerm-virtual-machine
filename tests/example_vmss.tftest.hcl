provider "azurerm" {
  features {}
}

run "validate_example_vmss" {
  command = plan
  module {
    source = "./examples/vmss"
  }
}
