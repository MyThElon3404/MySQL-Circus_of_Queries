-- QUESTION : 1
-- 1. Find the number of apartments per nationality that are owned by people under 30 years old.
-- Output the nationality along with the number of apartments.
-- Sort records by the apartments count in descending order.

CREATE TABLE airbnb_hosts (
    host_id INT,
    nationality VARCHAR(50),
    gender VARCHAR(10),
    age INT
);
INSERT INTO airbnb_hosts (host_id, nationality, gender, age) VALUES
(0, 'USA', 'M', 28),
(1, 'USA', 'F', 29),
(2, 'China', 'F', 31),
(3, 'China', 'M', 24),
(4, 'Mali', 'M', 30),
(5, 'Mali', 'F', 30),
(6, 'Luxembourg', 'M', 25),
(7, 'Luxembourg', 'F', 25),
(8, 'Australia', 'F', 33),
(9, 'Australia', 'M', 35),
(10, 'Brazil', 'M', 39),
(11, 'Brazil', 'F', 42);

CREATE TABLE airbnb_units (
    host_id INT,
    unit_id VARCHAR(10),
    unit_type VARCHAR(20),
    n_beds INT,
    n_bedrooms INT,
    country VARCHAR(50),
    city VARCHAR(50)
);
INSERT INTO airbnb_units (host_id, unit_id, unit_type, n_beds, n_bedrooms, country, city) VALUES
(0, 'A1', 'Room', 1, 1, 'USA', 'New York'),
(0, 'A2', 'Room', 1, 1, 'USA', 'New Jersey'),
(0, 'A3', 'Room', 1, 1, 'USA', 'New Jersey'),
(1, 'A4', 'Apartment', 2, 1, 'USA', 'Houston'),
(1, 'A5', 'Apartment', 2, 1, 'USA', 'Las Vegas'),
(2, 'A6', 'Yurt', 3, 1, 'Mongolia', NULL),
(3, 'A7', 'Penthouse', 3, 3, 'China', 'Tianjin'),
(3, 'A8', 'Penthouse', 5, 5, 'China', 'Beijing'),
(4, 'A9', 'Apartment', 2, 1, 'Mali', 'Bamako'),
(5, 'A10', 'Room', 3, 1, 'Mali', 'Segou'),
(5, 'A11', 'Room', 2, 1, 'Mali', 'Segou'),
(6, 'A12', 'Penthouse', 6, 6, 'Luxembourg', 'Luxembourg'),
(7, 'A13', 'Room', 4, 1, 'Luxembourg', 'Luxembourg'),
(8, 'A14', 'Apartment', 2, 1, 'Australia', 'Perth'),
(9, 'A15', 'Apartment', 2, 1, 'Australia', 'Perth'),
(9, 'A16', 'Apartment', 2, 1, 'Australia', 'Perth'),
(10, 'A17', 'Room', 4, 1, 'Brazil', 'Rio De Janeiro'),
(10, 'A18', 'Room', 4, 1, 'Argentina', 'Mendoza'),
(10, 'A19', 'Room', 4, 2, 'Uruguay', 'Mercedes'),
(10, 'A20', 'Room', 4, 2, 'Brazil', 'Brasilia'),
(11, 'A21', 'Apartment', 2, 2, 'Mexico', 'Mexico City');

-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

SELECT h.nationality,
    COUNT(u.unit_id) AS apartments_count
FROM airbnb_hosts h
JOIN airbnb_units u
	ON h.host_id = u.host_id
WHERE h.age < 30 
	AND u.unit_type = 'Apartment'
GROUP BY h.nationality
ORDER BY apartments_count DESC;

-- ==================================================================================================================================

-- QUESTION : 2 
-- 2. Rank guests based on the total number of messages they've exchanged with any of the hosts. Guests with the same number of messages as other guests should have the same rank. Do not skip rankings if the preceding rankings are identical.
-- Output the rank, guest id, and number of total messages they've sent. Order by the highest number of total messages first.

