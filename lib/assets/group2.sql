BEGIN;

DELETE FROM group_users;
DELETE FROM groups;


INSERT INTO groups(id, name) VALUES(1,'チーム柴田');
INSERT INTO group_users(group_id, user_id) VALUES(1,6);
INSERT INTO group_users(group_id, user_id) VALUES(1,21);
INSERT INTO group_users(group_id, user_id) VALUES(1,57);
INSERT INTO group_users(group_id, user_id) VALUES(1,11);
INSERT INTO group_users(group_id, user_id) VALUES(1,18);
INSERT INTO group_users(group_id, user_id) VALUES(1,37);
INSERT INTO group_users(group_id, user_id) VALUES(1,17);

INSERT INTO groups(id, name) VALUES(2,'チーム大西');
INSERT INTO group_users(group_id, user_id) VALUES(2,33);
INSERT INTO group_users(group_id, user_id) VALUES(2,55);
INSERT INTO group_users(group_id, user_id) VALUES(2,5);
INSERT INTO group_users(group_id, user_id) VALUES(2,40);
INSERT INTO group_users(group_id, user_id) VALUES(2,50);
INSERT INTO group_users(group_id, user_id) VALUES(2,63);
INSERT INTO group_users(group_id, user_id) VALUES(2,64);

INSERT INTO groups(id, name) VALUES(3,'チーム光田');
INSERT INTO group_users(group_id, user_id) VALUES(3,25);
INSERT INTO group_users(group_id, user_id) VALUES(3,16);
INSERT INTO group_users(group_id, user_id) VALUES(3,15);
INSERT INTO group_users(group_id, user_id) VALUES(3,35);
INSERT INTO group_users(group_id, user_id) VALUES(3,53);
INSERT INTO group_users(group_id, user_id) VALUES(3,65);
INSERT INTO group_users(group_id, user_id) VALUES(3,46);

INSERT INTO groups(id, name) VALUES(4,'チーム森下');
INSERT INTO group_users(group_id, user_id) VALUES(4,3);
INSERT INTO group_users(group_id, user_id) VALUES(4,32);
INSERT INTO group_users(group_id, user_id) VALUES(4,1);
INSERT INTO group_users(group_id, user_id) VALUES(4,29);
INSERT INTO group_users(group_id, user_id) VALUES(4,48);
INSERT INTO group_users(group_id, user_id) VALUES(4,56);
INSERT INTO group_users(group_id, user_id) VALUES(4,10);

INSERT INTO groups(id, name) VALUES(5,'チーム深田');
INSERT INTO group_users(group_id, user_id) VALUES(5,24);
INSERT INTO group_users(group_id, user_id) VALUES(5,12);
INSERT INTO group_users(group_id, user_id) VALUES(5,13);
INSERT INTO group_users(group_id, user_id) VALUES(5,30);
INSERT INTO group_users(group_id, user_id) VALUES(5,52);
INSERT INTO group_users(group_id, user_id) VALUES(5,42);
INSERT INTO group_users(group_id, user_id) VALUES(5,58);

INSERT INTO groups(id, name) VALUES(6,'チーム戸田');
INSERT INTO group_users(group_id, user_id) VALUES(6,22);
INSERT INTO group_users(group_id, user_id) VALUES(6,62);
INSERT INTO group_users(group_id, user_id) VALUES(6,47);
INSERT INTO group_users(group_id, user_id) VALUES(6,49);
INSERT INTO group_users(group_id, user_id) VALUES(6,31);
INSERT INTO group_users(group_id, user_id) VALUES(6,51);
INSERT INTO group_users(group_id, user_id) VALUES(6,28);
INSERT INTO group_users(group_id, user_id) VALUES(6,27);

INSERT INTO groups(id, name) VALUES(7,'チーム寺本');
INSERT INTO group_users(group_id, user_id) VALUES(7,4);
INSERT INTO group_users(group_id, user_id) VALUES(7,41);
INSERT INTO group_users(group_id, user_id) VALUES(7,9);
INSERT INTO group_users(group_id, user_id) VALUES(7,23);
INSERT INTO group_users(group_id, user_id) VALUES(7,45);
INSERT INTO group_users(group_id, user_id) VALUES(7,20);
INSERT INTO group_users(group_id, user_id) VALUES(7,60);
INSERT INTO group_users(group_id, user_id) VALUES(7,43);

INSERT INTO groups(id, name) VALUES(8,'チーム豊島');
INSERT INTO group_users(group_id, user_id) VALUES(8,26);
INSERT INTO group_users(group_id, user_id) VALUES(8,14);
INSERT INTO group_users(group_id, user_id) VALUES(8,19);
INSERT INTO group_users(group_id, user_id) VALUES(8,34);
INSERT INTO group_users(group_id, user_id) VALUES(8,61);
INSERT INTO group_users(group_id, user_id) VALUES(8,7);
INSERT INTO group_users(group_id, user_id) VALUES(8,59);

COMMIT;