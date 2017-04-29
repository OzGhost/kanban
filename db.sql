-- DBMS Subject
-- Kanban Project

-- Apply for MariaDB 10.1.17
use yii2basic;

DROP TABLE IF EXISTS LOGS;
DROP TABLE IF EXISTS REQUESTS;
DROP TABLE IF EXISTS CI;
DROP TABLE IF EXISTS TASKS;
DROP TABLE IF EXISTS PROJECTS;
DROP TABLE IF EXISTS USERS;

CREATE TABLE USERS (
    UserID      int not null auto_increment,
    UserName    varchar(32) not null unique,
    Password    varchar(64) not null,
    KEY (UserID)
) ENGINE=InnoDB;

CREATE TABLE PROJECTS (
    ProjectID   int not null auto_increment,
    ProjectName varchar(32) not null,
    Owner       int not null,
    Status      tinyint(1),
    CreateDate  datetime default current_timestamp,
    EndDate     datetime default NULL,
    KEY (ProjectID),
    constraint FK_project_user
        foreign key (Owner)
        references USERS(UserID)
) ENGINE=InnoDB;

CREATE TABLE TASKS (
    TaskID          int not null auto_increment,
    TaskName        varchar(32) not null,
    ProjectID       int not null,
    Desc_            text,
    Status          tinyint(1),
    CreateDate      datetime default current_timestamp,
    DeadLine        datetime default NULL,
    StartDate       datetime default NULL,
    CompleteDate    datetime default NULL,
    Affecter        int not null,
    KEY (TaskID),
    UNIQUE (TaskName, ProjectID),
    constraint FK_task_project
        foreign key (ProjectID)
        references PROJECTS(ProjectID),
    constraint FK_task_user
        foreign key (Affecter)
        references USERS(UserID)
) ENGINE=InnoDB;

CREATE TABLE CI (
    UserID          int not null,
    ProjectID       int not null,
    confirmDelete   tinyint(1),
    KEY (UserID, ProjectID),
    constraint FK_ci_user
        foreign key (UserID)
        references USERS(UserID),
    constraint FK_ci_project
        foreign key (ProjectID)
        references PROJECTS(ProjectID)
) ENGINE=InnoDB;

CREATE TABLE REQUESTS (
    Sender      int not null,
    Receiver    int not null,
    ProjectID   int not null,
    Type        boolean,
    RequestDate datetime default current_timestamp,
    KEY (Sender, Receiver, ProjectID),
    constraint FK_request_user
        foreign key (Sender)
        references USERS(UserID),
    constraint FK_request_user2
        foreign key (Receiver)
        references USERS(UserID),
    constraint FK_request_project
        foreign key (ProjectID)
        references PROJECTS(ProjectID)
) ENGINE=InnoDB;

CREATE TABLE LOGS (
    LogID       int not null auto_increment,
    Maker       int not null,
    ProjectID   int not null,
    TaskID      int not null,
    ModifyDate  datetime default current_timestamp,
    Type        tinyint(1),
    SubType     tinyint(1),
    KEY (LogID),
    CONSTRAINT FK_log_user
        FOREIGN KEY (Maker)
        REFERENCES USERS(UserID)
    ,
    CONSTRAINT FK_log_project
        FOREIGN KEY (ProjectID)
        REFERENCES PROJECTS(ProjectID)
    ,
    CONSTRAINT FK_log_task
        FOREIGN KEY (TaskID)
        REFERENCES TASKS(TaskID)
) ENGINE=InnoDB;


-- Functions

	-- Checking login infomation
		-- input: UserName, Password
		-- output:
                -- 0 infor matched
                -- -1 user name not exits
                -- -2 password not matched
DROP FUNCTION IF EXISTS checkingLogin;
DELIMITER //
CREATE FUNCTION checkingLogin(Uname varchar(32), Upass varchar(64))
    RETURNS int
    READS SQL DATA
    BEGIN
        IF NOT EXISTS (
            SELECT UserID
                FROM USERS
                WHERE UserName = Uname
        ) THEN -- case user name do not exit
            RETURN -1;
        END IF;
        IF NOT EXISTS (
            SELECT UserID
            FROM USERS
            WHERE UserName = Uname
                AND Password = Upass
        ) THEN -- case password wrong
            RETURN -2;
        ELSE
            -- login infor matched
            RETURN 0;
        END IF;
    END
    //
DELIMITER ;

	-- checking UserID exists
		-- input: UserID
		-- output: 0 if UserID exists / -1 not exists UserID
DROP FUNCTION IF EXISTS checkingUserExists;
DELIMITER //
CREATE FUNCTION checkingUserExists(Uid int)
    RETURNS tinyint
    READS SQL DATA
    BEGIN
        IF EXISTS (
            SELECT UserID
                FROM USERS
                WHERE UserID = Uid
            ) THEN -- case UserID was exists
            RETURN 0;
        ELSE -- case UserID was not exists
            RETURN -1;
		END IF;
    END //
DELIMITER ;

	-- checking ProjectID exists
		-- input: ProjectID
		-- output: 0 if ProjectID exits / -1 if not exists project
DROP FUNCTION IF EXISTS checkingProjectExists;
DELIMITER //
CREATE FUNCTION checkingProjectExists(Pid int)
    RETURNS tinyint
    READS SQL DATA
    BEGIN
        IF EXISTS (
            SELECT ProjectID
                FROM PROJECTS
                WHERE ProjectID = Pid
            ) THEN -- case ProjectID was exists
            RETURN 0;
        ELSE -- case ProjectID was not exists
            RETURN -1;
		END IF;
    END //
DELIMITER ;

	-- Checking Project include user
		-- input: ProjectID, UserID
		-- output: 0 if User have join Project / -1 if not
DROP FUNCTION IF EXISTS checkingProjectIncludeUser;
DELIMITER //
CREATE FUNCTION checkingProjectIncludeUser(Pid int, Uid int)
    RETURNS tinyint
    READS SQL DATA
    BEGIN
        DECLARE n tinyint;
        -- check joiner
        SELECT COUNT(UserID)
            INTO n
            FROM CI
            WHERE UserID = Uid
                AND ProjectID = Pid
        ;
        IF n = 1 THEN
            RETURN 0;
        ELSE -- check owner
            IF EXISTS (
                SELECT Owner
                    FROM PROJECTS
                    WHERE ProjectID = Pid
                        AND Owner = Uid
            ) THEN
                RETURN 0;
            ELSE
                RETURN -1;
            END IF;
        END IF;
    END //
