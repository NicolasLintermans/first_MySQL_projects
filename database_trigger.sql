# trigger_time: BEFORE OR AFTER
# tigger_event: INSERT, UPDATE OR DELETE

# user validation (18+) via MySQL

# create and use database 'trigger_user'
CREATE DATABASE trigger_user;
USE trigger_user


# create users table
CREATE TABLE users(
    username VARCHAR(100) NOT NULL,
    age INT NOT NULL
    );


# insert data into users table
INSERT INTO users(username, age) VALUES("Nicolas", 25);


# create the user trigger
DELIMITER $$    # the delimiter is now set to two dollar signs, since our code block consists of multiple ';', and we want every line executed 
CREATE TRIGGER is_adult
    BEFORE INSERT ON users FOR EACH ROW    # trigger_time = BEFORE, trigger_event = INSERT, table = users
    BEGIN
        IF NEW.age < 18    # NEW is a placeholder for new (potential) user entry
            THEN
                SIGNAL SQLSTATE '45000'    # generic "unhandled user-defined exception"
                    SET MESSAGE_TEXT = 'You have to be at least 18 years old.';
        END IF;
    END;    # the code between BEGIN and END will run every time before inserting a new user in the users table and will check whether the 'if' condition between IF and END IF (i.e. age < 18) is satisfied or not
$$    # so: this is where the code block 'stops'


DELIMITER ;    # set delimiter back to ;


# This statement results in no error (as is desired: age >= 18)
INSERT INTO users(username, age) VALUES ("Laurence", 28);


# This statement results in an error (as is desired: age < 18)
INSERT INTO users(username, age) VALUES ("Thomas", 14);
# Error message: ERROR 1644 (45000): You have to be at least 18 years old.


# Double-check to make sure
SELECT * FROM users;
# Output:
# +----------+-----+
# | username | age |
# +----------+-----+
# | Nicolas  |  25 |
# | Laurence |  28 |
# +----------+-----+
# 2 rows in set (0.00 sec)
# So: the user trigger works, Thomas (aged 14) is not added









