![release packages](https://github.com/icon-project/icon-release/workflows/Release%20packages/badge.svg?event=workflow_dispatch)
![release snap](https://github.com/icon-project/icon-release/workflows/Release%20snap/badge.svg?event=release)
[![loopchain](https://snapcraft.io/loopchain/badge.svg)](https://snapcraft.io/loopchain)

# ICON release
This repository to release packages of ICON projects that [loopchain], [icon-service], [icon-rpc-server]

## wheel build and github release
### run manual workflow
 - [release package action]

## snap build
### run manual workflow
 - [snap release action]

### automation
> automation build will be triggered when published on github release

## docker build
> TODO


[loopchain]: https://github.com/icon-project/loopchain
[icon-service]: https://github.com/icon-project/icon-service
[icon-rpc-server]: https://github.com/icon-project/icon-rpc-server
[release package action]: https://github.com/icon-project/icon-release/actions?query=workflow%3A.github%2Fworkflows%2Frelease_packages.yaml
[snap release action]: https://github.com/icon-project/icon-release/actions?query=workflow%3A.github%2Fworkflows%2Fsnap_release.yaml