-- ===============================================================
-- Notification Service Database Schema
-- ===============================================================

-- Notification templates table
CREATE TABLE IF NOT EXISTS notification_templates (
    template_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_name VARCHAR(100) NOT NULL,
    template_type VARCHAR(20) NOT NULL CHECK (template_type IN ('EMAIL', 'SMS', 'PUSH', 'IN_APP')),
    subject VARCHAR(255),
    body_html TEXT,
    body_text TEXT,
    variables TEXT, -- JSON string of available variables
    language VARCHAR(5) DEFAULT 'en',
    is_active BOOLEAN DEFAULT true,
    is_system_template BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    UNIQUE(template_name, template_type, language)
);

-- Notification logs table
CREATE TABLE IF NOT EXISTS notification_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type VARCHAR(20) NOT NULL CHECK (notification_type IN ('EMAIL', 'SMS', 'PUSH', 'IN_APP')),
    recipient VARCHAR(255) NOT NULL,
    template_name VARCHAR(100),
    subject VARCHAR(255),
    content TEXT,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SENT', 'FAILED', 'DELIVERED')),
    provider VARCHAR(50),
    provider_message_id VARCHAR(255),
    error_message TEXT,
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    user_id UUID,
    organization_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User notification preferences table
CREATE TABLE IF NOT EXISTS user_notification_preferences (
    preference_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    notification_category VARCHAR(50) NOT NULL CHECK (notification_category IN ('SECURITY', 'ACCOUNT', 'SYSTEM', 'MARKETING')),
    email_enabled BOOLEAN DEFAULT true,
    sms_enabled BOOLEAN DEFAULT false,
    push_enabled BOOLEAN DEFAULT true,
    in_app_enabled BOOLEAN DEFAULT true,
    frequency VARCHAR(20) DEFAULT 'IMMEDIATE' CHECK (frequency IN ('IMMEDIATE', 'DAILY', 'WEEKLY', 'DISABLED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, notification_category)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_notification_templates_name_type ON notification_templates(template_name, template_type);
CREATE INDEX IF NOT EXISTS idx_notification_templates_active ON notification_templates(is_active);
CREATE INDEX IF NOT EXISTS idx_notification_templates_language ON notification_templates(language);

CREATE INDEX IF NOT EXISTS idx_notification_logs_user_id ON notification_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_notification_logs_type ON notification_logs(notification_type);
CREATE INDEX IF NOT EXISTS idx_notification_logs_status ON notification_logs(status);
CREATE INDEX IF NOT EXISTS idx_notification_logs_created_at ON notification_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_notification_logs_recipient ON notification_logs(recipient);

CREATE INDEX IF NOT EXISTS idx_user_preferences_user_id ON user_notification_preferences(user_id);
CREATE INDEX IF NOT EXISTS idx_user_preferences_category ON user_notification_preferences(notification_category);