DELIMITER ;

    -- Checking User own the Project
        -- input: UserID who own the Project, ProjectID was owned
        -- output: boolean 0 if that true or -1 if that not true
DROP FUNCTION IF EXISTS checkingUserOwnProject;
DELIMITER //
CREATE FUNCTION checkingUserOwnProject(Uid int, Pid int)
    RETURNS tinyint
    READS SQL DATA
BEGIN
    DECLARE n tinyint;
    SELECT COUNT(Pid)
        INTO n
        FROM PROJECTS
        WHERE Owner = Uid
            AND ProjectID = Pid
    ;
    IF n = 1 THEN
        RETURN 0;
    ELSE
        RETURN -1;
    END IF;
END //
DELIMITER ;

	-- Checking project include task
		-- input: ProjectID, TaskID
		-- output: 0 if project have task / -1 if not
DROP FUNCTION IF EXISTS checkingProjectIncludeTask;
DELIMITER //
CREATE FUNCTION checkingProjectIncludeTask(Pid int, Tid int)
    RETURNS tinyint
    READS SQL DATA
    BEGIN
        DECLARE n tinyint;
        SELECT COUNT(TaskID)
            INTO n
            FROM TASKS
            WHERE TaskID = Tid
                AND ProjectID = Pid
        ;
        IF n = 1 THEN
            RETURN 0;
        ELSE
            RETURN -1;
        END IF;
    END
    //
DELIMITER ;

	-- checking duplic project name of user
		-- input: UserID, ProjectName
		-- output: 0 if user had a project with this name / -1 if not
DROP FUNCTION IF EXISTS checkingDuplicProjectName;
DELIMITER //
CREATE FUNCTION checkingDuplicProjectName(Uid int, Pname varchar(32))
    RETURNS tinyint
    READS SQL DATA
    BEGIN
        DECLARE n tinyint;
        SELECT COUNT(ProjectID)
            INTO n
            FROM PROJECTS
            WHERE Owner = Uid
                AND ProjectName = Pname
        ;
        IF n = 0 THEN
            RETURN -1;
        END IF;
        RETURN 0;
    END //
DELIMITER ;

    -- checkign user request on project
DROP FUNCTION IF EXISTS checkingUserReqOnProject;
DELIMITER //
CREATE FUNCTION checkingUserReqOnProject(Uid int, Pid int)
    RETURNS tinyint
    READS SQL DATA
    BEGIN
        IF EXISTS (
            SELECT Sender
                FROM REQUESTS
                WHERE Type = 1
                    AND Sender = Uid
                    AND ProjectID = Pid
        ) THEN -- case user was sent request to project
            RETURN 0;
        END IF;
        IF EXISTS (
            SELECT Receiver
                FROM REQUESTS
                WHERE Type = 2
                    AND Receiver = Uid
                    AND ProjectID = Pid
        ) THEN -- case user was received request on project
            RETURN 0;
        END IF;
        RETURN -1;
    END //
DELIMITER ;

	-- function get status of Project
		-- input: ProjectID
		-- return status of specified project
		-- return -1 if project not exitsts
DROP FUNCTION IF EXISTS stateOfProject;
DELIMITER //
CREATE FUNCTION stateOfProject(Pid int)
RETURNS tinyint
READS SQL DATA
BEGIN
	DECLARE state tinyint;
	IF NOT EXISTS (
		SELECT ProjectID
			FROM PROJECTS
			WHERE ProjectID = Pid
	) THEN -- case ProjectID not exists
		RETURN -1;
	END IF;
	SELECT Status
		INTO state
		FROM PROJECTS
		WHERE ProjectID = Pid
	;
	RETURN state;
END //
DELIMITER ;

    -- function count task
DROP FUNCTION IF EXISTS taskCount;
DELIMITER //
CREATE FUNCTION taskCount(Pid int, state int)
RETURNS int
READS SQL DATA
BEGIN
    DECLARE n tinyint;
    IF state = 0 THEN -- count all task of project
        SELECT Count(TaskID)
            INTO n
            FROM TASKS
            WHERE ProjectID = Pid
                AND Status != 4
        ;
    ELSE
        SELECT Count(TaskID)
            INTO n
            FROM TASKS
            WHERE ProjectID = Pid
                AND Status = state
        ;
    END IF;
    RETURN n;
END //
DELIMITER ;

-- Trigger

   -- handling append user to project
        -- delete all request that user involked
		-- ON CI AFTER INSERT
DROP TRIGGER IF EXISTS TG_appendUser;
DELIMITER //
CREATE TRIGGER TG_appendUser
AFTER INSERT ON CI
FOR EACH ROW
	DELETE FROM REQUESTS
		WHERE ProjectID = NEW.ProjectID
			AND (
				Sender = NEW.UserID
				OR Receiver = NEW.UserID
			)
	//
DELIMITER ;

	-- handling task change
		-- prevent changing task if project is waiting to remove
		-- ON TASKS BEFORE UPDATE, INSERT, DELETE
DROP TRIGGER IF EXISTS TG_insertTask;
DELIMITER //
CREATE TRIGGER TG_insertTask
BEFORE INSERT ON TASKS
FOR EACH ROW
BEGIN
    -- prevent change on waiting delete task
	IF stateOfProject(NEW.ProjectID) = 3 THEN
        SIGNAL SQLSTATE '42000' SET
            MYSQL_ERRNO = 1148,
            MESSAGE_TEXT = 'Can not new task will be waiting';
	END IF;
    -- handle new task on old project
    IF stateOfProject(NEW.ProjectID) = 2 THEN
        UPDATE PROJECTS
            SET Status = 1
            WHERE ProjectID = NEW.ProjectID
        ;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS TG_updateTask;
