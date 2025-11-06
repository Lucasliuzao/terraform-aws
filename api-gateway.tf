
variable "api_id" {
  description = "ID da API Gateway (HTTP API)"
  type        = string
}

variable "vpc_link_id" {
  description = "ID do VPC Link já existente"
  type        = string
}

variable "alb_dns" {
  description = "DNS do ALB interno (sem https)"
  type        = string
}

# ROUTE + INTEGRATION
# Cria integração com o ALB via VPC Link
resource "aws_apigatewayv2_integration" "moradores_condominios_infos" {
  api_id                 = var.api_id
  integration_type       = "HTTP_PROXY"
  integration_uri        = "http://${var.alb_dns}/api/moradores/condominios/infos/{id}"
  connection_type        = "VPC_LINK"
  connection_id          = var.vpc_link_id
  integration_method     = "GET"
  payload_format_version = "1.0"
}

# Define a rota GET /api/moradores/condominios/infos/{id}
resource "aws_apigatewayv2_route" "moradores_condominios_infos" {
  api_id    = var.api_id
  route_key = "GET /api/moradores/condominios/infos/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.moradores_condominios_infos.id}"
}

# DEPLOYMENT & STAGE
resource "aws_apigatewayv2_stage" "uat" {
  api_id      = var.api_id
  name        = "uat"
  auto_deploy = true
  description = "UAT stage for moradores/condominios routes"
}
