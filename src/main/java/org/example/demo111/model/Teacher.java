package org.example.demo111.model;

import java.util.Date;

/**
 * 教师实体类
 */
public class Teacher {
    private Integer hylTno10;           // 教师编号
    private Integer hylTage10;          // 年龄
    private String hylTname10;          // 姓名
    private Date hylTbirth10;           // 出生日期
    private String hylTtitle10;         // 职称
    private String hylTsex10;           // 性别
    private String hylTemail10;         // 邮箱
    private String hylToffice10;        // 办公室
    private String hylTphone10;         // 电话
    private Date hylTjoindate10;        // 入职时间
    private String hylTstatus10;        // 状态
    private Integer hylFno10;           // 学院编号
    
    // 关联字段
    private String facultyName;         // 学院名称
    
    // 构造函数
    public Teacher() {}
    
    public Teacher(Integer hylTno10, String hylTname10, String hylTsex10, 
                   Integer hylTage10, String hylTtitle10, String hylTemail10) {
        this.hylTno10 = hylTno10;
        this.hylTname10 = hylTname10;
        this.hylTsex10 = hylTsex10;
        this.hylTage10 = hylTage10;
        this.hylTtitle10 = hylTtitle10;
        this.hylTemail10 = hylTemail10;
    }
    
    // Getter和Setter方法
    public Integer getHylTno10() { return hylTno10; }
    public void setHylTno10(Integer hylTno10) { this.hylTno10 = hylTno10; }
    
    public Integer getHylTage10() { return hylTage10; }
    public void setHylTage10(Integer hylTage10) { this.hylTage10 = hylTage10; }
    
    public String getHylTname10() { return hylTname10; }
    public void setHylTname10(String hylTname10) { this.hylTname10 = hylTname10; }
    
    public Date getHylTbirth10() { return hylTbirth10; }
    public void setHylTbirth10(Date hylTbirth10) { this.hylTbirth10 = hylTbirth10; }
    
    public String getHylTtitle10() { return hylTtitle10; }
    public void setHylTtitle10(String hylTtitle10) { this.hylTtitle10 = hylTtitle10; }
    
    public String getHylTsex10() { return hylTsex10; }
    public void setHylTsex10(String hylTsex10) { this.hylTsex10 = hylTsex10; }
    
    public String getHylTemail10() { return hylTemail10; }
    public void setHylTemail10(String hylTemail10) { this.hylTemail10 = hylTemail10; }
    
    public String getHylToffice10() { return hylToffice10; }
    public void setHylToffice10(String hylToffice10) { this.hylToffice10 = hylToffice10; }
    
    public String getHylTphone10() { return hylTphone10; }
    public void setHylTphone10(String hylTphone10) { this.hylTphone10 = hylTphone10; }
    
    public Date getHylTjoindate10() { return hylTjoindate10; }
    public void setHylTjoindate10(Date hylTjoindate10) { this.hylTjoindate10 = hylTjoindate10; }
    
    public String getHylTstatus10() { return hylTstatus10; }
    public void setHylTstatus10(String hylTstatus10) { this.hylTstatus10 = hylTstatus10; }
    
    public Integer getHylFno10() { return hylFno10; }
    public void setHylFno10(Integer hylFno10) { this.hylFno10 = hylFno10; }
    
    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }
    
    @Override
    public String toString() {
        return "Teacher{" +
                "hylTno10=" + hylTno10 +
                ", hylTname10='" + hylTname10 + '\'' +
                ", hylTsex10='" + hylTsex10 + '\'' +
                ", hylTage10=" + hylTage10 +
                ", hylTtitle10='" + hylTtitle10 + '\'' +
                ", hylTemail10='" + hylTemail10 + '\'' +
                ", hylTstatus10='" + hylTstatus10 + '\'' +
                ", facultyName='" + facultyName + '\'' +
                '}';
    }
} 