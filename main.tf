variable "input_file_path" {
  description = "Path to the input text file"
  type        = string
  default     = "input.txt"
}

locals {
  Queue = [
    for line in split("\n", file(var.input_file_path)) : {
      Queue_name = length(split(":", line)) >= 1 ? split(":", line)[0] : ""
      Threshold  = length(split(":", line)) >= 2 ? split(":", line)[1] : ""
      sustain    = length(split(":", line)) >= 3 ? split(":", line)[2] : ""
    }
  ]
}

output "queue_info" {
  value = local.Queue
}
