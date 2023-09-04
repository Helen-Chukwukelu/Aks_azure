variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  default = "AppGwVnet"
}

variable "frontend_sub" {
  default = "frontAGSubnet"
}

/* variable "backend_sub" {
  default = "backAGSubnet"
} */

variable "pip" {
  default = "testAGPublicIPAddress"
}

variable "appgw" {
  default = "testAppGateway"
}

variable "gw_ip_conf" {
  default = "test-gateway-ip-configuration"
}

variable "user_identity" {
  default = "appgw-api"
}

variable "backend_address_pool_name" {
  default = "testBackendPool"
}

variable "frontend_port_name" {
  default = "myFrontendPort"
}

variable "frontend_ip_configuration_name" {
  default = "myAGIPConfig"
}

variable "http_setting_name" {
  default = "myHTTPsetting"
}

variable "listener_name" {
  default = "myListener"
}

variable "request_routing_rule_name" {
  default = "myRoutingRule"
}

variable "AKStoAppGWVnetPeering_name" {
  default = "AKStoAppGWVnetPeering"
}

variable "AppGWtoAKSVnetPeering_name" {
  default = "AppGWtoAKSVnetPeering"
}

variable "aks_vnet_name" {
  default = "aks-vnet-77731381"
}
