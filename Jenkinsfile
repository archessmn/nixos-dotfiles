library 'github.com/archessmn/jenkins-library'

pipeline {
  agent any
  environment {
    PATH="/run/current-system/sw/bin"
  }
  stages {
    stage('Build') {
      steps {
        sh 'nix build .#nixosConfigurations.temjin.config.system.build.toplevel'
        sh 'nix build .#nixosConfigurations.tsuro.config.system.build.toplevel'
      }
    }
    stage('Deploy') {
      when {
        anyOf {
          branch 'main'
        }
      }
      steps {
        script {
          def temjinStatus = sh script: 'nixos-rebuild switch --flake .#temjin --target-host ops@localhost --sudo', returnStatus: true
          nixosHostStatus.set host: 'temjin', status: 'SUCCESS'
          def tsuroStatus = sh script: 'nixos-rebuild switch --flake .#tsuro --target-host ops@tsuro --sudo', returnStatus: true
          nixosHostStatus.set host: 'tsuro', status: 'SUCCESS'
        }
      }
    }
  }
}