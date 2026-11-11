import json
import subprocess
import requests
import os
import sys
from colorama import Fore, Style


ignore_list = {
    "immich-app": [
        "immich-machine-learning",
        "immich-server",
        "postgres",
    ],
    "ashhhleyyy": [
        "ury-buzz"
    ],
    "linuxserver": [
        "mariadb"
    ],
}

ghcr_rewrites = {
    # "immich-app": {
    #     "immich-server": "immich"
    # }
}

manifest_rewrites = {
    "ghcr.io": {
        "archessmn": {
            "swurapp": "main"
        },
        "blakeblackshear": {
            "frigate": "stable"
        },
        "ystv": {
            "chdrms": "pr-67"
        }
    },
    # "docker.io": {
    #     "valkey": {
    #         "valkey": "9"
    #     }
    # }
}

nixeval = subprocess.Popen(["nix", "eval", "--json",
                            ".#nixosConfigurations", "--apply", "attrs: let names = builtins.filter (n: builtins.match \"temjin|tsuro\" n != null) (builtins.attrNames attrs); in builtins.listToAttrs (map (name: {inherit name;value = attrs.${name}.config.virtualisation.oci-containers.containers;}) names)"], stdout=subprocess.PIPE)

ociContainers = json.loads(subprocess.check_output(
    ["jq", "[.[].[].image]"], stdin=nixeval.stdout))

images: list[str] = list(set(ociContainers))

image_names = []
image_mappings = {}

