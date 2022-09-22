CREATE DATABASE IF NOT EXISTS ulearn;

USE ulearn;

-- ----------------------------
-- Table structure for u_user
-- ----------------------------
DROP TABLE IF EXISTS `u_user`;
CREATE TABLE `u_user` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
	`username` VARCHAR(100) UNIQUE NOT NULL COMMENT '用户名, 邮箱前缀',
	`password` VARCHAR(255) NOT NULL COMMENT '用户密码',
	`email` VARCHAR(100) NOT NULL COMMENT '用户邮箱',
	`createTime` DATETIME NOT NULL COMMENT '用户创建时间',
	`key` VARCHAR(100) NOT NULL COMMENT '加密秘钥',
	PRIMARY KEY (`id`)
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户表';


-- ----------------------------
-- Table structure for u_question
-- ----------------------------
DROP TABLE IF EXISTS `u_question`;
CREATE TABLE `u_question` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '问题ID',
	`userId` BIGINT NOT NULL COMMENT '创建者ID',
	`title` VARCHAR(100) NOT NULL COMMENT '标题',
	`content` VARCHAR(100) NOT NULL COMMENT '内容',
	`create_time` DATETIME NOT NULL COMMENT '创建时间',
	`view` INT DEFAULT 0 COMMENT '浏览次数',
	PRIMARY KEY (`id`)
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='问题表';