CREATE TABLE airbnb_contacts (
    id_guest VARCHAR(255),
    id_host VARCHAR(255),
    id_listing VARCHAR(255),
    ts_contact_at DATETIME,
    ts_reply_at DATETIME,
    ts_accepted_at DATETIME,
    ts_booking_at DATETIME,
    ds_checkin DATETIME,
    ds_checkout DATETIME,
    n_guests INT,
    n_messages INT
);
INSERT INTO airbnb_contacts (id_guest, id_host, id_listing, ts_contact_at, ts_reply_at, ts_accepted_at, ts_booking_at, ds_checkin, ds_checkout, n_guests, n_messages)
VALUES
('86b39b70-965b-479d-a0b0-719b195acea2', '1dfb22ec-c20e-4bf9-b161-1607afa25c5a', 'd668de42-122a-45cd-b91f-91a70895f902', '2014-04-18 09:32:23', '2014-04-18 09:39:06', NULL, NULL, '2014-12-31', '2015-01-02', 7, 5),
('14f943bb-74e9-458b-be55-203dc7220688', '3347390d-8670-4870-9dab-da30f3700141', '14c47fb8-e831-4044-9674-9b3fd0499193', '2014-10-06 06:55:45', '2014-10-06 10:06:38', '2014-10-06 10:06:38', '2014-10-06 10:06:38', '2014-11-03', '2014-11-07', 2, 8),
('425aa1ed-82ab-4ecf-b62f-d61e1848706d', '02cafb86-5445-45cc-80f2-405291578356', 'c5a4a913-a094-4a9d-82e2-0b2d4f9d9eeb', '2014-10-04 05:02:39', '2014-10-04 23:10:01', NULL, NULL, '2014-11-02', '2014-11-09', 2, 2),
('bb490ede-8a70-4d61-a2e8-625855a393e2', 'f49c3095-58de-4b8d-9d5b-3bfceceb47d8', '27f4b429-d544-464f-b4b5-3c09fd5992e7', '2014-08-31 11:46:11', '2014-08-31 16:48:28', NULL, NULL, '2014-11-03', '2014-11-07', 2, 5),
('b2fda15a-89bb-4e6e-ae81-8b21598e2482', '71f1d49e-2ff4-4d72-b8e6-fd4c67feaa74', '95fb78ca-8e6e-436a-9830-949d995ad14f', '2014-10-08 15:07:56', '2014-10-08 15:32:12', '2014-10-08 15:32:12', '2014-10-08 22:21:41', '2014-11-06', '2014-11-09', 2, 10),
('b8831610-31f2-4c58-8ada-63b3601ca476', 'bdd8a691-31e2-48d8-b526-6a75a4363b89', '9633168d-9834-4887-af97-6af7db1d96ab', '2014-10-14 04:05:14', '2014-10-14 08:48:41', '2014-10-14 08:48:41', NULL, '2014-11-07', '2014-11-29', 2, 17),
('136c10f8-af53-4e5a-a5b3-d9c9c495b166', '6dc86890-53d7-4d06-b767-5e117762d76b', '2e6adb00-a660-465e-a85e-c8e341a5fb2f', '2014-12-06 20:24:54', '2014-12-06 20:49:00', '2014-12-06 20:51:56', '2014-12-06 20:51:56', '2014-12-12', '2014-12-14', 2, 13),
('9a45a950-b4f7-4f16-abe6-f9286abf2641', 'beeab7c3-ab4e-45d7-bde9-978de0fd8d57', 'c318d3e3-b36e-43b8-9b0c-3400cbca3895', '2014-10-11 21:15:30', '2014-10-12 09:17:14', NULL, NULL, '2014-10-24', '2014-10-27', 1, 3),
('1759c05e-f12a-4eaa-8059-3bcaca443c88', '200a661e-2758-45e9-8bcc-42e32342e6bd', 'e465ef3d-3c26-4c46-b515-4b24d10bcdf8', '2014-10-31 12:40:58', '2014-10-31 12:55:50', NULL, NULL, '2014-10-31', '2014-11-02', 2, 3),
('126ed661-fa20-4041-ac16-ec118bbcce3b', 'a33e4240-6a0c-47b4-b866-45f9b5952c18', '2d77af55-7f10-41d6-93da-383cf59082b6', '2014-10-03 12:02:49', '2014-10-03 12:05:25', NULL, NULL, '2014-10-25', '2014-10-29', 4, 2),
('924f864f-db83-4945-9a65-cf42a657ca68', '7c0b097b-ea7c-4ea2-967a-8fe38fce6e95', 'f63e28a2-0f72-4b3e-8b5c-46284455ff9a', '2014-10-21 20:57:44', '2014-10-21 21:12:25', '2014-10-23 21:04:47', NULL, '2014-11-09', '2014-11-15', 3, 4),
('bd8f3dd6-fecc-479a-a88f-1d0049600e9f', 'd73772a8-efa3-445c-b9c2-0498fea9815f', '5236a962-7989-4563-9d86-b3c5e5af4d6a', '2014-10-09 07:46:25', '2014-10-09 08:04:13', '2014-10-09 08:04:13', '2014-10-09 09:30:18', '2014-10-10', '2014-10-12', 2, 10),
('679d857b-08b8-4748-b703-86735aa42296', 'd7789520-e8d7-498b-88c4-e997da9b208c', '7d051fe3-84d3-4234-a4cc-1f278f6bb068', '2014-10-11 10:37:00', '2014-10-11 22:30:00', NULL, NULL, '2014-11-03', '2014-11-06', 2, 4);
-- SOLUTION :------------------------------------------------------------------------------------------------------------------------

WITH guest_message_count AS (
    SELECT id_guest,
		SUM(n_messages) AS total_messages
    FROM airbnb_contacts
    GROUP BY id_guest
)
SELECT id_guest,
    total_messages,
    RANK() OVER (ORDER BY total_messages DESC) AS rank,
FROM guest_message_count
ORDER BYtotal_messages DESC, id_guest;
-- ==================================================================================================================================

