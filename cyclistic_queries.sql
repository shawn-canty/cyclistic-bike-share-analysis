-- Merging the Cyclistic trip data from the past 12 months into a single working table.
-- Using UNION ALL to combine all rows, without filtering duplicates yet.
CREATE TABLE `cyclistic-analysis-501319.cyclistic_raw_data.combined_tripdata_12_months` AS
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_06`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_07`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_08`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_09`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_10`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_11`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2025_12`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2026_01`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2026_02`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2026_03`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2026_04`
UNION ALL
SELECT * FROM `cyclistic-analysis-501319.cyclistic_raw_data.tripdata_2026_05`;

-- Verifying that the dataset covers the correct 12-month period. 
SELECT
  MIN(started_at) AS first_ride,
  MAX(started_at) AS last_ride
FROM `cyclistic-analysis-501319.cyclistic_raw_data.combined_tripdata_12_months`;
-- Validating the distinct bike types active in the network.
SELECT DISTINCT rideable_type
FROM `cyclistic-analysis-501319.cyclistic_raw_data.combined_tripdata_12_months`;
-- Verifying primary key integrity by identifying duplicate ride_ids.
SELECT
 ride_id,
 COUNT(*) AS duplicate_count
FROM `cyclistic-analysis-501319.cyclistic_raw_data.combined_tripdata_12_months`
GROUP BY
 ride_id
HAVING
 COUNT(*) > 1;
 
-- Generating a deduplicated working table to preserve the raw baseline data.
CREATE TABLE `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata` AS
SELECT DISTINCT *
FROM `cyclistic-analysis-501319.cyclistic_raw_data.combined_tripdata_12_months`;
--Measuring missing data in key areas to decide which filtering methods to use.
SELECT
 SUM(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS null_ride_ids,
 SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS null_start_stations,
 SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS null_end_stations,
 SUM(CASE WHEN member_casual IS NULL THEN 1 ELSE 0 END) AS null_member_casual,
 SUM(CASE WHEN started_at IS NULL THEN 1 ELSE 0 END) AS null_started_at,
 SUM(CASE WHEN ended_at IS NULL THEN 1 ELSE 0 END) AS null_ended_at,
 SUM(CASE WHEN rideable_type IS NULL THEN 1 ELSE 0 END) AS null_rideable_type
FROM
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`;
  
-- Checking if the missing station names are primarily linked to electric, dockless bikes.
SELECT
  rideable_type,
  SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS null_start_stations,
  SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS null_end_stations
FROM
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`
WHERE
  start_station_name IS NULL OR end_station_name IS NULL
GROUP BY
  rideable_type;
  
-- Verifying that the user type column only contains two categories with no formatting errors.
SELECT
  member_casual,
  COUNT(*) AS total_trips
FROM
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`
GROUP BY
  member_casual;
  
-- Verifying types of bikes to ensure no legacy tags or misspellings are present.
SELECT
  rideable_type,
  COUNT(*) AS total_trips
FROM
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`
GROUP BY
  rideable_type;
  
-- Validating the ride duration calculation to ensure accurate behavioral tracking.
SELECT 
  ride_id,
  started_at,
  ended_at,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`
LIMIT 10;

-- Checking that the day-of-week extraction runs correctly for weekly trend analysis.
SELECT 
  ride_id,
  started_at,
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`
LIMIT 10;

-- Checking that the month extraction runs correctly for seasonal trend mapping.
SELECT 
  ride_id,
  started_at,
  EXTRACT(MONTH FROM started_at) AS month
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`
LIMIT 10;

-- Creating a finalized master table for Tableau visualization.
-- This query calculates ride duration and extracts date features for trend analysis,
-- and force-cleans string data to prevent categorical fragmentation.
CREATE TABLE `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata` AS
SELECT 
  ride_id, 
  rideable_type, 
  started_at, 
  ended_at, 
  TRIM(start_station_name) AS start_station_name, 
  start_station_id, 
  TRIM(end_station_name) AS end_station_name, 
  end_station_id, 
  start_lat, 
  start_lng, 
  end_lat, 
  end_lng, 
  member_casual, 
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length, 
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week, 
  EXTRACT(MONTH FROM started_at) AS month 
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.cleaned_tripdata`;
  
-- Establishing overall baselines for total volume and trip duration before segmenting the users.
SELECT 
  COUNT(ride_id) AS total_rides,
  ROUND(AVG(ride_length), 2) AS avg_ride_length_min,
  MAX(ride_length) AS max_ride_length_min,
  MIN(ride_length) AS min_ride_length_min
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata`;
  
-- Identifying the single busiest day of the week for overall network traffic.
SELECT 
  day_of_week, 
  COUNT(ride_id) AS total_rides
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata`
WHERE 
  ride_length > 0 AND ride_length < 1440
GROUP BY 
  day_of_week
ORDER BY 
  total_rides DESC
LIMIT 1;

--Calculating the average trip duration by user type.
SELECT 
  member_casual,
  ROUND(AVG(ride_length), 2) AS average_ride_length_minutes
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata`
WHERE 
  ride_length > 0 AND ride_length < 1440
GROUP BY 
  member_casual;
  
-- Calculating average daily ride duration segmented by user type.
SELECT 
  month,
  member_casual, 
  day_of_week, 
  ROUND(AVG(ride_length), 2) AS average_ride_length_minutes 
FROM `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata` 
WHERE ride_length > 0 AND ride_length < 1440 
GROUP BY 
    month, 
    member_casual, 
    day_of_week 
ORDER BY 
    month, 
    member_casual, 
    day_of_week;
    
-- Calculating total daily traffic volume segmented by user type.
SELECT 
  month,
  member_casual, 
  day_of_week, 
  COUNT(ride_id) AS total_rides 
FROM `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata` 
WHERE ride_length > 0 AND ride_length < 1440 
GROUP BY 
    month, 
    member_casual, 
    day_of_week 
ORDER BY 
    month, 
    member_casual, 
    day_of_week;
    
-- Calculating monthly traffic volume to map seasonal trends by user type.
SELECT 
  month, 
  member_casual, 
  COUNT(ride_id) AS total_rides
FROM 
  `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata`
WHERE 
  ride_length > 0 AND ride_length < 1440
GROUP BY 
  month, 
  member_casual
ORDER BY 
  month, 
  member_casual;
  
-- Identifying the highest-traffic starting stations by user type to map physical network hotspots.
SELECT 
  month,
  start_station_name, 
  member_casual, 
  COUNT(ride_id) AS total_rides 
FROM `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata` 
WHERE ride_length > 0 AND ride_length < 1440 
  AND start_station_name IS NOT NULL 
GROUP BY 
    month, 
    start_station_name, 
    member_casual 
ORDER BY total_rides DESC;

-- Identifying the highest-traffic ending stations by user type to complete the location analysis.
SELECT 
  month,
  end_station_name, 
  member_casual, 
  COUNT(ride_id) AS total_rides 
FROM `cyclistic-analysis-501319.cyclistic_raw_data.master_tripdata` 
WHERE ride_length > 0 AND ride_length < 1440 
  AND end_station_name IS NOT NULL 
GROUP BY 
  month, 
  end_station_name, 
  member_casual 
ORDER BY total_rides DESC;
