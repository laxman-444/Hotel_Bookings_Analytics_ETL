-- BRONZE: raw hotel bookings loaded as-is, plus file name and load time
CREATE OR REFRESH STREAMING TABLE bronze_hotel_bookings AS
SELECT *,
       _metadata.file_name AS source_file,
       current_timestamp() AS loaded_at
FROM STREAM read_files('/Volumes/hotel_bookings/default/raw_files/',
                       format => 'csv', header => true);
