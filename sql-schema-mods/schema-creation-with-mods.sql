CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE circuit (
    id SERIAL PRIMARY KEY, --circuitId
    alias CITEXT, --circuitRef
    name CITEXT,
    location CITEXT,
    country CITEXT,
    latitude numeric,
    longitude numeric,
    altitude numeric,
    url CITEXT
)
;


CREATE TABLE constructor (
    id SERIAL PRIMARY KEY, -- constructorId
    alias CITEXT, --constructorRef
    name CITEXT,
    nationality CITEXT,
    url CITEXT
)
;

CREATE TABLE driver (
    id SERIAL PRIMARY KEY, -- driverId
    alias CITEXT, --driverRef
    number SMALLINT,
    code VARCHAR(3),
    first_name CITEXT, --forename
    last_name CITEXT, --lastname
    born_date DATE,
    nationality CITEXT,
    url CITEXT
)
;

CREATE TABLE season (
    id INT PRIMARY KEY, -- year
    url CITEXT
)
;

CREATE TABLE status (
    id INT PRIMARY KEY, -- statusId
    description CITEXT --status
)
;

CREATE TABLE race (
    id INT PRIMARY KEY, --raceId
    year INT,
    round INT,
    circuit_id INT REFERENCES circuit (id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    name CITEXT,
    date DATE,
    time TIME,
    url CITEXT
)
;

CREATE TABLE qualifying_session (
    id INT PRIMARY KEY, --qualifyId
    race_id INT REFERENCES race (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    driver_id INT REFERENCES driver (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    constructor_id INT REFERENCES constructor (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    number INT,
    position INT,
    q1_time INTERVAL, --q1
    q2_time INTERVAL,
    q3_time INTERVAL
)
;

CREATE TABLE race_result (
    id INT PRIMARY KEY, --resultId
    race_id INT REFERENCES race (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    driver_id INT REFERENCES driver (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    constructor_id INT REFERENCES constructor (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    number INT,
    grid INT,
    position INT,
    position_text TEXT,
    position_order INT,
    points INT,
    laps INT,
    interval_time TEXT,
    milliseconds INT,
    fastest_lap_number INT,
    fastest_lap_time INTERVAL,
    fastest_lap_speed NUMERIC,
    status_id INT REFERENCES status (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
)
;

CREATE TABLE driver_standing (
    id INT PRIMARY KEY, --driverStandingsId
    race_id INT REFERENCES race (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    driver_id INT REFERENCES driver (id)
        ON DELETE RESTRICT ON UPDATE CASCADE, 
    points INT,
    position INT,
    position_text TEXT,
    wins INTEGER
)
;

CREATE TABLE constructor_result (
    id INT PRIMARY KEY, --constructorResultsId
    race_id INT REFERENCES race (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    constructor_id INT REFERENCES constructor (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    points INT,
    status TEXT
)
;

CREATE TABLE lap_time (
    id BIGSERIAL PRIMARY KEY,
    race_id INT REFERENCES race (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    driver_id INT REFERENCES driver (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    lap INT,
    position INT,
    time INTERVAL,
    miliseconds INT
)
;

CREATE TABLE pit_stop (
    id SERIAL PRIMARY KEY,
    race_id INT REFERENCES race (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    driver_id INT REFERENCES driver (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    stop INT,
    lap INT,
    time INTERVAL,
    duration INTERVAL,
    miliseconds INT
)
;


ALTER TABLE lap_time ADD COLUMN time_str TEXT;
ALTER TABLE lap_time RENAME COLUMN miliseconds TO milliseconds;
ALTER TABLE lap_time DROP COLUMN time;
ALTER TABLE lap_time RENAME COLUMN time_str TO time;
ALTER TABLE pit_stop ALTER COLUMN time TYPE TEXT;
ALTER TABLE pit_stop ALTER COLUMN duration TYPE TEXT;
ALTER TABLE pit_stop ALTER COLUMN duration TYPE NUMERIC USING duration::numeric;
ALTER TABLE pit_stop RENAME COLUMN miliseconds TO milliseconds;
ALTER TABLE qualifying_session ALTER COLUMN q1_time TYPE TEXT;
ALTER TABLE qualifying_session ALTER COLUMN q2_time TYPE TEXT;
ALTER TABLE qualifying_session ALTER COLUMN q3_time TYPE TEXT;
ALTER TABLE qualifying_session ADD COLUMN q1_time_milliseconds INT;
ALTER TABLE qualifying_session ADD COLUMN q2_time_milliseconds INT;
ALTER TABLE qualifying_session ADD COLUMN q3_time_milliseconds INT;
ALTER TABLE race_result ALTER COLUMN fastest_lap_time TYPE TEXT;
ALTER TABLE race_result ADD COLUMN fastest_lap_milliseconds INT;
ALTER TABLE race_result ADD COLUMN rank INT;

CREATE TABLE era (
    id SERIAL PRIMARY KEY,
    year_begin INT,
    year_end INT,
    date_begin DATE,
    date_end DATE,
    alias CITEXT,
    name CITEXT,
    period CITEXT,
    url CITEXT,
    alias2 CITEXT
)
;

CREATE OR REPLACE FUNCTION public.select_era(year INTEGER)
    RETURNS INTEGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    
    AS $BODY$

    DECLARE
    era_id INTEGER;

    BEGIN
        SELECT id INTO era_id FROM
        public.era WHERE ((
            (year > era.year_begin) AND
            (year < era.year_end)) OR
            era.year_begin = year 
            OR 
            era.year_end = year);

    RETURN era_id;
    END;
    $BODY$
    ;


ALTER TABLE race ADD COLUMN era_id INT REFERENCES era (id)
        ON DELETE RESTRICT ON UPDATE CASCADE;

UPDATE race SET era_id = public.select_era(race.year);

ALTER TABLE race ADD COLUMN season_last_round BOOL;

UPDATE race SET season_last_round = False;

UPDATE race
SET season_last_round = True
WHERE (year, round) IN (
        SELECT year, max(round) AS last_round 
        FROM race
        GROUP BY year)
    ;

UPDATE race 
SET season_last_round = False
WHERE id = 1048 ;