DELIMITER //
CREATE TRIGGER TG_updateTask
BEFORE UPDATE ON TASKS
FOR EACH ROW
BEGIN
    -- prevent change on waiting delete task
	IF stateOfProject(OLD.ProjectID) = 3 OR OLD.Status = 3 THEN
        SIGNAL SQLSTATE '42000' SET
            MYSQL_ERRNO = 1148,
            MESSAGE_TEXT = 'Can not change waiting/complete task';
	END IF;
    -- auto update project status when last task done
	IF NEW.Status = 3 AND stateOfProject(NEW.ProjectID) = 1 AND NOT EXISTS (
		SELECT TaskID
			FROM TASKS
			WHERE ProjectID = NEW.ProjectID
				AND TaskID != NEW.TaskID
				AND Status != 3
	) THEN -- case last task recently done
		BEGIN
			UPDATE PROJECTS
				SET Status = 2
				WHERE ProjectID = NEW.ProjectID
			;
		END;
	END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS TG_deleteTask;
DELIMITER //
CREATE TRIGGER TG_deleteTask
BEFORE DELETE ON TASKS
FOR EACH ROW
BEGIN
    -- prevent change on waiting delete task
    IF stateOfProject(OLD.ProjectID) = 3 THEN
        IF EXISTS(
            SELECT UserID
                FROM CI
                WHERE ProjectID = OLD.ProjectID
                    AND confirmDelete != 1
            ) THEN -- case normal delete => prevent
            BEGIN
                SIGNAL SQLSTATE '42000' SET
                MYSQL_ERRNO = 1148,
                MESSAGE_TEXT = 'Can not delete task is waiting!';
            END;
        END IF;
    ELSE
        IF OLD.Status != 1 THEN -- case invalid task delete
            SIGNAL SQLSTATE '42000' SET
                MYSQL_ERRNO = 1148,
                MESSAGE_TEXT = 'Can not delete not new task';
        END IF;
    END IF;
END //
DELIMITER ;

	-- handling request on waiting project
		-- prevent send request or invite to project which are waiting to remove
		-- ON REQUESTS BEFORE INSERT, DELETE
DROP TRIGGER IF EXISTS TG_requestSend;
DELIMITER //
CREATE TRIGGER TG_requestSend
BEFORE INSERT ON REQUESTS
FOR EACH ROW
BEGIN
    -- prevent change on waiting delete task
	IF stateOfProject(NEW.ProjectID) = 3 THEN
        SIGNAL SQLSTATE '42000' SET
            MYSQL_ERRNO = 1148,
            MESSAGE_TEXT = 'Can not request on waiting project!';
	END IF;
END //
DELIMITER ;

    -- handling project change on waiting for delete
        -- prevent update project when status is 3
        -- ON PROJECT BEFORE UPDATE
DROP TRIGGER IF EXISTS TG_pvProjectChange;
DELIMITER //
CREATE TRIGGER TG_pvProjectChange
BEFORE UPDATE ON PROJECTS
FOR EACH ROW
BEGIN
    IF OLD.Status = NEW.Status AND OLD.Status = 3 THEN
        SIGNAL SQLSTATE '42000' SET
            MYSQL_ERRNO = 1148,
            MESSAGE_TEXT = 'Can not change waiting project!';
    END IF;
END //
DELIMITER ;


-- Procedure

    -- new user
		-- input: UserName, Password
		-- output:
            -- id of new user if success
            -- -1 if user name already exists
            -- -2 system failure
DROP PROCEDURE IF EXISTS newUser;
DELIMITER //
CREATE PROCEDURE newUser(Uname varchar(32), Upass varchar(64))
`nU`:
BEGIN
    DECLARE n tinyint;
    START TRANSACTION;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    IF EXISTS (
        SELECT UserName
            FROM USERS
            WHERE UserName = Uname
    ) THEN -- case user name already exits
        BEGIN
            SELECT '-1' AS 'ms';
            LEAVE `nU`;
        END;
    END IF;
    -- case user name is a new one
    INSERT INTO USERS(UserName, Password)
        VALUES (Uname, Upass);
    SET n = ROW_COUNT();
    IF n = 1 THEN
        SELECT LAST_INSERT_ID() AS 'ms';
    ELSE
        -- case system failure
        SELECT '-2' AS 'ms';
    END IF;
    COMMIT;
END //
DELIMITER ;

    -- new project
        -- return project id if success
        -- return -1: userid not exists
        -- return -2: if duplic project name
DROP PROCEDURE IF EXISTS newProject;
DELIMITER //
CREATE PROCEDURE newProject(Uid int, Pname varchar(32))
`newP`:
BEGIN
    DECLARE i int;
    START TRANSACTION;
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exit
            SELECT '-1' AS 'ms';
            LEAVE `newP`;
        END;
    END IF;
    IF checkingDuplicProjectName(Uid, Pname) = 0 THEN
        BEGIN -- duplic project name
            SELECT '-2' AS 'ms';
            LEAVE `newP`;
        END;
    END IF;
    INSERT INTO PROJECTS(ProjectName, Status, Owner)
        VALUES (Pname, 1, Uid);
    SELECT LAST_INSERT_ID() AS 'ms';
    COMMIT;
END //
DELIMITER ;

    -- request delete project
        -- input: UserID, ProjectID
        -- output:
            -- 1: project deleted
            -- 0: success
            -- -1: userid not exists
            -- -2: project not exists
            -- -3: user not own project
DROP PROCEDURE IF EXISTS reqDelProject;
DELIMITER //
CREATE PROCEDURE reqDelProject(Uid int, Pid int)
`rdP`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exists
            SELECT '-1' AS 'ms';
            LEAVE `rdP`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `rdP`;
        END;
    END IF;
    IF stateOfProject(Pid) = 3 THEN
        BEGIN
            SELECT '0' AS 'ms';
            LEAVE `rdP`;
        END;
    END IF;
    IF checkingUserOwnProject(Uid, Pid) != 0 THEN
        BEGIN -- case User not own project
            SELECT '-3' AS ms;
            LEAVE `rdP`;
        END;
    ELSE
        BEGIN
            -- recheck
            START TRANSACTION;
            SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
                UPDATE PROJECTS
                    SET Status = 3 -- change project's status
                    WHERE ProjectID = Pid
                ;
                IF EXISTS (
                    SELECT UserID
                        FROM CI
                        WHERE ProjectID = Pid
                ) THEN -- case project have more than one member
                    BEGIN
                        UPDATE CI
                            SET confirmDelete = -1 -- change confirm status
                            WHERE ProjectID = Pid
                        ;
                        SELECT '0' AS ms;
                    END;
                ELSE
                    BEGIN
                        CALL delProject(Pid);
                        SELECT '1' AS 'ms';
                    END;
                END IF;
            COMMIT;
        END;
    END IF;
