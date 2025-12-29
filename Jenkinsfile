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
        sh 'nixos-rebuild switch --flake .#temjin --target-host ops@localhost --use-remote-sudo'
        sh 'nixos-rebuild switch --flake .#tsuro --target-host ops@tsuro --use-remote-sudo'
      }
    }
  }
}