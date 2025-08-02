-- IAM Microservices - Seed Data for Testing
-- This script populates reference tables with test data

-- Clear existing data (optional, for testing)
TRUNCATE TABLE "users", organization, department, usertype, userstatus, authtype RESTART IDENTITY CASCADE;

-- Insert Authentication Types
INSERT INTO authtype (authtypename, description) VALUES 
('EMAIL_PASSWORD', 'Standard email and password authentication'),
('GOOGLE_OAUTH', 'Google OAuth authentication'),
('FACEBOOK_OAUTH', 'Facebook OAuth authentication'),
('GITHUB_OAUTH', 'GitHub OAuth authentication'),
('LINKEDIN_OAUTH', 'LinkedIn OAuth authentication')
ON CONFLICT (authtypename) DO NOTHING;

-- Insert User Statuses
INSERT INTO userstatus (userstatusname, description) VALUES 
('ACTIVE', 'Active user account'),
('INACTIVE', 'Inactive user account'),
('PENDING', 'Pending email verification'),
('SUSPENDED', 'Suspended user account'),
('LOCKED', 'Account locked due to security')
ON CONFLICT (userstatusname) DO NOTHING;

-- Insert User Types (Hierarchical permissions)
INSERT INTO usertype (usertypename, description, permissionlevel) VALUES 
('SUPER_ADMIN', 'System super administrator - full access', 10),
('ORG_ADMIN', 'Organization administrator', 8),
('DEPT_HEAD', 'Department head/manager', 5),
('DEPT_USER', 'Department regular user', 2),
('GUEST_USER', 'Guest/limited access user', 1)
ON CONFLICT (usertypename) DO NOTHING;

-- Insert Test Organizations
INSERT INTO organization (orgname, description) VALUES 
('TechCorp Solutions', 'Technology solutions company for testing'),
('StartupXYZ', 'Startup company for development testing'),
('Enterprise Inc', 'Large enterprise for scale testing')
ON CONFLICT DO NOTHING;

-- Insert Departments for each organization
INSERT INTO department (departmentname, description) VALUES 
('Engineering', 'Software development and engineering'),
('Product Management', 'Product strategy and management'),
('Human Resources', 'HR and people operations'),
('Marketing', 'Marketing and communications'),
('Sales', 'Sales and business development'),
('Finance', 'Financial operations'),
('IT Support', 'Information technology support'),
('General', 'General/unassigned department')
ON CONFLICT DO NOTHING;

-- Verify data insertion
SELECT 'Auth Types:' as table_name, COUNT(*) as count FROM authtype
UNION ALL
SELECT 'User Statuses:', COUNT(*) FROM userstatus  
UNION ALL
SELECT 'User Types:', COUNT(*) FROM usertype
UNION ALL
SELECT 'Organizations:', COUNT(*) FROM organization
UNION ALL
SELECT 'Departments:', COUNT(*) FROM department;

-- Display reference data for easy lookup
SELECT 'Reference Data for API Testing:' as info;
SELECT authtypeid, authtypename FROM authtype ORDER BY authtypeid;
SELECT userstatusid, userstatusname FROM userstatus ORDER BY userstatusid;  
SELECT usertypeid, usertypename, permissionlevel FROM usertype ORDER BY permissionlevel DESC;
SELECT orgid, orgname FROM organization ORDER BY orgid;
SELECT departmentid, departmentname FROM department ORDER BY departmentid;

-- ✅ Insert a test Super Admin User
-- Password should be stored in encrypted form in production.
-- This uses plain text for testing; you may need to hash this in app logic.

INSERT INTO users (
    userid,
    email,
    username,
    name,
    hashedpassword,
    orgid,
    departmentid,
    usertypeid,
    authtypeid,
    userstatusid,
    createdat,
    updatedat,
    lastlogin,
    failedloginattempts,
    accountlocked,
    passwordresettoken,
    passwordresettokenexpiry,
    emailverified,
    emailverificationtoken
)
VALUES (
    gen_random_uuid(),
    'admin@iam.com',
    'superadmin',
    'Super Admin',
    '$2a$10$uDVpL0MG3DR7sEXAMPLEHASHEDPASSWORDzWSrD6VZP3Q.Ct3ai',
    1,                -- orgid
    1,                -- departmentid
    1,                -- usertypeid (SUPER_ADMIN)
    1,                -- authtypeid (EMAIL_PASSWORD)
    1,                -- userstatusid (ACTIVE)
    CURRENT_TIMESTAMP, -- createdat
    CURRENT_TIMESTAMP, -- updatedat
    NULL,             -- lastlogin
    0,                -- failedloginattempts
    FALSE,            -- accountlocked
    NULL,             -- passwordresettoken
    NULL,             -- passwordresettokenexpiry
    TRUE,             -- emailverified
    NULL              -- emailverificationtoken
);

