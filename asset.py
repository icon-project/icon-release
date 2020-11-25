import pytz
from datetime import datetime


def docker_tag() -> str:
    tzinfo = pytz.timezone("Asia/Seoul")
    # hash_tag = "${{ hashFiles('Makefile') }}"
    # print(hash_tag)
    # version_tag = f"{datetime.now(tzinfo).strftime('%Y%m%dT%H%M%S')}x{hash_tag[:6]}"
    version_tag = f"{datetime.now(tzinfo).strftime('%Y.%m.%d-%H%M%S')}"
    return f"DOCKER_TAG={version_tag}"


def package_info(file_path: str) -> str:
    with open(file_path) as f:
        body = f.read()

    # https://git.io/JkD3W
    return f"PACKAGE_INFO_BODY<<EOF\n{body}\nEOF"
