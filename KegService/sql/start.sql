USE Kegums;

INSERT INTO drinkers (name) values ('Bash');
INSERT INTO drinkers (name) values ('Tim');
INSERT INTO drinkers (name) values ('Trun');
INSERT INTO drinkers (name) values ('Marc');

INSERT INTO kegs (name) VALUES ('Shock Top Pumpkin Wheat');

INSERT INTO temperature (degrees) VALUES (32);

INSERT INTO pours (kegId, volume, drinkerId) VALUES (1, 13, 1);
INSERT INTO pours (kegId, volume) VALUES (1, 8);
INSERT INTO pours (kegId, volume, drinkerId) VALUES (1, 9, 4);

UPDATE kegs SET kicked = NOW() WHERE id = 1;

INSERT INTO kegs (name) VALUES ('Sam Adams Winter Lager');

INSERT INTO pours (kegId, volume, drinkerId) VALUES (2, 8, 1);

INSERT INTO pours (kegId, volume) VALUES (2, 6);
INSERT INTO pours (kegId, volume) VALUES (2, 10);

INSERT INTO pours (kegId, volume, drinkerId) VALUES (2, 10, 1);
INSERT INTO pours (kegId, volume, drinkerId) VALUES (2, 11, 2);
INSERT INTO pours (kegId, volume, drinkerId) VALUES (2, 9, 3);
