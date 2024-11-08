library(DBI)
library(RSQLite)

Final_db <- dbConnect (RSQLite::SQLite(), "Final.db")

#Table for Lamprey
dbExecute(Final_db,
          "CREATE TABLE Lamprey (
    [Lamprey ID]   TEXT    PRIMARY KEY
                           NOT NULL,
    [Capture Site] TEXT    NOT NULL,
    [Release Site] TEXT    NOT NULL,
    [Genetic ID]   INTEGER
);
")

#Table for Capture Site
dbExecute(Final_db,
          "CREATE TABLE [Capture Site] (
    [Capture Site] TEXT    PRIMARY KEY
                           NOT NULL,
    [Utm X]        INTEGER NOT NULL,
    [Utm Y]        INTEGER NOT NULL
);
")

#Table for Captures
dbExecute(Final_db,
          "CREATE TABLE Captures (
    [Capture ID]   TEXT PRIMARY KEY
                        NOT NULL,
    [Lamprey ID]   TEXT REFERENCES Lamprey ([Lamprey ID]) MATCH SIMPLE
                        NOT NULL,
    [Capture Site] TEXT REFERENCES [Capture Site] ([Capture Site]) MATCH SIMPLE,
    Date           TEXT NOT NULL
);
")

#Table for Morphometrics
dbExecute(Final_db,
          "CREATE TABLE Morphometrics (
    [Measurement ID] TEXT    PRIMARY KEY
                             NOT NULL,
    Length           NUMERIC,
    Girth            NUMERIC,
    [Genetic ID]     INTEGER,
    [Lamprey ID]     TEXT    REFERENCES Lamprey ([Lamprey ID]) MATCH SIMPLE
                             NOT NULL
);
")

#Table for Tags
dbExecute(Final_db,
          "CREATE TABLE Tags (
    [PIT Tag #]  TEXT PRIMARY KEY
                      NOT NULL,
    Status       TEXT,
    [Lamprey ID] TEXT REFERENCES Lamprey ([Lamprey ID]) MATCH SIMPLE
);
")