DO
$$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'urv_app') THEN
    CREATE ROLE urv_app LOGIN PASSWORD 'urv_app_password';
  END IF;
END
$$;

CREATE DATABASE urv_development OWNER urv_app;
CREATE DATABASE urv_test        OWNER urv_app;

GRANT ALL PRIVILEGES ON DATABASE urv_development TO urv_app;
GRANT ALL PRIVILEGES ON DATABASE urv_test        TO urv_app;