END //
DELIMITER ;

    -- confirm delete
        -- input: UserID who confirm the request delete
        --          ProjectID which User confirm for
        --          Option which User choosed
        -- output: 0 if success / -1 if false / 1 denied request / 2 delete project
            -- 0: success
            -- 1: denied request
            -- 2: delete project
            -- -1: userid not exists
            -- -2: project not exists
            -- -3: user not join project yet
            -- -4: project not wait for remove
            -- -5: option invalid
DROP PROCEDURE IF EXISTS confirmDelete;
DELIMITER //
CREATE PROCEDURE confirmDelete(Uid int, Pid int, opt int)
`cDP`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exists
            SELECT '-1' AS 'ms';
            LEAVE `cDP`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `cDP`;
        END;
    END IF;
    IF checkingProjectIncludeUser(Pid, Uid) != 0 THEN
        BEGIN -- case User is not apart of project
            SELECT '-3' AS ms;
            LEAVE `cDP`;
        END;
    END IF;
    IF stateOfProject(Pid) != 3 THEN
        BEGIN -- case project do not wait for remove
            SELECT '-4' AS ms;
            LEAVE `cDP`;
        END;
    END IF;
    IF opt != 0 AND opt != 1 THEN -- case option not valid
        BEGIN
            SELECT '-5' AS ms;
            LEAVE `cDP`;
        END;
    END IF;
    IF opt = 0 THEN -- case denied request
        BEGIN
            -- recheck
            START TRANSACTION;
            SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
            UPDATE CI
                SET confirmDelete = NULL
                WHERE ProjectID = Pid
            ;
            UPDATE PROJECTS
                SET Status = 1
                WHERE ProjectID = Pid
            ;
            SELECT '1' AS ms;
            COMMIT;
            LEAVE `cDP`;
        END;
    END IF;
    -- update Ci
    UPDATE CI
        SET confirmDelete = 1
        WHERE ProjectID = Pid
            AND UserID = Uid
    ;
    -- checking last confirm
    IF EXISTS (
        SELECT UserID
            FROM CI
            WHERE ProjectID = Pid
                AND confirmDelete = -1
    ) THEN -- case someone not confirm yet
        BEGIN
            SELECT '0' AS ms;
        END;
    ELSE -- case last confirm
        BEGIN
            CALL delProject(Pid);
            SELECT '2' AS ms;
        END;
    END IF;
END //
DELIMITER ;

    -- delete project
        -- input: ProjectID
        -- output: silent
DROP PROCEDURE IF EXISTS delProject;
DELIMITER //
CREATE PROCEDURE delProject(Pid int)
`dPro`:
BEGIN
    IF stateOfProject(Pid) != 3 THEN -- case Project do not wait to delete
        BEGIN
            LEAVE `dPro`;
        END;
    END IF;
    IF EXISTS (
        SELECT UserID
            FROM CI
            WHERE ProjectID = Pid
                AND confirmDelete != 1
        ) THEN -- case someone denined to delete this project
		BEGIN
			LEAVE `dPro`;
		END;
	ELSE -- case everyone agree to delete this project
		BEGIN
            START TRANSACTION;
            SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
			DELETE FROM LOGS WHERE ProjectID = Pid;
			DELETE FROM TASKS WHERE ProjectID = Pid;
			DELETE FROM REQUESTS WHERE ProjectID = Pid;
			DELETE FROM CI WHERE ProjectID = Pid;
			DELETE FROM PROJECTS WHERE ProjectID = Pid;
            COMMIT;
		END;
    END IF;
END //
DELIMITER ;

	-- rename Project
		-- input: UserID, ProjectID, ProjectName
		-- output:
            -- 0: success
            -- -1: user not exists
            -- -2: project not exists
            -- -3: user not own project
            -- -4: duplic project name
DROP PROCEDURE IF EXISTS renameProject;
DELIMITER //
CREATE PROCEDURE renameProject(Uid int, Pid int, Pname varchar(32))
`rP`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exists
            SELECT '-1' AS 'ms';
            LEAVE `rP`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `rP`;
        END;
    END IF;
	IF checkingUserOwnProject(Uid, Pid) != 0 THEN
		BEGIN -- case user not own project
			SELECT '-3' AS ms;
			LEAVE `rP`;
		END;
	END IF;
	IF checkingDuplicProjectName(Uid, Pname) = 0 THEN
		BEGIN -- case project name is duplicate
			SELECT '-4' AS ms;
			LEAVE `rP`;
		END;
	END IF;
	UPDATE PROJECTS
		SET ProjectName = Pname
		WHERE ProjectID = Pid
	;
	SELECT '0' AS ms;
END //
DELIMITER ;

    -- new Task
		-- input: UserID, ProjectID, Task Name, Task Description
        -- output:
            -- new task info: success
            -- -1: user not exists
            -- -2: project not exists
            -- -3: duplic task name
            -- -4: user not join project yet
DROP PROCEDURE IF EXISTS newTask;
DELIMITER //
CREATE PROCEDURE newTask(Uid int, Pid int, Tname varchar(32), Tdesc text, Tdl varchar(19))
`nT`:
BEGIN
    DECLARE id int;
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exists
            SELECT '-1' AS 'ms';
            LEAVE `nT`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `nT`;
        END;
    END IF;
    IF EXISTS (
        SELECT TaskID
            FROM TASKS
            WHERE TaskName = Tname
                AND ProjectID = Pid
    ) THEN -- case duplict task name
        BEGIN
            SELECT '-3' AS 'ms';
            LEAVE `nT`;
        END;
    END IF;
    IF checkingProjectIncludeUser(Pid, Uid) != 0 THEN
        BEGIN
            SELECT '-4' AS 'ms';
            LEAVE `nT`;
        END;
    END IF;
    START TRANSACTION;
    INSERT INTO TASKS (TaskName, ProjectID, Desc_, Status, Affecter, DeadLine)
        VALUES(Tname, Pid, Tdesc, 1, Uid, Tdl);
    SET id = LAST_INSERT_ID();
    INSERT INTO LOGS (Maker, ProjectID, TaskID, ModifyDate, Type)
        VALUES (Uid, Pid, id, CURRENT_TIMESTAMP, 1)
    ;
    SELECT TaskID, TaskName, Desc_, Status, u.UserName AS AffecterName, CreateDate
        FROM TASKS AS t
        JOIN USERS AS u ON u.UserID = t.Affecter
        WHERE TaskID = id
    ;
    COMMIT;
