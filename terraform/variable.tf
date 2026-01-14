variable "env" {
  type    = string
  default = "dev"
}

variable "db_table_name" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}
