heroku pgbackups:capture --app ucbpblmembersportal --expire
rm latest.dump
touch latest.dump
BACKUP_URL=$(heroku pgbackups:url --app ucbpblmembersportal)
curl -o latest.dump "$BACKUP_URL"

rake db:drop
rake db:create
pg_restore -d ucbpblmembersportal_development -e -h localhost -w latest.dump
