-- ╔══════════════════════════════════════════════════════════╗
-- ║  SITE SETTINGS (cấu hình website)                        ║
-- ╚══════════════════════════════════════════════════════════╝

CREATE TABLE IF NOT EXISTS site_settings (
    id TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- RLS Policies
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "everyone can read site settings" ON site_settings
    FOR SELECT USING (true);

CREATE POLICY "admin can manage site settings" ON site_settings
    FOR ALL USING (
        EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
    );

-- Insert default sidebar settings
INSERT INTO site_settings (id, value)
VALUES (
    'sidebar',
    '{"title": "Gia phả họ Lê", "contact_phone": "088 999 1120", "contact_message": "Để thiết lập gia phả điện tử riêng cho dòng họ, truy cập được từ bất kì đâu, vui lòng liên hệ", "contact_note": "để nhận báo giá."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET value = EXCLUDED.value;