END //
DELIMITER ;


    -- update Task State
		-- input: UserID, ProjectID, TaskID, Number of new state
		-- output:
            -- new state: success
            -- 0: no change
            -- -1: user not exists
            -- -2: project not exists
            -- -3: task not exists
            -- -4: user not join project yet
            -- -5: task not belong project
            -- -6: state invalid
            -- -7: forward only 1-2
            -- -8: not have permit
            -- -9: change done task
            -- -10: task effect on more than one task per project
DROP PROCEDURE IF EXISTS updateTaskState;
DELIMITER //
CREATE PROCEDURE updateTaskState(Uid int, Pid int, Tid int, State tinyint)
`uTask`:
BEGIN
    DECLARE c_Affecter int;
    DECLARE c_State tinyint;
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exists
            SELECT '-1' AS 'ms';
            LEAVE `uTask`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `uTask`;
        END;
    END IF;
    IF NOT EXISTS (
        SELECT TaskID
            FROM TASKS
            WHERE TaskID = Tid
    ) THEN
        BEGIN -- case task not exists
            SELECT '-3' AS 'ms';
            LEAVE `uTask`;
        END;
    END IF;
    -- recheck
    SELECT Affecter, Status
        INTO c_Affecter, c_State
        FROM TASKS
        WHERE TaskID = Tid
    ;
    IF checkingProjectIncludeUser(Pid, Uid) != 0 THEN
        BEGIN -- user not join this project
            SELECT '-4' AS 'ms';
            LEAVE `uTask`;
        END;
    END IF;
    IF checkingProjectIncludeTask(Pid, Tid) != 0 THEN
        BEGIN -- task not belong project
            SELECT '-5' AS 'ms';
            LEAVE `uTask`;
        END;
    END IF;
    IF State < 1 OR State > 3 THEN -- case bad state value
        BEGIN
            SELECT '-6' AS 'ms';
            LEAVE `uTask`;
        END;
    END IF;
    IF c_State = State THEN -- case state no change
        BEGIN
            SELECT '0' AS ms;
            LEAVE `uTask`;
        END;
    ELSE
        CASE c_State
            WHEN 1 THEN -- case current state is 1
                IF State = 2 THEN -- case task state change to 2
                    BEGIN
                        IF EXISTS (
                            SELECT TaskID
                                FROM TASKS
                                WHERE ProjectID = Pid
                                    AND Status = 2
                                    AND Affecter = Uid
                        ) THEN
                            BEGIN -- case user is doing some task on that project
                                SELECT '-10' AS 'ms';
                                LEAVE `uTask`;
                            END;
                        END IF;
                        START TRANSACTION;
                        SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
                        UPDATE TASKS
                            SET Status = State, Affecter = Uid, StartDate = CURRENT_TIMESTAMP
                            WHERE TaskID = Tid
                        ;
                        INSERT INTO LOGS (Maker, ProjectID, TaskID, ModifyDate, Type, SubType)
                            VALUES (Uid, Pid, Tid, CURRENT_TIMESTAMP, 2, 12)
                        ;
                        SELECT State AS ms;
                        COMMIT;
                    END;
                ELSE -- anything else state is deny
                    BEGIN
                        SELECT '-7' AS ms;
                        LEAVE `uTask`;
                    END;
                END IF;
            WHEN 2 THEN -- case state is 2
                BEGIN
                    IF c_Affecter = Uid THEN -- case affter responsible this task
                        BEGIN
                            IF State = 3 THEN -- case task change state from 2 to 3
                                BEGIN
                                    START TRANSACTION;
                                    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
                                    UPDATE TASKS
                                        SET CompleteDate = CURRENT_TIMESTAMP, Status = 3
                                        WHERE TaskID = Tid
                                    ;
                                    INSERT INTO LOGS (Maker, ProjectID, TaskID, ModifyDate, Type, SubType)
                                        VALUES (Uid, Pid, Tid, CURRENT_TIMESTAMP, 2, 23)
                                    ;
                                    COMMIT;
                                END;
                            ELSE
								IF State = 1 THEN -- case task change state from 2 to 1
									BEGIN
                                        START TRANSACTION;
                                        SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
										UPDATE TASKS
											SET StartDate = NULL, Status = 1
											WHERE TaskID = Tid
										;
										INSERT INTO LOGS (Maker, ProjectID, TaskID, ModifyDate, Type, SubType)
											VALUES (Uid, Pid, Tid, CURRENT_TIMESTAMP, 2, 21)
										;
                                        COMMIT;
									END;
								END IF;
							END IF;
                            SELECT State AS ms;
                        END;
                    ELSE -- case affter not responsible this task
                        BEGIN
                            SELECT '-8' AS ms;
                            LEAVE `uTask`;
                        END;
                    END IF;
                END;
			ELSE -- anything else will be deny
                BEGIN
                    SELECT '-9' AS ms;
                    LEAVE `uTask`;
                END;
        END CASE;
    END IF;
END //
DELIMITER ;

    -- delete Task
		-- input: UserID, ProjectID, TaskID
		-- output:
            -- 0: success
            -- -1: user not exists
            -- -2: project not exists
            -- -3: task not exists
            -- -4: task not state 1
            -- -5: user not join project yet
            -- -6: task not belong project
