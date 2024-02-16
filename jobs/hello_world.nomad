job "hello_world" {
  
  datacenters = [
  "DC1"
]
  type = "service"

  group "app" {
    count = 3

    network {
      mode = "bridge"
      port "http" {
        to = 8000
      }
    }

    
    service {
      name = "webapp"
      tags = [
  "traefik.enable=true",
  "traefik.http.routers.webapp.rule=Host(`bedbug-lb-tf-1464285659.eu-central-1.elb.amazonaws.com`)",
  "traefik.http.middlewares.testheader.headers.customresponseheaders.X-Script-Name=test"
]
      port = "http"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }

      connect {
        sidecar_service {}
      }
    }


    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "server" {
      driver = "docker"
      shutdown_delay = "2s"

      config {
        image = "mnomitch/hello_world_server"
        ports = ["http"]
      }

      env {
        MESSAGE = "Hello from Nomad!"
      }
    }
  }
}
