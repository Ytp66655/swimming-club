-- 在 Supabase SQL Editor 中运行此文件
-- 签到表：每人每天一条记录（自动去重，彻底杜绝并发覆盖问题）
CREATE TABLE checkins (
  id BIGSERIAL PRIMARY KEY,
  date TEXT NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(date, name)
);

-- 抽奖记录表
CREATE TABLE draws (
  id BIGSERIAL PRIMARY KEY,
  date TEXT NOT NULL,
  winners JSONB NOT NULL DEFAULT '[]',
  pool JSONB NOT NULL DEFAULT '[]',
  count INTEGER NOT NULL DEFAULT 3,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 开放匿名读写权限（签到工具不需要登录）
ALTER TABLE checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE draws ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read checkins" ON checkins FOR SELECT USING (true);
CREATE POLICY "Public insert checkins" ON checkins FOR INSERT WITH CHECK (true);

CREATE POLICY "Public read draws" ON draws FOR SELECT USING (true);
CREATE POLICY "Public insert draws" ON draws FOR INSERT WITH CHECK (true);
