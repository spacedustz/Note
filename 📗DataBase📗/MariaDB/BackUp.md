
```bash
## BackUp
mariadb-dump -u root -p {DB명} > {파일명}.sql

## Restore
mariadb -u root -p {DB명} < {백업파일명}.sql
```