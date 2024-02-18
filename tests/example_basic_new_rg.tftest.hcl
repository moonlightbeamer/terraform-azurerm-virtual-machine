provider "azurerm" {
  features {}
}

variables {
  size = "Standard_A2_v2"
  location = "eastus"
}

# integration test
run "setup_resource_group" {
  command = apply
  variables {
    location            = var.location
    resource_group_name = "test"
  }
  module {
    source = "./tests/setup-resource-group"
  }
}

run "validate_build" {
  command = plan

  variables {
    create_resource_group = "false"
    location              = run.setup_resource_group.resource_group_location
    resource_group_name   = run.setup_resource_group.resource_group_name
  }

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = length(module.linux.*.vm_name) >= 1
    error_message = "There were no linux compute instances created"
  }

  assert {
    condition     = length(module.windows.*.vm_name) >= 1
    error_message = "There were no windows compute instances created"
  }
}

run "validate_build_vm_id" {
  command = plan

  variables {
    create_resource_group = "false"
    create_public_ip      = "true"
    location              = run.setup_resource_group.resource_group_location
    resource_group_name   = run.setup_resource_group.resource_group_name
  }

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = can(regex("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Compute/virtualMachines/.+", module.linux.vm_id))
    error_message = "There were no linux compute instances created"
  }

  assert {
    condition     = can(regex("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Compute/virtualMachines/.+", module.windows.vm_id))
    error_message = "There were no linux compute instances created"
  }
}

# End to End test
run "validate_build_vm_ip" {
  command = apply

  variables {
    create_resource_group = "false"
    create_public_ip      = "true"
    location              = run.setup_resource_group.resource_group_location
    resource_group_name   = run.setup_resource_group.resource_group_name
  }

  module {
    source = "./examples/basic"
  }

  assert {
    condition     = can(regex("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Compute/virtualMachines/.+", module.linux.vm_id))
    error_message = "There were no linux compute instances created"
  }

  assert {
    condition     = can(regex("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Compute/virtualMachines/.+", module.windows.vm_id))
    error_message = "There were no windows compute instances created"
  }

  assert {
    condition     = can(regex("((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}", output.linux_public_ip))
    error_message = "There were no linux compute instances created with IP addresses"
  }

  assert {
    condition     = can(regex("((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}", output.windows_public_ip))
    error_message = "There were no windows compute instances created with IP addresses"
  }

}
