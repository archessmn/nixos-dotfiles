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
  }
}