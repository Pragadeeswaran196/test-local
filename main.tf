variable "input_file_path" {
  description = "Path to the input text file"
  type        = string
  default     = "input.txt"
}

locals {
  Queue = [for line in split("\n", file(var.input_file_path)) : {
    Queue_name = split(":", line)[0]
    Threshold = split(":", line)[1]
    sustain = split(":", line)[2]
  }]
}

output "queue_info" {
  value = local.Queue
}
