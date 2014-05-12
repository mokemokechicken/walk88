BEGIN;
DELETE FROM groups;
DELETE FROM group_users;

INSERT INTO groups(id, name) VALUES(1, 'ソニックムーブチーム');
INSERT INTO group_users(group_id, user_id) VALUES(1, 75);
INSERT INTO group_users(group_id, user_id) VALUES(1, 70);
INSERT INTO group_users(group_id, user_id) VALUES(1, 72);
INSERT INTO group_users(group_id, user_id) VALUES(1, 69);
INSERT INTO group_users(group_id, user_id) VALUES(1, 76);
INSERT INTO group_users(group_id, user_id) VALUES(1, 79);
INSERT INTO group_users(group_id, user_id) VALUES(1, 81);
INSERT INTO group_users(group_id, user_id) VALUES(1, 82);

INSERT INTO groups(id, name) VALUES(2, 'ゆめみチーム');
INSERT INTO group_users(group_id, user_id) VALUES(2, 78);
INSERT INTO group_users(group_id, user_id) VALUES(2, 22);
INSERT INTO group_users(group_id, user_id) VALUES(2, 21);
INSERT INTO group_users(group_id, user_id) VALUES(2, 80);
INSERT INTO group_users(group_id, user_id) VALUES(2, 83);
INSERT INTO group_users(group_id, user_id) VALUES(2, 24);
INSERT INTO group_users(group_id, user_id) VALUES(2, 14);
INSERT INTO group_users(group_id, user_id) VALUES(2, 6);

COMMIT;
