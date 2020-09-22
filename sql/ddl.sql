
CREATE TABLE meshblock_detail (
  mb_code16 varchar(11) NULL,
  mb_category_name_2016 text NULL,
  area_albers_sqkm float8 NULL,
  dwelling float8 NULL,
  person float8 NULL,
  state float8 NULL,
  ra_code16 varchar(2) NULL,
  sa1_main16 varchar(11) NULL
);
CREATE UNIQUE INDEX meshblock_detail_mb_code16_idx ON public.meshblock_detail USING btree (mb_code16);

ALTER TABLE meshblock_detail 
ADD CONSTRAINT meshblock_detail_fk1
FOREIGN KEY (ra_code16) 
REFERENCES  remote_detail(ra_code16);

ALTER TABLE meshblock_detail 
ADD CONSTRAINT meshblock_detail_fk2
FOREIGN KEY (sa1_main16) 
REFERENCES  sa1_seifa(sa1_main16);

-- public.meshblock_statistics definition

-- Drop table

-- DROP TABLE meshblock_statistics;

CREATE TABLE meshblock_statistics (
  mb_code16 varchar(11) NULL,
  distance int4 NULL,
  mb_category_name_2016 text NULL,
  intersection_area float8 NULL,
  population_covered float8 NULL,
  dwelling_covered float8 NULL,
  n_mb int8 NULL,
  category_proportion numeric NULL
);
CREATE UNIQUE INDEX ON public.meshblock_statistics USING btree (mb_code16, distance);

ALTER TABLE meshblock_statistics 
ADD CONSTRAINT meshblock_statistics_fk1
FOREIGN KEY (mb_code16) 
REFERENCES  meshblock_detail(mb_code16);

-- public.meshblock_concordance definition

-- Drop table

-- DROP TABLE meshblock_concordance;

CREATE TABLE meshblock_concordance (
  mb_code16 varchar(11) NULL,
  to_mb_code16 varchar(11) NULL,
  distance int4 NULL,
  intersection_area float8 NULL,
  proportion_covered numeric NULL,
  population_covered float8 NULL,
  dwelling_covered float8 NULL
);

CREATE UNIQUE INDEX ON public.meshblock_concordance USING btree (mb_code16, to_mb_code16, distance);

ALTER TABLE meshblock_concordance 
ADD CONSTRAINT meshblock_concordance_fk1
FOREIGN KEY (mb_code16) 
REFERENCES  meshblock_detail(mb_code16);


-- public.remoteness definition

-- Drop table

-- DROP TABLE remoteness;

CREATE TABLE remote_detail (
  ra_code16 varchar(2) NULL,
  ra_name16 varchar(50) NULL,
  CONSTRAINT remote_detail_pkey PRIMARY KEY (ra_code16)
);

create table remote_detail as 
select ra_code16, ra_name16 from remoteness;



-- public.sa1_seifa definition

-- Drop table

-- DROP TABLE sa1_seifa;

CREATE TABLE sa1_seifa (
  sa1_7dig16 varchar(7) NULL,
  sa1_main16 varchar(11) NULL,
  irsd numeric NULL,
  irsad numeric NULL,
  ier numeric NULL,
  ieo numeric NULL
);
