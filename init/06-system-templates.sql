- ===============================================================
-- System Templates (Email)
-- ===============================================================

-- Welcome Email Template
INSERT INTO notification_templates (template_name, template_type, subject, body_html, body_text, variables, language, is_system_template) VALUES
('welcome', 'EMAIL', 'Welcome to IAM System!',
'<html>
<body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; text-align: center;">
        <h1 style="color: white; margin: 0;">Welcome to IAM System!</h1>
    </div>
    <div style="padding: 30px; background: #f8f9fa;">
        <h2 style="color: #333;">Hello [[${name}]]!</h2>
        <p style="color: #666; line-height: 1.6;">
            Welcome to our Identity and Access Management System. Your account has been successfully created and you can now access all the features available to you.
        </p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="[[${loginUrl}]]" style="background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
                Login to Your Account
            </a>
        </div>
        <p style="color: #666; font-size: 14px;">
            If you have any questions, please contact our support team at <a href="mailto:[[${supportEmail}]]">[[${supportEmail}]]</a>
        </p>
    </div>
    <div style="background: #e9ecef; padding: 20px; text-align: center; font-size: 12px; color: #666;">
        <p>© 2024 IAM System. All rights reserved.</p>
    </div>
</body>
</html>',
'Hello [[${name}]]!

Welcome to our Identity and Access Management System. Your account has been successfully created.

Login URL: [[${loginUrl}]]

If you have any questions, contact support at [[${supportEmail}]]

© 2024 IAM System. All rights reserved.',
'{"name": "User full name", "loginUrl": "Login page URL", "supportEmail": "Support email address"}',
'en', true),

-- Password Reset Template
('password-reset', 'EMAIL', 'Reset Your Password',
'<html>
<body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: #dc3545; padding: 30px; text-align: center;">
        <h1 style="color: white; margin: 0;">Password Reset Request</h1>
    </div>
    <div style="padding: 30px; background: #f8f9fa;">
        <h2 style="color: #333;">Password Reset</h2>
        <p style="color: #666; line-height: 1.6;">
            You have requested to reset your password. Click the button below to create a new password.
        </p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="[[${resetUrl}]]" style="background: #dc3545; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
                Reset Password
            </a>
        </div>
        <p style="color: #666; font-size: 14px;">
            This link will expire in [[${expiryHours}]] hours. If you did not request this reset, please ignore this email.
        </p>
    </div>
</body>
</html>',
'Password Reset Request

You have requested to reset your password. Use the link below:
[[${resetUrl}]]

This link expires in [[${expiryHours}]] hours.

If you did not request this reset, please ignore this email.',
'{"resetUrl": "Password reset URL", "expiryHours": "Expiry time in hours"}',
'en', true),

-- Security Alert Template
('security-alert', 'EMAIL', 'Security Alert - Action Required',
'<html>
<body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: #ffc107; padding: 30px; text-align: center;">
        <h1 style="color: #212529; margin: 0;">🔒 Security Alert</h1>
    </div>
    <div style="padding: 30px; background: #f8f9fa;">
        <h2 style="color: #dc3545;">Security Event Detected</h2>
        <p style="color: #666; line-height: 1.6;">
            We detected a security event on your account: <strong>[[${alertType}]]</strong>
        </p>
        <p style="color: #666;">
            <strong>Time:</strong> [[${timestamp}]]
        </p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="[[${actionUrl}]]" style="background: #dc3545; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
                Review Security Settings
            </a>
        </div>
        <p style="color: #666; font-size: 14px;">
            If this was not you, please contact support immediately.
        </p>
    </div>
</body>
</html>',
'🔒 SECURITY ALERT

Security event detected: [[${alertType}]]
Time: [[${timestamp}]]

Review your security settings: [[${actionUrl}]]

If this was not you, contact support immediately.',
'{"alertType": "Type of security alert", "timestamp": "Event timestamp", "actionUrl": "Security settings URL"}',
'en', true),

-- Role Change Template
('role-change', 'EMAIL', 'Your Role Has Been Updated',
'<html>
<body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
    <div style="background: #28a745; padding: 30px; text-align: center;">
        <h1 style="color: white; margin: 0;">Role Update Notification</h1>
    </div>
    <div style="padding: 30px; background: #f8f9fa;">
        <h2 style="color: #333;">Your Role Has Been [[${action}]]</h2>
        <p style="color: #666; line-height: 1.6;">
            Your role <strong>[[${roleName}]]</strong> has been [[${action}]] on [[${timestamp}]].
        </p>
        <p style="color: #666;">
            This change affects your access permissions within the system.
        </p>
    </div>
</body>
</html>',
'Role Update Notification

Your role [[${roleName}]] has been [[${action}]] on [[${timestamp}]].

This change affects your access permissions within the system.',
'{"roleName": "Role name", "action": "assigned/revoked", "timestamp": "Change timestamp"}',
'en', true)
ON CONFLICT (template_name, template_type, language) DO NOTHING;