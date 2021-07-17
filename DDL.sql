--清空資料庫
USE master;
GO
DROP DATABASE IF EXISTS big_DB;
GO

--資料庫
CREATE DATABASE big_DB;
GO

--切換使用中的資料庫
USE big_DB;
GO

--建立tables
CREATE TABLE dbo.survey
(
survey_id   INT     NOT NULL,
age_type    INT     NOT NULL,
survey_type INT     NOT NULL,
year        INT     NOT NULL,
wave        INT     NOT NULL,

CONSTRAINT PK_survey_survey_id PRIMARY KEY CLUSTERED ( survey_id)
);

CREATE TABLE dbo.auth
(
class_id    INT             NOT NULL,
class       NVARCHAR( 4000) NOT NULL,
min_auth    INT             NOT NULL,

CONSTRAINT PK_auth_class_id PRIMARY KEY CLUSTERED ( class_id)
);

CREATE TABLE dbo.problems
(
problem_id      VARCHAR( 30)    NOT NULL,
topic           NVARCHAR( 4000) NOT NULL,
class_id        INT             NOT NULL,
problem_type    NVARCHAR( 4000) NOT NULL,

CONSTRAINT PK_problems_problem_id PRIMARY KEY CLUSTERED ( problem_id),
CONSTRAINT FK_problems_class_id FOREIGN KEY ( class_id) REFERENCES dbo.auth ( class_id)
);

CREATE TABLE dbo.survey_problem
(
survey_id   INT             NOT NULL,
problem_id  VARCHAR( 30)    NOT NULL,

CONSTRAINT PK_survey_problem_survey_id_problem_id PRIMARY KEY CLUSTERED ( survey_id, problem_id),
CONSTRAINT FK_survey_problem_survey_id FOREIGN KEY ( survey_id) REFERENCES dbo.survey ( survey_id),
CONSTRAINT FK_survey_problem_problem_id FOREIGN KEY ( problem_id) REFERENCES dbo.problems ( problem_id)
);

CREATE TABLE dbo.answer
(
answer_id   BIGINT          NOT NULL,
problem_id  VARCHAR( 30)    NOT NULL,
survey_id   INT             NOT NULL,
answer      NVARCHAR( 4000),

CONSTRAINT PK_answer_answer_id_problem_id PRIMARY KEY CLUSTERED ( answer_id, problem_id),
CONSTRAINT FK_answer_survey_id FOREIGN KEY ( survey_id) REFERENCES dbo.survey ( survey_id),
CONSTRAINT FK_answer_problem_id FOREIGN KEY ( problem_id) REFERENCES dbo.problems ( problem_id)
);

CREATE TABLE dbo.tag_value
(
problem_id  VARCHAR( 30)    NOT NULL,
tag_value   INT,
tag_name    NVARCHAR( 4000) NOT NULL,

CONSTRAINT PK_tag_value_problem_id PRIMARY KEY CLUSTERED ( problem_id),
CONSTRAINT FK_tag_value_problem_id FOREIGN KEY ( problem_id) REFERENCES dbo.problems ( problem_id)
);

CREATE TABLE dbo.account
(
user_id         INT             NOT NULL,
account_name    NVARCHAR( 4000) NOT NULL,
email           NVARCHAR( 4000) NOT NULL,
password        VARCHAR( 200)   NOT NULL,
auth            INT             NOT NULL,

CONSTRAINT PK_account_user_id PRIMARY KEY CLUSTERED ( user_id)
);

CREATE TABLE dbo.auth_change_log
(
datetime    datetime        NOT NULL,
admin_id    INT             NOT NULL,
user_id     INT             NOT NULL,
old_auth    INT             NOT NULL,
new_auth    INT             NOT NULL,
reason      NVARCHAR( 4000) NOT NULL,

CONSTRAINT PK_auth_change_log_datetime PRIMARY KEY CLUSTERED ( datetime),
CONSTRAINT FK_auth_change_log_admin_id FOREIGN KEY ( admin_id) REFERENCES dbo.account ( user_id),
CONSTRAINT FK_auth_change_log_user_id FOREIGN KEY ( user_id) REFERENCES dbo.account ( user_id)
);

GO

USE master;
GO
