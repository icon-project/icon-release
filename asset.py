from datetime import datetime
from string import Template


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
    return f"PACKAGE_INFO_BODY<<EOF\n{body}\nEOF"


def metadata(tag: str) -> str:
    with open("./appstream.template", "r") as f:
        template = f.read()

    import re
    import os
    from pathlib import Path
    from datetime import datetime

    release_date = re.sub(r"\.\d+$", "", tag)
    release_date = datetime.strptime(release_date, "%Y%m%d")
    appstream_data = {
        "NAME": "loopchain",
        "SUMMARY": "loopchain citizen",
        "DATE": f"{release_date:%Y-%m-%d}",
        "VERSION": tag
    }
    t = Template(template)
    appstream = t.substitute(appstream_data)

    appstream_path: Path = Path("./snap/local/org.iconrepublic.loopchain.appdata.xml")
    try:
        appstream_path.parent.mkdir()
    except FileExistsError:
        pass

    with open(appstream_path, "w") as f:
        f.write(appstream)

    return os.fspath(appstream_path)
