-- 初始化数据库扩展
CREATE EXTENSION IF NOT EXISTS ltree;
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- 创建目标表
CREATE TABLE IF NOT EXISTS goals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    path LTREE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    priority INTEGER NOT NULL DEFAULT 3 CHECK (priority BETWEEN 1 AND 5),
    progress INTEGER NOT NULL DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
    target_date DATE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT valid_status CHECK (status IN ('active', 'completed', 'archived', 'paused'))
);

-- 创建 ltree 索引以支持层级查询
CREATE INDEX IF NOT EXISTS goals_path_idx ON goals USING GIST (path);
CREATE INDEX IF NOT EXISTS goals_status_idx ON goals (status);
CREATE INDEX IF NOT EXISTS goals_created_at_idx ON goals (created_at DESC);

-- 创建习惯日志表（时间序列）
CREATE TABLE IF NOT EXISTS habit_logs (
    time TIMESTAMPTZ NOT NULL,
    habit_id UUID NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    value NUMERIC,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 转换为 TimescaleDB 超表
SELECT create_hypertable('habit_logs', 'time', if_not_exists => TRUE);

-- 创建习惯定义表
CREATE TABLE IF NOT EXISTS habits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    frequency VARCHAR(20) NOT NULL DEFAULT 'daily',
    trigger_type VARCHAR(20),
    trigger_value TEXT,
    goal_id UUID REFERENCES goals(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_frequency CHECK (frequency IN ('daily', 'weekly', 'count'))
);

-- 创建反思记录表
CREATE TABLE IF NOT EXISTS reflections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    data JSONB,
    goal_id UUID REFERENCES goals(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_type CHECK (type IN ('sport', 'work', 'life'))
);

-- 创建 JSONB 索引
CREATE INDEX IF NOT EXISTS reflections_data_idx ON reflections USING GIN (data);
CREATE INDEX IF NOT EXISTS reflections_type_idx ON reflections (type);
CREATE INDEX IF NOT EXISTS reflections_created_at_idx ON reflections (created_at DESC);

-- 创建知识库表
CREATE TABLE IF NOT EXISTS knowledge_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(20) NOT NULL DEFAULT 'note',
    category VARCHAR(50),
    tags TEXT[],
    source VARCHAR(200),
    tsv TSVECTOR GENERATED ALWAYS AS (
        to_tsvector('english', coalesce(title,'') || ' ' || coalesce(content,''))
    ) STORED,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_knowledge_type CHECK (type IN ('question', 'solution', 'note', 'resource'))
);

-- 创建全文搜索索引
CREATE INDEX IF NOT EXISTS knowledge_entries_tsv_idx ON knowledge_entries USING GIN (tsv);
CREATE INDEX IF NOT EXISTS knowledge_entries_tags_idx ON knowledge_entries USING GIN (tags);

-- 创建知识-目标关联表
CREATE TABLE IF NOT EXISTS knowledge_goal_links (
    knowledge_id UUID NOT NULL REFERENCES knowledge_entries(id) ON DELETE CASCADE,
    goal_id UUID NOT NULL REFERENCES goals(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (knowledge_id, goal_id)
);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为各表创建更新时间触发器
CREATE TRIGGER update_goals_updated_at BEFORE UPDATE ON goals
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_habits_updated_at BEFORE UPDATE ON habits
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reflections_updated_at BEFORE UPDATE ON reflections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_knowledge_entries_updated_at BEFORE UPDATE ON knowledge_entries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 插入示例数据（可选）
-- INSERT INTO goals (path, name, description, priority) VALUES
-- ('Life', '人生愿景', '成为一个有影响力的技术领导者', 1),
-- ('Life.Career', '职业发展', '在技术领域持续成长', 2),
-- ('Life.Career.2025', '2025年目标', '晋升为高级工程师', 2);