for image in images:
    if image.startswith(("docker.io")) or image.split('/')[0].find(".") == -1:
        print(f"Image: {image}")
        if image_mappings.get(image.split(':')[0].split('@')[0]):
            print(Fore.YELLOW, "  Image version already fetched, continuing",
                  Fore.RESET, sep="")
            continue
        if image.split('/')[0].find("/") == -1:
            registry = "docker.io"
        else:
            registry = image.split('/')[0]
        owner = image.replace(f'{registry}/', '', 1).split('/')[0]
        if len(image.replace(f'{registry}/', '', 1).split('/')) == 1:
            repo = owner
            owner = "library"
        else:
            repo = image.replace(
                f'{registry}/', '', 1).split('/')[1].split(':')[0].split('@')[0]

        if ignore_list.get(owner, False) and repo in ignore_list[owner]:
            print(Fore.YELLOW, "  Ignoring", Fore.RESET, sep="")
            continue

        if ghcr_rewrites.get(owner, False) and ghcr_rewrites[owner].get(repo, False):
            repo = ghcr_rewrites[owner][repo]

        repo_read_token_res = requests.get(
            f"https://auth.docker.io/token?service=registry.docker.io&scope=repository:{owner}/{repo}:pull")

        if repo_read_token_res.status_code != 200:
            print("  Failed to get token")
            print(repo_read_token_res.text)
            continue

        repo_read_token = repo_read_token_res.json()["token"]

        manifest = "latest"

        if "docker.io" in manifest_rewrites:
            if owner in manifest_rewrites["docker.io"]:
                if repo in manifest_rewrites["docker.io"][owner]:
                    manifest = manifest_rewrites["docker.io"][owner][repo]
                    print(
                        Fore.YELLOW, f"  Setting manifest to override {manifest}", Fore.RESET, sep="")

        if manifest == "latest":
            if image.find("@") != -1 and image.split("@")[0].find(":") != -1:
                manifest = image.split("@")[0].split(":")[1]
                print(
                    Fore.YELLOW, f"  Setting manifest to found {manifest}", Fore.RESET, sep="")

        latest_res = requests.get(
            f"https://registry-1.docker.io/v2/{owner}%2F{repo}/manifests/{manifest}",
            headers={
                "Accept": "application/vnd.oci.image.index.v1+json",
                "Authorization": f"Bearer {repo_read_token}"
            }
        )

        if latest_res.status_code != 200:
            print(Fore.RED, "  Not found", Fore.RESET, sep="")
            continue

        release = latest_res.json()

        if "manifests" not in release:
            print("  No manifests")
            continue

        output_image = ""

        for os_manifest in release["manifests"]:
            if os_manifest["platform"]["os"] == "linux" and os_manifest["platform"]["architecture"] == "amd64":
                output_image = f'docker.io/{owner}/{repo}:{manifest}@{os_manifest["digest"]}'
                break

        if output_image == "":
            print(Fore.RED, "  No manifest matching the os and architecture",
                  Fore.RESET, sep="")
            continue

        if output_image == image:
            print(Fore.YELLOW, "  Image up to date, continuing",
                  Fore.RESET, sep="")
            continue
        else:
            print(Style.BRIGHT, "  Updated image: ", Style.RESET_ALL, Fore.GREEN,
                  output_image, Fore.RESET, sep="")

        image_names.append(f"{image.split(':')[0].split('@')[0]}")
        image_mappings.setdefault(
            f"{image.split(':')[0].split('@')[0]}", output_image)

    elif image.startswith(("ghcr.io", "lscr.io")):
        print(f"Image: {image}")
        registry = image.split('/')[0]
        owner = image.replace(f'{registry}/', '', 1).split('/')[0]
        repo = image.replace(
            f'{registry}/', '', 1).split('/')[1].split(':')[0].split('@')[0]

        if ignore_list.get(owner, False) and repo in ignore_list[owner]:
            print(Fore.YELLOW, "  Ignoring", Fore.RESET, sep="")
            continue

        if ghcr_rewrites.get(owner, False) and ghcr_rewrites[owner].get(repo, False):
            repo = ghcr_rewrites[owner][repo]

        repo_read_token_res = requests.get(
            f"https://ghcr.io/token?service=ghcr.io&scope=repository:{owner}/{repo}:pull")

        if repo_read_token_res.status_code != 200:
            print("  Failed to get token")
            continue

        repo_read_token = repo_read_token_res.json()["token"]

        manifest = "latest"

        if "ghcr.io" in manifest_rewrites:
            if owner in manifest_rewrites["ghcr.io"]:
                if repo in manifest_rewrites["ghcr.io"][owner]:
                    manifest = manifest_rewrites["ghcr.io"][owner][repo]
                    print(
                        Fore.YELLOW, f"  Setting manifest to override {manifest}", Fore.RESET, sep="")

        if manifest == "latest":
            if image.find("@") != -1 and image.split("@")[0].find(":") != -1:
                manifest = image.split("@")[0].split(":")[1]
                print(
                    Fore.YELLOW, f"  Setting manifest to found {manifest}", Fore.RESET, sep="")

        latest_res = requests.get(
            f"https://ghcr.io/v2/{owner}%2F{repo}/manifests/{manifest}",
            headers={
                "Accept": "application/vnd.oci.image.index.v1+json",
                "Authorization": f"Bearer {repo_read_token}"
            }
        )

        if latest_res.status_code != 200:
            print(Fore.RED, "  Not found", Fore.RESET, sep="")
            continue

        release = latest_res.json()

        if "manifests" not in release:
            print("  No manifests")
            continue

        output_image = ""

        for os_manifest in release["manifests"]:
            if os_manifest["platform"]["os"] == "linux" and os_manifest["platform"]["architecture"] == "amd64":
                output_image = f'ghcr.io/{owner}/{repo}:{manifest}@{os_manifest["digest"]}'
                break

        if output_image == "":
            print(Fore.RED, "  No manifest matching the os and architecture",
                  Fore.RESET, sep="")
            continue

        if output_image == image:
            print(Fore.YELLOW, "  Image up to date, continuing",
                  Fore.RESET, sep="")
            continue
        else:
            print(Style.BRIGHT, "  Updated image: ", Style.RESET_ALL, Fore.GREEN,
                  output_image, Fore.RESET, sep="")

        image_names.append(f"{registry}/{owner}/{repo}")
        image_mappings.setdefault(f"{registry}/{owner}/{repo}", output_image)

if os.getenv("GITHUB_OUTPUT"):
    with open(os.environ["GITHUB_OUTPUT"], "a") as gh:
        gh.write(
            f'image-names={json.dumps(image_names)}\r\n')
        gh.write(
            f'image-mappings={json.dumps(image_mappings)}\r\n')
else:
    print(
        f'image-names={json.dumps(image_names)}')
    print(
        f'image-mappings={json.dumps(image_mappings)}')

    # break
