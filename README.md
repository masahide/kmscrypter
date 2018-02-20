# kmscrypter

Command wrapper for encryption and decryption using [aws kms](https://aws.amazon.com/kms/).

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

```bash
AWS_ACCESS_KEY_ID=<your_key_id>
AWS_SECRET_ACCESS_KEY=<your_secret_key>
AWS_REGION=<ap-northeast-1(etc..)>
```

### As a decryption command wrapper
```
$  kmscrypter some_command [arg1 arg2...]
```
kmscrypter operates as follows.

1. Find the key name of the environment variable with `_KMS` suffix
2. Execute KMS Decrypt API using aws credentials to decrypt the value
3. Set the decrypted value to the key name from which the `_KMS` suffix was removed from the original key
4. Execute `some_command` with` args`.


### Use case 1:

Handle secret variables with ansible.

#### secret.json:
```json
{
  "user1": "pass1111",
  "user2": "pass12345"
}
```

#### encrypt json:
* Set the master key ARN to `KMS_CMK`
* Set the json string to the key with the `_PLAINTEXT 'suffix
```bash
$ SECRET_JSON_PLAINTEXT=$(cat secret.json) \
KMS_CMK=arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab \
kmscrypter
```
output:
```bash
export SECRET_JSON_KMS="hZGLgZvuacL2TiyoCQ1HLGq1k5GJgYP......"
```


#### playbook example:
From `ansible-playbook` you can reference it using` lookup` filter etc.
```yaml
- hosts: all
   vars:
     secret: "{{ lookup('env', 'SECRET_JSON') | from_json }}"
   tasks:
   - debug: msg = {{secret [%s | format (item)]}}
     with_items:
       - "user1"
       - "user2"
```


#### running ansible-playbook:
When wrapping and running `ansible-playbook` as follows, the value of` SECRET_JSON_KMS` is decrypted and set as `SECRET_JSON` and passed to` ansible-playbook`.
```bash
$ SECRET_JSON_KMS="hZGLgZvuacL2TiyoCQ1HLGq1k5GJgYP..." kmscrypter ansible-playbook site.yml
```
or
```bash
$ export SECRET_JSON_KMS="hZGLgZvuacL2TiyoCQ1HLGq1k5GJgYP..."
$ kmscrypter ansible-playbook site.yml
```

