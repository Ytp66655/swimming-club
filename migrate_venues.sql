-- Run once in the Supabase SQL Editor before publishing the new page.
-- Existing check-ins are preserved as "未标注场馆".
BEGIN;
ALTER TABLE checkins ADD COLUMN IF NOT EXISTS venue TEXT;
UPDATE checkins SET venue = '未标注场馆' WHERE venue IS NULL OR BTRIM(venue) = '';
ALTER TABLE checkins ALTER COLUMN venue SET NOT NULL;
ALTER TABLE checkins DROP CONSTRAINT IF EXISTS checkins_date_name_key;
ALTER TABLE checkins DROP CONSTRAINT IF EXISTS checkins_date_name_venue_key;
ALTER TABLE checkins ADD CONSTRAINT checkins_date_name_venue_key UNIQUE (date, name, venue);
ALTER TABLE checkins DROP CONSTRAINT IF EXISTS checkins_venue_check;
ALTER TABLE checkins ADD CONSTRAINT checkins_venue_check CHECK (venue IN ('上海游泳馆', '周浦游泳馆', '未标注场馆'));
COMMIT;