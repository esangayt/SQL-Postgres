-- -------------------------------------------------------------
-- TablePlus 5.3.8(500)
--
-- https://tableplus.com/
--
-- Database: medium
-- Generation Time: 2023-07-26 10:19:07.4290
-- -------------------------------------------------------------


DROP TABLE IF EXISTS "public"."followers";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS followers_id_seq;

-- Table Definition
CREATE TABLE "public"."followers" (
    "id" int4 NOT NULL DEFAULT nextval('followers_id_seq'::regclass),
    "leader_id" int4 NOT NULL,
    "follower_id" int4 NOT NULL,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."user";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_id_seq1;

-- Table Definition
CREATE TABLE "public"."user" (
    "id" int4 NOT NULL DEFAULT nextval('user_id_seq1'::regclass),
    "name" varchar NOT NULL,
    "birthday" date,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."user" ("id", "name", "birthday") VALUES
(1, 'Morgan Freeman', '1937-06-01'),
(2, 'Elon Musk', '1971-06-28'),
(3, 'Keanu Reeves', '1964-09-02'),
(4, 'Robin Williams', '1951-07-21'),
(5, 'Tom Hanks', '1956-07-09'),
(6, 'Harrison Ford', '1942-07-13'),
(7, 'Nicole Kidman', '1967-06-20'),
(8, 'Julia Roberts', '1967-10-28'),
(9, 'Nicolas Cage', '1964-01-07'),
(10, 'Bill Murray', '1950-10-21'),
(11, 'Bruce Lee', '1940-11-27');

ALTER TABLE "public"."followers" ADD FOREIGN KEY ("follower_id") REFERENCES "public"."user"("id");
ALTER TABLE "public"."followers" ADD FOREIGN KEY ("leader_id") REFERENCES "public"."user"("id");
