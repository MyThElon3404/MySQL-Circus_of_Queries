show tables;

select * from Pieces;
select * from Providers;
select * from provides; 


-- 4.1 Select the name of all the pieces. 
select Name from Pieces;

-- 4.2 Select all the providers' data. 
select * from providers;
 
-- 4.3 Obtain the average price of each piece (show only the piece code and the average price).
select piece, avg(price) 
from Provides 
group by piece;

-- 4.4 Obtain the names of all providers who supply piece 1.
select Name 
from Providers
where Code in (
	select  Provider from provides where Piece = 1
); 

select Providers.Name 
from Providers join Provides
on Providers.Code = Provides.Provider
where Provides.Piece = 1;

/* Without subquery */
 SELECT Providers.Name
   FROM Providers INNER JOIN Provides
          ON Providers.Code = Provides.Provider
             AND Provides.Piece = 1;
             
/* With subquery */
SELECT Name
FROM Providers
WHERE Code IN (
	SELECT Provider FROM Provides WHERE Piece = 1
);


-- 4.5 Select the name of pieces provided by provider with code "HAL".
select Name from Pieces
where Code in (
select Piece from Provides where Provider = 'HAL'
);

select Pieces.Name
from Pieces join Provides
on (Pieces.code = Provides.Piece)
where Provides.Provider = 'HAL';

/* With EXISTS subquery */   
-- Interesting clause
SELECT Name
  FROM Pieces
  WHERE EXISTS(
    SELECT * FROM Provides
      WHERE Provider = 'HAL'
        AND Piece = Pieces.Code
  );


-- 4.6
-- ---------------------------------------------
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Intereting and important one.
-- For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
-- (note that there could be two providers who supply the same piece at the most expensive price).

SELECT Pieces.Name, Providers.Name, Price
  FROM Pieces INNER JOIN Provides ON Pieces.Code = Piece
              INNER JOIN Providers ON Providers.Code = Provider
  WHERE Price =
  (
    SELECT MAX(Price) FROM Provides
    WHERE Piece = Pieces.Code
  );

-- 4.7 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 7 cents each.
INSERT INTO Provides(Piece, Provider, Price) VALUES (1, 'TNBC', 7);

-- 4.8 Increase all prices by one cent.
UPDATE Provides
SET Price = Price + 1;

-- 4.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
DELETE FROM Provides WHERE provider = 'RBT' AND Piece = 4;


-- 4.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces 
-- (the provider should still remain in the database).
DELETE FROM provides
WHERE Provider = 'RBT';


