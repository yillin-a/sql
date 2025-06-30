package org.example.demo111.model;

/**
 * 专业实体类
 */
public class Major {
    private Integer hylMno10;           // 专业编号
    private String hylMname10;          // 专业名称
    private String hylMdegree10;        // 学位类型
    private Integer hylMyears10;        // 学制年限
    private Integer hylFno10;           // 所属学院编号
    
    // 关联字段
    private String facultyName;         // 学院名称
    private Integer studentCount;       // 学生数量
    
    // 构造函数
    public Major() {}
    
    public Major(String hylMname10, String hylMdegree10, Integer hylMyears10, Integer hylFno10) {
        this.hylMname10 = hylMname10;
        this.hylMdegree10 = hylMdegree10;
        this.hylMyears10 = hylMyears10;
        this.hylFno10 = hylFno10;
    }
    
    // Getter和Setter方法
    public Integer getHylMno10() { return hylMno10; }
    public void setHylMno10(Integer hylMno10) { this.hylMno10 = hylMno10; }
    
    public String getHylMname10() { return hylMname10; }
    public void setHylMname10(String hylMname10) { this.hylMname10 = hylMname10; }
    
    public String getHylMdegree10() { return hylMdegree10; }
    public void setHylMdegree10(String hylMdegree10) { this.hylMdegree10 = hylMdegree10; }
    
    public Integer getHylMyears10() { return hylMyears10; }
    public void setHylMyears10(Integer hylMyears10) { this.hylMyears10 = hylMyears10; }
    
    public Integer getHylFno10() { return hylFno10; }
    public void setHylFno10(Integer hylFno10) { this.hylFno10 = hylFno10; }
    
    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }
    
    public Integer getStudentCount() { return studentCount; }
    public void setStudentCount(Integer studentCount) { this.studentCount = studentCount; }
    
    @Override
    public String toString() {
        return "Major{" +
               "hylMno10=" + hylMno10 +
               ", hylMname10='" + hylMname10 + '\'' +
               ", hylMdegree10='" + hylMdegree10 + '\'' +
               ", hylMyears10=" + hylMyears10 +
               ", hylFno10=" + hylFno10 +
               ", facultyName='" + facultyName + '\'' +
               ", studentCount=" + studentCount +
               '}';
    }
} 