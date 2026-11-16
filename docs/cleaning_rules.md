# Cleaning Rules and Why

Source: `hotel_bookings_raw.csv` (1,316 rows, 20 columns, synthetic 2025 hotel stays). All rules run in `silver_bookings_clean`, and bad rows are saved with a reason in `silver_bookings_rejected`.

| # | Problem found | Rule applied | SQL used | Why |
|---|---|---|---|---|
| 1 | Duplicate bookings | Keep one copy of each row | `SELECT DISTINCT` | `booking_id` must be unique, so extra copies inflate bookings and revenue |
| 2 | Extra spaces and mixed case in city, room type, booking channel, meal plan | Trim spaces, convert to Title Case | `INITCAP(TRIM(col))` | The same value must not appear as several groups in reports |
| 3 | Blank city or booking channel | Replace with `Unknown` | `COALESCE(..., 'Unknown')` | The booking is still valid, so we keep it and show the gap openly |
| 4 | Blank nights | Calculate from the dates | `COALESCE(nights, DATEDIFF(check_out_date, check_in_date))` | The answer is already in the data |
| 5 | Blank total amount | Calculate nights x room rate | `COALESCE(total_amount, DATEDIFF(...) * room_rate)` | This is the business formula for the amount |
| 6 | Blank guest rating or guest ID | Leave as is | no change | Cancelled stays have no rating, and `AVG` skips blanks |
| 7 | Check-out on or before check-in | Remove from clean table, save in rejected table | `EXPECT (check_out_date > check_in_date) ON VIOLATION DROP ROW` | A stay cannot end before it starts |
| 8 | Negative room rate | Remove from clean table, save in rejected table | `EXPECT (room_rate >= 0) ON VIOLATION DROP ROW` | A negative price is impossible |
| 9 | Cancelled bookings | Keep in Silver, exclude from revenue and room nights in Gold | `CASE WHEN booking_status = 'Completed'` | Cancellation is a normal business event, not a data error |
| 10 | Payment method text | Do not use INITCAP | no change | INITCAP would turn `UPI` into `Upi` |

**Reconciliation:** Bronze rows = clean rows + rejected rows + duplicates removed. The PDF's reference run gives 1,316 = 1,269 + 21 + 26. Replace with your own numbers after running.
