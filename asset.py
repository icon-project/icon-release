from datetime import datetime


def docker_tag() -> str:
    import pytz
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
    return body


def snap_version(release_tag: str) -> str:
    """ Make snap release version
    release tag format : YYYYMMDD[.micro]

    :param release_tag:
    :return: snap release version
    """

    import re

    pattern = re.compile(r"(\d{4})(\d{2})\d{2}(\.[0-9]*)?([.-_]?(?:dev|rc|post)\d*)?")
    version = ""
    if release_tag:
        match = re.search(pattern, release_tag)
        if match:
            year, month, micro, suffix = match.groups()
            version = f"{year}.{month}{micro}{suffix}"

    return version
