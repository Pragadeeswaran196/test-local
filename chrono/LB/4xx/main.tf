locals {
  lines = split("\n", file("backend_4xx.txt"))
  non_empty_lines = [
    for line in local.lines : line if trimspace(line) != ""
  ]

  LB = [
    for line in local.non_empty_lines : {
      LB_name = split(",", line)[0]
      Threshold  = length(split(",", line)) >= 2 ? split(",", line)[1] : ""
      sustain    = length(split(",", line)) >= 3 ? split(",", line)[2] : ""
    }
  ]
}
resource "chronosphere_monitor" "critical_prod_aws_inf_elb_backend_4xx_test" {
  name                   = "Critical | PROD | AWS INF | ELB  |  backend_4XX Ratio Breached Upper Threshold-test"
  slug                   = "critical-prod-aws-inf-elb-backend-4xx_test"
  bucket_id              = "techops-prod-alerts"
  notification_policy_id = "techops-prod-alerts"
  query {
    prometheus_expr = "up"
  }
  series_conditions {
    condition {
      op       = "GT"
      severity = "critical"
      sustain  = "10m"
      value    = 100
    }
    dynamic "override" {
      for_each = { for lb in local.LB : lb.LB_name => lb }

      content {
        condition {
          op       = "GT"
          severity = "critical"
          sustain  = override.value.sustain
          value    = override.value.Threshold
        }

        label_matcher {
          name  = "tag_Name"
          type  = "EXACT"
          value = override.value.LB_name
        }
      }
    }
  }
  annotations = {
    SOP = "https://fourkites.atlassian.net/wiki/spaces/TECHOPS/pages/629407987/ALB+ELB+5XX+Alert"
  }
  interval = "1m"
  labels = {
    Comp      = "Load-balancer"
    Env       = "Prod"
    Terraform = "True"
  }
  signal_grouping {
    label_names = ["dimension_LoadBalancerName", "tag_env", "tag_Name"]
  }
}


