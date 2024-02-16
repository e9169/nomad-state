job "podinfo" {
  
  datacenters = [
  "DC1"
]
  type = "service"

  constraint {
    attribute = "${meta.type}"
    value     = "client"
  }

  group "app" {
    count = 0

    network {
      mode = "bridge"
      port "http" {
        static = 80
        to = 9898
      }
    }

    
    service {
      name = "webapp"
      tags = [
  "traefik.enable=true",
  "traefik.http.routers.webapp.rule=Host(`escargot-lb-tf-1014484851.eu-central-1.elb.amazonaws.com`)"
]
      port = "http"

    //   check {
    //     name     = "alive"
    //     type     = "http"
    //     path     = "/"
    //     interval = "10s"
    //     timeout  = "2s"
    //   }
    }


    // restart {
    //   attempts = 2
    //   interval = "30m"
    //   delay = "15s"
    //   mode = "fail"
    // }

    task "server" {
      driver = "docker"

      config {
        image = "stefanprodan/podinfo"
        ports = ["http"]
      }

      // env {
      //   MESSAGE = "Hello from Nomad and Hackerdays!"
      // }
    }
  }
}
