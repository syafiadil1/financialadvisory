package model;

public class UserModel {

    private Integer userId;
    private String name;
    private String password;
    private String email;
    private Integer roleId;
    private String roleName;
    private Integer departmentId;
    private String departmentName;
    private String salt;

    public UserModel() {}

    public UserModel(Integer userId,
                     String name,
                     String password,
                     String email,
                     Integer roleId,
                     String roleName,
                     Integer departmentId,
                     String departmentName,
                     String salt) {

        this.userId = userId;
        this.name = name;
        this.password = password;
        this.email = email;
        this.roleName = roleName;
        this.departmentName = departmentName;
        this.roleId = roleId;
        this.departmentId = departmentId;
        this.salt = salt;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }
    
    public String getRoleName() {
		return roleName;
	}
    
    public void setRoleName(String roleName) {
    	this.roleName = roleName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }
    
    public void setSalt(String salt) {
		this.salt = salt;
	}
    
    public String getSalt() {
		return salt;
	}
}