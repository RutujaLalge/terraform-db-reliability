-- Seed hotel_bookings with 150 fake rows across multiple cities, orgs, statuses
INSERT INTO hotel_bookings (id, org_id, hotel_id, city, checkin_date, checkout_date, amount, status, created_at)
SELECT
    gen_random_uuid(),
    (ARRAY[
        '11111111-1111-1111-1111-111111111111',
        '22222222-2222-2222-2222-222222222222',
        '33333333-3333-3333-3333-333333333333'
    ]::uuid[])[1 + floor(random() * 3)::int],
    'hotel_' || (1 + floor(random() * 20))::int,
    (ARRAY['delhi', 'mumbai', 'bangalore', 'pune', 'chennai'])[1 + floor(random() * 5)::int],
    CURRENT_DATE + (floor(random() * 30))::int,
    CURRENT_DATE + (floor(random() * 30) + 1)::int,
    round((500 + random() * 9500)::numeric, 2),
    (ARRAY['confirmed', 'cancelled', 'pending', 'completed'])[1 + floor(random() * 4)::int],
    NOW() - (floor(random() * 60) || ' days')::interval
FROM generate_series(1, 150);

-- Seed booking_events for roughly half the bookings
INSERT INTO booking_events (booking_id, event_type, payload, created_at)
SELECT
    id,
    (ARRAY['created', 'payment_received', 'cancelled', 'checked_in'])[1 + floor(random() * 4)::int],
    jsonb_build_object('note', 'auto-generated event', 'source', 'seed_script'),
    created_at + (floor(random() * 5) || ' hours')::interval
FROM hotel_bookings
WHERE random() < 0.5;
