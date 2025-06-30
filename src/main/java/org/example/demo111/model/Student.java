package org.example.demo111.model;

import java.util.Date;

/**
 * 学生实体类
 */
public class Student {
    private Integer hylSno10;           // 学号
    private Integer hylSage10;          // 年龄
    private String hylSname10;          // 姓名
    private Date hylSbirth10;           // 出生日期
    private String hylSplace10;         // 籍贯
    private String hylSsex10;           // 性别
    private Double hylScreditsum10;     // 已修学分
    private String hylSemail10;         // 邮箱
    private String hylSphone10;         // 电话
    private Date hylSenrolldate10;      // 入学时间
    private String hylSstatus10;        // 状态
    private Double hylSgpa10;           // GPA
    private Integer hylSrank10;         // 排名
    private Integer hylMno10;           // 专业编号
    private Integer hylAcno10;          // 行政班编号
    
    // 关联字段
    private String majorName;           // 专业名称
    private String className;           // 班级名称
    
    // 构造函数
    public Student() {}
    
    public Student(Integer hylSno10, String hylSname10, String hylSsex10, 
                   Integer hylSage10, String hylSplace10, String hylSemail10) {
        this.hylSno10 = hylSno10;
        this.hylSname10 = hylSname10;
        this.hylSsex10 = hylSsex10;
        this.hylSage10 = hylSage10;
        this.hylSplace10 = hylSplace10;
        this.hylSemail10 = hylSemail10;
    }
    
    // Getter和Setter方法
    public Integer getHylSno10() { return hylSno10; }
    public void setHylSno10(Integer hylSno10) { this.hylSno10 = hylSno10; }
    
    public Integer getHylSage10() { return hylSage10; }
    public void setHylSage10(Integer hylSage10) { this.hylSage10 = hylSage10; }
    
    public String getHylSname10() { return hylSname10; }
    public void setHylSname10(String hylSname10) { this.hylSname10 = hylSname10; }
    
    public Date getHylSbirth10() { return hylSbirth10; }
    public void setHylSbirth10(Date hylSbirth10) { this.hylSbirth10 = hylSbirth10; }
    
    public String getHylSplace10() { return hylSplace10; }
    public void setHylSplace10(String hylSplace10) { this.hylSplace10 = hylSplace10; }
    
    public String getHylSsex10() { return hylSsex10; }
    public void setHylSsex10(String hylSsex10) { this.hylSsex10 = hylSsex10; }
    
    public Double getHylScreditsum10() { return hylScreditsum10; }
    public void setHylScreditsum10(Double hylScreditsum10) { this.hylScreditsum10 = hylScreditsum10; }
    
    public String getHylSemail10() { return hylSemail10; }
    public void setHylSemail10(String hylSemail10) { this.hylSemail10 = hylSemail10; }
    
    public String getHylSphone10() { return hylSphone10; }
    public void setHylSphone10(String hylSphone10) { this.hylSphone10 = hylSphone10; }
    
    public Date getHylSenrolldate10() { return hylSenrolldate10; }
    public void setHylSenrolldate10(Date hylSenrolldate10) { this.hylSenrolldate10 = hylSenrolldate10; }
    
    public String getHylSstatus10() { return hylSstatus10; }
    public void setHylSstatus10(String hylSstatus10) { this.hylSstatus10 = hylSstatus10; }
    
    public Double getHylSgpa10() { return hylSgpa10; }
    public void setHylSgpa10(Double hylSgpa10) { this.hylSgpa10 = hylSgpa10; }
    
    public Integer getHylSrank10() { return hylSrank10; }
    public void setHylSrank10(Integer hylSrank10) { this.hylSrank10 = hylSrank10; }
    
    public Integer getHylMno10() { return hylMno10; }
    public void setHylMno10(Integer hylMno10) { this.hylMno10 = hylMno10; }
    
    public Integer getHylAcno10() { return hylAcno10; }
    public void setHylAcno10(Integer hylAcno10) { this.hylAcno10 = hylAcno10; }
    
    public String getMajorName() { return majorName; }
    public void setMajorName(String majorName) { this.majorName = majorName; }
    
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    
    @Override
    public String toString() {
        return "Student{" +
                "hylSno10=" + hylSno10 +
                ", hylSname10='" + hylSname10 + '\'' +
                ", hylSsex10='" + hylSsex10 + '\'' +
                ", hylSage10=" + hylSage10 +
                ", hylSplace10='" + hylSplace10 + '\'' +
                ", hylSemail10='" + hylSemail10 + '\'' +
                ", hylSstatus10='" + hylSstatus10 + '\'' +
                ", hylSgpa10=" + hylSgpa10 +
                ", hylSrank10=" + hylSrank10 +
                '}';
    }
} 