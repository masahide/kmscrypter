# kmscrypter

Command wrapper for encryption and decryption using aws kms.

[![Go Report Card](https://goreportcard.com/badge/github.com/masahide/kmscrypter)](https://goreportcard.com/report/github.com/masahide/kmscrypter)
[![Build Status](https://travis-ci.org/masahide/kmscrypter.svg?branch=master)](https://travis-ci.org/masahide/kmscrypter)
[![codecov](https://codecov.io/gh/masahide/kmscrypter/branch/master/graph/badge.svg)](https://codecov.io/gh/masahide/kmscrypter)
[![goreleaser](https://img.shields.io/badge/powered%20by-goreleaser-green.svg?style=flat-square)](https://github.com/goreleaser)

## Description

kmscrypter decrypts environment variables with keys that end in `_KMS` and assigns them to a key of the same name with the KMS suffix removed.
It also encrypts the value of an environment variable that has a key ending with `_PLAINTEXT` and assigns it to a key of the same name that replaced the suffix with `_KMS`.

For example, the following environment variable:
```
MY_SECRET_KMS="hZGLgZHLGcL2Tq1k5GJgYPjH2Pu/ifH/mV57PTXRyq3dd3Lmr3KqvLrlnoneZ...."
```
Will generate a `MY_SECRET` key in the `ENV` variable that contains the plaintext value of the original key.

## Installation

### Linux

For RHEL/CentOS:

```bash
sudo yum install https://github.com/masahide/kmscrypter/releases/download/v0.1.0/kmscrypter_amd64.rpm
```

For Ubuntu/Debian:

```bash
wget -qO /tmp/kmscrypter_amd64.deb https://github.com/masahide/kmscrypter/releases/download/v0.1.0/kmscrypter_amd64.deb && sudo dpkg -i /tmp/kmscrypter_amd64.deb
```

### macOS


install via [brew](https://brew.sh):

```bash
brew tap masahide/kmscrypter https://github.com/masahide/kmscrypter
brew install kmscrypter
```


## Usage

requires IAM access to Amazon's KMS service. 
It is necessary to exploit the role of EC2 IAM or to set access credentials in environment settings.
(or [~/.aws/credentials and ~/.aws/config File](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html))

```
AWS_ACCESS_KEY_ID=<your_key_id>
AWS_SECRET_ACCESS_KEY=<your_secret_key>
AWS_REGION=<ap-northeast-1 etc...>
```
