USE Kegums;

INSERT INTO banners (url) values ('shocktop_pumpkin.png');
INSERT INTO banners (url) values ('pufo.jpg');
INSERT INTO banners (url) values ('sams_boston.jpg');
INSERT INTO banners (url) values ('sams_october.jpg');
INSERT INTO banners (url) values ('sams_winter.jpg');

INSERT INTO kegs (name, bannerId) VALUES ('Shock Top Pumpkin Wheat', 1);

INSERT INTO temperature (degrees) VALUES (32);

INSERT INTO pours (kegId, volume) VALUES (1, 13);
INSERT INTO pours (kegId, volume) VALUES (1, 8);
INSERT INTO pours (kegId, volume) VALUES (1, 9);
