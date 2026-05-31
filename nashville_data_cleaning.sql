USE PortfolioProject;

-- Skip the ALTER TABLE, just run the UPDATE directly
UPDATE nashville_housing
SET PropertyStreet = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    PropertyCity = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

-- Now run the rest
UPDATE nashville_housing
SET SoldAsVacant = CASE
  WHEN SoldAsVacant = 'Y' THEN 'Yes'
  WHEN SoldAsVacant = 'N' THEN 'No'
  ELSE SoldAsVacant
END;

SELECT SoldAsVacant, COUNT(*) as count
FROM nashville_housing
GROUP BY SoldAsVacant;

SELECT LandUse,
  COUNT(*) AS total_sales,
  ROUND(AVG(SalePrice),0) AS avg_price,
  MIN(SalePrice) AS min_price,
  MAX(SalePrice) AS max_price
FROM nashville_housing
WHERE SalePrice IS NOT NULL
GROUP BY LandUse
ORDER BY avg_price DESC;

SELECT
  SUM(CASE WHEN PropertyAddress IS NULL THEN 1 ELSE 0 END) AS null_addresses,
  SUM(CASE WHEN SalePrice IS NULL THEN 1 ELSE 0 END) AS null_prices,
  SUM(CASE WHEN OwnerName IS NULL THEN 1 ELSE 0 END) AS null_owners,
  COUNT(*) AS total_records
FROM nashville_housing;

SELECT
  YEAR(STR_TO_DATE(SaleDate,'%Y-%m-%d')) AS sale_year,
  COUNT(*) AS total_sales,
  ROUND(AVG(SalePrice),0) AS avg_sale_price
FROM nashville_housing
WHERE SalePrice IS NOT NULL
GROUP BY sale_year
ORDER BY sale_year;

CREATE OR REPLACE VIEW v_clean_nashville AS
SELECT UniqueID, ParcelID, LandUse,
  PropertyStreet, PropertyCity,
  SaleDate, SalePrice, SoldAsVacant,
  OwnerName, TotalValue, YearBuilt, Bedrooms
FROM nashville_housing
WHERE SalePrice IS NOT NULL
  AND OwnerName IS NOT NULL;

SELECT * FROM v_clean_nashville;