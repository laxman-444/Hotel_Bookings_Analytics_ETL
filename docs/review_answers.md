# Answers to the Project Review Questions

**1. Why do we keep the raw data in Bronze instead of cleaning the file directly?**
Bronze is an exact copy of the source. If a cleaning rule turns out to be wrong, or we need to audit a number later, we can re-run Silver from the original data. Cleaning the file directly would destroy that evidence.

**2. Why is a cancelled booking kept, but a booking with check-out before check-in rejected?**
A cancelled booking is a normal business event, so it is valid data and we need it to calculate the cancellation rate. A check-out on or before check-in is impossible, so it must be a data error.

**3. Why can `booking_id` find duplicates but `guest_id` cannot?**
`booking_id` identifies one booking, so it should appear once. `guest_id` identifies a guest, and one guest can make many bookings, so repeating is normal.

**4. How does DATEDIFF fill a blank nights value, and what happens if you swap its arguments?**
`DATEDIFF(check_out_date, check_in_date)` counts the days from check-in to check-out, so 20 April to 23 April gives 3. If you swap the arguments, the result becomes negative (-3), which would break nights, total amount and room nights.

**5. Why do we leave a blank rating as NULL instead of replacing it with 0?**
A 0 would be treated as a real rating and would pull the average down. NULL means "no rating", and `AVG` skips NULLs, so the average only uses real ratings.

**6. What is the average daily rate (ADR), and why is it calculated as net revenue / room nights?**
ADR is the average revenue earned per room per night. Dividing total net revenue by total room nights weights every stay by its length. Averaging each booking's rate would give a 1-night stay the same weight as a 7-night stay.

**7. Which booking channel has the highest cancellation rate?**
The Website channel has the highest cancellation rate at **15.8%** (71 of 449 bookings), followed closely by Mobile App at 15.3%. Walk In is much lower at 8.9%. (Check these against your own `gold_channel_summary` after running.)

**8. Which dashboard tool did you choose, and why?**
Databricks AI/BI. It reads the Gold tables directly in the same workspace, needs no connection setup, refreshes right after a pipeline run, and works on Free Edition.