-- ----------------------------
-- Table structure for u_answer
-- ----------------------------
DROP TABLE IF EXISTS `u_answer`; 
CREATE TABLE `u_answer` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '回答ID',
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`questionId` BIGINT NOT NULL COMMENT '问题ID',
	`content` VARCHAR(100) NOT NULL COMMENT '内容',
	`createTime` DATETIME NOT NULL COMMENT '创建时间',
	`accepted` BOOL NOT NULL DEFAULT FALSE COMMENT '答案是否被问答这采纳',
	`acceptedTime` DATETIME DEFAULT NULL COMMENT '答案被采纳的时间',
	PRIMARY KEY (`id`),
	FOREIGN KEY (`questionId`)
	REFERENCES u_question(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='问题表';


-- ----------------------------
-- Table structure for u_tag
-- ----------------------------
DROP TABLE IF EXISTS `u_tag`;
CREATE TABLE `u_tag` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签ID',
	`name` VARCHAR(50) NOT NULL COMMENT '标签名',
	PRIMARY KEY (`id`)
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='标签表';

INSERT INTO u_tag(`name`) VALUES('CS');
INSERT INTO u_tag(`name`) VALUES('FAM');
INSERT INTO u_tag(`name`) VALUES('IBM');
INSERT INTO u_tag(`name`) VALUES('IC');
INSERT INTO u_tag(`name`) VALUES('AEE');


-- ----------------------------
-- Table structure for u_question_tag
-- ----------------------------
DROP TABLE IF EXISTS `u_question_tag`;
CREATE TABLE `u_question_tag` (
	`questionId` BIGINT NOT NULL COMMENT '问题ID',
	`tagId` BIGINT NOT NULL COMMENT '标签ID',
	CONSTRAINT unique_q_t UNIQUE (`questionId`, `tagId`) COMMENT '确保同一个问题没有重复使用同一个标签',
	FOREIGN KEY(`questionId`)
	REFERENCES u_question(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='问题及标签联表';


-- ----------------------------
-- Table structure for u_vote_question
-- ----------------------------
DROP TABLE IF EXISTS `u_vote_question`;
CREATE TABLE `u_vote_question` (
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`questionId` BIGINT NOT NULL COMMENT '问题ID',
	`status` BOOL NOT NULL COMMENT '是否为有用, true代表有用, false反之',
	`createTime` DATETIME NOT NULL COMMENT '创建时间',
	CONSTRAINT unique_u_q UNIQUE (`userId`, `questionId`),
	FOREIGN KEY(`questionId`)
	REFERENCES u_question(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户投票及问题联表';


-- ----------------------------
-- Table structure for u_vote_answer
-- ----------------------------
DROP TABLE IF EXISTS `u_vote_answer`;
CREATE TABLE `u_vote_answer` (
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`answerId` BIGINT NOT NULL COMMENT '回答ID',
	`status` BOOL NOT NULL COMMENT '是否为有用, true代表有用, false反之',
	`creat`u_follow_question`eTime` DATETIME NOT NULL COMMENT '创建时间',
	CONSTRAINT unique_u_a UNIQUE (`userId`, `answerId`),
	FOREIGN KEY(`answerId`)
	REFERENCES u_answer(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户投票及回答联表';


-- ----------------------------
-- Table structure for u_follow_question
-- ----------------------------
DROP TABLE IF EXISTS `u_follow_question`;
CREATE TABLE `u_follow_question` (
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`questionId` BIGINT NOT NULL COMMENT '问题ID',
	`createTime` DATETIME NOT NULL COMMENT '关注时间',
	CONSTRAINT unique_u_q UNIQUE (`userId`, `questionId`),
	FOREIGN KEY (`questionId`)
	REFERENCES u_question(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户关注问题联表';


-- ----------------------------
-- Table structure for u_follow_answer
-- ----------------------------
DROP TABLE IF EXISTS `u_follow_answer`;
CREATE TABLE `u_follow_answer` (
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`answerId` BIGINT NOT NULL COMMENT '回答ID',
	`createTime` DATETIME NOT NULL COMMENT '关注时间',
	CONSTRAINT unique_u_a UNIQUE (`userId`, `answerId`),
	FOREIGN KEY (`answerId`)
	REFERENCES u_answer(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户关注问题联表';


-- ----------------------------
-- Table structure for u_bookmark
-- ----------------------------
DROP TABLE IF EXISTS `u_bookmark`;
CREATE TABLE `u_bookmark` (
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`questionId` BIGINT NOT NULL COMMENT '问题ID',
	`groupId` BIGINT DEFAULT NULL COMMENT '用户收藏分组, groupId = 1 为默认分组',
	`createTime` DATETIME NOT NULL COMMENT '收藏时间',
	CONSTRAINT unique_u_q UNIQUE (`userId`, `questionId`, `groupId`),
	FOREIGN KEY (`questionId`)
	REFERENCES u_question(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户收藏问题联表';


-- ----------------------------
-- Table structure for u_bookmark_group
-- ----------------------------
DROP TABLE IF EXISTS `u_bookmark_group`;
CREATE TABLE `u_bookmark_group` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户书签分组',
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`name` VARCHAR(100) NOT NULL COMMENT '标签名称',
	PRIMARY KEY (`id`),
	CONSTRAINT unique_n UNIQUE(`name`)
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户收藏分组表';

INSERT INTO u_bookmark_group VALUES(1, 0, '默认书签分组');

-- ----------------------------
-- Table structure for u_question_comment
-- ----------------------------
DROP TABLE IF EXISTS `u_question_comment`;
CREATE TABLE `u_question_comment` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户评论',
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`questionId` BIGINT NOT NULL COMMENT '问题ID',
	`content` VARCHAR(100) NOT NULL COMMENT '内容',
	`createTime` DATETIME NOT NULL COMMENT '创建时间',
	PRIMARY KEY(`id`),
	FOREIGN KEY (`questionId`)
	REFERENCES u_question(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户问题评论表';


-- ----------------------------
-- Table structure for u_answer_comment
-- ----------------------------
DROP TABLE IF EXISTS `u_answer_comment`;
CREATE TABLE `u_answer_comment` (
	`id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户评论',
	`userId` BIGINT NOT NULL COMMENT '用户ID',
	`answerId` BIGINT NOT NULL COMMENT '回答ID',
	`content` VARCHAR(100) NOT NULL COMMENT '内容',
	`createTime` DATETIME NOT NULL COMMENT '创建时间',
	PRIMARY KEY(`id`),
	FOREIGN KEY (`answerId`)
	REFERENCES u_answer(`id`)
	ON DELETE CASCADE
) ENGINE=INNODB CHARACTER SET=utf8 COMMENT='用户问题评论表';

