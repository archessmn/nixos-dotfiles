pipeline {
  agent any
  environment {
      PATH="/run/current-system/sw/bin"
  }
  stages {
    stage('Build') {
      steps {
        sh 'nixos-rebuild build --flake .#temjin'
      }
    }
    stage('Deploy') {
      when {
        anyOf {
          branch 'main'
        }
      }
      steps {
        sh 'nixos-rebuild switch --flake .#temjin --target-host ops@localhost --use-remote-sudo'
      }
    }
  }
}