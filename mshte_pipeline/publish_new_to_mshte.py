import json
import os
import re
import subprocess
import sys


def usage(err):
    print(err)
    print("\n\nUsage:\nInstall to chef workstation and run..." +
          "\npython " + sys.argv[0].split('/')[-1] + " [cookbook]\n")
    sys.exit(1)


def check_process(p, err):
    if p.returncode != 0:
        raise Exception(err)


def to_tuple(str):
    return tuple(int(x) for x in str.split('.'))


def get_supermarket_versions(cookbook):
    print('Getting versions of ' + cookbook + ' from supermarket...')
    p = subprocess.Popen(
        [
            'knife', 'cookbook', 'site', 'show', cookbook,
            '-F', 'json'
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    check_process(p, stderr)
    j = json.loads(stdout)
    versions = map(
        lambda x: re.search(r'[0-9]+\.[0-9]+\.[0-9]+', x).group(),
        map(lambda x: x.encode('utf-8'), j['versions']))
    return versions


def get_chefserver_latest_version(cookbook):
    print('Getting latest version of ' + cookbook + ' from chef server...')
    p = subprocess.Popen(
        [
            'knife', 'cookbook', 'show', cookbook,
            '-F', 'json'
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    if p.returncode != 0:
        return

    # Only reach this code if the cookbook is found.
    j = json.loads(stdout)
    versions = map(lambda x: x.encode('utf-8'), j)
    return re.search(r'[0-9]+\.[0-9]+\.[0-9]+', versions[0]).group()


def upload_to_chefserver(cookbook, version):
    print('Installing ' + cookbook + ' ' + version +
          ' and its dependencies locally...')
    print('This may take a while...')
    p = subprocess.Popen(
        [
            'knife', 'cookbook', 'site', 'install', cookbook, version
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    check_process(p, stderr)

    print('Uploading ' + cookbook + ' ' + version +
          ' and its dependencies to chef server...')
    p = subprocess.Popen(
        [
            'knife', 'cookbook', 'upload', cookbook,
            '--include-dependencies', '--freeze'
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = p.communicate()
    check_process(p, stderr)


try:
    # Force system locale to use the same encoding that we use.
    os.environ['LC_ALL'] = 'en_US.UTF-8'

    cookbook = sys.argv[1]

    sm_versions = get_supermarket_versions(cookbook)
    cs_latest_version = get_chefserver_latest_version(cookbook)

    if cs_latest_version is not None:
        i = 0
        while (i < len(sm_versions) and
               to_tuple(sm_versions[i]) > to_tuple(cs_latest_version)):
            upload_to_chefserver(cookbook, sm_versions[i])
            i += 1
        if i == 0:
            print('Chef server is up to date with ' + cookbook + ' ' +
                  cs_latest_version + '.')
    else:
        upload_to_chefserver(cookbook, sm_versions[0])


except Exception as err:
    usage(err)
