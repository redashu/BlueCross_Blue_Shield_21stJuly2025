# Commands to set up psql DB

1. sudo apt install wget ca-certificates

2. wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

3. sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

4. sudo apt update

5. sudo apt install postgresql postgresql-contrib

6. service postgresql status

7. sudo -u postgres psql

8. \password postgres

9. CREATE DATABASE dynatrace;

10. \c dynatrace

11. create table employees (employee_number int8, lastname varchar, name varchar, gender varchar, city varchar, job_title varchar, department varchar, store_location varchar, division varchar, age float8, 
length_service float8, abset_hours float8, business_unit varchar);

12. scp -i .ssh/"dynatracecase.pem" absenteeism.csv  ubuntu@<your-ip>:/home/ubuntu
hom
13. \copy employees FROM 'absenteeism.csv' DELIMITER ',' CSV;

14. sudo vim /etc/postgresql/16/main/postgresql.conf
    listen_addresses = '*'

15. sudo vim /etc/postgresql/16/main/pg_hba.conf
    host all all 0.0.0.0/0 md5

16. sudo systemctl restart postgresql

17. ss -nlt | grep 5432

18. CREATE USER dynatrace WITH PASSWORD 'yourpasswordhere' INHERIT;

19. GRANT pg_monitor TO dynatrace;
\
20. ALTER USER dynatrace WITH SUPERUSER;

21. Connect using local psql
psql -h <your-ip-here> -p 5432 -d dynatrace -U postgres

22.  Connect using DBeaver









