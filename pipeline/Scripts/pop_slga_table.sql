SET search_path TO data_schema;

CREATE TABLE slga_EDGE_GEOCODE_PUBLICSCH_1718 (
    ncessch VARCHAR(12),
    name VARCHAR(60),
    opstfips VARCHAR(2),
    street VARCHAR(59),
    city VARCHAR(26),
    state VARCHAR(2),
    zip VARCHAR(5),
    stfip VARCHAR(2),
    cnty VARCHAR(5),
    nmcnty VARCHAR(33),
    locale VARCHAR(2),
    lat VARCHAR(20),
    lon VARCHAR(20),
    cbsa VARCHAR(5),
    nmcbsa VARCHAR(46),
    cbsatype VARCHAR(1),
    csa VARCHAR(3),
    nmcsa VARCHAR(58),
    necta VARCHAR(5),
    nmnecta VARCHAR(40),
    cd VARCHAR(4),
    sldl VARCHAR(5),
    sldu VARCHAR(5),
    schoolyear VARCHAR(9)
);
COPY slga_EDGE_GEOCODE_PUBLICSCH_1718 FROM '/home/Data/EDGE_GEOCODE_PUBLICSCH_1718.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';