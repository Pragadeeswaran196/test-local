locals {
  Queue = [for line in split("\n", file("visble_msg.txt")) : {
    Queue_name = split(",", line)[0]
    Threshold = split(",", line)[1]
    sustain = split(",", line)[2]
  }]
}
