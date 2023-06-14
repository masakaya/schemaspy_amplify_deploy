# schemaspy_amplify_deploy

## Sample database 

https://www.mysqltutorial.org/mysql-sample-database.aspx

![ERD](./screenshot/MySQL-Sample-Database-Schema.png)


## Build database.

1. Create DDL file ( `ddl/V{NUMBER}__sqlname.sql` )
2. docker-compose up

## Extra Command.

### Check migration info

**Check baseline**
```
docker-compose --profile extra up flyway-baseline
```

**Check Migration Info**
```
docker-compose --profile extra up flyway-info
```