DROP PROCEDURE IF EXISTS delTask;
DELIMITER //
CREATE PROCEDURE delTask(Uid int, Pid int, Tid int)
`dTask`:
BEGIN
    DECLARE c_state tinyint;
    DECLARE n tinyint;
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN -- case user not exists
            SELECT '-1' AS 'ms';
            LEAVE `dTask`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `dTask`;
        END;
    END IF;
    IF NOT EXISTS (
        SELECT TaskID
            FROM TASKS
            WHERE TaskID = Tid
    ) THEN
        BEGIN -- case task not exists
            SELECT '-3' AS 'ms';
            LEAVE `dTask`;
        END;
    END IF;
    SELECT Status
        INTO c_state
        FROM TASKS
        WHERE TaskID = Tid
    ;
    IF c_state != 1 THEN -- case current state is not 1
        BEGIN
            SELECT '-4' AS ms;
            LEAVE `dTask`;
        END;
    END IF;
    IF checkingProjectIncludeUser(Pid, Uid) != 0 THEN
        BEGIN -- case User not join project yet
            SELECT '-5' AS 'ms';
            LEAVE `dTask`;
        END;
    END IF;
    IF checkingProjectIncludeTask(Pid, Tid) != 0 THEN
        BEGIN -- task not belong project
            SELECT '-6' AS 'ms';
            LEAVE `dTask`;
        END;
    END IF;
    -- if every thing is OK
    START TRANSACTION;
    UPDATE TASKS
        SET Status = 4, Affecter = Uid
        WHERE TaskID = Tid
    ;
    INSERT INTO LOGS (Maker, ProjectID, TaskID, ModifyDate, Type)
        VALUES (Uid, Pid, Tid, CURRENT_TIMESTAMP, 3)
    ;
    SELECT '0' AS ms;
    COMMIT;
END //
DELIMITER ;


    -- get project list
        -- input: UserID
        -- output: list of project that include user was provide above
            -- -1: user not exists
DROP PROCEDURE IF EXISTS getProjectList;
DELIMITER //
CREATE PROCEDURE getProjectList(Uid int)
`gPL`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN -- case UserID not exists
        BEGIN
            SELECT '-1' AS ms;
            LEAVE `gPL`;
        END;
    END IF;
    SELECT ProjectID, ProjectName, Status, CreateDate,
        CASE Owner
            WHEN Uid THEN 1
            ELSE 0 END
            AS 'Owner'
        FROM PROJECTS
        WHERE Owner = Uid
            OR ProjectID IN (
                SELECT ProjectID
                    FROM CI
                    WHERE UserID = Uid
            )
        ORDER BY CreateDate
	;
END //
DELIMITER ;

    -- get Task List
        -- input: ProjectID, UserID
        -- output: The list of task that belong project was provide above
            -- -1: user not exists
            -- -2: project not exists
            -- -3: user not join project yet
DROP PROCEDURE IF EXISTS getTaskList;
DELIMITER //
CREATE PROCEDURE getTaskList(Uid int, Pid int)
`gTL`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN-- case User not exists
            SELECT '-1' AS ms;
            LEAVE `gTL`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `gTL`;
        END;
    END IF;
    IF checkingProjectIncludeUser(Pid, Uid) != 0 THEN
        BEGIN-- case User not join this project yet
            SELECT '-3' AS ms;
            LEAVE `gTL`;
        END;
    END IF;
    SELECT t.TaskID, t.TaskName, t.Desc_, t.Status, u.UserName AS AffecterName, t.CreateDate, t.DeadLine,
        CASE u.UserID
            WHEN Uid THEN 'Y'
            ELSE 'N'
        END AS 'Permit'
        FROM TASKS AS t
        JOIN USERS AS u ON u.UserID = t.Affecter
        WHERE t.ProjectID = Pid
            AND t.Status != 4
        ORDER BY t.CreateDate
    ;
END //
DELIMITER ;

    -- request to join
        -- input: UserID who send request, ProjectID where
        -- output:
            -- -1: user not exists
            -- -2: project not exists
            -- -3: user is apart of project
            -- -4: request was send
            -- -5: can not find receiver
DROP PROCEDURE IF EXISTS requestToJoin;
DELIMITER //
CREATE PROCEDURE requestToJoin(Uid int, Pid int)
`rTJ`:
BEGIN
    DECLARE rcv INT;
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN-- case User not exists
            SELECT '-1' AS ms;
            LEAVE `rTJ`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-2' AS 'ms';
            LEAVE `rTJ`;
        END;
    END IF;
    IF checkingProjectIncludeUser(Pid, Uid) = 0 THEN
        BEGIN -- case project have included user
            SELECT '-3' AS ms;
            LEAVE `rTJ`;
        END;
    END IF;
    START TRANSACTION;
    SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    IF EXISTS (
        SELECT ProjectID
            FROM REQUESTS
            WHERE (
				Sender = Uid
                AND ProjectID = Pid
				) OR (
				Receiver = Uid
				AND ProjectID = Pid
			)
        ) THEN -- case request was send somewhen in the past
        BEGIN -- or invite was send and not confirm yet
            SELECT '-4' AS ms;
            LEAVE `rTJ`;
        END;
    END IF;
    -- get receiver ID
    SELECT Owner
        INTO rcv
        FROM PROJECTS
        WHERE ProjectID = Pid
    ;
	IF rcv IS NULL THEN
		BEGIN -- can not find receiver
			SELECT '-5' AS ms;
			LEAVE `rTJ`;
		END;
	END IF;
    -- new request
    INSERT INTO REQUESTS(Sender, Receiver, ProjectID, Type)
        VALUES (Uid, rcv, Pid, 1)
    ;
	SELECT '0' AS ms;
    COMMIT;
END //
DELIMITER ;

    -- invite to join the project
        -- input: UserID who invite someone to join
        --          UserID who was invited
        --          ProjectID which was to join in
        -- output:
            -- 0: success
            -- -1: sender not exists
            -- -2: receiver not exists
            -- -3: project not exists
            -- -4: sender not own project
            -- -5: receiver has join project
            -- -6: request was exists
            -- -7: invite was sent
