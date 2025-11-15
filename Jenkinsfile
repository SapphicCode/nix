pipeline {
  agent {
    label 'local'
  }

  stages {
    stage("Checkout") {
      steps {
        checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://git.sapphiccode.net/SapphicCode/universe.git']])
        script {
          def rev = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
          def remoteUrl = sh(script: "git config --get remote.origin.url", returnStdout: true).trim()
          env.FLAKE_REF = "git+${remoteUrl}?rev=${rev}"
        }
      }
    }
    stage("Deploy NixOS") {
      matrix {
        axes {
          axis {
            name 'HOST'
            values "blahaj", "hyperhaj"
          }
        }
        stages {
          stage("Deploy") {
            steps {
              script {
                def host = env.HOST
                def args = ""
                if (host == "hyperhaj") {
                  args = "-o Port=2222 "
                }
                def address = "${args}${host}.sapphicco.de"

                withCredentials([sshUserPrivateKey(credentialsId: 'db1b8ea2-5664-4eed-93e6-eff75d958125', keyFileVariable: 'SSH_ID', usernameVariable: 'USER')]) {
                  sh """#!/usr/bin/env bash
                  set -euxo pipefail

                  ssh -i \$SSH_ID -o StrictHostKeyChecking=no -o User=\$USER ${address} -- sudo nixos-rebuild switch --flake "\${FLAKE_REF}"
                  """
                }
              }
            }
          }
        }
      }
    }
  }
}
