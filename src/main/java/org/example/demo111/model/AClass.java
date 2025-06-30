package org.example.demo111.model;

/**
 * 行政班实体类
 * 对应数据库表 huyl_aclass10
 */
public class AClass {
    private Integer hylAcno10;          // 行政班编号
    private String hylAcname10;         // 行政班名称
    private Integer hylAcyear10;        // 入学年份
    private Integer hylAcmaxstu10;      // 班级人数上限
    private Integer hylMno10;           // 专业编号
    
    // 关联信息（非数据库字段）
    private String majorName;           // 专业名称
    private String facultyName;         // 学院名称
    private Integer currentStudents;    // 当前学生数
    
    public AClass() {}
    
    public AClass(Integer hylAcno10, String hylAcname10, Integer hylAcyear10, 
                  Integer hylAcmaxstu10, Integer hylMno10) {
        this.hylAcno10 = hylAcno10;
        this.hylAcname10 = hylAcname10;
        this.hylAcyear10 = hylAcyear10;
        this.hylAcmaxstu10 = hylAcmaxstu10;
        this.hylMno10 = hylMno10;
    }
    
    // Getters and Setters
    public Integer getHylAcno10() {
        return hylAcno10;
    }
    
    public void setHylAcno10(Integer hylAcno10) {
        this.hylAcno10 = hylAcno10;
    }
    
    public String getHylAcname10() {
        return hylAcname10;
    }
    
    public void setHylAcname10(String hylAcname10) {
        this.hylAcname10 = hylAcname10;
    }
    
    public Integer getHylAcyear10() {
        return hylAcyear10;
    }
    
    public void setHylAcyear10(Integer hylAcyear10) {
        this.hylAcyear10 = hylAcyear10;
    }
    
    public Integer getHylAcmaxstu10() {
        return hylAcmaxstu10;
    }
    
    public void setHylAcmaxstu10(Integer hylAcmaxstu10) {
        this.hylAcmaxstu10 = hylAcmaxstu10;
    }
    
    public Integer getHylMno10() {
        return hylMno10;
    }
    
    public void setHylMno10(Integer hylMno10) {
        this.hylMno10 = hylMno10;
    }
    
    public String getMajorName() {
        return majorName;
    }
    
    public void setMajorName(String majorName) {
        this.majorName = majorName;
    }
    
    public String getFacultyName() {
        return facultyName;
    }
    
    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }
    
    public Integer getCurrentStudents() {
        return currentStudents;
    }
    
    public void setCurrentStudents(Integer currentStudents) {
        this.currentStudents = currentStudents;
    }
    
    @Override
    public String toString() {
        return "AClass{" +
                "hylAcno10=" + hylAcno10 +
                ", hylAcname10='" + hylAcname10 + '\'' +
                ", hylAcyear10=" + hylAcyear10 +
                ", hylAcmaxstu10=" + hylAcmaxstu10 +
                ", hylMno10=" + hylMno10 +
                ", majorName='" + majorName + '\'' +
                ", facultyName='" + facultyName + '\'' +
                ", currentStudents=" + currentStudents +
                '}';
    }
} 