DROP PROCEDURE IF EXISTS inviteToJoin;
DELIMITER //
CREATE PROCEDURE inviteToJoin(SenderID int, ReceiverID int, Pid int)
`iTJ`:
BEGIN
    IF checkingUserExists(SenderID) != 0 THEN
        BEGIN-- case User not exists
            SELECT '-1' AS ms;
            LEAVE `iTJ`;
        END;
    END IF;
    IF checkingUserExists(ReceiverID) != 0 THEN
        BEGIN-- case User not exists
            SELECT '-2' AS ms;
            LEAVE `iTJ`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-3' AS 'ms';
            LEAVE `iTJ`;
        END;
    END IF;
    IF checkingUserOwnProject(SenderID, Pid) != 0 THEN
        BEGIN -- case sender did not own project
            SELECT '-4' AS ms;
            LEAVE `iTJ`;
        END;
    END IF;
    START TRANSACTION;
    SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	IF checkingProjectIncludeUser(Pid, ReceiverID) = 0 THEN
        BEGIN -- case receiver is a part of project
            SELECT '-5' AS ms;
            LEAVE `iTJ`;
        END;
	END IF;
	IF EXISTS (
		SELECT Receiver
			FROM REQUESTS
			WHERE Sender = ReceiverID
				AND ProjectID = Pid
	) THEN -- case request to join have existed
        BEGIN
            SELECT '-6' AS ms;
            LEAVE `iTJ`;
        END;
	END IF;
    IF EXISTS (
        SELECT Receiver
            FROM REQUESTS
            WHERE Sender = SenderID
                AND Receiver = ReceiverID
                AND ProjectID = Pid
        ) THEN -- case the invite was send somewhen in the past
        BEGIN
            SELECT '-7' AS ms;
            LEAVE `iTJ`;
        END;
    END IF;
    -- new request
    INSERT INTO REQUESTS (Sender, Receiver, ProjectID, Type)
        VALUES (SenderID, ReceiverID, Pid, 2)
    ;
	SELECT '0' AS ms;
    COMMIT;
END //
DELIMITER ;

    -- append user to project
        -- input: UserID, ProjectID
        -- output: silent
DROP PROCEDURE IF EXISTS appendToProject;
DELIMITER //
CREATE PROCEDURE appendToProject(Uid int, Pid int)
`aTP`:
BEGIN
    IF checkingUserExists(Uid) != 0
        OR checkingProjectExists(Pid) != 0
        THEN -- case bad input
        BEGIN
            LEAVE `aTP`;
        END;
    END IF;
    IF checkingProjectIncludeUser(Pid, Uid) = 0 THEN
        DELETE FROM REQUESTS
            WHERE ProjectID = Pid
                AND (
                    Sender = Uid
                    OR Receiver = Uid
                )
        ;
    END IF;
    -- append
    INSERT INTO CI (UserID, ProjectID)
        VALUES (Uid, Pid)
    ;
END //
DELIMITER ;

    -- accept request
        -- input: ReceiverID, SenderID, ProjectID
        -- output:
            -- 1: append sender to project
            -- 2: append receiver to project
            -- -1: sender not exists
            -- -2: receiver not exists
            -- -3: project not exists
            -- -4: request not exists
            -- -5: store issue -> system failure
DROP PROCEDURE IF EXISTS acceptRequest;
DELIMITER //
CREATE PROCEDURE acceptRequest(ReceiverID int, SenderID int, Pid int)
`aR`:
BEGIN
    DECLARE type_ tinyint;
    IF checkingUserExists(SenderID) != 0 THEN
        BEGIN-- case User not exists
            SELECT '-1' AS ms;
            LEAVE `aR`;
        END;
    END IF;
    IF checkingUserExists(ReceiverID) != 0 THEN
        BEGIN-- case User not exists
            SELECT '-2' AS ms;
            LEAVE `aR`;
        END;
    END IF;
    IF checkingProjectExists(Pid) != 0 THEN
        BEGIN -- case project not exists
            SELECT '-3' AS 'ms';
            LEAVE `aR`;
        END;
    END IF;
    IF NOT EXISTS (
        SELECT Type
            FROM REQUESTS
            WHERE Sender = SenderID
                AND Receiver = ReceiverID
                AND ProjectID = Pid
    ) THEN
        BEGIN -- case request not exists
            SELECT '-4' AS 'ms';
            LEAVE `aR`;
        END;
    END IF;
    SELECT TYPE
        INTO type_
        FROM REQUESTS
        WHERE Sender = SenderID
            AND Receiver = ReceiverID
            AND ProjectID = Pid
    ;
    IF type_ != 1 AND type_ != 2 THEN -- case type not valid
        BEGIN
            SELECT '-5' AS ms;
            LEAVE `aR`;
        END;
    END IF;
    IF type_ = 1 THEN -- case request to join
        BEGIN
            CALL appendToProject(SenderID, Pid);
            SELECT '1' AS ms;
        END;
    ELSEIF type_ = 2 THEN -- case invite to join
        BEGIN
            CALL appendToProject(ReceiverID, Pid);
            SELECT '2' AS ms;
        END;
    END IF;
END //
DELIMITER ;

    -- refuse request
        -- input: ReceiverID, SenderID, ProjectID
        -- output: silent
DROP PROCEDURE IF EXISTS refuseRequest;
DELIMITER //
CREATE PROCEDURE refuseRequest(ReceiverID int, SenderID int, Pid int)
`rR`:
BEGIN
    DELETE FROM REQUESTS
        WHERE Sender = SenderID
            AND Receiver = ReceiverID
            AND ProjectID = Pid
    ;
END //
DELIMITER ;

    -- get Request Recevied List (list of request to join the project)
        -- input: UserID
        -- output: list of request that someone send to you
DROP PROCEDURE IF EXISTS getRequestReceivedList;
DELIMITER //
CREATE PROCEDURE getRequestReceivedList(Uid int)
`gRRL`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN
            SELECT '-1' AS ms;
            LEAVE `gRRL`;
        END;
    END IF;
    SELECT r.Sender AS SenderID, u.UserName AS SenderName, r.ProjectID, p.ProjectName, r.RequestDate, r.Type
        FROM REQUESTS AS r
        JOIN PROJECTS AS p ON r.ProjectID = p.ProjectID
		JOIN USERS AS u ON r.Sender = u.UserID
        WHERE Receiver = Uid
        ORDER BY r.RequestDate DESC
    ;
END //
DELIMITER ;

	-- get confirm list
		-- input: UserID
		-- output: list of project need to confirm
DROP PROCEDURE IF EXISTS getConfirmList;
DELIMITER //
CREATE PROCEDURE getConfirmList(Uid int)
BEGIN
    SELECT c.ProjectID, p.ProjectName, p.Owner, c.confirmDelete
        FROM CI AS c
        JOIN (
            SELECT pj.ProjectID, pj.ProjectName, u.UserName AS 'Owner'
                FROM PROJECTS AS pj
                JOIN USERS AS u ON pj.Owner = u.UserID
                WHERE pj.Status = 3
        ) AS p ON c.ProjectID = p.ProjectID
        WHERE c.UserID = Uid
    UNION SELECT p.ProjectID, p.ProjectName, u.UserName, 1 AS 'confirm'
        FROM PROJECTS AS p
        JOIN USERS AS u ON u.UserID = p.Owner
        WHERE p.Status = 3
            AND p.Owner = Uid
    ;
