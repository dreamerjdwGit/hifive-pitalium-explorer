
\c true

\p ******* DROP TABLE START *******

DROP TABLE Config;
DROP TABLE ProcessedImage;
DROP TABLE Area;
DROP TABLE Target;
DROP TABLE Screenshot;
DROP TABLE TestEnvironment;
DROP TABLE TestExecution;

\p ******* DROP TABLE END *******

\p ******* DROP SEQUENCE START *******

DROP SEQUENCE Seq_Target;
DROP SEQUENCE Seq_Area;
DROP SEQUENCE Seq_Screenshot;
DROP SEQUENCE Seq_TestEnvironment;
DROP SEQUENCE Seq_TestExecution;

\p ******* DROP SEQUENCE END *******

\c false

\p ******* CREATE SEQUENCE START *******

CREATE SEQUENCE Seq_TestExecution AS INTEGER START WITH 1;
CREATE SEQUENCE Seq_TestEnvironment AS INTEGER START WITH 1;
CREATE SEQUENCE Seq_Screenshot AS INTEGER START WITH 1;
CREATE SEQUENCE Seq_Target AS INTEGER START WITH 1;
CREATE SEQUENCE Seq_Area AS INTEGER START WITH 1;

\p ******* CREATE SEQUENCE END *******

\p ******* CREATE TABLE START *******

CREATE TABLE Config (
	key VARCHAR(100),
	value VARCHAR(500),
	PRIMARY KEY (key)
);

CREATE TABLE TestExecution (
	id INTEGER GENERATED BY DEFAULT AS SEQUENCE Seq_TestExecution,
	label VARCHAR(100),
	time TIMESTAMP(0) NOT NULL, /* UTC */
	execResult VARCHAR(10),
	PRIMARY KEY (id)
);

CREATE TABLE TestEnvironment (
	id INTEGER GENERATED BY DEFAULT AS SEQUENCE Seq_TestEnvironment,
	label VARCHAR(100),
	platform VARCHAR(100),
	platformVersion VARCHAR(100),
	deviceName VARCHAR(100),
	browserName VARCHAR(100),
	browserVersion VARCHAR(100),
	PRIMARY KEY (id)
);

CREATE TABLE Screenshot (
	id INTEGER GENERATED BY DEFAULT AS SEQUENCE Seq_Screenshot,
	screenshotName VARCHAR(100) NOT NULL, 
	expectedId INTEGER,
	fileName VARCHAR(260) NOT NULL,
	comparisonResult BOOLEAN,
	testClass VARCHAR(100) NOT NULL,
	testMethod VARCHAR(100) NOT NULL,
	testScreen VARCHAR(100) NOT NULL,
	testExecutionId INTEGER NOT NULL,
	testEnvironmentId INTEGER NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (expectedId) REFERENCES Screenshot (id),
	FOREIGN KEY (testExecutionId) REFERENCES TestExecution (id),
	FOREIGN KEY (testEnvironmentId) REFERENCES TestEnvironment (id)
);

CREATE TABLE Target (
	targetId int NOT NULL,
	screenshotId int NOT NULL,
	fileName VARCHAR(260) NOT NULL,
	comparisonResult boolean,
	PRIMARY KEY (targetId),
	FOREIGN KEY (screenshotId) REFERENCES Screenshot (id)
);

CREATE TABLE Area (
	areaId int NOT NULL,
	targetId int NOT NULL,
	selectorValue varchar(20) NOT NULL,
	selectorType varchar(20) NOT NULL,
	selectorIndex int,
	x decimal(5,1) NOT NULL,
	y decimal(5,1) NOT NULL,
	width decimal(5,1) NOT NULL,
	height decimal(5,1) NOT NULL,
	excluded boolean NOT NULL,
	PRIMARY KEY (areaId),
	FOREIGN KEY (targetId) REFERENCES Target (targetId)
);

CREATE TABLE ProcessedImage (
	screenshotId INTEGER NOT NULL,
	algorithm VARCHAR(100) NOT NULL,
	fileName VARCHAR(260) NOT NULL,
	PRIMARY KEY (screenshotId, algorithm),
	FOREIGN KEY (screenshotId) REFERENCES Screenshot (id)
);

\p ******* CREATE TABLE END *******

\p ******* CREATE INDEX START *******

CREATE INDEX Idx_TestExecutionTime ON TestExecution (time);

\p ******* CREATE INDEX END *******
