variable "input_file_path" {
  description = "Path to the input text file"
  type        = string
  default     = "input.txt"
}

data "local_file" "input" {
  depends_on = [var.input_file_path]
  filename  = var.input_file_path
}

output "processed_text" {
  value = data.local_file.input.content
}
