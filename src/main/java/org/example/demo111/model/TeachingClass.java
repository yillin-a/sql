package org.example.demo111.model;

/**
 * 教学班实体类
 */
public class TeachingClass {
    private Integer hylTcno10;          // 教学班编号
    private String hylTcname10;         // 教学班名称
    private Integer hylTcyear10;        // 学年
    private Integer hylTcterm10;        // 学期
    private String hylTcrepeat10;       // 重修班类型
    private String hylTcbatch10;        // 班次编号
    private Integer hylTcmaxstu10;      // 最大学生数
    private Integer hylTccurstu10;      // 当前学生数
    private Integer hylCno10;           // 课程编号
    private Integer hylTno10;           // 教师编号
    
    // 关联字段
    private String courseName;          // 课程名称
    private String teacherName;         // 教师姓名
    private String courseType;          // 课程类型
    private Double courseCredit;        // 课程学分
    private Integer courseHour;         // 课程学时
    private String testType;            // 考核方式
    
    // 构造函数
    public TeachingClass() {}
    
    public TeachingClass(Integer hylTcno10, String hylTcname10, Integer hylTcyear10, 
                        Integer hylTcterm10, String hylTcrepeat10, String hylTcbatch10,
                        Integer hylTcmaxstu10, Integer hylTccurstu10, 
                        Integer hylCno10, Integer hylTno10) {
        this.hylTcno10 = hylTcno10;
        this.hylTcname10 = hylTcname10;
        this.hylTcyear10 = hylTcyear10;
        this.hylTcterm10 = hylTcterm10;
        this.hylTcrepeat10 = hylTcrepeat10;
        this.hylTcbatch10 = hylTcbatch10;
        this.hylTcmaxstu10 = hylTcmaxstu10;
        this.hylTccurstu10 = hylTccurstu10;
        this.hylCno10 = hylCno10;
        this.hylTno10 = hylTno10;
    }
    
    // Getter和Setter方法
    public Integer getHylTcno10() {
        return hylTcno10;
    }
    
    public void setHylTcno10(Integer hylTcno10) {
        this.hylTcno10 = hylTcno10;
    }
    
    public String getHylTcname10() {
        return hylTcname10;
    }
    
    public void setHylTcname10(String hylTcname10) {
        this.hylTcname10 = hylTcname10;
    }
    
    public Integer getHylTcyear10() {
        return hylTcyear10;
    }
    
    public void setHylTcyear10(Integer hylTcyear10) {
        this.hylTcyear10 = hylTcyear10;
    }
    
    public Integer getHylTcterm10() {
        return hylTcterm10;
    }
    
    public void setHylTcterm10(Integer hylTcterm10) {
        this.hylTcterm10 = hylTcterm10;
    }
    
    public String getHylTcrepeat10() {
        return hylTcrepeat10;
    }
    
    public void setHylTcrepeat10(String hylTcrepeat10) {
        this.hylTcrepeat10 = hylTcrepeat10;
    }
    
    public String getHylTcbatch10() {
        return hylTcbatch10;
    }
    
    public void setHylTcbatch10(String hylTcbatch10) {
        this.hylTcbatch10 = hylTcbatch10;
    }
    
    public Integer getHylTcmaxstu10() {
        return hylTcmaxstu10;
    }
    
    public void setHylTcmaxstu10(Integer hylTcmaxstu10) {
        this.hylTcmaxstu10 = hylTcmaxstu10;
    }
    
    public Integer getHylTccurstu10() {
        return hylTccurstu10;
    }
    
    public void setHylTccurstu10(Integer hylTccurstu10) {
        this.hylTccurstu10 = hylTccurstu10;
    }
    
    public Integer getHylCno10() {
        return hylCno10;
    }
    
    public void setHylCno10(Integer hylCno10) {
        this.hylCno10 = hylCno10;
    }
    
    public Integer getHylTno10() {
        return hylTno10;
    }
    
    public void setHylTno10(Integer hylTno10) {
        this.hylTno10 = hylTno10;
    }
    
    // 关联字段的getter和setter
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public String getTeacherName() {
        return teacherName;
    }
    
    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
    
    public String getCourseType() {
        return courseType;
    }
    
    public void setCourseType(String courseType) {
        this.courseType = courseType;
    }
    
    public Double getCourseCredit() {
        return courseCredit;
    }
    
    public void setCourseCredit(Double courseCredit) {
        this.courseCredit = courseCredit;
    }
    
    public Integer getCourseHour() {
        return courseHour;
    }
    
    public void setCourseHour(Integer courseHour) {
        this.courseHour = courseHour;
    }
    
    public String getTestType() {
        return testType;
    }
    
    public void setTestType(String testType) {
        this.testType = testType;
    }
    
    @Override
    public String toString() {
        return "TeachingClass{" +
                "hylTcno10=" + hylTcno10 +
                ", hylTcname10='" + hylTcname10 + '\'' +
                ", hylTcyear10=" + hylTcyear10 +
                ", hylTcterm10=" + hylTcterm10 +
                ", hylTcrepeat10='" + hylTcrepeat10 + '\'' +
                ", hylTcbatch10='" + hylTcbatch10 + '\'' +
                ", hylTcmaxstu10=" + hylTcmaxstu10 +
                ", hylTccurstu10=" + hylTccurstu10 +
                ", hylCno10=" + hylCno10 +
                ", hylTno10=" + hylTno10 +
                ", courseName='" + courseName + '\'' +
                ", teacherName='" + teacherName + '\'' +
                '}';
    }
} 