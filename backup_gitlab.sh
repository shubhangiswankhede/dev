#!/bin/bash
set -e
set -x

KEY='/opt/jenkins_home/.ssh/id_rsa'
BACKUP_FILES='*_gitlab_backup.tar'
GITLAB_DIR='/var/git/gitlab/tmp/backups'
USER='chefsolo'
GITLAB_HOST='mdc2vr4083'
BACKUP_HOST='esu2v326'
BACKUP_DIR='/seci/gitlab_backup'
CMD="export rvmsudo_secure_path=1; \
cd /var/git/gitlab; \
rvmsudo -u git -H bundle exec rake gitlab:backup:create RAILS_ENV=production"

#do backup
ssh -i ${KEY} ${USER}@${GITLAB_HOST}  ${CMD}

#download backup file
scp -i ${KEY} ${USER}@${GITLAB_HOST}:${GITLAB_DIR}/${BACKUP_FILES} .

#delete backup file on the GitLab server
ssh -i ${KEY} ${USER}@${GITLAB_HOST} sudo rm -f ${GITLAB_DIR}/${BACKUP_FILES}

#delete backup files older than 30 days
ssh -i ${KEY} ${USER}@${BACKUP_HOST} sudo find ${BACKUP_DIR} -ctime +30 -delete

#upload fresh backup
scp -i ${KEY} ${BACKUP_FILES} ${USER}@${BACKUP_HOST}:${BACKUP_DIR}/

#clean workdir
rm -f ./${BACKUP_FILES}
