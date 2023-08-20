locals {
  Queue = [for line in split("\n", file("input.txt")) : {
    Queue_name = split(":", line)[0]
    Threshold = split(":", line)[1]
    sustain = split(":", line)[2]
  }]
}
