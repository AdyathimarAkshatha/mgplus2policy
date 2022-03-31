#____________________________ERIKS____________________________________________-#

resource "azurerm_management_group" "eriksmg" {
  display_name = "ERIKS1"
}

# Assign policies to root i.e ERIKS management group 
# policy 1
# policy definition
resource "azurerm_policy_definition" "policyone" {
  display_name        = "only deloy in West europe"
  name                = "deploy in weu"
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.eriksmg.group_id

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "westeurope"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
}
# end of policy 1 definition 

# policy 1 assignment 
resource "azurerm_management_group_policy_assignment" "policyone" {
  name                 = "region specic policy"
  display_name = "region policy"
  policy_definition_id = azurerm_policy_definition.policyone.id
  management_group_id  = azurerm_management_group.eriksmg.id
}
# end of policy 1 assignment 
# end of policy 1

# policy 2
# policy 2 definition 
resource "azurerm_policy_definition" "policytwo" {
  display_name        = "All resources should have tag"
  name                = "resources tag"
  
  policy_type         = "Custom"
  mode                = "All"
  management_group_id = azurerm_management_group.eriksmg.group_id
  parameters          = <<PARAMETERS
 {
"tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag, such as 'environment'"
        }
    } 
}
    PARAMETERS
  policy_rule         = <<POLICY_RULE
 {
"if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field": "[concat('tags[', parameters('tagName'), ']')]",
            "exists": "false"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }

 POLICY_RULE
}
# end of policy 2 definition
# start of policy 2 assignment 
resource "azurerm_management_group_policy_assignment" "policytwo" {
  display_name         = "resource policy"
  name                 = "resource policy"
  policy_definition_id = azurerm_policy_definition.policytwo.id
  management_group_id  = azurerm_management_group.eriksmg.id
}
# end of policy 2 assignment 
# end of policy 2 

#end eriks root mg 
#_________________________________________________ERIKS End_________________________________
# level 2.1 Decomissioned starts
resource "azurerm_management_group" "decomissionedmg" {
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.eriksmg.id
    
}
# level 2.1 Decomissioned ends
# level 2.2
resource "azurerm_management_group" "sandboxmg" {
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.eriksmg.id
}
# level 2.2 Sandbox end 
# level 2.3 
resource "azurerm_management_group" "platformmg" {
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.eriksmg.id
}
# level 2.3 Platform End 
# level 2.4
resource "azurerm_management_group" "landingzonemg" {
  display_name               = "Landing Zone"
  parent_management_group_id = azurerm_management_group.eriksmg.id
}
# level 2.4 LandingZone End 

# level 2.3.1
resource "azurerm_management_group" "connectivitymg" {
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platformmg.id
}

#level 2.3.2
resource "azurerm_management_group" "idenditymg" {
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platformmg.id
}

#level 2.3.3
resource "azurerm_management_group" "managementmg" {
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platformmg.id
}

# level 2.4.1
resource "azurerm_management_group" "regionsmg" {
  display_name               = "Regions"
  parent_management_group_id = azurerm_management_group.landingzonemg.id
}

resource "azurerm_management_group" "APAC" {
  display_name               = "APAC"
  parent_management_group_id = azurerm_management_group.regionsmg.id
}

resource "azurerm_management_group" "Corpmg" {
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.APAC.id
}

resource "azurerm_management_group" "Onlinemg" {
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.APAC.id
}

resource "azurerm_management_group" "sapmg" {
  display_name               = "SAP"
  parent_management_group_id = azurerm_management_group.APAC.id
}


#-----------
resource "azurerm_management_group" "cemg" {
  display_name               = "CE"
  parent_management_group_id = azurerm_management_group.regionsmg.id
}

resource "azurerm_management_group" "cecorpmg" {
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.cemg.id
}

resource "azurerm_management_group" "cesapmg" {
  display_name               = "SAP"
  parent_management_group_id = azurerm_management_group.cemg.id
}

resource "azurerm_management_group" "ceonlinemg" {
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.cemg.id
}

resource "azurerm_management_group" "ukimg" {
  display_name               = "UKI"
  parent_management_group_id = azurerm_management_group.regionsmg.id
}

resource "azurerm_management_group" "ukicorpmg" {
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.ukimg.id
}

resource "azurerm_management_group" "ukisapmg" {
  display_name               = "SAP"
  parent_management_group_id = azurerm_management_group.ukimg.id
}

resource "azurerm_management_group" "ukionlinemg" {
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.ukimg.id
}




