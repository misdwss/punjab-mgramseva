FROM egovio/flyway:4.1.2

COPY ./migration/main /flyway/sql
<<<<<<< HEAD:municipal-services/property-services/src/main/resources/db/Dockerfile
=======

COPY ./migration/dev /flyway/dev

COPY ./migration/seed /flyway/seed
>>>>>>> master:core-services/egov-pg-service/src/main/resources/db/Dockerfile

COPY migrate.sh /usr/bin/migrate.sh

RUN chmod +x /usr/bin/migrate.sh

CMD ["/usr/bin/migrate.sh"]
