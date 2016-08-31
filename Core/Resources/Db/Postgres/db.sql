CREATE TABLE addressbooks (
    id SERIAL NOT NULL,
    principaluri VARCHAR(255),
    displayname VARCHAR(255),
    uri VARCHAR(200),
    description TEXT,
    synctoken INTEGER NOT NULL DEFAULT 1
);
ALTER TABLE ONLY addressbooks
    ADD CONSTRAINT addressbooks_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX addressbooks_ukey
    ON addressbooks USING btree (principaluri, uri);

CREATE TABLE cards (
    id SERIAL NOT NULL,
    addressbookid INTEGER NOT NULL,
    carddata BYTEA,
    uri VARCHAR(200),
    lastmodified INTEGER,
    etag VARCHAR(32),
    size INTEGER NOT NULL
);

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX cards_ukey
    ON cards USING btree (addressbookid, uri);

CREATE TABLE addressbookchanges (
    id SERIAL NOT NULL,
    uri VARCHAR(200) NOT NULL,
    synctoken INTEGER NOT NULL,
    addressbookid INTEGER NOT NULL,
    operation SMALLINT NOT NULL
);

ALTER TABLE ONLY addressbookchanges
    ADD CONSTRAINT addressbookchanges_pkey PRIMARY KEY (id);

CREATE INDEX addressbookchanges_addressbookid_synctoken_ix
ON addressbookchanges USING btree (addressbookid, synctoken);

CREATE TABLE calendarobjects (
    id SERIAL NOT NULL,
    calendardata BYTEA,
    uri VARCHAR(200),
    calendarid INTEGER NOT NULL,
    lastmodified INTEGER,
    etag VARCHAR(32),
    size INTEGER NOT NULL,
    componenttype VARCHAR(8),
    firstoccurence INTEGER,
    lastoccurence INTEGER,
    uid VARCHAR(200)
);

ALTER TABLE ONLY calendarobjects
    ADD CONSTRAINT calendarobjects_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX calendarobjects_ukey
    ON calendarobjects USING btree (calendarid, uri);


CREATE TABLE calendars (
    id SERIAL NOT NULL,
    synctoken INTEGER NOT NULL DEFAULT 1,
    components VARCHAR(21)
);

ALTER TABLE ONLY calendars
    ADD CONSTRAINT calendars_pkey PRIMARY KEY (id);


CREATE TABLE calendarinstances (
    id SERIAL NOT NULL,
    calendarid INTEGER NOT NULL,
    principaluri VARCHAR(100),
    access SMALLINT NOT NULL DEFAULT '1', -- '1 = owner, 2 = read, 3 = readwrite'
    displayname VARCHAR(100),
    uri VARCHAR(200),
    description TEXT,
    calendarorder INTEGER NOT NULL DEFAULT 0,
    calendarcolor VARCHAR(10),
    timezone TEXT,
    transparent SMALLINT NOT NULL DEFAULT '0',
    share_href VARCHAR(100),
    share_displayname VARCHAR(100),
    share_invitestatus SMALLINT NOT NULL DEFAULT '2' --  '1 = noresponse, 2 = accepted, 3 = declined, 4 = invalid'
);

ALTER TABLE ONLY calendarinstances
    ADD CONSTRAINT calendarinstances_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX calendarinstances_principaluri_uri
    ON calendarinstances USING btree (principaluri, uri);


CREATE UNIQUE INDEX calendarinstances_principaluri_calendarid
    ON calendarinstances USING btree (principaluri, calendarid);

CREATE UNIQUE INDEX calendarinstances_principaluri_share_href
    ON calendarinstances USING btree (principaluri, share_href);

CREATE TABLE calendarsubscriptions (
    id SERIAL NOT NULL,
    uri VARCHAR(200) NOT NULL,
    principaluri VARCHAR(100) NOT NULL,
    source TEXT,
    displayname VARCHAR(100),
    refreshrate VARCHAR(10),
    calendarorder INTEGER NOT NULL DEFAULT 0,
    calendarcolor VARCHAR(10),
    striptodos SMALLINT NULL,
    stripalarms SMALLINT NULL,
    stripattachments SMALLINT NULL,
    lastmodified INTEGER
);

ALTER TABLE ONLY calendarsubscriptions
    ADD CONSTRAINT calendarsubscriptions_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX calendarsubscriptions_ukey
    ON calendarsubscriptions USING btree (principaluri, uri);

CREATE TABLE calendarchanges (
    id SERIAL NOT NULL,
    uri VARCHAR(200) NOT NULL,
    synctoken INTEGER NOT NULL,
    calendarid INTEGER NOT NULL,
    operation SMALLINT NOT NULL DEFAULT 0
);

ALTER TABLE ONLY calendarchanges
    ADD CONSTRAINT calendarchanges_pkey PRIMARY KEY (id);

CREATE INDEX calendarchanges_calendarid_synctoken_ix
    ON calendarchanges USING btree (calendarid, synctoken);

CREATE TABLE schedulingobjects (
    id SERIAL NOT NULL,
    principaluri VARCHAR(255),
    calendardata BYTEA,
    uri VARCHAR(200),
    lastmodified INTEGER,
    etag VARCHAR(32),
    size INTEGER NOT NULL
);

CREATE TABLE principals (
    id SERIAL NOT NULL,
    uri VARCHAR(200) NOT NULL,
    email VARCHAR(80),
    displayname VARCHAR(80)
);

ALTER TABLE ONLY principals
    ADD CONSTRAINT principals_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX principals_ukey
    ON principals USING btree (uri);

CREATE TABLE groupmembers (
    id SERIAL NOT NULL,
    principal_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL
);

ALTER TABLE ONLY groupmembers
    ADD CONSTRAINT groupmembers_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX groupmembers_ukey
    ON groupmembers USING btree (principal_id, member_id);

-- INSERT INTO principals (uri,email,displayname) VALUES
-- ('principals/admin', 'admin@example.org','Administrator'),
-- ('principals/admin/calendar-proxy-read', null, null),
-- ('principals/admin/calendar-proxy-write', null, null);

CREATE TABLE propertystorage (
    id SERIAL NOT NULL,
    path VARCHAR(1024) NOT NULL,
    name VARCHAR(100) NOT NULL,
    valuetype INT,
    value BYTEA
);

ALTER TABLE ONLY propertystorage
    ADD CONSTRAINT propertystorage_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX propertystorage_ukey
ON propertystorage (path, name);

CREATE TABLE users (
    id SERIAL NOT NULL,
    username VARCHAR(50),
    digesta1 VARCHAR(32)
);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX users_ukey
    ON users USING btree (username);

-- INSERT INTO users (username,digesta1) VALUES
-- ('admin', '87fd274b7b6c01e48d7c2f965da8ddf7');
