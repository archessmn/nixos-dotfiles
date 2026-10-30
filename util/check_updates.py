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
    ]
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
    }
}


ociContainers = json.loads(subprocess.run(["nix", "eval", "--json",
                                           ".#nixosConfigurations.temjin.config.virtualisation.oci-containers.containers"], capture_output=True).stdout)

images = list(set(map(lambda kv: str(kv[1]["image"]), ociContainers.items())))

for image in images:
    if image.startswith("ghcr.io"):
        print(f"Image: {image}")
        # print("  ghcr detected")
        # print(f"  {image.replace('ghcr.io/', '', 1)}")
        owner = image.replace('ghcr.io/', '', 1).split('/')[0]
        repo = image.replace(
            'ghcr.io/', '', 1).split('/')[1].split(':')[0].split('@')[0]

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
                print(Style.BRIGHT, "  Updated image: ", Style.RESET_ALL, Fore.GREEN,
                      output_image, Fore.RESET, sep="")
                break

        if output_image == "":
            print(Fore.RED, "  No manifest matching the os and architecture",
                  Fore.RESET, sep="")
            continue

        files_with_image = list(filter(lambda f: f != '', subprocess.run(["nix", "develop", ".#", "--command",
                                                                          "rg", f"ghcr.io/{owner}/{repo}", ".", "-l"], capture_output=True).stdout.decode().split("\n")))
        print(files_with_image)

        for file in files_with_image:
            with open(file, "r") as open_file:
                filedata = open_file.read()

            filedata = filedata.replace(image, output_image)

            with open(file, 'w') as open_file:
                open_file.write(filedata)

        if os.getenv("GITHUB_OUTPUT"):
            with open(os.environ["GITHUB_OUTPUT"], "a") as gh:
                gh.write(
                    f'test={json.dumps([{"image": image, "update": output_image}]).replace("\"", "\\\"")}')
        else:
            print(
                f'"test={json.dumps([{"image": image, "update": output_image}]).replace("\"", "\\\"")}"')

        break
