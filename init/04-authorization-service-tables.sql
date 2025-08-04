-- ===============================================================
-- Authorization Service Database Schema
-- ===============================================================

-- Roles table
CREATE TABLE IF NOT EXISTS roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    org_id INTEGER NOT NULL,
    department_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    is_system_role BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID
);

-- Permissions table
CREATE TABLE IF NOT EXISTS permissions (
    permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permission_name VARCHAR(100) NOT NULL UNIQUE,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    is_system_permission BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    updated_by UUID,
    UNIQUE(resource, action)
);

-- User-Role mapping table
CREATE TABLE IF NOT EXISTS user_roles (
    user_role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    role_id UUID NOT NULL REFERENCES roles(role_id),
    granted_by UUID,
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMP,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, role_id)
);

-- Role-Permission mapping table
CREATE TABLE IF NOT EXISTS role_permissions (
    role_permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(role_id),
    permission_id UUID NOT NULL REFERENCES permissions(permission_id),
    granted_by UUID,
    is_active BOOLEAN DEFAULT true,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, permission_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_roles_org_id ON roles(org_id);
CREATE INDEX IF NOT EXISTS idx_roles_department_id ON roles(department_id);
CREATE INDEX IF NOT EXISTS idx_roles_active ON roles(is_active);
CREATE INDEX IF NOT EXISTS idx_roles_system ON roles(is_system_role);

CREATE INDEX IF NOT EXISTS idx_permissions_resource ON permissions(resource);
CREATE INDEX IF NOT EXISTS idx_permissions_action ON permissions(action);
CREATE INDEX IF NOT EXISTS idx_permissions_active ON permissions(is_active);

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_active ON user_roles(is_active);
CREATE INDEX IF NOT EXISTS idx_user_roles_expires ON user_roles(expires_at);

CREATE INDEX IF NOT EXISTS idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_permission_id ON role_permissions(permission_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_active ON role_permissions(is_active);

-- ===============================================================
-- System Data (Default Roles and Permissions)
-- ===============================================================

-- System Permissions
INSERT INTO permissions (permission_name, resource, action, description, is_system_permission) VALUES
('users.read', 'users', 'read', 'Read user information', true),
('users.write', 'users', 'write', 'Create and update users', true),
('users.delete', 'users', 'delete', 'Delete users', true),
('users.admin', 'users', 'admin', 'Full user administration', true),

('roles.read', 'roles', 'read', 'Read role information', true),
('roles.write', 'roles', 'write', 'Create and update roles', true),
('roles.delete', 'roles', 'delete', 'Delete roles', true),
('roles.assign', 'roles', 'assign', 'Assign roles to users', true),

('permissions.read', 'permissions', 'read', 'Read permission information', true),
('permissions.write', 'permissions', 'write', 'Create and update permissions', true),
('permissions.delete', 'permissions', 'delete', 'Delete permissions', true),

('organizations.read', 'organizations', 'read', 'Read organization information', true),
('organizations.write', 'organizations', 'write', 'Create and update organizations', true),
('organizations.admin', 'organizations', 'admin', 'Full organization administration', true),

('system.admin', 'system', 'admin', 'Full system administration', true)
ON CONFLICT (permission_name) DO NOTHING;

-- System Roles
INSERT INTO roles (role_name, description, org_id, is_system_role) VALUES
('SUPER_ADMIN', 'Full system administrator with all permissions', 1, true),
('ORG_ADMIN', 'Organization administrator', 1, true),
('DEPT_MANAGER', 'Department manager with user management rights', 1, true),
('USER', 'Standard user with basic permissions', 1, true),
('GUEST', 'Guest user with read-only access', 1, true)
ON CONFLICT (role_name) DO NOTHING;

-- Assign permissions to SUPER_ADMIN role
INSERT INTO role_permissions (role_id, permission_id, is_active)
SELECT 
    (SELECT role_id FROM roles WHERE role_name = 'SUPER_ADMIN'),
    permission_id,
    true
FROM permissions
WHERE is_system_permission = true
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Assign basic permissions to USER role
INSERT INTO role_permissions (role_id, permission_id, is_active)
SELECT 
    (SELECT role_id FROM roles WHERE role_name = 'USER'),
    permission_id,
    true
FROM permissions
WHERE permission_name IN ('users.read', 'organizations.read')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Assign read permissions to GUEST role
INSERT INTO role_permissions (role_id, permission_id, is_active)
SELECT 
    (SELECT role_id FROM roles WHERE role_name = 'GUEST'),
    permission_id,
    true
FROM permissions
WHERE action = 'read'
ON CONFLICT (role_id, permission_id) DO NOTHING;