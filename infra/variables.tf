variable "aws_region" {
  description = "Región AWS del proyecto"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Nombre del proyecto"
  type        = string
  default     = "Plataforma-Vinculacion-Practicas"
}

variable "owner" {
  description = "Equipo responsable"
  type        = string
  default     = "Los-Ingenieros"
}

variable "environment" {
  description = "Ambiente lógico"
  type        = string
  default     = "practica12-v2"
}

variable "bucket_prefix" {
  description = "Prefijo del bucket (se añade sufijo aleatorio para unicidad global)"
  type        = string
  default     = "los-ingenieros-p12-iac"

  validation {
    condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 40
    error_message = "El prefijo debe tener entre 3 y 40 caracteres."
  }
}

variable "extra_tags" {
  description = "Etiquetas adicionales (CostCenter, Semester)"
  type        = map(string)
  default     = {}
}
