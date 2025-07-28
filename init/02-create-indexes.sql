-- User table indexes
CREATE INDEX idx_user_email ON "users"(email);
CREATE INDEX idx_user_username ON "users"(username);
CREATE INDEX idx_user_org_id ON "users"(orgid);
CREATE INDEX idx_user_department_id ON "users"(departmentid);
CREATE INDEX idx_user_status ON "users"(userstatusid);
CREATE INDEX idx_user_type ON "users"(usertypeid);

-- Organization indexes
CREATE INDEX idx_org_name ON organization(orgname);
CREATE INDEX idx_org_active ON organization(isactive);

-- Composite indexes for common filter combinations
CREATE INDEX idx_user_org_dept ON "users"(orgid, departmentid);
CREATE INDEX idx_user_org_status ON "users"(orgid, userstatusid);

-- Reference table indexes
CREATE INDEX idx_department_active ON department(isactive);
CREATE INDEX idx_usertype_active ON usertype(isactive);
CREATE INDEX idx_userstatus_active ON userstatus(isactive);
CREATE INDEX idx_authtype_active ON authtype(isactive);