END //
DELIMITER ;

    -- get Request Sended List
        -- input: UserID
        -- output: list of request that you send to some
DROP PROCEDURE IF EXISTS getRequestSendedList;
DELIMITER //
CREATE PROCEDURE getRequestSendedList (Uid int)
`gRSL`:
BEGIN
    IF checkingUserExists(Uid) != 0 THEN
        BEGIN
            SELECT '-1' AS ms;
            LEAVE `gRSL`;
        END;
    END IF;
    SELECT r.Receiver AS ReceiverID, u.UserName AS ReceiverName, r.ProjectID, p.ProjectName, r.RequestDate, r.Type
        FROM REQUESTS AS r
        JOIN PROJECTS AS p ON r.ProjectID = p.ProjectID
		JOIN USERS AS u ON r.Receiver = u.UserID
        WHERE Sender = Uid
        ORDER BY r.RequestDate DESC;
END //
DELIMITER ;

    -- Search project
DROP PROCEDURE IF EXISTS searchProject;
DELIMITER //
CREATE PROCEDURE searchProject(Uid int, pattern varchar(100))
BEGIN
    SELECT p.ProjectID, p.ProjectName, u.UserName,
            checkingProjectIncludeUser(p.ProjectID, Uid) as Own,
            checkingUserReqOnProject(Uid, p.ProjectID) as rOn
        FROM PROJECTS as p
        JOIN USERS as u ON u.UserID = p.Owner
        WHERE p.Status = 1
            AND 1 = (p.ProjectName REGEXP pattern)
        ORDER BY p.ProjectName;
END //
DELIMITER ;

    -- Search user
DROP PROCEDURE IF EXISTS searchUser;
DELIMITER //
CREATE PROCEDURE searchUser(Uid int, pattern varchar(100))
BEGIN
    SELECT UserName, UserID
        FROM USERS
        WHERE 1 = (UserName REGEXP pattern)
            AND UserID != Uid
    ;
END //
DELIMITER ;

    -- get list of project possible for invite
DROP PROCEDURE IF EXISTS getPossibleInviteProjectList;
DELIMITER //
CREATE PROCEDURE getPossibleInviteProjectList(Uid int, rcv int)
BEGIN
    SELECT ProjectID, ProjectName
        FROM PROJECTS
        WHERE Owner = Uid
            AND ProjectID NOT IN
            (
                SELECT ProjectID
                    FROM CI
                    WHERE UserID = rcv
                UNION SELECT ProjectID
                    FROM REQUESTS
                    WHERE (Sender = rcv)
                        OR (Receiver = rcv)
            )
    ;
END //
DELIMITER ;

    -- get project info
DROP PROCEDURE IF EXISTS getProjectInfo;
DELIMITER //
CREATE PROCEDURE getProjectInfo(Pid int)
BEGIN
    SELECT p.ProjectID, p.ProjectName, u.UserName AS 'Owner',
            p.Status, p.CreateDate, p.EndDate,
            taskCount(Pid, 0) AS 'Total',
            taskCount(Pid, 3) AS 'Done'
        FROM PROJECTS AS p
        JOIN USERS AS u ON u.UserID = p.Owner
        WHERE p.ProjectID = Pid
    ;
END //
DELIMITER ;

    -- get member list
DROP PROCEDURE IF EXISTS getMemberList;
DELIMITER //
CREATE PROCEDURE getMemberList(Pid int)
BEGIN
    SELECT ml.UserName
        FROM (
            SELECT u.UserName AS 'UserName'
                FROM CI AS c
                JOIN USERS AS u ON u.UserID = c.UserID
                WHERE c.ProjectID = Pid
            UNION SELECT u.UserName AS 'UseName'
                FROM PROJECTS AS p
                JOIN USERS AS u ON u.UserID = p.Owner
                WHERE p.ProjectID = Pid
        ) AS ml
        ORDER BY ml.UserName
    ;
END //
DELIMITER ;

    -- get task detail
DROP PROCEDURE IF EXISTS getTaskDetail;
DELIMITER //
CREATE PROCEDURE getTaskDetail(Pid int)
BEGIN
    SELECT TaskName, Status, CreateDate, DeadLine, StartDate, CompleteDate
        FROM TASKS
        WHERE ProjectID = Pid
            AND Status != 4
    ;
END //
DELIMITER ;

    -- get border time
DROP PROCEDURE IF EXISTS getBorderTime;
DELIMITER //
CREATE PROCEDURE getBorderTime(Pid int)
BEGIN
    DECLARE leftBorder datetime;
    DECLARE rightBorder datetime;
    SELECT MIN(CreateDate)
        INTO leftBorder
        FROM TASKS
        WHERE ProjectID = Pid
    ;
    IF EXISTS (
        SELECT TaskID
            FROM TASKS
            WHERE ProjectID = Pid
                AND (Status = 1 OR Status = 2)
    ) THEN
        BEGIN
            SELECT MAX(d.DeadLine)
                INTO rightBorder
                FROM (
                    SELECT DeadLine
                        FROM TASKS
                        WHERE ProjectID = Pid
                    UNION SELECT CURRENT_TIMESTAMP AS 'DeadLine'
                ) AS d
            ;
        END;
    ELSE
        BEGIN
            SELECT MAX(d.DeadLine)
                INTO rightBorder
                FROM (
                    SELECT DeadLine
                        FROM TASKS
                        WHERE ProjectID = Pid
                ) AS d
            ;
        END;
    END IF;
    SELECT leftBorder, rightBorder;
END //
DELIMITER ;

    -- get log list
DROP PROCEDURE IF EXISTS getLogList;
DELIMITER //
CREATE PROCEDURE getLogList(Pid int)
BEGIN
    SELECT l.ModifyDate, l.Type, l.SubType, u.UserName, t.TaskName
        FROM LOGS AS l
        JOIN USERS AS u ON u.UserID = l.Maker
        JOIN TASKS AS t ON t.TaskID = l.TaskID
        WHERE l.ProjectID = Pid
    ;
END //
DELIMITER ;


