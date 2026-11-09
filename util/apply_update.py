import subprocess
import argparse
import re
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


def update_image(image: str, updated_image: str):
    print(f"Updating image: {image} to {updated_image}")
    # print("  ghcr detected")
    # print(f"  {image.replace('ghcr.io/', '', 1)}")
    registry = image.split('/')[0]
    owner = image.replace(f'{registry}/', '', 1).split('/')[0]
    repo = image.replace(
        f'{registry}/', '', 1).split('/')[1].split(':')[0].split('@')[0]

    files_with_image = list(filter(lambda f: f != '', subprocess.run(["nix", "develop", ".#", "--command",
                                                                      "rg", f"{registry}/{owner}/{repo}", ".", "-l"], capture_output=True).stdout.decode().split("\n")))
    # print(files_with_image)

    for file in files_with_image:

        regex = re.compile(
            fr"({registry}/{owner}/{repo}).*?(?=\")", re.MULTILINE)

        with open(file, "r") as open_file:
            filedata = open_file.read()

        filedata = regex.sub(updated_image, filedata)
        # filedata.replace(image, updated_image)

        with open(file, 'w') as open_file:
            open_file.write(filedata)


if __name__ == "__main__":
    arguments = argparse.ArgumentParser(description="Crestron NVX Host Setup")
    arguments.add_argument("-i", "--image",
                           help="Image to look for")
    arguments.add_argument("-u", "--updated-image",
                           help="New image to replace it with")

    args = arguments.parse_args()

    update_image(args.image, args.updated_image)
