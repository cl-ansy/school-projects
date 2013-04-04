
CREATE TABLE CONTROL_PARAMETER
(
	param_name           CHAR(18) NOT NULL ,
	legal_range          CHAR(18) NULL ,
	filter_name          CHAR(18) NOT NULL ,
	control_value        CHAR(18) NULL ,
	stage_ID             CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKCONTROL_PARAMETER ON CONTROL_PARAMETER
(param_name   ASC,filter_name   ASC,stage_ID   ASC);

ALTER TABLE CONTROL_PARAMETER
	ADD CONSTRAINT  XPKCONTROL_PARAMETER PRIMARY KEY (param_name,filter_name,stage_ID);

CREATE TABLE FILTER
(
	filter_name          CHAR(18) NOT NULL ,
	Number_of_required_inputs CHAR(18) NULL ,
	stage_ID             CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKFILTER ON FILTER
(filter_name   ASC);

ALTER TABLE FILTER
	ADD CONSTRAINT  XPKFILTER PRIMARY KEY (filter_name);

CREATE TABLE INPUT_STAGE_PARAMETER
(
	control_value        CHAR(18) NULL ,
	stage_ID             CHAR(18) NOT NULL ,
	param_name           CHAR(18) NULL ,
	filter_name          CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKINPUT_STAGE_PARAMETER ON INPUT_STAGE_PARAMETER
(stage_ID   ASC);

ALTER TABLE INPUT_STAGE_PARAMETER
	ADD CONSTRAINT  XPKINPUT_STAGE_PARAMETER PRIMARY KEY (stage_ID);

CREATE TABLE PIPE
(
	Pipe_ID              CHAR(18) NOT NULL ,
	pipeline_ID          CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKPIPE ON PIPE
(Pipe_ID   ASC,pipeline_ID   ASC);

ALTER TABLE PIPE
	ADD CONSTRAINT  XPKPIPE PRIMARY KEY (Pipe_ID,pipeline_ID);

CREATE TABLE PIPE_D_PROC_CONNECTION
(
	pipe_con_id          CHAR(18) NOT NULL ,
	Pipe_ID              CHAR(18) NULL ,
	pipeline_ID          CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKPIPE_D_PROC_CONNECTION ON PIPE_D_PROC_CONNECTION
(pipe_con_id   ASC);

ALTER TABLE PIPE_D_PROC_CONNECTION
	ADD CONSTRAINT  XPKPIPE_D_PROC_CONNECTION PRIMARY KEY (pipe_con_id);

CREATE TABLE PIPE_SPLITTER
(
	input_pipe           CHAR(18) NOT NULL ,
	output_pipe          CHAR(18) NOT NULL ,
	Pipe_ID              CHAR(18) NOT NULL ,
	pipeline_ID          CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKPIPE_SPLITTER ON PIPE_SPLITTER
(input_pipe   ASC,output_pipe   ASC,Pipe_ID   ASC,pipeline_ID   ASC);

ALTER TABLE PIPE_SPLITTER
	ADD CONSTRAINT  XPKPIPE_SPLITTER PRIMARY KEY (input_pipe,output_pipe,Pipe_ID,pipeline_ID);

CREATE TABLE PIPELINE
(
	pipeline_ID          CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKPIPELINE ON PIPELINE
(pipeline_ID   ASC);

ALTER TABLE PIPELINE
	ADD CONSTRAINT  XPKPIPELINE PRIMARY KEY (pipeline_ID);

CREATE TABLE STAGE
(
	stage_ID             CHAR(18) NOT NULL ,
	Pipe_ID              CHAR(18) NULL ,
	pipeline_ID          CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKSTAGE ON STAGE
(stage_ID   ASC);

ALTER TABLE STAGE
	ADD CONSTRAINT  XPKSTAGE PRIMARY KEY (stage_ID);

ALTER TABLE CONTROL_PARAMETER
	ADD (CONSTRAINT R_10 FOREIGN KEY (filter_name) REFERENCES FILTER (filter_name));

ALTER TABLE CONTROL_PARAMETER
	ADD (CONSTRAINT R_14 FOREIGN KEY (stage_ID) REFERENCES STAGE (stage_ID));

ALTER TABLE FILTER
	ADD (CONSTRAINT R_8 FOREIGN KEY (stage_ID) REFERENCES STAGE (stage_ID) ON DELETE SET NULL);

ALTER TABLE INPUT_STAGE_PARAMETER
	ADD (CONSTRAINT R_9 FOREIGN KEY (stage_ID) REFERENCES STAGE (stage_ID));

ALTER TABLE INPUT_STAGE_PARAMETER
	ADD (CONSTRAINT R_11 FOREIGN KEY (param_name, filter_name, stage_ID) REFERENCES CONTROL_PARAMETER (param_name, filter_name, stage_ID) ON DELETE SET NULL);

ALTER TABLE PIPE
	ADD (CONSTRAINT R_5 FOREIGN KEY (pipeline_ID) REFERENCES PIPELINE (pipeline_ID));

ALTER TABLE PIPE_D_PROC_CONNECTION
	ADD (CONSTRAINT R_1 FOREIGN KEY (Pipe_ID, pipeline_ID) REFERENCES PIPE (Pipe_ID, pipeline_ID) ON DELETE SET NULL);

ALTER TABLE PIPE_D_PROC_CONNECTION
	ADD (CONSTRAINT R_2 FOREIGN KEY (Pipe_ID, pipeline_ID) REFERENCES PIPE (Pipe_ID, pipeline_ID) ON DELETE SET NULL);

ALTER TABLE PIPE_SPLITTER
	ADD (CONSTRAINT R_3 FOREIGN KEY (Pipe_ID, pipeline_ID) REFERENCES PIPE (Pipe_ID, pipeline_ID));

ALTER TABLE PIPE_SPLITTER
	ADD (CONSTRAINT R_4 FOREIGN KEY (Pipe_ID, pipeline_ID) REFERENCES PIPE (Pipe_ID, pipeline_ID));

ALTER TABLE STAGE
	ADD (CONSTRAINT R_7 FOREIGN KEY (Pipe_ID, pipeline_ID) REFERENCES PIPE (Pipe_ID, pipeline_ID) ON DELETE SET NULL);

CREATE  TRIGGER  tD_CONTROL_PARAMETER AFTER DELETE ON CONTROL_PARAMETER for each row
-- ERwin Builtin Trigger
-- DELETE trigger on CONTROL_PARAMETER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* CONTROL_PARAMETER  INPUT_STAGE_PARAMETER on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00014205", PARENT_OWNER="", PARENT_TABLE="CONTROL_PARAMETER"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="param_name""filter_name""stage_ID" */
    UPDATE INPUT_STAGE_PARAMETER
      SET
        /* %SetFK(INPUT_STAGE_PARAMETER,NULL) */
        INPUT_STAGE_PARAMETER.param_name = NULL,
        INPUT_STAGE_PARAMETER.filter_name = NULL,
        INPUT_STAGE_PARAMETER.stage_ID = NULL
      WHERE
        /* %JoinFKPK(INPUT_STAGE_PARAMETER,:%Old," = "," AND") */
        INPUT_STAGE_PARAMETER.param_name = :old.param_name AND
        INPUT_STAGE_PARAMETER.filter_name = :old.filter_name AND
        INPUT_STAGE_PARAMETER.stage_ID = :old.stage_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_CONTROL_PARAMETER BEFORE INSERT ON CONTROL_PARAMETER for each row
-- ERwin Builtin Trigger
-- INSERT trigger on CONTROL_PARAMETER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* STAGE  CONTROL_PARAMETER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001fbbb", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="stage_ID" */
    SELECT count(*) INTO NUMROWS
      FROM STAGE
      WHERE
        /* %JoinFKPK(:%New,STAGE," = "," AND") */
        :new.stage_ID = STAGE.stage_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert CONTROL_PARAMETER because STAGE does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* FILTER  CONTROL_PARAMETER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="FILTER"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="filter_name" */
    SELECT count(*) INTO NUMROWS
      FROM FILTER
      WHERE
        /* %JoinFKPK(:%New,FILTER," = "," AND") */
        :new.filter_name = FILTER.filter_name;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert CONTROL_PARAMETER because FILTER does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_CONTROL_PARAMETER AFTER UPDATE ON CONTROL_PARAMETER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on CONTROL_PARAMETER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* CONTROL_PARAMETER  INPUT_STAGE_PARAMETER on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00037b42", PARENT_OWNER="", PARENT_TABLE="CONTROL_PARAMETER"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="param_name""filter_name""stage_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.param_name <> :new.param_name OR 
    :old.filter_name <> :new.filter_name OR 
    :old.stage_ID <> :new.stage_ID
  THEN
    UPDATE INPUT_STAGE_PARAMETER
      SET
        /* %SetFK(INPUT_STAGE_PARAMETER,NULL) */
        INPUT_STAGE_PARAMETER.param_name = NULL,
        INPUT_STAGE_PARAMETER.filter_name = NULL,
        INPUT_STAGE_PARAMETER.stage_ID = NULL
      WHERE
        /* %JoinFKPK(INPUT_STAGE_PARAMETER,:%Old," = ",",") */
        INPUT_STAGE_PARAMETER.param_name = :old.param_name AND
        INPUT_STAGE_PARAMETER.filter_name = :old.filter_name AND
        INPUT_STAGE_PARAMETER.stage_ID = :old.stage_ID;
  END IF;

  /* ERwin Builtin Trigger */
  /* STAGE  CONTROL_PARAMETER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="stage_ID" */
  SELECT count(*) INTO NUMROWS
    FROM STAGE
    WHERE
      /* %JoinFKPK(:%New,STAGE," = "," AND") */
      :new.stage_ID = STAGE.stage_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update CONTROL_PARAMETER because STAGE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* FILTER  CONTROL_PARAMETER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="FILTER"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="filter_name" */
  SELECT count(*) INTO NUMROWS
    FROM FILTER
    WHERE
      /* %JoinFKPK(:%New,FILTER," = "," AND") */
      :new.filter_name = FILTER.filter_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update CONTROL_PARAMETER because FILTER does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_FILTER AFTER DELETE ON FILTER for each row
-- ERwin Builtin Trigger
-- DELETE trigger on FILTER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* FILTER  CONTROL_PARAMETER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f2d8", PARENT_OWNER="", PARENT_TABLE="FILTER"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="filter_name" */
    SELECT count(*) INTO NUMROWS
      FROM CONTROL_PARAMETER
      WHERE
        /*  %JoinFKPK(CONTROL_PARAMETER,:%Old," = "," AND") */
        CONTROL_PARAMETER.filter_name = :old.filter_name;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete FILTER because CONTROL_PARAMETER exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_FILTER BEFORE INSERT ON FILTER for each row
-- ERwin Builtin Trigger
-- INSERT trigger on FILTER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* STAGE  FILTER on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000d607", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="FILTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="stage_ID" */
    UPDATE FILTER
      SET
        /* %SetFK(FILTER,NULL) */
        FILTER.stage_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM STAGE
            WHERE
              /* %JoinFKPK(:%New,STAGE," = "," AND") */
              :new.stage_ID = STAGE.stage_ID
        ) 
        /* %JoinPKPK(FILTER,:%New," = "," AND") */
         and FILTER.filter_name = :new.filter_name;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_FILTER AFTER UPDATE ON FILTER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on FILTER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* FILTER  CONTROL_PARAMETER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000220a5", PARENT_OWNER="", PARENT_TABLE="FILTER"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="filter_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.filter_name <> :new.filter_name
  THEN
    SELECT count(*) INTO NUMROWS
      FROM CONTROL_PARAMETER
      WHERE
        /*  %JoinFKPK(CONTROL_PARAMETER,:%Old," = "," AND") */
        CONTROL_PARAMETER.filter_name = :old.filter_name;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update FILTER because CONTROL_PARAMETER exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* STAGE  FILTER on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="FILTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="stage_ID" */
  SELECT count(*) INTO NUMROWS
    FROM STAGE
    WHERE
      /* %JoinFKPK(:%New,STAGE," = "," AND") */
      :new.stage_ID = STAGE.stage_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.stage_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update FILTER because STAGE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_INPUT_STAGE_PARAMETER BEFORE INSERT ON INPUT_STAGE_PARAMETER for each row
-- ERwin Builtin Trigger
-- INSERT trigger on INPUT_STAGE_PARAMETER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* CONTROL_PARAMETER  INPUT_STAGE_PARAMETER on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="000288ff", PARENT_OWNER="", PARENT_TABLE="CONTROL_PARAMETER"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="param_name""filter_name""stage_ID" */
    UPDATE INPUT_STAGE_PARAMETER
      SET
        /* %SetFK(INPUT_STAGE_PARAMETER,NULL) */
        INPUT_STAGE_PARAMETER.param_name = NULL,
        INPUT_STAGE_PARAMETER.filter_name = NULL,
        INPUT_STAGE_PARAMETER.stage_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM CONTROL_PARAMETER
            WHERE
              /* %JoinFKPK(:%New,CONTROL_PARAMETER," = "," AND") */
              :new.param_name = CONTROL_PARAMETER.param_name AND
              :new.filter_name = CONTROL_PARAMETER.filter_name AND
              :new.stage_ID = CONTROL_PARAMETER.stage_ID
        ) 
        /* %JoinPKPK(INPUT_STAGE_PARAMETER,:%New," = "," AND") */
         and INPUT_STAGE_PARAMETER.stage_ID = :new.stage_ID;

    /* ERwin Builtin Trigger */
    /* STAGE  INPUT_STAGE_PARAMETER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="stage_ID" */
    SELECT count(*) INTO NUMROWS
      FROM STAGE
      WHERE
        /* %JoinFKPK(:%New,STAGE," = "," AND") */
        :new.stage_ID = STAGE.stage_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert INPUT_STAGE_PARAMETER because STAGE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_INPUT_STAGE_PARAMETER AFTER UPDATE ON INPUT_STAGE_PARAMETER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on INPUT_STAGE_PARAMETER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* CONTROL_PARAMETER  INPUT_STAGE_PARAMETER on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00028399", PARENT_OWNER="", PARENT_TABLE="CONTROL_PARAMETER"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="param_name""filter_name""stage_ID" */
  SELECT count(*) INTO NUMROWS
    FROM CONTROL_PARAMETER
    WHERE
      /* %JoinFKPK(:%New,CONTROL_PARAMETER," = "," AND") */
      :new.param_name = CONTROL_PARAMETER.param_name AND
      :new.filter_name = CONTROL_PARAMETER.filter_name AND
      :new.stage_ID = CONTROL_PARAMETER.stage_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.param_name IS NOT NULL AND
    :new.filter_name IS NOT NULL AND
    :new.stage_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update INPUT_STAGE_PARAMETER because CONTROL_PARAMETER does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* STAGE  INPUT_STAGE_PARAMETER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="stage_ID" */
  SELECT count(*) INTO NUMROWS
    FROM STAGE
    WHERE
      /* %JoinFKPK(:%New,STAGE," = "," AND") */
      :new.stage_ID = STAGE.stage_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update INPUT_STAGE_PARAMETER because STAGE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_PIPE AFTER DELETE ON PIPE for each row
-- ERwin Builtin Trigger
-- DELETE trigger on PIPE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* PIPE  STAGE on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="000527a3", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="STAGE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    UPDATE STAGE
      SET
        /* %SetFK(STAGE,NULL) */
        STAGE.Pipe_ID = NULL,
        STAGE.pipeline_ID = NULL
      WHERE
        /* %JoinFKPK(STAGE,:%Old," = "," AND") */
        STAGE.Pipe_ID = :old.Pipe_ID AND
        STAGE.pipeline_ID = :old.pipeline_ID;

    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_SPLITTER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    SELECT count(*) INTO NUMROWS
      FROM PIPE_SPLITTER
      WHERE
        /*  %JoinFKPK(PIPE_SPLITTER,:%Old," = "," AND") */
        PIPE_SPLITTER.Pipe_ID = :old.Pipe_ID AND
        PIPE_SPLITTER.pipeline_ID = :old.pipeline_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete PIPE because PIPE_SPLITTER exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_SPLITTER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    SELECT count(*) INTO NUMROWS
      FROM PIPE_SPLITTER
      WHERE
        /*  %JoinFKPK(PIPE_SPLITTER,:%Old," = "," AND") */
        PIPE_SPLITTER.Pipe_ID = :old.Pipe_ID AND
        PIPE_SPLITTER.pipeline_ID = :old.pipeline_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete PIPE because PIPE_SPLITTER exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_D_PROC_CONNECTION on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    UPDATE PIPE_D_PROC_CONNECTION
      SET
        /* %SetFK(PIPE_D_PROC_CONNECTION,NULL) */
        PIPE_D_PROC_CONNECTION.Pipe_ID = NULL,
        PIPE_D_PROC_CONNECTION.pipeline_ID = NULL
      WHERE
        /* %JoinFKPK(PIPE_D_PROC_CONNECTION,:%Old," = "," AND") */
        PIPE_D_PROC_CONNECTION.Pipe_ID = :old.Pipe_ID AND
        PIPE_D_PROC_CONNECTION.pipeline_ID = :old.pipeline_ID;

    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_D_PROC_CONNECTION on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    UPDATE PIPE_D_PROC_CONNECTION
      SET
        /* %SetFK(PIPE_D_PROC_CONNECTION,NULL) */
        PIPE_D_PROC_CONNECTION.Pipe_ID = NULL,
        PIPE_D_PROC_CONNECTION.pipeline_ID = NULL
      WHERE
        /* %JoinFKPK(PIPE_D_PROC_CONNECTION,:%Old," = "," AND") */
        PIPE_D_PROC_CONNECTION.Pipe_ID = :old.Pipe_ID AND
        PIPE_D_PROC_CONNECTION.pipeline_ID = :old.pipeline_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_PIPE BEFORE INSERT ON PIPE for each row
-- ERwin Builtin Trigger
-- INSERT trigger on PIPE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* PIPELINE  PIPE on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f171", PARENT_OWNER="", PARENT_TABLE="PIPELINE"
    CHILD_OWNER="", CHILD_TABLE="PIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="pipeline_ID" */
    SELECT count(*) INTO NUMROWS
      FROM PIPELINE
      WHERE
        /* %JoinFKPK(:%New,PIPELINE," = "," AND") */
        :new.pipeline_ID = PIPELINE.pipeline_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert PIPE because PIPELINE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_PIPE AFTER UPDATE ON PIPE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on PIPE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* PIPE  STAGE on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00073b86", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="STAGE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Pipe_ID <> :new.Pipe_ID OR 
    :old.pipeline_ID <> :new.pipeline_ID
  THEN
    UPDATE STAGE
      SET
        /* %SetFK(STAGE,NULL) */
        STAGE.Pipe_ID = NULL,
        STAGE.pipeline_ID = NULL
      WHERE
        /* %JoinFKPK(STAGE,:%Old," = ",",") */
        STAGE.Pipe_ID = :old.Pipe_ID AND
        STAGE.pipeline_ID = :old.pipeline_ID;
  END IF;

  /* ERwin Builtin Trigger */
  /* PIPE  PIPE_SPLITTER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Pipe_ID <> :new.Pipe_ID OR 
    :old.pipeline_ID <> :new.pipeline_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM PIPE_SPLITTER
      WHERE
        /*  %JoinFKPK(PIPE_SPLITTER,:%Old," = "," AND") */
        PIPE_SPLITTER.Pipe_ID = :old.Pipe_ID AND
        PIPE_SPLITTER.pipeline_ID = :old.pipeline_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update PIPE because PIPE_SPLITTER exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* PIPE  PIPE_SPLITTER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Pipe_ID <> :new.Pipe_ID OR 
    :old.pipeline_ID <> :new.pipeline_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM PIPE_SPLITTER
      WHERE
        /*  %JoinFKPK(PIPE_SPLITTER,:%Old," = "," AND") */
        PIPE_SPLITTER.Pipe_ID = :old.Pipe_ID AND
        PIPE_SPLITTER.pipeline_ID = :old.pipeline_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update PIPE because PIPE_SPLITTER exists.'
      );
    END IF;
  END IF;

  /* PIPE  PIPE_D_PROC_CONNECTION on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Pipe_ID <> :new.Pipe_ID OR 
    :old.pipeline_ID <> :new.pipeline_ID
  THEN
    UPDATE PIPE_D_PROC_CONNECTION
      SET
        /* %SetFK(PIPE_D_PROC_CONNECTION,NULL) */
        PIPE_D_PROC_CONNECTION.Pipe_ID = NULL,
        PIPE_D_PROC_CONNECTION.pipeline_ID = NULL
      WHERE
        /* %JoinFKPK(PIPE_D_PROC_CONNECTION,:%Old," = ",",") */
        PIPE_D_PROC_CONNECTION.Pipe_ID = :old.Pipe_ID AND
        PIPE_D_PROC_CONNECTION.pipeline_ID = :old.pipeline_ID;
  END IF;

  /* PIPE  PIPE_D_PROC_CONNECTION on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Pipe_ID <> :new.Pipe_ID OR 
    :old.pipeline_ID <> :new.pipeline_ID
  THEN
    UPDATE PIPE_D_PROC_CONNECTION
      SET
        /* %SetFK(PIPE_D_PROC_CONNECTION,NULL) */
        PIPE_D_PROC_CONNECTION.Pipe_ID = NULL,
        PIPE_D_PROC_CONNECTION.pipeline_ID = NULL
      WHERE
        /* %JoinFKPK(PIPE_D_PROC_CONNECTION,:%Old," = ",",") */
        PIPE_D_PROC_CONNECTION.Pipe_ID = :old.Pipe_ID AND
        PIPE_D_PROC_CONNECTION.pipeline_ID = :old.pipeline_ID;
  END IF;

  /* ERwin Builtin Trigger */
  /* PIPELINE  PIPE on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPELINE"
    CHILD_OWNER="", CHILD_TABLE="PIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="pipeline_ID" */
  SELECT count(*) INTO NUMROWS
    FROM PIPELINE
    WHERE
      /* %JoinFKPK(:%New,PIPELINE," = "," AND") */
      :new.pipeline_ID = PIPELINE.pipeline_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update PIPE because PIPELINE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_PIPE_D_PROC_CONNECTION BEFORE INSERT ON PIPE_D_PROC_CONNECTION for each row
-- ERwin Builtin Trigger
-- INSERT trigger on PIPE_D_PROC_CONNECTION 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_D_PROC_CONNECTION on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00027b46", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    UPDATE PIPE_D_PROC_CONNECTION
      SET
        /* %SetFK(PIPE_D_PROC_CONNECTION,NULL) */
        PIPE_D_PROC_CONNECTION.Pipe_ID = NULL,
        PIPE_D_PROC_CONNECTION.pipeline_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM PIPE
            WHERE
              /* %JoinFKPK(:%New,PIPE," = "," AND") */
              :new.Pipe_ID = PIPE.Pipe_ID AND
              :new.pipeline_ID = PIPE.pipeline_ID
        ) 
        /* %JoinPKPK(PIPE_D_PROC_CONNECTION,:%New," = "," AND") */
         and PIPE_D_PROC_CONNECTION.pipe_con_id = :new.pipe_con_id;

    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_D_PROC_CONNECTION on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    UPDATE PIPE_D_PROC_CONNECTION
      SET
        /* %SetFK(PIPE_D_PROC_CONNECTION,NULL) */
        PIPE_D_PROC_CONNECTION.Pipe_ID = NULL,
        PIPE_D_PROC_CONNECTION.pipeline_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM PIPE
            WHERE
              /* %JoinFKPK(:%New,PIPE," = "," AND") */
              :new.Pipe_ID = PIPE.Pipe_ID AND
              :new.pipeline_ID = PIPE.pipeline_ID
        ) 
        /* %JoinPKPK(PIPE_D_PROC_CONNECTION,:%New," = "," AND") */
         and PIPE_D_PROC_CONNECTION.pipe_con_id = :new.pipe_con_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_PIPE_D_PROC_CONNECTION AFTER UPDATE ON PIPE_D_PROC_CONNECTION for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on PIPE_D_PROC_CONNECTION 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* PIPE  PIPE_D_PROC_CONNECTION on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00025c1e", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  SELECT count(*) INTO NUMROWS
    FROM PIPE
    WHERE
      /* %JoinFKPK(:%New,PIPE," = "," AND") */
      :new.Pipe_ID = PIPE.Pipe_ID AND
      :new.pipeline_ID = PIPE.pipeline_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.Pipe_ID IS NOT NULL AND
    :new.pipeline_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update PIPE_D_PROC_CONNECTION because PIPE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* PIPE  PIPE_D_PROC_CONNECTION on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_D_PROC_CONNECTION"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  SELECT count(*) INTO NUMROWS
    FROM PIPE
    WHERE
      /* %JoinFKPK(:%New,PIPE," = "," AND") */
      :new.Pipe_ID = PIPE.Pipe_ID AND
      :new.pipeline_ID = PIPE.pipeline_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.Pipe_ID IS NOT NULL AND
    :new.pipeline_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update PIPE_D_PROC_CONNECTION because PIPE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_PIPE_SPLITTER BEFORE INSERT ON PIPE_SPLITTER for each row
-- ERwin Builtin Trigger
-- INSERT trigger on PIPE_SPLITTER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_SPLITTER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00020642", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    SELECT count(*) INTO NUMROWS
      FROM PIPE
      WHERE
        /* %JoinFKPK(:%New,PIPE," = "," AND") */
        :new.Pipe_ID = PIPE.Pipe_ID AND
        :new.pipeline_ID = PIPE.pipeline_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert PIPE_SPLITTER because PIPE does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* PIPE  PIPE_SPLITTER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    SELECT count(*) INTO NUMROWS
      FROM PIPE
      WHERE
        /* %JoinFKPK(:%New,PIPE," = "," AND") */
        :new.Pipe_ID = PIPE.Pipe_ID AND
        :new.pipeline_ID = PIPE.pipeline_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert PIPE_SPLITTER because PIPE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_PIPE_SPLITTER AFTER UPDATE ON PIPE_SPLITTER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on PIPE_SPLITTER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* PIPE  PIPE_SPLITTER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0002168f", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  SELECT count(*) INTO NUMROWS
    FROM PIPE
    WHERE
      /* %JoinFKPK(:%New,PIPE," = "," AND") */
      :new.Pipe_ID = PIPE.Pipe_ID AND
      :new.pipeline_ID = PIPE.pipeline_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update PIPE_SPLITTER because PIPE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* PIPE  PIPE_SPLITTER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="PIPE_SPLITTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  SELECT count(*) INTO NUMROWS
    FROM PIPE
    WHERE
      /* %JoinFKPK(:%New,PIPE," = "," AND") */
      :new.Pipe_ID = PIPE.Pipe_ID AND
      :new.pipeline_ID = PIPE.pipeline_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update PIPE_SPLITTER because PIPE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_PIPELINE AFTER DELETE ON PIPELINE for each row
-- ERwin Builtin Trigger
-- DELETE trigger on PIPELINE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* PIPELINE  PIPE on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d2b9", PARENT_OWNER="", PARENT_TABLE="PIPELINE"
    CHILD_OWNER="", CHILD_TABLE="PIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="pipeline_ID" */
    SELECT count(*) INTO NUMROWS
      FROM PIPE
      WHERE
        /*  %JoinFKPK(PIPE,:%Old," = "," AND") */
        PIPE.pipeline_ID = :old.pipeline_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete PIPELINE because PIPE exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_PIPELINE AFTER UPDATE ON PIPELINE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on PIPELINE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* PIPELINE  PIPE on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000ff9f", PARENT_OWNER="", PARENT_TABLE="PIPELINE"
    CHILD_OWNER="", CHILD_TABLE="PIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="pipeline_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.pipeline_ID <> :new.pipeline_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM PIPE
      WHERE
        /*  %JoinFKPK(PIPE,:%Old," = "," AND") */
        PIPE.pipeline_ID = :old.pipeline_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update PIPELINE because PIPE exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_STAGE AFTER DELETE ON STAGE for each row
-- ERwin Builtin Trigger
-- DELETE trigger on STAGE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* STAGE  CONTROL_PARAMETER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0002b43c", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="stage_ID" */
    SELECT count(*) INTO NUMROWS
      FROM CONTROL_PARAMETER
      WHERE
        /*  %JoinFKPK(CONTROL_PARAMETER,:%Old," = "," AND") */
        CONTROL_PARAMETER.stage_ID = :old.stage_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete STAGE because CONTROL_PARAMETER exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* STAGE  INPUT_STAGE_PARAMETER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="stage_ID" */
    SELECT count(*) INTO NUMROWS
      FROM INPUT_STAGE_PARAMETER
      WHERE
        /*  %JoinFKPK(INPUT_STAGE_PARAMETER,:%Old," = "," AND") */
        INPUT_STAGE_PARAMETER.stage_ID = :old.stage_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete STAGE because INPUT_STAGE_PARAMETER exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* STAGE  FILTER on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="FILTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="stage_ID" */
    UPDATE FILTER
      SET
        /* %SetFK(FILTER,NULL) */
        FILTER.stage_ID = NULL
      WHERE
        /* %JoinFKPK(FILTER,:%Old," = "," AND") */
        FILTER.stage_ID = :old.stage_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_STAGE BEFORE INSERT ON STAGE for each row
-- ERwin Builtin Trigger
-- INSERT trigger on STAGE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* PIPE  STAGE on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000fa95", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="STAGE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Pipe_ID""pipeline_ID" */
    UPDATE STAGE
      SET
        /* %SetFK(STAGE,NULL) */
        STAGE.Pipe_ID = NULL,
        STAGE.pipeline_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM PIPE
            WHERE
              /* %JoinFKPK(:%New,PIPE," = "," AND") */
              :new.Pipe_ID = PIPE.Pipe_ID AND
              :new.pipeline_ID = PIPE.pipeline_ID
        ) 
        /* %JoinPKPK(STAGE,:%New," = "," AND") */
         and STAGE.stage_ID = :new.stage_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_STAGE AFTER UPDATE ON STAGE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on STAGE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* STAGE  CONTROL_PARAMETER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0004269d", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="CONTROL_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="stage_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.stage_ID <> :new.stage_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM CONTROL_PARAMETER
      WHERE
        /*  %JoinFKPK(CONTROL_PARAMETER,:%Old," = "," AND") */
        CONTROL_PARAMETER.stage_ID = :old.stage_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update STAGE because CONTROL_PARAMETER exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* STAGE  INPUT_STAGE_PARAMETER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="INPUT_STAGE_PARAMETER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="stage_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.stage_ID <> :new.stage_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM INPUT_STAGE_PARAMETER
      WHERE
        /*  %JoinFKPK(INPUT_STAGE_PARAMETER,:%Old," = "," AND") */
        INPUT_STAGE_PARAMETER.stage_ID = :old.stage_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update STAGE because INPUT_STAGE_PARAMETER exists.'
      );
    END IF;
  END IF;

  /* STAGE  FILTER on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="STAGE"
    CHILD_OWNER="", CHILD_TABLE="FILTER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="stage_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.stage_ID <> :new.stage_ID
  THEN
    UPDATE FILTER
      SET
        /* %SetFK(FILTER,NULL) */
        FILTER.stage_ID = NULL
      WHERE
        /* %JoinFKPK(FILTER,:%Old," = ",",") */
        FILTER.stage_ID = :old.stage_ID;
  END IF;

  /* ERwin Builtin Trigger */
  /* PIPE  STAGE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PIPE"
    CHILD_OWNER="", CHILD_TABLE="STAGE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Pipe_ID""pipeline_ID" */
  SELECT count(*) INTO NUMROWS
    FROM PIPE
    WHERE
      /* %JoinFKPK(:%New,PIPE," = "," AND") */
      :new.Pipe_ID = PIPE.Pipe_ID AND
      :new.pipeline_ID = PIPE.pipeline_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.Pipe_ID IS NOT NULL AND
    :new.pipeline_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update STAGE because PIPE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/

