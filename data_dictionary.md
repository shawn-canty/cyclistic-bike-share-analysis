# Data Dictionary: Cyclistic Trip Data

The following table defines the schema for the 5.9 million raw trip records utilized in this analysis.

| Field Name | Data Type | Description |
| :--- | :--- | :--- |
| `ride_id` | String | Primary Key. A unique alphanumeric identifier for each individual bike trip. |
| `rideable_type` | String | The type of bicycle used for the trip (e.g., classic_bike, electric_bike, docked_bike). |
| `started_at` | Timestamp | The exact local date and time the trip began. |
| `ended_at` | Timestamp | The exact local date and time the trip concluded. |
| `start_station_name` | String | The geographic name of the station where the trip originated. |
| `start_station_id` | String | A unique alphanumeric identifier for the starting station. |
| `end_station_name` | String | The geographic name of the station where the trip ended. |
| `end_station_id` | String | A unique alphanumeric identifier for the ending station. |
| `start_lat` | Float | The geographic latitude coordinate of the starting location. |
| `start_lng` | Float | The geographic longitude coordinate of the starting location. |
| `end_lat` | Float | The geographic latitude coordinate of the ending location. |
| `end_lng` | Float | The geographic longitude coordinate of the ending location. |
| `member_casual` | String | The rider's subscription type (either `member` for Annual Members or `casual` for Casual Riders). |
