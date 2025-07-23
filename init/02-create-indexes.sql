-- Performance indexes for common queries

-- User table indexes
CREATE INDEX idx_user_email ON User(Email);
CREATE INDEX idx_user_username ON User(Username);
CREATE INDEX idx_user_org_id ON User(OrgID);
CREATE INDEX idx_user_department_id ON User(DepartmentID);
CREATE INDEX idx_user_status ON User(UserStatusID);
CREATE INDEX idx_user_type ON User(UserTypeID);

-- Organization indexes
CREATE INDEX idx_org_name ON Organization(OrgName);
CREATE INDEX idx_org_active ON Organzation(IsActive);

-- Composite indexes for common filter combinations
CREATE INDEX idx_user_org_dept ON User(OrgId, DepartmentID);
CREATE INDEX idx_user_org_status ON User(OrgID, UserStatusID);

-- Rerence table indexes
CREATE INDEX idx_department_active ON Department(IsActive);
CREATE INDEX idx_usertype_active ON UserType(IsActive);
CREATE INDEX idx_userstatus_active ON UserStatus(IsActive);
CREATE INDEX idx_authtype_active ON AuthType(IsActive);
