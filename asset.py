import pytz
from datetime import datetime


def docker_tag():
    tzinfo = pytz.timezone("Asia/Seoul")
    # hash_tag = "${{ hashFiles('Makefile') }}"
    # print(hash_tag)
    # version_tag = f"{datetime.now(tzinfo).strftime('%Y%m%dT%H%M%S')}x{hash_tag[:6]}"
    version_tag = f"{datetime.now(tzinfo).strftime('%Y.%m.%d-%H%M%S')}"
    return f"DOCKER_TAG={version_tag}"
