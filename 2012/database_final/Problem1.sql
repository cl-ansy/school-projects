
CREATE TABLE Department
(
	dept_number          CHAR(18) NOT NULL ,
	dept_name            CHAR(18) NULL ,
	factory_name         CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKDepartment ON Department
(dept_number   ASC,factory_name   ASC);

ALTER TABLE Department
	ADD CONSTRAINT  XPKDepartment PRIMARY KEY (dept_number,factory_name);

CREATE TABLE Employee
(
	emp_code             CHAR(18) NOT NULL ,
	emp_name             CHAR(18) NULL ,
	dept_number          CHAR(18) NOT NULL ,
	factory_name         CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKEmployee ON Employee
(emp_code   ASC,dept_number   ASC,factory_name   ASC);

ALTER TABLE Employee
	ADD CONSTRAINT  XPKEmployee PRIMARY KEY (emp_code,dept_number,factory_name);

CREATE TABLE Factory
(
	factory_name         CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKFactory ON Factory
(factory_name   ASC);

ALTER TABLE Factory
	ADD CONSTRAINT  XPKFactory PRIMARY KEY (factory_name);

CREATE TABLE Job
(
	job_number           CHAR(18) NOT NULL ,
	job_description      CHAR(18) NULL ,
	date                 CHAR(18) NULL ,
	emp_code             CHAR(18) NULL ,
	dept_number          CHAR(18) NULL ,
	factory_name         CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKJob ON Job
(job_number   ASC);

ALTER TABLE Job
	ADD CONSTRAINT  XPKJob PRIMARY KEY (job_number);

CREATE TABLE Job_Sheet
(
	week_number          CHAR(18) NULL ,
	emp_code             CHAR(18) NOT NULL ,
	dept_number          CHAR(18) NOT NULL ,
	year                 CHAR(18) NULL ,
	factory_name         CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKJob_Sheet ON Job_Sheet
(emp_code   ASC,dept_number   ASC,factory_name   ASC);

ALTER TABLE Job_Sheet
	ADD CONSTRAINT  XPKJob_Sheet PRIMARY KEY (emp_code,dept_number,factory_name);

CREATE TABLE Product
(
	product_id           CHAR(18) NOT NULL ,
	product_type         CHAR(18) NULL ,
	product_description  CHAR(18) NULL ,
	factory_name         CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKProduct ON Product
(product_id   ASC,factory_name   ASC);

ALTER TABLE Product
	ADD CONSTRAINT  XPKProduct PRIMARY KEY (product_id,factory_name);

CREATE TABLE Product_Material
(
	material_type        CHAR(18) NOT NULL ,
	product_id           CHAR(18) NULL ,
	factory_name         CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKProduct_Material ON Product_Material
(material_type   ASC);

ALTER TABLE Product_Material
	ADD CONSTRAINT  XPKProduct_Material PRIMARY KEY (material_type);

CREATE TABLE Product_Paint
(
	paint_id             CHAR(18) NOT NULL ,
	paint_color          CHAR(18) NULL ,
	paint_type           CHAR(18) NULL ,
	product_id           CHAR(18) NULL ,
	factory_name         CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKProduct_Paint ON Product_Paint
(paint_id   ASC);

ALTER TABLE Product_Paint
	ADD CONSTRAINT  XPKProduct_Paint PRIMARY KEY (paint_id);

CREATE TABLE Task
(
	task_description     CHAR(18) NOT NULL ,
	job_number           CHAR(18) NULL 
);

CREATE UNIQUE INDEX XPKTask ON Task
(task_description   ASC);

ALTER TABLE Task
	ADD CONSTRAINT  XPKTask PRIMARY KEY (task_description);

CREATE TABLE Task_Rate
(
	hourly_rate          CHAR(18) NULL ,
	payment              CHAR(18) NULL ,
	task_description     CHAR(18) NOT NULL 
);

CREATE UNIQUE INDEX XPKTask_Rate ON Task_Rate
(task_description   ASC);

ALTER TABLE Task_Rate
	ADD CONSTRAINT  XPKTask_Rate PRIMARY KEY (task_description);

ALTER TABLE Department
	ADD (CONSTRAINT R_6 FOREIGN KEY (factory_name) REFERENCES Factory (factory_name));

ALTER TABLE Employee
	ADD (CONSTRAINT R_1 FOREIGN KEY (dept_number, factory_name) REFERENCES Department (dept_number, factory_name));

ALTER TABLE Job
	ADD (CONSTRAINT R_3 FOREIGN KEY (emp_code, dept_number, factory_name) REFERENCES Job_Sheet (emp_code, dept_number, factory_name) ON DELETE SET NULL);

ALTER TABLE Job_Sheet
	ADD (CONSTRAINT R_2 FOREIGN KEY (emp_code, dept_number, factory_name) REFERENCES Employee (emp_code, dept_number, factory_name));

ALTER TABLE Product
	ADD (CONSTRAINT R_7 FOREIGN KEY (factory_name) REFERENCES Factory (factory_name));

ALTER TABLE Product_Material
	ADD (CONSTRAINT R_8 FOREIGN KEY (product_id, factory_name) REFERENCES Product (product_id, factory_name) ON DELETE SET NULL);

ALTER TABLE Product_Paint
	ADD (CONSTRAINT R_9 FOREIGN KEY (product_id, factory_name) REFERENCES Product (product_id, factory_name) ON DELETE SET NULL);

ALTER TABLE Task
	ADD (CONSTRAINT R_4 FOREIGN KEY (job_number) REFERENCES Job (job_number) ON DELETE SET NULL);

ALTER TABLE Task_Rate
	ADD (CONSTRAINT R_5 FOREIGN KEY (task_description) REFERENCES Task (task_description));

CREATE  TRIGGER  tD_Department AFTER DELETE ON Department for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Department 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Department  Employee on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f4e2", PARENT_OWNER="", PARENT_TABLE="Department"
    CHILD_OWNER="", CHILD_TABLE="Employee"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="dept_number""factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Employee
      WHERE
        /*  %JoinFKPK(Employee,:%Old," = "," AND") */
        Employee.dept_number = :old.dept_number AND
        Employee.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Department because Employee exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Department BEFORE INSERT ON Department for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Department 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Factory  Department on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e533", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Department"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Factory
      WHERE
        /* %JoinFKPK(:%New,Factory," = "," AND") */
        :new.factory_name = Factory.factory_name;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Department because Factory does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Department AFTER UPDATE ON Department for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Department 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Department  Employee on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000237f0", PARENT_OWNER="", PARENT_TABLE="Department"
    CHILD_OWNER="", CHILD_TABLE="Employee"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="dept_number""factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.dept_number <> :new.dept_number OR 
    :old.factory_name <> :new.factory_name
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Employee
      WHERE
        /*  %JoinFKPK(Employee,:%Old," = "," AND") */
        Employee.dept_number = :old.dept_number AND
        Employee.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Department because Employee exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Factory  Department on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Department"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Factory
    WHERE
      /* %JoinFKPK(:%New,Factory," = "," AND") */
      :new.factory_name = Factory.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Department because Factory does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Employee AFTER DELETE ON Employee for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Employee 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Employee  Job_Sheet on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001138e", PARENT_OWNER="", PARENT_TABLE="Employee"
    CHILD_OWNER="", CHILD_TABLE="Job_Sheet"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="emp_code""dept_number""factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Job_Sheet
      WHERE
        /*  %JoinFKPK(Job_Sheet,:%Old," = "," AND") */
        Job_Sheet.emp_code = :old.emp_code AND
        Job_Sheet.dept_number = :old.dept_number AND
        Job_Sheet.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Employee because Job_Sheet exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Employee BEFORE INSERT ON Employee for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Employee 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Department  Employee on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00010b84", PARENT_OWNER="", PARENT_TABLE="Department"
    CHILD_OWNER="", CHILD_TABLE="Employee"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="dept_number""factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Department
      WHERE
        /* %JoinFKPK(:%New,Department," = "," AND") */
        :new.dept_number = Department.dept_number AND
        :new.factory_name = Department.factory_name;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Employee because Department does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Employee AFTER UPDATE ON Employee for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Employee 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Employee  Job_Sheet on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0002854b", PARENT_OWNER="", PARENT_TABLE="Employee"
    CHILD_OWNER="", CHILD_TABLE="Job_Sheet"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="emp_code""dept_number""factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.emp_code <> :new.emp_code OR 
    :old.dept_number <> :new.dept_number OR 
    :old.factory_name <> :new.factory_name
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Job_Sheet
      WHERE
        /*  %JoinFKPK(Job_Sheet,:%Old," = "," AND") */
        Job_Sheet.emp_code = :old.emp_code AND
        Job_Sheet.dept_number = :old.dept_number AND
        Job_Sheet.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Employee because Job_Sheet exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Department  Employee on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Department"
    CHILD_OWNER="", CHILD_TABLE="Employee"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="dept_number""factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Department
    WHERE
      /* %JoinFKPK(:%New,Department," = "," AND") */
      :new.dept_number = Department.dept_number AND
      :new.factory_name = Department.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Employee because Department does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Factory AFTER DELETE ON Factory for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Factory 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Factory  Product on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001c628", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Product"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Product
      WHERE
        /*  %JoinFKPK(Product,:%Old," = "," AND") */
        Product.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Factory because Product exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* Factory  Department on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Department"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Department
      WHERE
        /*  %JoinFKPK(Department,:%Old," = "," AND") */
        Department.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Factory because Department exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Factory AFTER UPDATE ON Factory for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Factory 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Factory  Product on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000232b5", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Product"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.factory_name <> :new.factory_name
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Product
      WHERE
        /*  %JoinFKPK(Product,:%Old," = "," AND") */
        Product.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Factory because Product exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Factory  Department on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Department"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.factory_name <> :new.factory_name
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Department
      WHERE
        /*  %JoinFKPK(Department,:%Old," = "," AND") */
        Department.factory_name = :old.factory_name;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Factory because Department exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Job AFTER DELETE ON Job for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Job 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Job  Task on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000a832", PARENT_OWNER="", PARENT_TABLE="Job"
    CHILD_OWNER="", CHILD_TABLE="Task"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="job_number" */
    UPDATE Task
      SET
        /* %SetFK(Task,NULL) */
        Task.job_number = NULL
      WHERE
        /* %JoinFKPK(Task,:%Old," = "," AND") */
        Task.job_number = :old.job_number;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Job BEFORE INSERT ON Job for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Job 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Job_Sheet  Job on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="000124af", PARENT_OWNER="", PARENT_TABLE="Job_Sheet"
    CHILD_OWNER="", CHILD_TABLE="Job"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="emp_code""dept_number""factory_name" */
    UPDATE Job
      SET
        /* %SetFK(Job,NULL) */
        Job.emp_code = NULL,
        Job.dept_number = NULL,
        Job.factory_name = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM Job_Sheet
            WHERE
              /* %JoinFKPK(:%New,Job_Sheet," = "," AND") */
              :new.emp_code = Job_Sheet.emp_code AND
              :new.dept_number = Job_Sheet.dept_number AND
              :new.factory_name = Job_Sheet.factory_name
        ) 
        /* %JoinPKPK(Job,:%New," = "," AND") */
         and Job.job_number = :new.job_number;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Job AFTER UPDATE ON Job for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Job 
DECLARE NUMROWS INTEGER;
BEGIN
  /* Job  Task on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00021f88", PARENT_OWNER="", PARENT_TABLE="Job"
    CHILD_OWNER="", CHILD_TABLE="Task"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="job_number" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.job_number <> :new.job_number
  THEN
    UPDATE Task
      SET
        /* %SetFK(Task,NULL) */
        Task.job_number = NULL
      WHERE
        /* %JoinFKPK(Task,:%Old," = ",",") */
        Task.job_number = :old.job_number;
  END IF;

  /* ERwin Builtin Trigger */
  /* Job_Sheet  Job on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Job_Sheet"
    CHILD_OWNER="", CHILD_TABLE="Job"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="emp_code""dept_number""factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Job_Sheet
    WHERE
      /* %JoinFKPK(:%New,Job_Sheet," = "," AND") */
      :new.emp_code = Job_Sheet.emp_code AND
      :new.dept_number = Job_Sheet.dept_number AND
      :new.factory_name = Job_Sheet.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.emp_code IS NOT NULL AND
    :new.dept_number IS NOT NULL AND
    :new.factory_name IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Job because Job_Sheet does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Job_Sheet AFTER DELETE ON Job_Sheet for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Job_Sheet 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Job_Sheet  Job on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000e3e8", PARENT_OWNER="", PARENT_TABLE="Job_Sheet"
    CHILD_OWNER="", CHILD_TABLE="Job"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="emp_code""dept_number""factory_name" */
    UPDATE Job
      SET
        /* %SetFK(Job,NULL) */
        Job.emp_code = NULL,
        Job.dept_number = NULL,
        Job.factory_name = NULL
      WHERE
        /* %JoinFKPK(Job,:%Old," = "," AND") */
        Job.emp_code = :old.emp_code AND
        Job.dept_number = :old.dept_number AND
        Job.factory_name = :old.factory_name;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Job_Sheet BEFORE INSERT ON Job_Sheet for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Job_Sheet 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Employee  Job_Sheet on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00012734", PARENT_OWNER="", PARENT_TABLE="Employee"
    CHILD_OWNER="", CHILD_TABLE="Job_Sheet"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="emp_code""dept_number""factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Employee
      WHERE
        /* %JoinFKPK(:%New,Employee," = "," AND") */
        :new.emp_code = Employee.emp_code AND
        :new.dept_number = Employee.dept_number AND
        :new.factory_name = Employee.factory_name;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Job_Sheet because Employee does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Job_Sheet AFTER UPDATE ON Job_Sheet for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Job_Sheet 
DECLARE NUMROWS INTEGER;
BEGIN
  /* Job_Sheet  Job on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00025606", PARENT_OWNER="", PARENT_TABLE="Job_Sheet"
    CHILD_OWNER="", CHILD_TABLE="Job"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="emp_code""dept_number""factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.emp_code <> :new.emp_code OR 
    :old.dept_number <> :new.dept_number OR 
    :old.factory_name <> :new.factory_name
  THEN
    UPDATE Job
      SET
        /* %SetFK(Job,NULL) */
        Job.emp_code = NULL,
        Job.dept_number = NULL,
        Job.factory_name = NULL
      WHERE
        /* %JoinFKPK(Job,:%Old," = ",",") */
        Job.emp_code = :old.emp_code AND
        Job.dept_number = :old.dept_number AND
        Job.factory_name = :old.factory_name;
  END IF;

  /* ERwin Builtin Trigger */
  /* Employee  Job_Sheet on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employee"
    CHILD_OWNER="", CHILD_TABLE="Job_Sheet"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="emp_code""dept_number""factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Employee
    WHERE
      /* %JoinFKPK(:%New,Employee," = "," AND") */
      :new.emp_code = Employee.emp_code AND
      :new.dept_number = Employee.dept_number AND
      :new.factory_name = Employee.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Job_Sheet because Employee does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Product AFTER DELETE ON Product for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Product 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Product  Product_Paint on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="000204ae", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Paint"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_id""factory_name" */
    UPDATE Product_Paint
      SET
        /* %SetFK(Product_Paint,NULL) */
        Product_Paint.product_id = NULL,
        Product_Paint.factory_name = NULL
      WHERE
        /* %JoinFKPK(Product_Paint,:%Old," = "," AND") */
        Product_Paint.product_id = :old.product_id AND
        Product_Paint.factory_name = :old.factory_name;

    /* ERwin Builtin Trigger */
    /* Product  Product_Material on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Material"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="product_id""factory_name" */
    UPDATE Product_Material
      SET
        /* %SetFK(Product_Material,NULL) */
        Product_Material.product_id = NULL,
        Product_Material.factory_name = NULL
      WHERE
        /* %JoinFKPK(Product_Material,:%Old," = "," AND") */
        Product_Material.product_id = :old.product_id AND
        Product_Material.factory_name = :old.factory_name;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Product BEFORE INSERT ON Product for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Product 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Factory  Product on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000ea81", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Product"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="factory_name" */
    SELECT count(*) INTO NUMROWS
      FROM Factory
      WHERE
        /* %JoinFKPK(:%New,Factory," = "," AND") */
        :new.factory_name = Factory.factory_name;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Product because Factory does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Product AFTER UPDATE ON Product for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Product 
DECLARE NUMROWS INTEGER;
BEGIN
  /* Product  Product_Paint on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00036cc7", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Paint"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_id""factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.product_id <> :new.product_id OR 
    :old.factory_name <> :new.factory_name
  THEN
    UPDATE Product_Paint
      SET
        /* %SetFK(Product_Paint,NULL) */
        Product_Paint.product_id = NULL,
        Product_Paint.factory_name = NULL
      WHERE
        /* %JoinFKPK(Product_Paint,:%Old," = ",",") */
        Product_Paint.product_id = :old.product_id AND
        Product_Paint.factory_name = :old.factory_name;
  END IF;

  /* Product  Product_Material on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Material"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="product_id""factory_name" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.product_id <> :new.product_id OR 
    :old.factory_name <> :new.factory_name
  THEN
    UPDATE Product_Material
      SET
        /* %SetFK(Product_Material,NULL) */
        Product_Material.product_id = NULL,
        Product_Material.factory_name = NULL
      WHERE
        /* %JoinFKPK(Product_Material,:%Old," = ",",") */
        Product_Material.product_id = :old.product_id AND
        Product_Material.factory_name = :old.factory_name;
  END IF;

  /* ERwin Builtin Trigger */
  /* Factory  Product on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Factory"
    CHILD_OWNER="", CHILD_TABLE="Product"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Factory
    WHERE
      /* %JoinFKPK(:%New,Factory," = "," AND") */
      :new.factory_name = Factory.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Product because Factory does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Product_Material BEFORE INSERT ON Product_Material for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Product_Material 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Product  Product_Material on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00012b18", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Material"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="product_id""factory_name" */
    UPDATE Product_Material
      SET
        /* %SetFK(Product_Material,NULL) */
        Product_Material.product_id = NULL,
        Product_Material.factory_name = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM Product
            WHERE
              /* %JoinFKPK(:%New,Product," = "," AND") */
              :new.product_id = Product.product_id AND
              :new.factory_name = Product.factory_name
        ) 
        /* %JoinPKPK(Product_Material,:%New," = "," AND") */
         and Product_Material.material_type = :new.material_type;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Product_Material AFTER UPDATE ON Product_Material for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Product_Material 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Product  Product_Material on child update no action */
  /* ERWIN_RELATION:CHECKSUM="000127b8", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Material"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="product_id""factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Product
    WHERE
      /* %JoinFKPK(:%New,Product," = "," AND") */
      :new.product_id = Product.product_id AND
      :new.factory_name = Product.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.product_id IS NOT NULL AND
    :new.factory_name IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Product_Material because Product does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Product_Paint BEFORE INSERT ON Product_Paint for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Product_Paint 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Product  Product_Paint on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00011d75", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Paint"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_id""factory_name" */
    UPDATE Product_Paint
      SET
        /* %SetFK(Product_Paint,NULL) */
        Product_Paint.product_id = NULL,
        Product_Paint.factory_name = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM Product
            WHERE
              /* %JoinFKPK(:%New,Product," = "," AND") */
              :new.product_id = Product.product_id AND
              :new.factory_name = Product.factory_name
        ) 
        /* %JoinPKPK(Product_Paint,:%New," = "," AND") */
         and Product_Paint.paint_id = :new.paint_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Product_Paint AFTER UPDATE ON Product_Paint for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Product_Paint 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Product  Product_Paint on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00012967", PARENT_OWNER="", PARENT_TABLE="Product"
    CHILD_OWNER="", CHILD_TABLE="Product_Paint"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="product_id""factory_name" */
  SELECT count(*) INTO NUMROWS
    FROM Product
    WHERE
      /* %JoinFKPK(:%New,Product," = "," AND") */
      :new.product_id = Product.product_id AND
      :new.factory_name = Product.factory_name;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.product_id IS NOT NULL AND
    :new.factory_name IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Product_Paint because Product does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Task AFTER DELETE ON Task for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Task 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Task  Task_Rate on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000dbe2", PARENT_OWNER="", PARENT_TABLE="Task"
    CHILD_OWNER="", CHILD_TABLE="Task_Rate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="task_description" */
    SELECT count(*) INTO NUMROWS
      FROM Task_Rate
      WHERE
        /*  %JoinFKPK(Task_Rate,:%Old," = "," AND") */
        Task_Rate.task_description = :old.task_description;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Task because Task_Rate exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Task BEFORE INSERT ON Task for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Task 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Job  Task on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000dda3", PARENT_OWNER="", PARENT_TABLE="Job"
    CHILD_OWNER="", CHILD_TABLE="Task"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="job_number" */
    UPDATE Task
      SET
        /* %SetFK(Task,NULL) */
        Task.job_number = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM Job
            WHERE
              /* %JoinFKPK(:%New,Job," = "," AND") */
              :new.job_number = Job.job_number
        ) 
        /* %JoinPKPK(Task,:%New," = "," AND") */
         and Task.task_description = :new.task_description;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Task AFTER UPDATE ON Task for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Task 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Task  Task_Rate on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0002041e", PARENT_OWNER="", PARENT_TABLE="Task"
    CHILD_OWNER="", CHILD_TABLE="Task_Rate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="task_description" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.task_description <> :new.task_description
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Task_Rate
      WHERE
        /*  %JoinFKPK(Task_Rate,:%Old," = "," AND") */
        Task_Rate.task_description = :old.task_description;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Task because Task_Rate exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Job  Task on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Job"
    CHILD_OWNER="", CHILD_TABLE="Task"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="job_number" */
  SELECT count(*) INTO NUMROWS
    FROM Job
    WHERE
      /* %JoinFKPK(:%New,Job," = "," AND") */
      :new.job_number = Job.job_number;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.job_number IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Task because Job does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Task_Rate BEFORE INSERT ON Task_Rate for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Task_Rate 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Task  Task_Rate on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e787", PARENT_OWNER="", PARENT_TABLE="Task"
    CHILD_OWNER="", CHILD_TABLE="Task_Rate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="task_description" */
    SELECT count(*) INTO NUMROWS
      FROM Task
      WHERE
        /* %JoinFKPK(:%New,Task," = "," AND") */
        :new.task_description = Task.task_description;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Task_Rate because Task does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Task_Rate AFTER UPDATE ON Task_Rate for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Task_Rate 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Task  Task_Rate on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000e59f", PARENT_OWNER="", PARENT_TABLE="Task"
    CHILD_OWNER="", CHILD_TABLE="Task_Rate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="task_description" */
  SELECT count(*) INTO NUMROWS
    FROM Task
    WHERE
      /* %JoinFKPK(:%New,Task," = "," AND") */
      :new.task_description = Task.task_description;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Task_Rate because Task does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/

